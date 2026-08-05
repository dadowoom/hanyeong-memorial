import { useAuth } from "@/_core/hooks/useAuth";
import AdminLayout from "@/components/admin/AdminLayout";
import { trpc } from "@/lib/trpc";
import { Eye, EyeOff, ExternalLink, Search } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { Link } from "wouter";

type StatusFilter = "all" | "published" | "hidden";

export default function AdminLetters() {
  const { user } = useAuth();
  const enabled = user?.role === "admin";
  const utils = trpc.useUtils();
  const lettersQuery = trpc.admin.letters.list.useQuery(undefined, { enabled });
  const [keyword, setKeyword] = useState("");
  const [statusFilter, setStatusFilter] = useState<StatusFilter>("all");
  const [shown, setShown] = useState(20);

  const updateStatus = trpc.admin.letters.updateStatus.useMutation({
    onSuccess: async letter => {
      await Promise.all([
        utils.admin.letters.list.invalidate(),
        utils.letter.recent.invalidate(),
      ]);
      toast.success(
        `편지가 ${letter.status === "published" ? "공개" : "숨김"} 처리되었습니다.`
      );
    },
    onError: error => toast.error(error.message),
  });

  const letters = useMemo(() => {
    const normalized = keyword.trim().toLowerCase();
    return (lettersQuery.data ?? []).filter(letter => {
      const matchesKeyword =
        !normalized ||
        [
          letter.author,
          letter.memorialName,
          letter.memorialRole,
          letter.content,
        ]
          .filter(Boolean)
          .some(value => value!.toLowerCase().includes(normalized));
      const matchesStatus =
        statusFilter === "all" || letter.status === statusFilter;
      return matchesKeyword && matchesStatus;
    });
  }, [keyword, lettersQuery.data, statusFilter]);

  const toggleStatus = (
    letter: NonNullable<typeof lettersQuery.data>[number]
  ) => {
    const status = letter.status === "published" ? "hidden" : "published";
    const label = status === "published" ? "공개" : "숨김";
    if (!window.confirm(`이 편지를 ${label} 처리할까요?`)) return;
    updateStatus.mutate({ id: letter.id, status });
  };

  return (
    <AdminLayout
      title="편지 관리"
      description="하늘로 보내는 편지와 신앙기념관에 남겨진 글을 확인하고 공개 여부를 관리합니다."
      action={
        <Link href="/letters">
          <span className="memorial-button-secondary inline-flex cursor-pointer">
            공개 편지 화면
            <ExternalLink className="h-4 w-4" />
          </span>
        </Link>
      }
    >
      <section className="border memorial-section bg-white p-4 md:p-5">
        <div className="grid gap-3 lg:grid-cols-[minmax(0,1fr)_200px]">
          <label className="flex min-h-11 items-center gap-3 border memorial-section px-4">
            <Search className="h-4 w-4 text-[var(--memorial-slate)]" />
            <input
              value={keyword}
              onChange={event => {
                setKeyword(event.target.value);
                setShown(20);
              }}
              placeholder="보낸 분, 받는 분, 편지 내용 검색"
              className="min-w-0 flex-1 bg-transparent text-sm outline-none"
            />
          </label>
          <select
            value={statusFilter}
            onChange={event => {
              setStatusFilter(event.target.value as StatusFilter);
              setShown(20);
            }}
            className="min-h-11 border memorial-section bg-white px-3 text-sm outline-none"
            aria-label="편지 공개 상태 필터"
          >
            <option value="all">모든 상태</option>
            <option value="published">공개</option>
            <option value="hidden">숨김</option>
          </select>
        </div>
        <p className="mt-4 text-xs text-[var(--memorial-slate)]">
          검색 결과 {letters.length}건 · 전체 {lettersQuery.data?.length ?? 0}건
        </p>
      </section>

      <section className="mt-5 space-y-3">
        {lettersQuery.isLoading ? (
          <StateBox>편지를 불러오고 있습니다.</StateBox>
        ) : lettersQuery.isError ? (
          <StateBox>편지를 불러오지 못했습니다.</StateBox>
        ) : letters.length === 0 ? (
          <StateBox>조건에 맞는 편지가 없습니다.</StateBox>
        ) : (
          letters.slice(0, shown).map(letter => (
            <article
              key={letter.id}
              className="border memorial-section bg-white p-5 md:p-6"
            >
              <div className="flex flex-col justify-between gap-4 md:flex-row md:items-start">
                <div>
                  <div className="flex flex-wrap items-center gap-2">
                    <h2 className="font-semibold">
                      {letter.memorialName} {letter.memorialRole}
                    </h2>
                    <span
                      className={`rounded-full px-2 py-0.5 text-[10px] ${
                        letter.status === "published"
                          ? "bg-emerald-50 text-emerald-700"
                          : "bg-[var(--memorial-cloud)] text-[var(--memorial-slate)]"
                      }`}
                    >
                      {letter.status === "published" ? "공개" : "숨김"}
                    </span>
                  </div>
                  <p className="mt-2 text-xs text-[var(--memorial-slate)]">
                    보낸 분 {letter.author} · {formatDate(letter.createdAt)}
                  </p>
                </div>
                <div className="flex items-center gap-2">
                  {letter.memorialSlug && (
                    <Link href={`/memorial/${letter.memorialSlug}`}>
                      <span className="memorial-button-secondary inline-flex min-h-9 cursor-pointer px-3 text-xs">
                        기념관 보기
                        <ExternalLink className="h-3.5 w-3.5" />
                      </span>
                    </Link>
                  )}
                  <button
                    type="button"
                    disabled={updateStatus.isPending}
                    onClick={() => toggleStatus(letter)}
                    className="memorial-button-secondary min-h-9 px-3 text-xs disabled:opacity-50"
                  >
                    {letter.status === "published" ? (
                      <EyeOff className="h-3.5 w-3.5" />
                    ) : (
                      <Eye className="h-3.5 w-3.5" />
                    )}
                    {letter.status === "published" ? "숨기기" : "공개하기"}
                  </button>
                </div>
              </div>
              <p className="mt-5 whitespace-pre-wrap border-t memorial-section pt-5 text-sm leading-7 text-[var(--memorial-ash)]">
                {letter.content}
              </p>
            </article>
          ))
        )}
      </section>

      {shown < letters.length && (
        <div className="mt-5 text-center">
          <button
            type="button"
            onClick={() => setShown(count => count + 20)}
            className="memorial-button-secondary"
          >
            편지 더 보기
          </button>
        </div>
      )}
    </AdminLayout>
  );
}

const dateFormatter = new Intl.DateTimeFormat("ko-KR", {
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
});

function formatDate(value: Date | string | null) {
  if (!value) return "-";
  return dateFormatter.format(new Date(value));
}

function StateBox({ children }: { children: string }) {
  return (
    <div className="border memorial-section bg-white py-16 text-center text-sm text-[var(--memorial-slate)]">
      {children}
    </div>
  );
}
