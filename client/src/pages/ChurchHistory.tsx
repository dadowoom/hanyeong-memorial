import { useAuth } from "@/_core/hooks/useAuth";
import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { churchConfig } from "@/config/church";
import { trpc } from "@/lib/trpc";
import { groupHistoryItemsByYear, sortHistoryDecades } from "@shared/history";
import { Settings2 } from "lucide-react";
import { lazy, Suspense, useEffect, useMemo, useState } from "react";

const HistoryAdminPanel = lazy(
  () => import("@/components/history/HistoryAdminPanel")
);

type HistoryDecade = {
  id: number;
  title: string;
  startYear: number;
  endYear: number;
  sortOrder: number;
};

type HistoryItem = {
  id: number;
  decadeId: number;
  year: number;
  month: number;
  content: string;
  sortOrder: number;
};

export default function ChurchHistory() {
  const { user } = useAuth();
  const historyQuery = trpc.history.public.useQuery();
  const [activeDecadeId, setActiveDecadeId] = useState<number | null>(null);
  const [managerOpen, setManagerOpen] = useState(false);
  const isAdmin = user?.role === "admin";

  const decades = useMemo(
    () =>
      sortHistoryDecades((historyQuery.data?.decades ?? []) as HistoryDecade[]),
    [historyQuery.data?.decades]
  );
  const items = (historyQuery.data?.items ?? []) as HistoryItem[];

  useEffect(() => {
    if (!decades.some(decade => decade.id === activeDecadeId)) {
      setActiveDecadeId(decades[0]?.id ?? null);
    }
  }, [activeDecadeId, decades]);

  useEffect(() => {
    const previousTitle = document.title;
    document.title = `교회 연혁 | ${churchConfig.serviceTitle}`;
    return () => {
      document.title = previousTitle;
    };
  }, []);

  const yearGroups = useMemo(
    () =>
      groupHistoryItemsByYear(
        items.filter(item => item.decadeId === activeDecadeId)
      ),
    [activeDecadeId, items]
  );

  return (
    <div className="memorial-shell min-h-screen bg-white">
      <Navbar />

      <main className="pt-16">
        <header className="border-b memorial-section memorial-section-muted">
          <div className="container py-12 md:py-16">
            <div className="flex flex-col justify-between gap-8 md:flex-row md:items-end">
              <div>
                <p className="memorial-eyebrow mb-5">HANYEONG CHURCH HISTORY</p>
                <h1 className="memorial-serif text-4xl leading-tight md:text-6xl">
                  교회 연혁
                </h1>
                <p className="memorial-body mt-5 max-w-2xl text-sm md:text-base">
                  한영교회가 걸어온 믿음과 섬김의 시간을 기록합니다.
                </p>
              </div>

              {isAdmin && (
                <button
                  type="button"
                  onClick={() => setManagerOpen(true)}
                  className="memorial-button-primary self-start md:self-auto"
                >
                  <Settings2 className="h-4 w-4" />
                  연혁 관리
                </button>
              )}
            </div>
          </div>
        </header>

        <section className="container py-12 md:py-20">
          {historyQuery.isLoading ? (
            <CenteredMessage>교회 연혁을 불러오고 있습니다.</CenteredMessage>
          ) : decades.length === 0 ? (
            <CenteredMessage>등록된 교회 연혁이 없습니다.</CenteredMessage>
          ) : (
            <>
              <div className="overflow-x-auto border-b memorial-section">
                <div className="flex min-w-max gap-1">
                  {decades.map(decade => {
                    const active = decade.id === activeDecadeId;
                    return (
                      <button
                        key={decade.id}
                        type="button"
                        onClick={() => setActiveDecadeId(decade.id)}
                        className={`min-h-12 min-w-28 border-b-2 px-5 py-3 text-sm font-semibold transition-colors ${
                          active
                            ? "border-[var(--memorial-navy)] text-[var(--memorial-navy)]"
                            : "border-transparent text-[var(--memorial-slate)] hover:text-[var(--memorial-ink)]"
                        }`}
                      >
                        {decade.title}
                      </button>
                    );
                  })}
                </div>
              </div>

              <div className="mx-auto mt-10 max-w-5xl">
                {yearGroups.length === 0 ? (
                  <CenteredMessage>
                    선택한 연대에 등록된 연혁이 없습니다.
                  </CenteredMessage>
                ) : (
                  <div className="divide-y memorial-section">
                    {yearGroups.map(group => (
                      <article
                        key={group.year}
                        className="grid gap-5 py-8 md:grid-cols-[160px_minmax(0,1fr)] md:gap-10 md:py-10"
                      >
                        <h2 className="memorial-serif text-4xl text-[var(--memorial-navy)] md:text-5xl">
                          {group.year}
                        </h2>
                        <div className="space-y-5">
                          {group.items.map(item => (
                            <div
                              key={item.id}
                              className="grid grid-cols-[48px_minmax(0,1fr)] gap-4"
                            >
                              <span className="pt-0.5 text-sm font-semibold text-[var(--memorial-slate)]">
                                {String(item.month).padStart(2, "0")}
                              </span>
                              <p className="whitespace-pre-line text-sm leading-7 text-[var(--memorial-ash)] md:text-base md:leading-8">
                                {item.content}
                              </p>
                            </div>
                          ))}
                        </div>
                      </article>
                    ))}
                  </div>
                )}
              </div>
            </>
          )}
        </section>
      </main>

      <Footer />
      {isAdmin && managerOpen && (
        <Suspense fallback={null}>
          <HistoryAdminPanel open onOpenChange={setManagerOpen} />
        </Suspense>
      )}
    </div>
  );
}

function CenteredMessage({ children }: { children: string }) {
  return (
    <div className="border-y memorial-section py-16 text-center text-sm text-[var(--memorial-slate)]">
      {children}
    </div>
  );
}
