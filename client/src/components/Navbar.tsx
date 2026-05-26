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
    <header className="fixed left-0 right-0 top-0 z-50 border-b memorial-section bg-white/95 backdrop-blur">
      <div className="container">
        <div className="flex h-16 items-center justify-between">
          <Link href="/">
            <div className="flex cursor-pointer items-center gap-3">
              <span className="memorial-mark flex h-8 w-8 items-center justify-center">
                <Plus className="h-4 w-4" strokeWidth={1.7} />
              </span>
              <div className="leading-tight">
                <span className="memorial-serif block text-sm text-[var(--memorial-ink)]">
                  {churchConfig.serviceName}
                </span>
                <span className="block text-[10px] text-[var(--memorial-ash)]">
                  {churchConfig.serviceSubtitle}
                </span>
              </div>
            </div>
          </Link>

          <nav className="hidden items-center gap-1 md:flex lg:gap-2">
            {navItems.map(item => (
              <a key={item.href} href={item.href} className="memorial-nav-link">
                {item.label}
              </a>
            ))}
          </nav>

          <div className="hidden items-center gap-3 lg:flex">
            <Link href={routes.memorialSearch}>
              <button className="memorial-button-secondary min-h-9 px-4 text-xs">
                <Search className="h-3.5 w-3.5" />
                추모관
              </button>
            </Link>
            {isAuthenticated ? (
              <>
                <Link href="/">
                  <span className="text-sm text-[var(--memorial-ash)] transition-colors hover:text-[var(--memorial-ink)]">
                    {user?.name || "계정"}
                  </span>
                </Link>
                <button
                  onClick={() => logout()}
                  className="memorial-button-secondary min-h-9 px-4 text-xs text-[var(--memorial-ash)]"
                >
                  로그아웃
                </button>
              </>
            ) : (
              <a href={getLoginUrl()}>
                <button className="memorial-button-primary min-h-9 px-4 text-xs">
                  로그인
                </button>
              </a>
            )}
          </div>

          <button
            type="button"
            className="inline-flex h-10 w-10 items-center justify-center rounded-full border border-[var(--memorial-line)] bg-white text-[var(--memorial-ink)] md:hidden"
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
        <div className="border-t memorial-section bg-white md:hidden">
          <div className="container flex flex-col gap-1 py-4">
            {navItems.map(item => (
              <a
                key={item.href}
                href={item.href}
                onClick={closeMobile}
                className="py-3 text-sm text-[var(--memorial-ink)]"
              >
                {item.label}
              </a>
            ))}
            <Link href={routes.memorialSearch}>
              <span
                onClick={closeMobile}
                className="py-3 text-sm text-[var(--memorial-ink)]"
              >
                추모관
              </span>
            </Link>
            <Link href={routes.memorialCreate}>
              <span
                onClick={closeMobile}
                className="py-3 text-sm text-[var(--memorial-ink)]"
              >
                추모관 만들기
              </span>
            </Link>
            <div className="mt-3 border-t memorial-section pt-4">
              {isAuthenticated ? (
                <button
                  onClick={() => {
                    logout();
                    closeMobile();
                  }}
                  className="memorial-button-secondary min-h-10 w-full text-sm"
                >
                  로그아웃
                </button>
              ) : (
                <a href={getLoginUrl()} onClick={closeMobile}>
                  <button className="memorial-button-primary min-h-10 w-full text-sm">
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
