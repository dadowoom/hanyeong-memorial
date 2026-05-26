import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { churchConfig, homeCopy, routes } from "@/config/church";
import {
  ArrowRight,
  BookOpenText,
  Flower2,
  Plus,
  Search,
  Send,
} from "lucide-react";
import { Link } from "wouter";

const SERVICE_ICONS = [BookOpenText, Send, Flower2] as const;
const SERVICES = homeCopy.services.map((service, index) => ({
  ...service,
  icon: SERVICE_ICONS[index] ?? BookOpenText,
}));
const STEPS = homeCopy.steps;
const VALUES = homeCopy.values;

const HERO_VIDEO_ID = "haLv3Gtv91M";
const HERO_VIDEO_START = 0;
const HERO_VIDEO_SRC = `https://www.youtube-nocookie.com/embed/${HERO_VIDEO_ID}?autoplay=1&mute=1&controls=0&loop=1&playlist=${HERO_VIDEO_ID}&playsinline=1&rel=0&modestbranding=1&start=${HERO_VIDEO_START}`;
const HERO_VIDEO_POSTER = `https://img.youtube.com/vi/${HERO_VIDEO_ID}/maxresdefault.jpg`;

export default function Home() {
  return (
    <div className="memorial-shell min-h-screen">
      <Navbar />

      <main className="pt-16">
        <section className="relative min-h-[calc(100svh-4rem)] overflow-hidden border-b memorial-section memorial-section-muted">
          <HeroVideoBackground />
          <div className="container relative z-10 flex min-h-[calc(100svh-4rem)] flex-col justify-center py-14 md:py-20">
            <div className="max-w-3xl">
              <p className="memorial-eyebrow mb-6">
                한영교회 온라인 신앙기념 서비스
              </p>
              <h1 className="memorial-serif max-w-3xl text-5xl leading-[1.08] sm:text-6xl md:text-8xl">
                <span className="block">한영교회</span>
                <span className="block">신앙기념관</span>
              </h1>
              <p className="mt-8 max-w-2xl text-base leading-8 text-[var(--memorial-ash)] md:text-lg">
                <span className="block">한영교회 신앙기념관은</span>
                <span className="block">
                  믿음으로 살다 주님 품에 안긴 성도들의 삶과 신앙을 기억하는
                  거룩한 공간입니다.
                </span>
              </p>
              <div className="mt-10 flex flex-col gap-3 sm:flex-row">
                <Link href={routes.memorialSearch}>
                  <button className="memorial-button-primary">
                    <Search className="h-4 w-4" />
                    기념관 자세히 보기
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
                <h2 className="memorial-serif max-w-3xl text-xl leading-[1.75] md:text-2xl md:leading-[1.7]">
                  <span className="block">
                    「{churchConfig.serviceName}」은 성도의 삶과 믿음과 사랑을
                  </span>
                  <span className="block">
                    가족과 교회의 기억 속에 아름답게 보존하며,
                  </span>
                  <span className="block">
                    다음 세대가 신앙의 이야기를 이어받도록 돕습니다.
                  </span>
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
          <div className="container">
            <div className="mb-10 flex flex-col justify-between gap-6 md:flex-row md:items-end">
              <div>
                <p className="mb-4 text-xs font-semibold uppercase text-white/62">
                  Services
                </p>
                <h2 className="memorial-serif text-3xl text-white md:text-5xl">
                  세 가지 서비스
                </h2>
              </div>
              <p className="max-w-md text-sm leading-7 text-white/68">
                등록부터 공유, 공동체 댓글까지 신앙기념관 운영 흐름을 단순하게
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
              <h2 className="memorial-serif text-3xl md:text-5xl">
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
                <h2 className="memorial-serif text-3xl text-white md:text-5xl">
                  신앙기념관을 만들 준비가 되었나요
                </h2>
                <p className="mt-5 max-w-2xl text-sm leading-7 text-white/68">
                  회원가입 후 성도의 삶과 신앙을 등록하고, 온라인 신앙기념관을
                  만들 수 있습니다. 소천 이후에는 별도 전환 흐름으로 추모관을 열
                  수 있습니다.
                </p>
              </div>
              <Link href={routes.memorialCreate}>
                <button className="memorial-button-light">
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

function HeroVideoBackground() {
  return (
    <div
      className="pointer-events-none absolute inset-0 overflow-hidden bg-[var(--memorial-cloud)]"
      aria-hidden="true"
    >
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_18%_28%,rgba(255,255,255,0.92),transparent_34%),linear-gradient(90deg,#ffffff_0%,#f8f8f8_43%,#f4f4f4_100%)]" />

      <div
        className="absolute inset-y-0 right-0 hidden w-[56vw] overflow-hidden bg-cover bg-center md:block lg:w-[62vw]"
        style={{ backgroundImage: `url(${HERO_VIDEO_POSTER})` }}
      >
        <iframe
          title={`${churchConfig.churchName} 배경 영상`}
          src={HERO_VIDEO_SRC}
          className="absolute left-1/2 top-1/2 h-[56.25vw] min-h-full w-screen min-w-[177.78vh] -translate-x-1/2 -translate-y-1/2 border-0 opacity-42 contrast-110 saturate-[0.55]"
          allow="autoplay; fullscreen; picture-in-picture"
          tabIndex={-1}
        />
        <div className="absolute inset-0 bg-[var(--memorial-navy)]/66" />
        <div className="absolute inset-0 bg-gradient-to-r from-[var(--memorial-cloud)] via-white/68 to-[var(--memorial-navy-soft)]/38" />
        <div className="absolute inset-0 bg-gradient-to-b from-[var(--memorial-navy-deep)]/16 via-transparent to-[var(--memorial-navy-deep)]/72" />
      </div>

      <div className="absolute inset-y-0 left-0 w-[56vw] bg-gradient-to-r from-white via-white/92 to-transparent" />
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_74%_10%,rgba(255,255,255,0.34),transparent_28%),radial-gradient(circle_at_92%_86%,rgba(201,201,205,0.28),transparent_34%)]" />
    </div>
  );
}
