import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { churchConfig, homeCopy, routes } from "@/config/church";
import { trpc } from "@/lib/trpc";
import {
  ArrowRight,
  BookOpenText,
  Flower2,
  Plus,
  Search,
  Send,
} from "lucide-react";
import { Link } from "wouter";

const SERVICE_ICONS = [BookOpenText, Flower2, Send] as const;
const SERVICES = homeCopy.services.map((service, index) => ({
  ...service,
  icon: SERVICE_ICONS[index] ?? BookOpenText,
}));
const STEPS = homeCopy.steps;
const VALUES = homeCopy.values;

export default function Home() {
  const memorialsQuery = trpc.memorial.list.useQuery();
  const recentMemorials = (memorialsQuery.data ?? []).slice(0, 3);

  return (
    <div className="memorial-shell min-h-screen">
      <Navbar />

      <main className="pt-16">
        <section className="relative min-h-[calc(100svh-4rem)] overflow-hidden border-b memorial-section memorial-section-muted">
          <HeroBackground />
          <div className="container relative z-10 flex min-h-[calc(100svh-4rem)] flex-col justify-center py-12 md:py-20">
            <div className="max-w-3xl">
              <p className="memorial-eyebrow mb-6">
                한영교회 온라인 신앙기념 서비스
              </p>
              <h1 className="memorial-serif max-w-3xl text-[2.75rem] leading-[1.04] sm:text-[3.2rem] md:text-[5.1rem] md:leading-[1.08]">
                <span className="block">한영교회</span>
                <span className="block">신앙기념관</span>
              </h1>
              <p className="mt-7 max-w-2xl text-[15px] leading-7 text-[var(--memorial-ash)] md:mt-8 md:text-lg md:leading-8">
                한영교회 신앙기념관은 <br className="hidden md:block" />
                성도들의 삶 속에 담긴 믿음의 발자취를 소중히 기억하고,{" "}
                <br className="hidden md:block" />그 신앙의 유산을 오늘과 다음
                세대가 함께 이어가도록 돕는 공간입니다.
              </p>
              <div className="memorial-action-row mt-9 md:mt-10">
                <Link href={`${routes.memorialGarden}#faith-memorials`}>
                  <button className="memorial-button-primary">
                    <Search className="h-4 w-4" />
                    신앙기념관 검색
                  </button>
                </Link>
                <Link href={routes.memorialCreate}>
                  <button className="memorial-button-secondary">
                    <Plus className="h-4 w-4" />
                    신앙기념관 만들기
                  </button>
                </Link>
              </div>
            </div>
          </div>
        </section>

        <section
          id="memorials"
          className="scroll-mt-16 border-b memorial-section bg-white"
        >
          <div className="container py-16 md:py-24">
            <div className="mx-auto max-w-6xl border-y memorial-section py-10 md:py-12">
              <div className="grid gap-7 md:grid-cols-[220px_minmax(0,1fr)] md:items-start">
                <div className="flex items-center gap-5 md:block">
                  <p className="memorial-eyebrow">Values</p>
                  <div className="h-px flex-1 bg-[var(--memorial-ash)] md:mt-8 md:w-16" />
                </div>
                <h2 className="memorial-serif max-w-3xl text-[1.35rem] leading-[1.65] md:text-2xl md:leading-[1.7]">
                  「{churchConfig.serviceName}」은 성도의 삶과 믿음과 사랑을{" "}
                  <br className="hidden md:block" />
                  가족과 교회의 기억 속에 아름답게 보존하며,{" "}
                  <br className="hidden md:block" />
                  다음 세대가 신앙의 이야기를 이어받도록 돕습니다.
                </h2>
              </div>

              <div className="mt-10 grid border-t memorial-section md:grid-cols-3">
                {VALUES.map(value => (
                  <article
                    key={value.number}
                    className="border-b memorial-section py-6 md:border-b-0 md:border-r md:px-7 md:last:border-r-0"
                  >
                    <p className="text-sm text-[var(--memorial-slate)]">
                      {value.number}
                    </p>
                    <h3 className="memorial-serif mt-5 text-base">
                      {value.title}
                    </h3>
                    <p className="memorial-body mt-4 text-sm">{value.desc}</p>
                  </article>
                ))}
              </div>
            </div>
          </div>
        </section>

        <section
          id="services"
          className="border-b border-[var(--memorial-night-line)] bg-[var(--memorial-ink)] py-16 text-white md:py-24"
        >
          <div className="container mb-16 md:mb-24">
            <div className="grid gap-8 border-y border-white/18 py-10 md:grid-cols-[minmax(0,0.82fr)_minmax(320px,0.58fr)] md:items-center md:py-12">
              <div>
                <p className="mb-4 text-xs font-semibold uppercase text-white/62">
                  Recent Memorials
                </p>
                <h2 className="memorial-serif text-[1.75rem] leading-tight text-white md:text-5xl">
                  최근 등록 신앙기념관
                </h2>
                <p className="mt-5 max-w-2xl text-sm leading-7 text-white/68">
                  새로 등록된 신앙기념관을 이름 중심으로 확인하고 바로 이동할 수
                  있습니다.
                </p>
              </div>

              <div className="border border-white/18 bg-[var(--memorial-graphite)]">
                {memorialsQuery.isLoading ? (
                  <p className="px-5 py-7 text-sm text-white/62">
                    최근 등록 신앙기념관을 불러오고 있습니다.
                  </p>
                ) : recentMemorials.length > 0 ? (
                  <div className="divide-y divide-white/14">
                    {recentMemorials.map((memorial, index) => (
                      <Link
                        key={memorial.id}
                        href={memorial.href}
                      >
                        <article className="group grid cursor-pointer grid-cols-[48px_minmax(0,1fr)_auto] items-center gap-4 px-5 py-5 transition-colors hover:bg-white/8">
                          <span className="text-sm text-white/42">
                            {String(index + 1).padStart(2, "0")}
                          </span>
                          <div className="min-w-0">
                            <h3 className="memorial-serif truncate text-xl text-white">
                              {memorial.name} {memorial.role}
                            </h3>
                            <p className="mt-1 truncate text-xs text-white/54">
                              {memorial.church}
                            </p>
                          </div>
                          <ArrowRight className="h-4 w-4 text-white/72 transition-transform group-hover:translate-x-1" />
                        </article>
                      </Link>
                    ))}
                  </div>
                ) : (
                  <p className="px-5 py-7 text-sm text-white/62">
                    아직 등록된 신앙기념관이 없습니다.
                  </p>
                )}
              </div>
            </div>
          </div>

          <div className="container">
            <div className="mb-10 flex flex-col justify-between gap-6 md:flex-row md:items-end">
              <div>
                <p className="mb-4 text-xs font-semibold uppercase text-white/62">
                  Services
                </p>
                <h2 className="memorial-serif text-[1.75rem] leading-tight text-white md:text-5xl">
                  세 가지 서비스
                </h2>
              </div>
              <p className="max-w-md text-sm leading-7 text-white/68">
                등록부터 공유, 공동체 응원글까지 신앙기념관 운영 흐름을 단순하게
                정리했습니다.
              </p>
            </div>

            <div className="grid grid-cols-1 gap-px bg-white/16 md:grid-cols-3">
              {SERVICES.map(service => {
                const Icon = service.icon;
                return (
                  <article
                    key={service.number}
                    className="bg-[var(--memorial-graphite)] p-6 md:p-8"
                  >
                    <div className="mb-12 flex items-start justify-between">
                      <span className="text-sm text-white/48">
                        {service.number}
                      </span>
                      <Icon className="h-5 w-5 text-white" strokeWidth={1.5} />
                    </div>
                    <h3 className="memorial-serif text-xl text-white">
                      {service.title}
                    </h3>
                    <p className="mt-4 text-sm leading-7 text-white/66">
                      {service.desc}
                    </p>
                  </article>
                );
              })}
            </div>
          </div>
        </section>

        <section
          id="process"
          className="border-b memorial-section bg-white py-16 md:py-24"
        >
          <div className="container grid gap-10 md:grid-cols-[0.8fr_1.2fr]">
            <div>
              <p className="memorial-eyebrow mb-4">Process</p>
              <h2 className="memorial-serif text-[1.75rem] leading-tight md:text-5xl">
                신앙기념관
                <br />
                만들기
              </h2>
            </div>
            <div className="border-t memorial-section">
              {STEPS.map((step, index) => (
                <div
                  key={step}
                  className="grid gap-6 border-b memorial-section py-6 md:grid-cols-[96px_1fr]"
                >
                  <span className="text-sm text-[var(--memorial-slate)]">
                    {String(index + 1).padStart(2, "0")}
                  </span>
                  <p className="text-base leading-8 text-[var(--memorial-ink)]">
                    {step}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section id="membership" className="bg-white py-16 md:py-24">
          <div className="container">
            <div className="grid gap-10 rounded-lg border border-[var(--memorial-ink)] bg-[var(--memorial-ink)] p-6 text-white md:grid-cols-[1fr_auto] md:items-center md:p-10">
              <div>
                <p className="mb-4 text-xs font-semibold uppercase text-white/62">
                  {churchConfig.churchName} 성도 전용
                </p>
                <h2 className="memorial-serif text-[1.75rem] leading-tight text-white md:text-5xl">
                  <span className="sm:block">신앙의 유산을</span>
                  <span className="sm:block">남길 준비가 되어 있나요</span>
                </h2>
                <p className="mt-5 max-w-2xl text-sm leading-7 text-white/68">
                  성도의 삶과 믿음의 기록을 정리해 가족과 다음 세대가 이어받을
                  신앙의 유산으로 남깁니다. 회원가입 후 온라인 신앙기념관을 만들
                  수 있습니다.
                </p>
              </div>
              <Link href={routes.memorialCreate}>
                <button className="memorial-button-light w-full sm:w-auto">
                  시작하기
                  <ArrowRight className="h-4 w-4" />
                </button>
              </Link>
            </div>
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}

function HeroBackground() {
  return (
    <div
      className="pointer-events-none absolute inset-0 overflow-hidden bg-[#fbfaf6]"
      aria-hidden="true"
    >
      <img
        src="/memorial-assets/home-hero-hanyeong-faith.jpg"
        alt=""
        className="absolute inset-0 h-full w-full object-cover object-[62%_center]"
        loading="eager"
      />
      <div className="absolute inset-0 bg-[linear-gradient(90deg,#ffffff_0%,rgba(255,255,255,0.98)_33%,rgba(255,255,255,0.82)_55%,rgba(255,255,255,0.18)_100%)]" />
      <div className="absolute inset-0 bg-[linear-gradient(180deg,rgba(255,255,255,0.72)_0%,rgba(255,255,255,0)_28%,rgba(255,255,255,0.72)_100%)]" />
      <div className="absolute inset-x-0 bottom-0 h-28 bg-gradient-to-t from-white to-transparent" />
    </div>
  );
}
