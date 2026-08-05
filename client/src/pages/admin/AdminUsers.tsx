import { useAuth } from "@/_core/hooks/useAuth";
import AdminLayout from "@/components/admin/AdminLayout";
import { trpc } from "@/lib/trpc";
import { Search, ShieldCheck, UserRound } from "lucide-react";
import { useMemo, useState } from "react";
import { toast } from "sonner";

type RoleFilter = "all" | "user" | "admin";
type StatusFilter = "all" | "pending" | "approved" | "rejected";

const dateFormatter = new Intl.DateTimeFormat("ko-KR", {
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
});

export default function AdminUsers() {
  const { user: currentUser } = useAuth();
  const enabled = currentUser?.role === "admin";
  const utils = trpc.useUtils();
  const usersQuery = trpc.admin.users.list.useQuery(undefined, { enabled });
  const [keyword, setKeyword] = useState("");
  const [roleFilter, setRoleFilter] = useState<RoleFilter>("all");
  const [statusFilter, setStatusFilter] = useState<StatusFilter>("all");

  const updateUser = trpc.admin.users.update.useMutation({
    onSuccess: async member => {
      await utils.admin.users.list.invalidate();
      toast.success(
        `${member.name || member.email || "회원"} 계정이 변경되었습니다.`
      );
    },
    onError: error => toast.error(error.message),
  });

  const members = useMemo(() => {
    const normalized = keyword.trim().toLowerCase();
    return (usersQuery.data ?? []).filter(member => {
      const matchesKeyword =
        !normalized ||
        [member.name, member.email, member.phone]
          .filter(Boolean)
          .some(value => value!.toLowerCase().includes(normalized));
      const matchesRole = roleFilter === "all" || member.role === roleFilter;
      const matchesStatus =
        statusFilter === "all" || member.approvalStatus === statusFilter;
      return matchesKeyword && matchesRole && matchesStatus;
    });
  }, [keyword, roleFilter, statusFilter, usersQuery.data]);

  const applyChange = (
    member: NonNullable<typeof usersQuery.data>[number],
    next: {
      role: "user" | "admin";
      approvalStatus: "pending" | "approved" | "rejected";
    }
  ) => {
    if (
      !window.confirm(
        `${member.name || member.email || "선택한 회원"} 계정의 권한 또는 이용 상태를 변경할까요?`
      )
    ) {
      return;
    }
    updateUser.mutate({ id: member.id, ...next });
  };

  return (
    <AdminLayout
      title="회원 관리"
      description="회원 정보를 확인하고 운영 권한과 사이트 이용 상태를 관리합니다. 회원 삭제는 데이터 보호를 위해 제공하지 않습니다."
    >
      <section className="border memorial-section bg-white p-4 md:p-5">
        <div className="grid gap-3 lg:grid-cols-[minmax(0,1fr)_180px_180px]">
          <label className="flex min-h-11 items-center gap-3 border memorial-section px-4">
            <Search className="h-4 w-4 text-[var(--memorial-slate)]" />
            <input
              value={keyword}
              onChange={event => setKeyword(event.target.value)}
              placeholder="이름, 이메일, 연락처 검색"
              className="min-w-0 flex-1 bg-transparent text-sm outline-none"
            />
          </label>
          <select
            value={roleFilter}
            onChange={event => setRoleFilter(event.target.value as RoleFilter)}
            className="min-h-11 border memorial-section bg-white px-3 text-sm outline-none"
            aria-label="권한 필터"
          >
            <option value="all">모든 권한</option>
            <option value="user">일반 회원</option>
            <option value="admin">관리자</option>
          </select>
          <select
            value={statusFilter}
            onChange={event =>
              setStatusFilter(event.target.value as StatusFilter)
            }
            className="min-h-11 border memorial-section bg-white px-3 text-sm outline-none"
            aria-label="이용 상태 필터"
          >
            <option value="all">모든 상태</option>
            <option value="approved">이용 가능</option>
            <option value="pending">승인 대기</option>
            <option value="rejected">이용 제한</option>
          </select>
        </div>
        <p className="mt-4 text-xs text-[var(--memorial-slate)]">
          검색 결과 {members.length}명 · 전체 {usersQuery.data?.length ?? 0}명
        </p>
      </section>

      <section className="mt-5 space-y-3">
        {usersQuery.isLoading ? (
          <StateBox>회원 정보를 불러오고 있습니다.</StateBox>
        ) : usersQuery.isError ? (
          <StateBox>회원 정보를 불러오지 못했습니다.</StateBox>
        ) : members.length === 0 ? (
          <StateBox>조건에 맞는 회원이 없습니다.</StateBox>
        ) : (
          members.map(member => {
            const isSelf = member.id === currentUser?.id;
            return (
              <article
                key={member.id}
                className="grid gap-5 border memorial-section bg-white p-5 lg:grid-cols-[minmax(0,1.25fr)_minmax(180px,0.7fr)_160px_170px] lg:items-center"
              >
                <div className="flex min-w-0 items-start gap-4">
                  <span className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-[var(--memorial-cloud)]">
                    {member.role === "admin" ? (
                      <ShieldCheck className="h-5 w-5 text-[var(--memorial-navy)]" />
                    ) : (
                      <UserRound className="h-5 w-5 text-[var(--memorial-slate)]" />
                    )}
                  </span>
                  <div className="min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <h2 className="font-semibold">
                        {member.name || "이름 없음"}
                      </h2>
                      {isSelf && (
                        <span className="rounded-full bg-[var(--memorial-navy)] px-2 py-0.5 text-[10px] text-white">
                          현재 계정
                        </span>
                      )}
                    </div>
                    <p className="mt-1 break-all text-sm text-[var(--memorial-slate)]">
                      {member.email || "이메일 없음"}
                    </p>
                    <p className="mt-1 text-xs text-[var(--memorial-slate)]">
                      {member.phone || "연락처 없음"}
                    </p>
                  </div>
                </div>

                <div className="text-xs leading-6 text-[var(--memorial-slate)]">
                  <p>가입 {formatDate(member.createdAt)}</p>
                  <p>최근 접속 {formatDate(member.lastSignedIn)}</p>
                  <p>가입 방식 {member.loginMethod || "확인 불가"}</p>
                </div>

                <label>
                  <span className="mb-2 block text-xs font-semibold">권한</span>
                  <select
                    value={member.role}
                    disabled={isSelf || updateUser.isPending}
                    onChange={event =>
                      applyChange(member, {
                        role: event.target.value as "user" | "admin",
                        approvalStatus: member.approvalStatus,
                      })
                    }
                    className="min-h-10 w-full border memorial-section bg-white px-3 text-sm disabled:bg-[var(--memorial-cloud)] disabled:text-[var(--memorial-slate)]"
                    aria-label={`${member.name || "회원"} 권한`}
                  >
                    <option value="user">일반 회원</option>
                    <option value="admin">관리자</option>
                  </select>
                </label>

                <label>
                  <span className="mb-2 block text-xs font-semibold">
                    이용 상태
                  </span>
                  <select
                    value={member.approvalStatus}
                    disabled={isSelf || updateUser.isPending}
                    onChange={event =>
                      applyChange(member, {
                        role: member.role,
                        approvalStatus: event.target.value as
                          | "pending"
                          | "approved"
                          | "rejected",
                      })
                    }
                    className="min-h-10 w-full border memorial-section bg-white px-3 text-sm disabled:bg-[var(--memorial-cloud)] disabled:text-[var(--memorial-slate)]"
                    aria-label={`${member.name || "회원"} 이용 상태`}
                  >
                    <option value="approved">이용 가능</option>
                    <option value="pending">승인 대기</option>
                    <option value="rejected">이용 제한</option>
                  </select>
                </label>
              </article>
            );
          })
        )}
      </section>
    </AdminLayout>
  );
}

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
