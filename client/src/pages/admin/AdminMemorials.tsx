import { useAuth } from "@/_core/hooks/useAuth";
import AdminLayout from "@/components/admin/AdminLayout";
import { trpc } from "@/lib/trpc";
import { ExternalLink, ImageIcon, Search } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";
import { Link } from "wouter";

type VisibilityFilter = "all" | "public" | "link" | "private";

const visibilityLabels = {
  public: "전체 공개",
  link: "링크 공개",
  private: "비공개",
} as const;

export default function AdminMemorials() {
  const { user } = useAuth();
  const enabled = user?.role === "admin";
  const utils = trpc.useUtils();
  const memorialsQuery = trpc.admin.memorials.list.useQuery(undefined, {
    enabled,
  });
  const [keyword, setKeyword] = useState("");
  const [visibilityFilter, setVisibilityFilter] =
    useState<VisibilityFilter>("all");

  const updateVisibility = trpc.admin.memorials.updateVisibility.useMutation({
    onSuccess: async memorial => {
      await Promise.all([
        utils.admin.memorials.list.invalidate(),
        utils.memorial.list.invalidate(),
      ]);
      toast.success(
        `${memorial.name} 신앙기념관이 ${visibilityLabels[memorial.visibility]}로 변경되었습니다.`
      );
    },
    onError: error => toast.error(error.message),
  });

  const memorials = useMemo(() => {
    const normalized = keyword.trim().toLowerCase();
    return (memorialsQuery.data ?? []).filter(memorial => {
      const matchesKeyword =
        !normalized ||
        [memorial.name, memorial.role, memorial.church, memorial.familyContact]
          .filter(Boolean)
          .some(value => value!.toLowerCase().includes(normalized));
      const matchesVisibility =
        visibilityFilter === "all" || memorial.visibility === visibilityFilter;
      return matchesKeyword && matchesVisibility;
    });
  }, [keyword, memorialsQuery.data, visibilityFilter]);

  const changeVisibility = (
    memorial: NonNullable<typeof memorialsQuery.data>[number],
    visibility: "public" | "link" | "private"
  ) => {
    if (visibility === memorial.visibility) return;
    if (
      !window.confirm(
        `${memorial.name} ${memorial.role}님의 공개 상태를 '${visibilityLabels[visibility]}'로 변경할까요?`
      )
    ) {
      return;
    }
    updateVisibility.mutate({ id: memorial.id, visibility });
  };

  return (
    <AdminLayout
      title="신앙기념관 관리"
      description="등록된 인물과 공개 상태를 확인하고, 개별 신앙기념관의 상세 관리 화면으로 이동합니다."
      action={
        <Link href="/memorial/create">
          <span className="memorial-button-primary inline-flex cursor-pointer">
            신앙기념관 만들기
          </span>
        </Link>
      }
    >
      <section className="border memorial-section bg-white p-4 md:p-5">
        <div className="grid gap-3 lg:grid-cols-[minmax(0,1fr)_220px]">
          <label className="flex min-h-11 items-center gap-3 border memorial-section px-4">
            <Search className="h-4 w-4 text-[var(--memorial-slate)]" />
            <input
              value={keyword}
              onChange={event => setKeyword(event.target.value)}
              placeholder="이름, 직분, 교회, 가족 연락처 검색"
              className="min-w-0 flex-1 bg-transparent text-sm outline-none"
            />
          </label>
          <select
            value={visibilityFilter}
            onChange={event =>
              setVisibilityFilter(event.target.value as VisibilityFilter)
            }
            className="min-h-11 border memorial-section bg-white px-3 text-sm outline-none"
            aria-label="공개 상태 필터"
          >
            <option value="all">모든 공개 상태</option>
            <option value="public">전체 공개</option>
            <option value="link">링크 공개</option>
            <option value="private">비공개</option>
          </select>
        </div>
        <p className="mt-4 text-xs text-[var(--memorial-slate)]">
          검색 결과 {memorials.length}개 · 전체{" "}
          {memorialsQuery.data?.length ?? 0}개
        </p>
      </section>

      <section className="mt-5 space-y-3">
        {memorialsQuery.isLoading ? (
          <StateBox>신앙기념관 정보를 불러오고 있습니다.</StateBox>
        ) : memorialsQuery.isError ? (
          <StateBox>신앙기념관 정보를 불러오지 못했습니다.</StateBox>
        ) : memorials.length === 0 ? (
          <StateBox>조건에 맞는 신앙기념관이 없습니다.</StateBox>
        ) : (
          memorials.map(memorial => {
            const href = `/memorial/${memorial.slug}/archive`;
            return (
              <article
                key={memorial.id}
                className="grid gap-5 border memorial-section bg-white p-5 lg:grid-cols-[minmax(0,1.2fr)_minmax(220px,0.8fr)_190px_150px] lg:items-center"
              >
                <div className="flex min-w-0 items-start gap-4">
                  {memorial.photoUrl ? (
                    <img
                      src={memorial.photoUrl}
                      alt={`${memorial.name} ${memorial.role}`}
                      className="h-20 w-16 shrink-0 object-cover"
                    />
                  ) : (
                    <span className="flex h-20 w-16 shrink-0 items-center justify-center bg-[var(--memorial-cloud)]">
                      <ImageIcon className="h-5 w-5 text-[var(--memorial-slate)]" />
                    </span>
                  )}
                  <div className="min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <h2 className="memorial-serif text-xl">
                        {memorial.name} {memorial.role}
                      </h2>
                      <span className="rounded-full bg-[var(--memorial-cloud)] px-2 py-0.5 text-[10px] text-[var(--memorial-slate)]">
                        {memorial.deathDate?.trim() ? "추모관" : "신앙기념관"}
                      </span>
                    </div>
                    <p className="mt-2 text-xs text-[var(--memorial-slate)]">
                      {memorial.church} · {memorial.birthDate || "생년 미등록"}
                      {memorial.deathDate?.trim()
                        ? ` - ${memorial.deathDate}`
                        : ""}
                    </p>
                    <p className="mt-1 text-xs text-[var(--memorial-slate)]">
                      가족 연락처 {memorial.familyContact || "-"} ·{" "}
                      {memorial.familyPhone || "-"}
                    </p>
                  </div>
                </div>

                <div className="text-xs leading-6 text-[var(--memorial-slate)]">
                  <p>등록 {formatDate(memorial.createdAt)}</p>
                  <p>수정 {formatDate(memorial.updatedAt)}</p>
                  <p className="line-clamp-2">
                    관리자 메모 {memorial.managerMemo || "-"}
                  </p>
                </div>

                <label>
                  <span className="mb-2 block text-xs font-semibold">
                    공개 상태
                  </span>
                  <select
                    value={memorial.visibility}
                    disabled={updateVisibility.isPending}
                    onChange={event =>
                      changeVisibility(
                        memorial,
                        event.target.value as "public" | "link" | "private"
                      )
                    }
                    className="min-h-10 w-full border memorial-section bg-white px-3 text-sm disabled:bg-[var(--memorial-cloud)]"
                    aria-label={`${memorial.name} 공개 상태`}
                  >
                    <option value="public">전체 공개</option>
                    <option value="link">링크 공개</option>
                    <option
                      value="private"
                      disabled={!memorial.hasAccessPassword}
                    >
                      비공개
                      {memorial.hasAccessPassword ? "" : " (비밀번호 없음)"}
                    </option>
                  </select>
                </label>

                <Link href={href}>
                  <span className="memorial-button-secondary inline-flex w-full cursor-pointer justify-center px-4 text-xs">
                    상세 관리
                    <ExternalLink className="h-3.5 w-3.5" />
                  </span>
                </Link>
              </article>
            );
          })
        )}
      </section>
    </AdminLayout>
  );
}

const dateFormatter = new Intl.DateTimeFormat("ko-KR", {
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
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
