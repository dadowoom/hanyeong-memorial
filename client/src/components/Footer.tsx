import { churchConfig, serviceLinks } from "@/config/church";
import { Plus } from "lucide-react";
import { Link } from "wouter";

export default function Footer() {
  return (
    <footer className="border-t border-[var(--memorial-night-line)] bg-[var(--memorial-ink)] text-white/62">
      <div className="container py-12 md:py-20">
        <div className="grid gap-10 md:grid-cols-[1.2fr_0.8fr_0.8fr]">
          <div>
            <div className="mb-5 flex items-center gap-3">
              <span className="flex h-8 w-8 items-center justify-center rounded-full bg-white text-[var(--memorial-ink)]">
                <Plus className="h-4 w-4" strokeWidth={1.7} />
              </span>
              <div className="leading-tight">
                <span className="memorial-serif block text-sm text-white">
                  {churchConfig.serviceName}
                </span>
                <span className="block text-[10px] text-white/52">
                  {churchConfig.serviceSubtitle}
                </span>
              </div>
            </div>
            <p className="max-w-sm text-sm leading-7">
              소중한 분의 삶과 신앙을 교회 공동체가 함께 기억합니다.
            </p>
          </div>

          <div>
            <h2 className="mb-4 text-xs font-semibold uppercase text-white">
              서비스
            </h2>
            <ul className="space-y-3 text-sm">
              {serviceLinks.map(link => (
                <li key={link.href}>
                  {link.type === "route" ? (
                    <Link href={link.href}>
                      <span className="cursor-pointer transition-colors hover:text-white">
                        {link.label}
                      </span>
                    </Link>
                  ) : (
                    <a
                      href={link.href}
                      className="transition-colors hover:text-white"
                    >
                      {link.label}
                    </a>
                  )}
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h2 className="mb-4 text-xs font-semibold uppercase text-white">
              {churchConfig.churchName}
            </h2>
            <ul className="space-y-3 text-sm">
              <li>{churchConfig.contact.address}</li>
              <li>{churchConfig.contact.serviceLabel}</li>
            </ul>
          </div>
        </div>

        <div className="mt-12 flex flex-col justify-between gap-3 border-t border-white/14 pt-6 text-xs md:flex-row">
          <p>© 2026 {churchConfig.churchName}. All rights reserved.</p>
          <p>{churchConfig.serviceName} - 온라인 추모 서비스</p>
        </div>
      </div>
    </footer>
  );
}
