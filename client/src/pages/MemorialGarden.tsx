import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { churchConfig, routes } from "@/config/church";
import { toImgUrl } from "@/lib/imageUrl";
import { trpc } from "@/lib/trpc";
import {
  ArrowRight,
  BookOpenText,
  ChevronLeft,
  ChevronRight,
  MessageCircle,
  Plus,
  Search,
  TreePine,
  UserRound,
} from "lucide-react";
import { useMemo, useState } from "react";
import { Link } from "wouter";

const FEATURES = [
  {
    label: "기록",
    title: "삶과 신앙을 한곳에",
    desc: "사진첩, 영상, 책장, 연표를 통해 성도의 믿음과 사랑을 차분하게 보존합니다.",
    icon: BookOpenText,
  },
  {
    label: "공유",
    title: "필요한 만큼 열어두기",
    desc: "공개 기념관과 비공개 기념관을 선택하고, 가족관은 별도 비밀번호로 보호합니다.",
    icon: Search,
  },
  {
    label: "마음",
    title: "기념관 댓글",
    desc: "가족과 교우가 기념관에 짧은 댓글을 남기며 기억과 응원을 조용히 이어갑니다.",
    icon: MessageCircle,
  },
];

const PEOPLE_PAGE_SIZE = 12;

export default function MemorialGarden() {
  const [personQuery, setPersonQuery] = useState("");
  const [personPage, setPersonPage] = useState(1);
  const memorialsQuery = trpc.memorial.list.useQuery();
  const memorials = memorialsQuery.data ?? [];
  const filteredMemorials = useMemo(() => {
    const keyword = personQuery.trim().toLowerCase();
    if (!keyword) return memorials;

    return memorials.filter(memorial =>
      [memorial.name, memorial.role, memorial.church]
        .filter(Boolean)
        .some(value => value.toLowerCase().includes(keyword))
    );
  }, [memorials, personQuery]);
  const totalPeoplePages = Math.max(
    1,
    Math.ceil(filteredMemorials.length / PEOPLE_PAGE_SIZE)
  );
  const currentPeoplePage = Math.min(personPage, totalPeoplePages);
  const visibleMemorials = useMemo(() => {
    const start = (currentPeoplePage - 1) * PEOPLE_PAGE_SIZE;
    return filteredMemorials.slice(start, start + PEOPLE_PAGE_SIZE);
  }, [currentPeoplePage, filteredMemorials]);
  const peoplePageNumbers = useMemo(
    () => Array.from({ length: totalPeoplePages }, (_, index) => index + 1),
    [totalPeoplePages]
  );

  return (
    <div className="memorial-shell min-h-screen">
      <Navbar />

      <main className="pt-16">
        <section className="relative overflow-hidden border-b memorial-section memorial-section-muted">
          <div className="absolute inset-0 bg-[linear-gradient(120deg,#ffffff_0%,#f8f8f8_52%,#f4f4f4_100%)]" />
          <div className="absolute right-0 top-0 hidden h-full w-1/2 border-l border-white/70 bg-[radial-gradient(circle_at_40%_35%,rgba(255,255,255,0.78),transparent_32%),linear-gradient(180deg,rgba(255,255,255,0.46),rgba(201,201,205,0.18))] md:block" />
          <div className="container relative grid gap-10 py-16 md:grid-cols-[minmax(0,0.82fr)_minmax(300px,0.7fr)] md:items-center md:py-24">
            <div>
              <p className="memorial-eyebrow mb-5">Faith Memorial</p>
              <h1 className="memorial-serif max-w-3xl text-5xl leading-[1.12] md:text-7xl">
                신앙 기념관
              </h1>
              <p className="memorial-body mt-8 max-w-2xl text-base">
                {churchConfig.churchName} 성도들의 삶과 믿음을 가족과 교회가
                함께 돌아보는 온라인 신앙 기념 공간입니다. 사진첩, 영상, 책장,
                연표, 댓글 기능을 한영교회에 맞는 차분한 언어로 정리했습니다.
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
                    기념관 만들기
                  </button>
                </Link>
              </div>
            </div>

            <div className="memorial-panel bg-white/80 p-6 backdrop-blur md:p-8">
              <TreePine
                className="h-8 w-8 text-[var(--memorial-ink)]"
                strokeWidth={1.5}
              />
              <p className="memorial-serif mt-8 text-2xl leading-10">
                “한 사람의 믿음은 가족의 기억에 머물고,
                <br />
                교회의 길 위에 조용히 이어집니다.”
              </p>
              <div className="mt-8 h-px bg-[var(--memorial-line)]" />
              <div className="mt-6 grid gap-px bg-[var(--memorial-line)] sm:grid-cols-3">
                <InfoTile label="공개" value="검색 가능" />
                <InfoTile label="비공개" value="비밀번호" />
                <InfoTile label="가족관" value="별도 보호" />
              </div>
            </div>
          </div>
        </section>

        <section className="border-b border-[var(--memorial-line)] bg-white py-16 md:py-24">
          <div className="container">
            <div className="mb-8 flex flex-col justify-between gap-5 md:flex-row md:items-end">
              <div>
                <p className="memorial-eyebrow mb-4">Registered People</p>
                <h2 className="memorial-serif text-3xl md:text-5xl">
                  등록된 인물
                </h2>
              </div>
              <p className="memorial-body max-w-md text-sm">
                등록된 성도의 사진과 이름, 직분을 한눈에 확인하고 각 기념관으로
                바로 이동할 수 있습니다.
              </p>
            </div>

            <div className="mb-8 grid gap-3 md:grid-cols-[minmax(0,420px)_1fr] md:items-center">
              <label className="flex h-12 items-center gap-3 border border-[var(--memorial-line)] bg-white px-4">
                <Search
                  className="h-4 w-4 shrink-0 text-[var(--memorial-ash)]"
                  strokeWidth={1.6}
                />
                <input
                  value={personQuery}
                  onChange={event => {
                    setPersonQuery(event.target.value);
                    setPersonPage(1);
                  }}
                  placeholder="이름, 직분, 교회로 검색"
                  className="h-full min-w-0 flex-1 bg-transparent text-sm text-[var(--memorial-ink)] outline-none placeholder:text-[var(--memorial-slate)]"
                />
              </label>
              <p className="text-sm text-[var(--memorial-ash)] md:text-right">
                등록 인물 {filteredMemorials.length}명 · 12명씩 보기
              </p>
            </div>

            {memorialsQuery.isLoading ? (
              <div className="border border-[var(--memorial-line)] bg-[#fbfaf8] px-6 py-12 text-center text-sm text-[var(--memorial-ash)]">
                등록된 인물을 불러오고 있습니다.
              </div>
            ) : filteredMemorials.length > 0 ? (
              <>
                <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                  {visibleMemorials.map(memorial => (
                    <Link key={memorial.id} href={`${memorial.href}/archive`}>
                      <article className="group cursor-pointer border border-[var(--memorial-line)] bg-white">
                        <div className="aspect-[4/3] overflow-hidden bg-[#f4f2ee]">
                          {memorial.photoUrl ? (
                            <img
                              src={toImgUrl(memorial.photoUrl)}
                              alt={memorial.photoCaption || memorial.name}
                              className="h-full w-full object-cover object-top grayscale transition duration-500 group-hover:scale-[1.03] group-hover:grayscale-0"
                            />
                          ) : (
                            <div className="flex h-full w-full items-center justify-center bg-[linear-gradient(145deg,#f7f5f0,#ebe7de)] text-[var(--memorial-ash)]">
                              <UserRound
                                className="h-12 w-12"
                                strokeWidth={1.2}
                              />
                            </div>
                          )}
                        </div>
                        <div className="p-4">
                          <p className="truncate text-[11px] font-medium uppercase tracking-[0.16em] text-[var(--memorial-brass)]">
                            {memorial.church}
                          </p>
                          <div className="mt-3 flex items-end justify-between gap-4">
                            <div className="min-w-0">
                              <h3 className="memorial-serif truncate text-xl text-[var(--memorial-ink)]">
                                {memorial.name}
                              </h3>
                              <p className="mt-1 truncate text-sm text-[var(--memorial-ash)]">
                                {memorial.role}
                              </p>
                            </div>
                            <ArrowRight className="h-4 w-4 shrink-0 text-[var(--memorial-ink)] transition-transform group-hover:translate-x-1" />
                          </div>
                        </div>
                      </article>
                    </Link>
                  ))}
                </div>

                {totalPeoplePages > 1 && (
                  <div className="mt-8 flex flex-wrap items-center justify-center gap-2">
                    <button
                      type="button"
                      onClick={() =>
                        setPersonPage(page => Math.max(1, page - 1))
                      }
                      disabled={currentPeoplePage === 1}
                      className="flex h-10 w-10 items-center justify-center border border-[var(--memorial-line)] bg-white text-[var(--memorial-ink)] transition-colors hover:bg-[var(--memorial-cloud)] disabled:cursor-not-allowed disabled:opacity-40"
                      aria-label="이전 페이지"
                    >
                      <ChevronLeft className="h-4 w-4" strokeWidth={1.7} />
                    </button>
                    {peoplePageNumbers.map(page => (
                      <button
                        key={page}
                        type="button"
                        onClick={() => setPersonPage(page)}
                        className={`h-10 min-w-10 border px-3 text-sm font-medium transition-colors ${
                          currentPeoplePage === page
                            ? "border-[var(--memorial-ink)] bg-[var(--memorial-ink)] text-white"
                            : "border-[var(--memorial-line)] bg-white text-[var(--memorial-ink)] hover:bg-[var(--memorial-cloud)]"
                        }`}
                        aria-current={
                          currentPeoplePage === page ? "page" : undefined
                        }
                      >
                        {page}
                      </button>
                    ))}
                    <button
                      type="button"
                      onClick={() =>
                        setPersonPage(page =>
                          Math.min(totalPeoplePages, page + 1)
                        )
                      }
                      disabled={currentPeoplePage === totalPeoplePages}
                      className="flex h-10 w-10 items-center justify-center border border-[var(--memorial-line)] bg-white text-[var(--memorial-ink)] transition-colors hover:bg-[var(--memorial-cloud)] disabled:cursor-not-allowed disabled:opacity-40"
                      aria-label="다음 페이지"
                    >
                      <ChevronRight className="h-4 w-4" strokeWidth={1.7} />
                    </button>
                  </div>
                )}
              </>
            ) : (
              <div className="border border-[var(--memorial-line)] bg-[#fbfaf8] px-6 py-12 text-center">
                <p className="text-sm text-[var(--memorial-ash)]">
                  {memorials.length === 0
                    ? "아직 공개된 기념관이 없습니다."
                    : "검색 결과가 없습니다."}
                </p>
                <Link href={routes.memorialCreate}>
                  <button className="memorial-button-primary mt-6">
                    <Plus className="h-4 w-4" />
                    기념관 만들기
                  </button>
                </Link>
              </div>
            )}
          </div>
        </section>

        <section
          id="memorial-space"
          className="scroll-mt-20 border-b border-[var(--memorial-night-line)] bg-[var(--memorial-ink)] py-16 text-white md:py-24"
        >
          <div className="container">
            <div className="grid gap-10 md:grid-cols-[0.8fr_1.2fr] md:items-start">
              <div>
                <p className="mb-4 text-xs font-semibold uppercase text-white/62">
                  Memorial Space
                </p>
                <h2 className="memorial-serif text-3xl text-white md:text-5xl">
                  추모관
                </h2>
              </div>
              <div className="border-t border-white/18">
                {[
                  [
                    "전환 준비",
                    "신앙기념관으로 기록을 먼저 정리하고, 소천 이후 필요한 시점에 추모관으로 전환할 수 있습니다.",
                  ],
                  [
                    "등록 공간",
                    "추후 추모관으로 전환된 인물은 이 영역에 별도로 모아 가족과 교회 공동체가 찾을 수 있게 준비합니다.",
                  ],
                  [
                    "확장 기능",
                    "추모관에는 사진첩, 영상, 연표와 함께 하늘로 보내는 편지 기능을 열 수 있습니다.",
                  ],
                ].map(([title, desc], index) => (
                  <article
                    key={title}
                    className="grid gap-5 border-b border-white/18 py-6 md:grid-cols-[96px_1fr]"
                  >
                    <span className="text-sm text-white/46">
                      {String(index + 1).padStart(2, "0")}
                    </span>
                    <div>
                      <h3 className="memorial-serif text-xl text-white">
                        {title}
                      </h3>
                      <p className="mt-3 text-sm leading-7 text-white/68">
                        {desc}
                      </p>
                    </div>
                  </article>
                ))}
              </div>
            </div>
          </div>
        </section>

        <section className="border-b border-[var(--memorial-night-line)] bg-[var(--memorial-ink)] py-16 text-white md:py-24">
          <div className="container">
            <div className="mb-10 flex flex-col justify-between gap-6 md:flex-row md:items-end">
              <div>
                <p className="mb-4 text-xs font-semibold uppercase text-white/62">
                  Functions
                </p>
                <h2 className="memorial-serif text-3xl text-white md:text-5xl">
                  한영교회를 위한 신앙 기념 방식
                </h2>
              </div>
              <p className="max-w-md text-sm leading-7 text-white/68">
                기념관의 핵심 기능은 유지하고, 소천 이후 필요한 추모관 전환은
                별도 흐름으로 분리해 둘 수 있게 정리했습니다.
              </p>
            </div>

            <div className="grid grid-cols-1 gap-px bg-white/16 md:grid-cols-3">
              {FEATURES.map(feature => {
                const Icon = feature.icon;
                return (
                  <article
                    key={feature.label}
                    className="bg-[var(--memorial-graphite)] p-6 md:p-8"
                  >
                    <div className="mb-12 flex items-start justify-between">
                      <span className="text-xs text-white/48">
                        {feature.label}
                      </span>
                      <Icon className="h-5 w-5 text-white" strokeWidth={1.5} />
                    </div>
                    <h3 className="memorial-serif text-xl text-white">
                      {feature.title}
                    </h3>
                    <p className="mt-4 text-sm leading-7 text-white/66">
                      {feature.desc}
                    </p>
                  </article>
                );
              })}
            </div>
          </div>
        </section>

        <section className="bg-white py-16 md:py-24">
          <div className="container">
            <div className="memorial-panel grid gap-8 p-6 md:grid-cols-[1fr_auto] md:items-center md:p-10">
              <div>
                <p className="memorial-eyebrow mb-4">Next</p>
                <h2 className="memorial-serif text-3xl md:text-5xl">
                  등록된 기념관으로 이동
                </h2>
                <p className="memorial-body mt-5 max-w-xl text-sm">
                  성함으로 기념관을 검색하거나, 로그인 후 새 기념관을 만들 수
                  있습니다.
                </p>
              </div>

              <Link href={routes.memorialSearch}>
                <button className="memorial-button-primary px-5">
                  기념관 자세히 보기
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

function InfoTile({ label, value }: { label: string; value: string }) {
  return (
    <div className="bg-white p-4">
      <p className="text-xs text-[var(--memorial-ash)]">{label}</p>
      <p className="memorial-serif mt-3 text-lg">{value}</p>
    </div>
  );
}
