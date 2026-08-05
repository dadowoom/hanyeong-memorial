import { useAuth } from "@/_core/hooks/useAuth";
import LogoMark from "@/components/LogoMark";
import { churchConfig } from "@/config/church";
import {
  BookOpenText,
  ExternalLink,
  Landmark,
  LayoutDashboard,
  LogOut,
  Mail,
  Menu,
  Users,
  X,
} from "lucide-react";
import { type ReactNode, useState } from "react";
import { Link, useLocation } from "wouter";

const adminNavItems = [
  { href: "/admin", label: "운영 현황", icon: LayoutDashboard },
  { href: "/admin/users", label: "회원 관리", icon: Users },
  { href: "/admin/memorials", label: "신앙기념관 관리", icon: Landmark },
  { href: "/admin/letters", label: "편지 관리", icon: Mail },
  { href: "/admin/history", label: "교회 연혁", icon: BookOpenText },
] as const;

export default function AdminLayout({
  title,
  description,
  children,
  action,
}: {
  title: string;
  description: string;
  children: ReactNode;
  action?: ReactNode;
}) {
  const { user, loading, logout } = useAuth({
    redirectOnUnauthenticated: true,
  });
  const [location] = useLocation();
  const [mobileOpen, setMobileOpen] = useState(false);

  if (loading || !user) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[var(--memorial-cloud)] px-6 text-center">
        <p className="text-sm text-[var(--memorial-slate)]">
          관리자 권한을 확인하고 있습니다.
        </p>
      </div>
    );
  }

  if (user.role !== "admin") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[var(--memorial-cloud)] px-6">
        <div className="w-full max-w-lg border memorial-section bg-white p-8 text-center md:p-12">
          <p className="memorial-eyebrow">ADMIN ACCESS</p>
          <h1 className="memorial-serif mt-5 text-3xl">
            관리자 전용 화면입니다
          </h1>
          <p className="mt-4 text-sm leading-7 text-[var(--memorial-slate)]">
            한영교회 역사관 관리자 권한이 있는 계정만 이용할 수 있습니다.
          </p>
          <Link href="/">
            <span className="memorial-button-primary mt-8 inline-flex">
              홈으로
            </span>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[var(--memorial-cloud)] text-[var(--memorial-ink)]">
      <aside className="fixed inset-y-0 left-0 z-40 hidden w-64 flex-col bg-[var(--memorial-navy)] text-white lg:flex">
        <Link href="/admin">
          <div className="flex h-20 cursor-pointer items-center gap-3 border-b border-white/12 px-6">
            <LogoMark className="h-10 w-10" />
            <div>
              <p className="memorial-serif text-base">
                {churchConfig.serviceTitle}
              </p>
              <p className="mt-1 text-[10px] tracking-[0.18em] text-white/52">
                ADMINISTRATION
              </p>
            </div>
          </div>
        </Link>

        <nav className="flex-1 space-y-1 px-4 py-6">
          {adminNavItems.map(item => {
            const active =
              item.href === "/admin"
                ? location === item.href
                : location.startsWith(item.href);
            return (
              <Link key={item.href} href={item.href}>
                <span
                  className={`flex min-h-11 cursor-pointer items-center gap-3 rounded-lg px-4 text-sm transition-colors ${
                    active
                      ? "bg-white text-[var(--memorial-navy)]"
                      : "text-white/70 hover:bg-white/10 hover:text-white"
                  }`}
                >
                  <item.icon className="h-4 w-4" />
                  {item.label}
                </span>
              </Link>
            );
          })}
        </nav>

        <div className="border-t border-white/12 p-4">
          <div className="px-3 py-2">
            <p className="truncate text-sm font-semibold">
              {user.name || "관리자"}
            </p>
            <p className="mt-1 truncate text-xs text-white/48">{user.email}</p>
          </div>
          <Link href="/">
            <span className="mt-2 flex min-h-10 cursor-pointer items-center gap-2 rounded-lg px-3 text-xs text-white/68 hover:bg-white/10 hover:text-white">
              <ExternalLink className="h-3.5 w-3.5" />
              사이트 보기
            </span>
          </Link>
          <button
            type="button"
            onClick={() => logout()}
            className="flex min-h-10 w-full items-center gap-2 rounded-lg px-3 text-xs text-white/68 hover:bg-white/10 hover:text-white"
          >
            <LogOut className="h-3.5 w-3.5" />
            로그아웃
          </button>
        </div>
      </aside>

      <div className="lg:pl-64">
        <header className="sticky top-0 z-30 border-b memorial-section bg-white/95 backdrop-blur lg:hidden">
          <div className="flex h-16 items-center justify-between px-4">
            <Link href="/admin">
              <span className="flex cursor-pointer items-center gap-2">
                <LogoMark className="h-9 w-9" />
                <span className="memorial-serif text-sm">역사관 관리자</span>
              </span>
            </Link>
            <button
              type="button"
              onClick={() => setMobileOpen(open => !open)}
              className="flex h-10 w-10 items-center justify-center rounded-full border memorial-section"
              aria-label={mobileOpen ? "관리자 메뉴 닫기" : "관리자 메뉴 열기"}
              aria-expanded={mobileOpen}
            >
              {mobileOpen ? (
                <X className="h-4 w-4" />
              ) : (
                <Menu className="h-4 w-4" />
              )}
            </button>
          </div>
          {mobileOpen && (
            <nav className="border-t memorial-section bg-white px-4 py-3">
              <div className="grid gap-2">
                {adminNavItems.map(item => (
                  <Link key={item.href} href={item.href}>
                    <span
                      onClick={() => setMobileOpen(false)}
                      className="flex min-h-11 cursor-pointer items-center gap-3 rounded-lg border memorial-section px-4 text-sm"
                    >
                      <item.icon className="h-4 w-4" />
                      {item.label}
                    </span>
                  </Link>
                ))}
                <Link href="/">
                  <span className="flex min-h-11 cursor-pointer items-center gap-3 rounded-lg border memorial-section px-4 text-sm">
                    <ExternalLink className="h-4 w-4" />
                    사이트 보기
                  </span>
                </Link>
              </div>
            </nav>
          )}
        </header>

        <main className="px-4 py-6 md:px-8 md:py-9 xl:px-12">
          <div className="mx-auto max-w-7xl">
            <div className="mb-7 flex flex-col justify-between gap-5 md:flex-row md:items-end">
              <div>
                <p className="memorial-eyebrow">HANYEONG ADMIN</p>
                <h1 className="memorial-serif mt-4 text-3xl md:text-4xl">
                  {title}
                </h1>
                <p className="mt-3 max-w-2xl text-sm leading-7 text-[var(--memorial-slate)]">
                  {description}
                </p>
              </div>
              {action}
            </div>
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
