import { useAuth } from "@/_core/hooks/useAuth";
import AdminLayout from "@/components/admin/AdminLayout";
import { trpc } from "@/lib/trpc";
import {
  ArrowRight,
  BookOpenText,
  Landmark,
  Mail,
  ShieldCheck,
  UserCheck,
  Users,
} from "lucide-react";
import { Link } from "wouter";

export default function AdminDashboard() {
  const { user } = useAuth();
  const enabled = user?.role === "admin";
  const usersQuery = trpc.admin.users.list.useQuery(undefined, { enabled });
  const memorialsQuery = trpc.admin.memorials.list.useQuery(undefined, {
    enabled,
  });
  const lettersQuery = trpc.admin.letters.list.useQuery(undefined, { enabled });
  const historyQuery = trpc.history.adminList.useQuery(undefined, { enabled });
  const users = usersQuery.data ?? [];
  const memorials = memorialsQuery.data ?? [];
  const letters = lettersQuery.data ?? [];
  const decades = historyQuery.data?.decades ?? [];
  const historyItems = historyQuery.data?.items ?? [];

  const stats = [
    {
      label: "전체 회원",
      value: users.length,
      hint: "등록된 계정",
      icon: Users,
    },
    {
      label: "활성 회원",
      value: users.filter(member => member.approvalStatus === "approved")
        .length,
      hint: "현재 이용 가능",
      icon: UserCheck,
    },
    {
      label: "관리자",
      value: users.filter(member => member.role === "admin").length,
      hint: "운영 권한 계정",
      icon: ShieldCheck,
    },
    {
      label: "신앙기념관",
      value: memorials.length,
      hint: `전체 공개 ${memorials.filter(memorial => memorial.visibility === "public").length}개`,
      icon: Landmark,
    },
    {
      label: "공개 편지",
      value: letters.filter(letter => letter.status === "published").length,
      hint: `숨김 ${letters.filter(letter => letter.status === "hidden").length}건`,
      icon: Mail,
    },
    {
      label: "연혁 기록",
      value: historyItems.length,
      hint: `연대 ${decades.length}개`,
      icon: BookOpenText,
    },
  ];

  return (
    <AdminLayout
      title="운영 현황"
      description="회원, 신앙기념관, 편지와 교회 연혁 상태를 확인하고 필요한 관리 화면으로 이동합니다."
      action={
        <Link href="/">
          <span className="memorial-button-secondary inline-flex cursor-pointer">
            사이트 확인
            <ArrowRight className="h-4 w-4" />
          </span>
        </Link>
      }
    >
      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
        {stats.map(stat => (
          <article
            key={stat.label}
            className="border memorial-section bg-white p-5 md:p-6"
          >
            <div className="flex items-center justify-between">
              <p className="text-sm font-semibold">{stat.label}</p>
              <stat.icon className="h-4 w-4 text-[var(--memorial-slate)]" />
            </div>
            <p className="memorial-serif mt-6 text-4xl">
              {usersQuery.isLoading ||
              memorialsQuery.isLoading ||
              lettersQuery.isLoading ||
              historyQuery.isLoading
                ? "–"
                : stat.value}
            </p>
            <p className="mt-2 text-xs text-[var(--memorial-slate)]">
              {stat.hint}
            </p>
          </article>
        ))}
      </section>

      <section className="mt-6 grid gap-5 lg:grid-cols-2">
        <AdminLinkCard
          href="/admin/users"
          eyebrow="MEMBERS"
          title="회원 관리"
          description="가입 회원의 연락처와 접속 상태를 확인하고 일반 회원·관리자 권한과 이용 상태를 관리합니다."
        />
        <AdminLinkCard
          href="/admin/memorials"
          eyebrow="FAITH MEMORIALS"
          title="신앙기념관 관리"
          description="등록된 인물과 가족 연락처를 확인하고 공개 상태와 상세 내용을 관리합니다."
        />
        <AdminLinkCard
          href="/admin/letters"
          eyebrow="LETTERS"
          title="편지 관리"
          description="하늘로 보내는 편지와 신앙기념관에 남겨진 글의 공개 여부를 관리합니다."
        />
        <AdminLinkCard
          href="/admin/history"
          eyebrow="CHURCH HISTORY"
          title="교회 연혁 관리"
          description="연대와 연혁 기록을 추가하고 공개 여부, 표시 순서를 관리합니다."
        />
      </section>
    </AdminLayout>
  );
}

function AdminLinkCard({
  href,
  eyebrow,
  title,
  description,
}: {
  href: string;
  eyebrow: string;
  title: string;
  description: string;
}) {
  return (
    <Link href={href}>
      <article className="group cursor-pointer border memorial-section bg-white p-6 transition-colors hover:border-[var(--memorial-navy)] md:p-8">
        <p className="memorial-eyebrow">{eyebrow}</p>
        <div className="mt-5 flex items-start justify-between gap-6">
          <div>
            <h2 className="memorial-serif text-2xl">{title}</h2>
            <p className="mt-3 text-sm leading-7 text-[var(--memorial-slate)]">
              {description}
            </p>
          </div>
          <ArrowRight className="mt-1 h-5 w-5 shrink-0 transition-transform group-hover:translate-x-1" />
        </div>
      </article>
    </Link>
  );
}
