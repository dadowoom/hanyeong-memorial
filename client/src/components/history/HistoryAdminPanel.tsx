import {
  DndContext,
  KeyboardSensor,
  PointerSensor,
  closestCenter,
  type DragEndEvent,
  useSensor,
  useSensors,
} from "@dnd-kit/core";
import {
  SortableContext,
  arrayMove,
  rectSortingStrategy,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { trpc } from "@/lib/trpc";
import {
  groupHistoryItemsByYear,
  sortHistoryDecades,
  sortHistoryItems,
} from "@shared/history";
import {
  Eye,
  EyeOff,
  GripVertical,
  Pencil,
  Plus,
  Save,
  Trash2,
  X,
} from "lucide-react";
import { type FormEvent, useEffect, useMemo, useState } from "react";
import { toast } from "sonner";

type Decade = {
  id: number;
  title: string;
  startYear: number;
  endYear: number;
  sortOrder: number;
  isVisible: boolean;
};

type HistoryItem = {
  id: number;
  decadeId: number;
  year: number;
  month: number;
  content: string;
  sortOrder: number;
  isVisible: boolean;
};

type DecadeDraft = {
  id: number | null;
  title: string;
  startYear: string;
  endYear: string;
  isVisible: boolean;
};

type ItemDraft = {
  id: number | null;
  year: string;
  month: string;
  content: string;
  isVisible: boolean;
};

const emptyDecadeDraft: DecadeDraft = {
  id: null,
  title: "",
  startYear: "",
  endYear: "",
  isVisible: true,
};

const emptyItemDraft: ItemDraft = {
  id: null,
  year: "",
  month: "",
  content: "",
  isVisible: true,
};

const inputClass =
  "h-11 w-full border border-[var(--memorial-line)] bg-white px-3 text-sm outline-none transition-colors focus:border-[var(--memorial-navy)]";

export default function HistoryAdminPanel({
  open = false,
  onOpenChange = () => undefined,
  mode = "dialog",
}: {
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  mode?: "dialog" | "page";
}) {
  const active = mode === "page" || open;
  const utils = trpc.useUtils();
  const historyQuery = trpc.history.adminList.useQuery(undefined, {
    enabled: active,
  });
  const [selectedDecadeId, setSelectedDecadeId] = useState<number | null>(null);
  const [decadeDraft, setDecadeDraft] = useState<DecadeDraft | null>(null);
  const [itemDraft, setItemDraft] = useState<ItemDraft | null>(null);
  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates })
  );

  const decades = useMemo(
    () => sortHistoryDecades((historyQuery.data?.decades ?? []) as Decade[]),
    [historyQuery.data?.decades]
  );
  const allItems = useMemo(
    () => sortHistoryItems((historyQuery.data?.items ?? []) as HistoryItem[]),
    [historyQuery.data?.items]
  );
  const selectedDecade =
    decades.find(decade => decade.id === selectedDecadeId) ?? null;
  const selectedItems = allItems.filter(
    item => item.decadeId === selectedDecadeId
  );
  const itemGroups = groupHistoryItemsByYear(selectedItems);

  useEffect(() => {
    if (!active) return;
    if (!decades.some(decade => decade.id === selectedDecadeId)) {
      setSelectedDecadeId(decades[0]?.id ?? null);
    }
  }, [active, decades, selectedDecadeId]);

  const refresh = async () => {
    await Promise.all([
      utils.history.adminList.invalidate(),
      utils.history.public.invalidate(),
    ]);
  };

  const handleError = (error: { message: string }) => {
    toast.error(error.message);
  };
  const createDecade = trpc.history.createDecade.useMutation({
    onSuccess: async () => {
      setDecadeDraft(null);
      await refresh();
      toast.success("연대가 추가되었습니다.");
    },
    onError: handleError,
  });
  const updateDecade = trpc.history.updateDecade.useMutation({
    onSuccess: async () => {
      setDecadeDraft(null);
      await refresh();
      toast.success("연대가 수정되었습니다.");
    },
    onError: handleError,
  });
  const deleteDecade = trpc.history.deleteDecade.useMutation({
    onSuccess: async () => {
      setSelectedDecadeId(null);
      setItemDraft(null);
      await refresh();
      toast.success("연대와 포함된 기록이 삭제되었습니다.");
    },
    onError: handleError,
  });
  const reorderDecades = trpc.history.reorderDecades.useMutation({
    onSuccess: refresh,
    onError: handleError,
  });
  const createItem = trpc.history.createItem.useMutation({
    onSuccess: async () => {
      setItemDraft(null);
      await refresh();
      toast.success("연혁 기록이 추가되었습니다.");
    },
    onError: handleError,
  });
  const updateItem = trpc.history.updateItem.useMutation({
    onSuccess: async () => {
      setItemDraft(null);
      await refresh();
      toast.success("연혁 기록이 수정되었습니다.");
    },
    onError: handleError,
  });
  const deleteItem = trpc.history.deleteItem.useMutation({
    onSuccess: async () => {
      await refresh();
      toast.success("연혁 기록이 삭제되었습니다.");
    },
    onError: handleError,
  });
  const reorderItems = trpc.history.reorderItems.useMutation({
    onSuccess: refresh,
    onError: handleError,
  });

  const busy =
    createDecade.isPending ||
    updateDecade.isPending ||
    deleteDecade.isPending ||
    reorderDecades.isPending ||
    createItem.isPending ||
    updateItem.isPending ||
    deleteItem.isPending ||
    reorderItems.isPending;

  const submitDecade = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!decadeDraft) return;
    const startYear = Number(decadeDraft.startYear);
    const endYear = Number(decadeDraft.endYear);
    if (!Number.isInteger(startYear) || !Number.isInteger(endYear)) {
      toast.error("시작 연도와 종료 연도를 확인해주세요.");
      return;
    }
    if (startYear > endYear) {
      toast.error("종료 연도는 시작 연도보다 작을 수 없습니다.");
      return;
    }

    const payload = {
      title: decadeDraft.title.trim(),
      startYear,
      endYear,
      isVisible: decadeDraft.isVisible,
    };
    if (decadeDraft.id) {
      const current = decades.find(decade => decade.id === decadeDraft.id);
      updateDecade.mutate({
        id: decadeDraft.id,
        ...payload,
        sortOrder: current?.sortOrder,
      });
    } else {
      createDecade.mutate(payload);
    }
  };

  const submitItem = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!itemDraft || !selectedDecade) return;
    const year = Number(itemDraft.year);
    const month = Number(itemDraft.month);
    if (!Number.isInteger(year) || year < 1800 || year > 2200) {
      toast.error("연도를 확인해주세요.");
      return;
    }
    if (!Number.isInteger(month) || month < 1 || month > 12) {
      toast.error("월은 1부터 12까지 입력해주세요.");
      return;
    }
    if (year < selectedDecade.startYear || year > selectedDecade.endYear) {
      toast.error(`${selectedDecade.title}의 연도 범위 안에서 입력해주세요.`);
      return;
    }

    const payload = {
      decadeId: selectedDecade.id,
      year,
      month,
      content: itemDraft.content.trim(),
      isVisible: itemDraft.isVisible,
    };
    if (itemDraft.id) {
      const current = selectedItems.find(item => item.id === itemDraft.id);
      updateItem.mutate({
        id: itemDraft.id,
        ...payload,
        sortOrder: current?.sortOrder,
      });
    } else {
      createItem.mutate(payload);
    }
  };

  const handleDecadeDragEnd = ({ active, over }: DragEndEvent) => {
    if (!over || active.id === over.id) return;
    const oldIndex = decades.findIndex(decade => decade.id === active.id);
    const newIndex = decades.findIndex(decade => decade.id === over.id);
    if (oldIndex < 0 || newIndex < 0) return;
    reorderDecades.mutate({
      ids: arrayMove(decades, oldIndex, newIndex).map(decade => decade.id),
    });
  };

  const handleItemDragEnd = (
    { active, over }: DragEndEvent,
    yearItems: HistoryItem[]
  ) => {
    if (!over || active.id === over.id || !selectedDecade) return;
    const oldIndex = yearItems.findIndex(item => item.id === active.id);
    const newIndex = yearItems.findIndex(item => item.id === over.id);
    if (oldIndex < 0 || newIndex < 0) return;
    reorderItems.mutate({
      decadeId: selectedDecade.id,
      ids: arrayMove(yearItems, oldIndex, newIndex).map(item => item.id),
    });
  };

  const workspace = (
    <div
      className={`grid md:grid-cols-[260px_minmax(0,1fr)] ${
        mode === "dialog"
          ? "max-h-[calc(92vh-92px)] overflow-y-auto"
          : "min-h-[560px]"
      }`}
    >
      <aside className="border-b memorial-section bg-[var(--memorial-cloud)] p-4 md:border-b-0 md:border-r md:p-5">
        <button
          type="button"
          onClick={() => setDecadeDraft(emptyDecadeDraft)}
          className="memorial-button-primary w-full"
        >
          <Plus className="h-4 w-4" />
          연대 추가
        </button>

        <DndContext
          sensors={sensors}
          collisionDetection={closestCenter}
          onDragEnd={handleDecadeDragEnd}
        >
          <SortableContext
            items={decades.map(decade => decade.id)}
            strategy={rectSortingStrategy}
          >
            <div className="mt-4 flex gap-2 overflow-x-auto pb-1 md:flex-col md:overflow-visible">
              {decades.map(decade => (
                <SortableDecade
                  key={decade.id}
                  decade={decade}
                  selected={decade.id === selectedDecadeId}
                  onSelect={() => {
                    setSelectedDecadeId(decade.id);
                    setDecadeDraft(null);
                    setItemDraft(null);
                  }}
                />
              ))}
            </div>
          </SortableContext>
        </DndContext>
      </aside>

      <section className="min-w-0 p-5 md:p-7">
        {historyQuery.isLoading ? (
          <ManagerMessage>연혁 정보를 불러오고 있습니다.</ManagerMessage>
        ) : decadeDraft ? (
          <DecadeForm
            draft={decadeDraft}
            setDraft={setDecadeDraft}
            onSubmit={submitDecade}
            busy={busy}
          />
        ) : selectedDecade ? (
          <>
            <div className="flex flex-col justify-between gap-4 border-b memorial-section pb-5 sm:flex-row sm:items-start">
              <div>
                <div className="flex items-center gap-2">
                  <h3 className="memorial-serif text-2xl">
                    {selectedDecade.title}
                  </h3>
                  {selectedDecade.isVisible ? (
                    <Eye
                      className="h-4 w-4 text-emerald-700"
                      aria-label="공개"
                    />
                  ) : (
                    <EyeOff
                      className="h-4 w-4 text-[var(--memorial-slate)]"
                      aria-label="숨김"
                    />
                  )}
                </div>
                <p className="mt-2 text-xs text-[var(--memorial-slate)]">
                  {selectedDecade.startYear} - {selectedDecade.endYear}
                </p>
              </div>
              <div className="flex items-center gap-2">
                <IconButton
                  label="연대 수정"
                  onClick={() =>
                    setDecadeDraft({
                      id: selectedDecade.id,
                      title: selectedDecade.title,
                      startYear: String(selectedDecade.startYear),
                      endYear: String(selectedDecade.endYear),
                      isVisible: selectedDecade.isVisible,
                    })
                  }
                >
                  <Pencil className="h-4 w-4" />
                </IconButton>
                <IconButton
                  label={
                    selectedDecade.isVisible ? "연대 숨기기" : "연대 공개하기"
                  }
                  onClick={() =>
                    updateDecade.mutate({
                      id: selectedDecade.id,
                      title: selectedDecade.title,
                      startYear: selectedDecade.startYear,
                      endYear: selectedDecade.endYear,
                      sortOrder: selectedDecade.sortOrder,
                      isVisible: !selectedDecade.isVisible,
                    })
                  }
                >
                  {selectedDecade.isVisible ? (
                    <EyeOff className="h-4 w-4" />
                  ) : (
                    <Eye className="h-4 w-4" />
                  )}
                </IconButton>
                <IconButton
                  label="연대 삭제"
                  tone="danger"
                  onClick={() => {
                    if (
                      window.confirm(
                        `${selectedDecade.title}와 포함된 모든 기록을 삭제할까요?`
                      )
                    ) {
                      deleteDecade.mutate({ id: selectedDecade.id });
                    }
                  }}
                >
                  <Trash2 className="h-4 w-4" />
                </IconButton>
              </div>
            </div>

            <div className="mt-6 flex items-center justify-between gap-4">
              <h4 className="text-sm font-semibold text-[var(--memorial-ink)]">
                연혁 기록 {selectedItems.length}건
              </h4>
              <button
                type="button"
                onClick={() => setItemDraft(emptyItemDraft)}
                className="memorial-button-secondary min-h-9 px-4 text-xs"
              >
                <Plus className="h-3.5 w-3.5" />
                기록 추가
              </button>
            </div>

            {itemDraft && (
              <div className="mt-5 border-y memorial-section bg-[var(--memorial-cloud)] px-4 py-5">
                <ItemForm
                  draft={itemDraft}
                  setDraft={setItemDraft}
                  onSubmit={submitItem}
                  busy={busy}
                />
              </div>
            )}

            {itemGroups.length === 0 ? (
              <ManagerMessage>등록된 연혁 기록이 없습니다.</ManagerMessage>
            ) : (
              <div className="mt-6 space-y-7">
                {itemGroups.map(group => (
                  <div key={group.year}>
                    <p className="mb-2 text-xs font-semibold text-[var(--memorial-slate)]">
                      {group.year}
                    </p>
                    <DndContext
                      sensors={sensors}
                      collisionDetection={closestCenter}
                      onDragEnd={event => handleItemDragEnd(event, group.items)}
                    >
                      <SortableContext
                        items={group.items.map(item => item.id)}
                        strategy={verticalListSortingStrategy}
                      >
                        <div className="divide-y memorial-section border-y memorial-section">
                          {group.items.map(item => (
                            <SortableHistoryItem
                              key={item.id}
                              item={item}
                              onEdit={() =>
                                setItemDraft({
                                  id: item.id,
                                  year: String(item.year),
                                  month: String(item.month),
                                  content: item.content,
                                  isVisible: item.isVisible,
                                })
                              }
                              onToggle={() =>
                                updateItem.mutate({
                                  id: item.id,
                                  decadeId: item.decadeId,
                                  year: item.year,
                                  month: item.month,
                                  content: item.content,
                                  sortOrder: item.sortOrder,
                                  isVisible: !item.isVisible,
                                })
                              }
                              onDelete={() => {
                                if (
                                  window.confirm("이 연혁 기록을 삭제할까요?")
                                ) {
                                  deleteItem.mutate({ id: item.id });
                                }
                              }}
                            />
                          ))}
                        </div>
                      </SortableContext>
                    </DndContext>
                  </div>
                ))}
              </div>
            )}
          </>
        ) : (
          <ManagerMessage>연대를 먼저 추가해주세요.</ManagerMessage>
        )}
      </section>
    </div>
  );

  if (mode === "page") {
    return (
      <section className="overflow-hidden border memorial-section bg-white">
        <div className="border-b memorial-section px-5 py-5 md:px-7">
          <h2 className="memorial-serif text-2xl">교회 연혁 관리</h2>
          <p className="mt-2 text-sm text-[var(--memorial-slate)]">
            연대를 만든 뒤 기록을 추가하고 공개 여부와 순서를 관리합니다.
          </p>
        </div>
        {workspace}
      </section>
    );
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[92vh] max-w-[calc(100%-1rem)] gap-0 overflow-hidden p-0 sm:max-w-6xl">
        <DialogHeader className="border-b memorial-section px-5 py-5 pr-12 md:px-7">
          <DialogTitle className="memorial-serif text-2xl">
            교회 연혁 관리
          </DialogTitle>
          <DialogDescription>
            연대와 교회 연혁 기록을 관리합니다.
          </DialogDescription>
        </DialogHeader>
        {workspace}
      </DialogContent>
    </Dialog>
  );
}

function DecadeForm({
  draft,
  setDraft,
  onSubmit,
  busy,
}: {
  draft: DecadeDraft;
  setDraft: (draft: DecadeDraft | null) => void;
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
  busy: boolean;
}) {
  return (
    <form onSubmit={onSubmit}>
      <div className="flex items-center justify-between gap-4 border-b memorial-section pb-4">
        <h3 className="memorial-serif text-2xl">
          {draft.id ? "연대 수정" : "연대 추가"}
        </h3>
        <IconButton label="취소" onClick={() => setDraft(null)}>
          <X className="h-4 w-4" />
        </IconButton>
      </div>
      <div className="mt-6 grid gap-5 sm:grid-cols-2">
        <Field label="연대 이름" wide>
          <input
            className={inputClass}
            value={draft.title}
            onChange={event =>
              setDraft({ ...draft, title: event.target.value })
            }
            placeholder="예: 2020년대"
            maxLength={64}
            required
          />
        </Field>
        <Field label="시작 연도">
          <input
            className={inputClass}
            type="number"
            min={1800}
            max={2200}
            value={draft.startYear}
            onChange={event =>
              setDraft({ ...draft, startYear: event.target.value })
            }
            required
          />
        </Field>
        <Field label="종료 연도">
          <input
            className={inputClass}
            type="number"
            min={1800}
            max={2200}
            value={draft.endYear}
            onChange={event =>
              setDraft({ ...draft, endYear: event.target.value })
            }
            required
          />
        </Field>
      </div>
      <VisibilityField
        checked={draft.isVisible}
        onChange={checked => setDraft({ ...draft, isVisible: checked })}
      />
      <button
        type="submit"
        disabled={busy}
        className="memorial-button-primary mt-6 disabled:opacity-50"
      >
        <Save className="h-4 w-4" />
        저장
      </button>
    </form>
  );
}

function ItemForm({
  draft,
  setDraft,
  onSubmit,
  busy,
}: {
  draft: ItemDraft;
  setDraft: (draft: ItemDraft | null) => void;
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
  busy: boolean;
}) {
  return (
    <form onSubmit={onSubmit}>
      <div className="flex items-center justify-between gap-4">
        <h5 className="text-sm font-semibold">
          {draft.id ? "기록 수정" : "기록 추가"}
        </h5>
        <IconButton label="취소" onClick={() => setDraft(null)}>
          <X className="h-4 w-4" />
        </IconButton>
      </div>
      <div className="mt-4 grid gap-4 sm:grid-cols-[1fr_1fr_2fr]">
        <Field label="연도">
          <input
            className={inputClass}
            type="number"
            min={1800}
            max={2200}
            value={draft.year}
            onChange={event => setDraft({ ...draft, year: event.target.value })}
            required
          />
        </Field>
        <Field label="월">
          <input
            className={inputClass}
            type="number"
            min={1}
            max={12}
            value={draft.month}
            onChange={event =>
              setDraft({ ...draft, month: event.target.value })
            }
            required
          />
        </Field>
        <Field label="내용">
          <textarea
            className={`${inputClass} min-h-28 resize-y py-3`}
            value={draft.content}
            onChange={event =>
              setDraft({ ...draft, content: event.target.value })
            }
            maxLength={10000}
            required
          />
        </Field>
      </div>
      <div className="flex flex-wrap items-end justify-between gap-4">
        <VisibilityField
          checked={draft.isVisible}
          onChange={checked => setDraft({ ...draft, isVisible: checked })}
        />
        <button
          type="submit"
          disabled={busy}
          className="memorial-button-primary min-h-9 px-4 text-xs disabled:opacity-50"
        >
          <Save className="h-3.5 w-3.5" />
          저장
        </button>
      </div>
    </form>
  );
}

function SortableDecade({
  decade,
  selected,
  onSelect,
}: {
  decade: Decade;
  selected: boolean;
  onSelect: () => void;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: decade.id });
  return (
    <div
      ref={setNodeRef}
      style={{
        transform: CSS.Transform.toString(transform),
        transition,
        opacity: isDragging ? 0.55 : 1,
      }}
      className={`flex min-w-44 items-center border px-2 py-2 transition-colors md:min-w-0 ${
        selected
          ? "border-[var(--memorial-navy)] bg-white text-[var(--memorial-navy)]"
          : "border-[var(--memorial-line)] bg-white text-[var(--memorial-ash)]"
      }`}
    >
      <button
        type="button"
        className="flex h-8 w-8 touch-none cursor-grab items-center justify-center active:cursor-grabbing"
        title="연대 순서 변경"
        aria-label={`${decade.title} 순서 변경`}
        {...attributes}
        {...listeners}
      >
        <GripVertical className="h-4 w-4" />
      </button>
      <button
        type="button"
        onClick={onSelect}
        className="min-w-0 flex-1 px-1 text-left text-sm font-semibold"
      >
        <span className="block truncate">{decade.title}</span>
        <span className="mt-0.5 block text-[10px] font-normal opacity-60">
          {decade.startYear}-{decade.endYear}
        </span>
      </button>
      {decade.isVisible ? (
        <Eye className="h-3.5 w-3.5 shrink-0" aria-label="공개" />
      ) : (
        <EyeOff className="h-3.5 w-3.5 shrink-0" aria-label="숨김" />
      )}
    </div>
  );
}

function SortableHistoryItem({
  item,
  onEdit,
  onToggle,
  onDelete,
}: {
  item: HistoryItem;
  onEdit: () => void;
  onToggle: () => void;
  onDelete: () => void;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: item.id });
  return (
    <div
      ref={setNodeRef}
      style={{
        transform: CSS.Transform.toString(transform),
        transition,
        opacity: isDragging ? 0.55 : item.isVisible ? 1 : 0.55,
      }}
      className="grid grid-cols-[36px_44px_minmax(0,1fr)_auto] items-start gap-2 bg-white py-4"
    >
      <button
        type="button"
        className="flex h-8 w-8 touch-none cursor-grab items-center justify-center active:cursor-grabbing"
        title="기록 순서 변경"
        aria-label={`${item.year}년 ${item.month}월 기록 순서 변경`}
        {...attributes}
        {...listeners}
      >
        <GripVertical className="h-4 w-4 text-[var(--memorial-slate)]" />
      </button>
      <span className="pt-1.5 text-xs font-semibold text-[var(--memorial-slate)]">
        {String(item.month).padStart(2, "0")}
      </span>
      <p className="whitespace-pre-line pt-1 text-sm leading-6 text-[var(--memorial-ash)]">
        {item.content}
      </p>
      <div className="flex items-center gap-1">
        <IconButton label="기록 수정" onClick={onEdit}>
          <Pencil className="h-3.5 w-3.5" />
        </IconButton>
        <IconButton
          label={item.isVisible ? "기록 숨기기" : "기록 공개하기"}
          onClick={onToggle}
        >
          {item.isVisible ? (
            <EyeOff className="h-3.5 w-3.5" />
          ) : (
            <Eye className="h-3.5 w-3.5" />
          )}
        </IconButton>
        <IconButton label="기록 삭제" tone="danger" onClick={onDelete}>
          <Trash2 className="h-3.5 w-3.5" />
        </IconButton>
      </div>
    </div>
  );
}

function Field({
  label,
  children,
  wide = false,
}: {
  label: string;
  children: React.ReactNode;
  wide?: boolean;
}) {
  return (
    <label className={wide ? "sm:col-span-2" : undefined}>
      <span className="mb-2 block text-xs font-semibold text-[var(--memorial-ash)]">
        {label}
      </span>
      {children}
    </label>
  );
}

function VisibilityField({
  checked,
  onChange,
}: {
  checked: boolean;
  onChange: (checked: boolean) => void;
}) {
  return (
    <label className="mt-5 inline-flex items-center gap-2 text-sm text-[var(--memorial-ash)]">
      <input
        type="checkbox"
        checked={checked}
        onChange={event => onChange(event.target.checked)}
        className="h-4 w-4 accent-[var(--memorial-navy)]"
      />
      공개
    </label>
  );
}

function IconButton({
  label,
  children,
  onClick,
  tone = "default",
}: {
  label: string;
  children: React.ReactNode;
  onClick: () => void;
  tone?: "default" | "danger";
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      title={label}
      aria-label={label}
      className={`inline-flex h-9 w-9 items-center justify-center border transition-colors ${
        tone === "danger"
          ? "border-red-200 text-red-700 hover:bg-red-50"
          : "border-[var(--memorial-line)] text-[var(--memorial-ash)] hover:bg-[var(--memorial-cloud)] hover:text-[var(--memorial-ink)]"
      }`}
    >
      {children}
    </button>
  );
}

function ManagerMessage({ children }: { children: string }) {
  return (
    <div className="mt-8 border-y memorial-section py-12 text-center text-sm text-[var(--memorial-slate)]">
      {children}
    </div>
  );
}
