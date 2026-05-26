import { useAuth } from "@/_core/hooks/useAuth";
import { churchConfig, navItems, routes } from "@/config/church";
import { getLoginUrl } from "@/const";
import { Menu, Plus, Search, X } from "lucide-react";
import { useState } from "react";
import { Link } from "wouter";

export default function Navbar() {
  const { user, isAuthenticated, logout } = useAuth();
  const [mobileOpen, setMobileOpen] = useState(false);

  const closeMobile = () => setMobileOpen(false);

  return (
    <header className="fixed left-0 right-0 top-0 z-50 border-b border-[var(--memorial-navy-deep)] bg-[var(--memorial-navy)]/95 text-white backdrop-blur">
      <div className="container">
        <div className="flex h-16 items-center justify-between">
          <Link href="/">
            <div className="flex cursor-pointer items-center gap-3">
              <span className="flex h-8 w-8 items-center justify-center rounded-full bg-white text-[var(--memorial-navy)]">
                <Plus className="h-4 w-4" strokeWidth={1.7} />
              </span>
              <div className="leading-tight">
                <span className="memorial-serif block text-sm text-white">
                  {churchConfig.serviceName}
                </span>
                <span className="block text-[10px] text-white/58">
                  {churchConfig.serviceSubtitle}
                </span>
              </div>
            </div>
          </Link>

          <nav className="hidden items-center gap-1 md:flex lg:gap-2">
            {navItems.map(item => (
              <a
                key={item.href}
                href={item.href}
                className="rounded-full px-4 py-2 text-sm text-white/72 transition-colors hover:bg-white/10 hover:text-white"
              >
                {item.label}
              </a>
            ))}
          </nav>

          <div className="hidden items-center gap-3 lg:flex">
            <Link href={routes.memorialSearch}>
              <button className="memorial-button-light min-h-9 px-4 text-xs">
                <Search className="h-3.5 w-3.5" />
                추모관
              </button>
            </Link>
            {isAuthenticated ? (
              <>
                <Link href="/">
                  <span className="text-sm text-white/70 transition-colors hover:text-white">
                    {user?.name || "계정"}
                  </span>
                </Link>
                <button
                  onClick={() => logout()}
                  className="min-h-9 rounded-full border border-white/20 px-4 text-xs font-semibold text-white/76 transition-colors hover:bg-white/10 hover:text-white"
                >
                  로그아웃
                </button>
              </>
            ) : (
              <a href={getLoginUrl()}>
                <button className="memorial-button-light min-h-9 px-4 text-xs">
                  로그인
                </button>
              </a>
            )}
          </div>

          <button
            type="button"
            className="inline-flex h-10 w-10 items-center justify-center rounded-full border border-white/18 bg-white/8 text-white md:hidden"
            onClick={() => setMobileOpen(open => !open)}
            aria-label={mobileOpen ? "메뉴 닫기" : "메뉴 열기"}
          >
            {mobileOpen ? (
              <X className="h-4 w-4" />
            ) : (
              <Menu className="h-4 w-4" />
            )}
          </button>
        </div>
      </div>

      {mobileOpen && (
        <div className="border-t border-white/14 bg-[var(--memorial-navy)] md:hidden">
          <div className="container flex flex-col gap-1 py-4">
            {navItems.map(item => (
              <a
                key={item.href}
                href={item.href}
                onClick={closeMobile}
                className="py-3 text-sm text-white/82"
              >
                {item.label}
              </a>
            ))}
            <Link href={routes.memorialSearch}>
              <span
                onClick={closeMobile}
                className="py-3 text-sm text-white/82"
              >
                추모관
              </span>
            </Link>
            <Link href={routes.memorialCreate}>
              <span
                onClick={closeMobile}
                className="py-3 text-sm text-white/82"
              >
                추모관 만들기
              </span>
            </Link>
            <div className="mt-3 border-t border-white/14 pt-4">
              {isAuthenticated ? (
                <button
                  onClick={() => {
                    logout();
                    closeMobile();
                  }}
                  className="min-h-10 w-full rounded-full border border-white/20 text-sm font-semibold text-white/82"
                >
                  로그아웃
                </button>
              ) : (
                <a href={getLoginUrl()} onClick={closeMobile}>
                  <button className="memorial-button-light min-h-10 w-full text-sm">
                    로그인
                  </button>
                </a>
              )}
            </div>
          </div>
        </div>
      )}
    </header>
  );
}
