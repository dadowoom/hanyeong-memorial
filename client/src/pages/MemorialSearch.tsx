import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { trpc } from "@/lib/trpc";
import { ArrowRight, LockKeyhole, Search } from "lucide-react";
import { useState } from "react";
import { Link } from "wouter";

export default function MemorialSearch() {
  const [query, setQuery] = useState("");
  const keyword = query.trim();
  const canSearch = keyword.length >= 2;
  const memorialsQuery = trpc.memorial.search.useQuery(
    { keyword },
    { enabled: canSearch }
  );
  const results = memorialsQuery.data ?? [];

  return (
    <div className="memorial-shell min-h-screen">
      <Navbar />

      <main className="pt-16">
        <section className="border-b memorial-section">
          <div className="container py-16 md:py-24">
            <div className="max-w-3xl">
              <p className="memorial-eyebrow mb-5">Memorials</p>
              <h1 className="memorial-serif text-4xl md:text-6xl">기념관</h1>
              <p className="memorial-body mt-6 max-w-xl text-sm">
                성함을 입력하면 해당 기념관을 찾을 수 있습니다. 전체 명단은
                공개하지 않습니다.
              </p>
            </div>

            <div className="memorial-input-panel mt-10 max-w-3xl">
              <label className="flex items-center gap-3 px-5 py-4">
                <Search
                  className="h-5 w-5 shrink-0 text-[var(--memorial-ash)]"
                  strokeWidth={1.6}
                />
                <input
                  value={query}
                  onChange={event => setQuery(event.target.value)}
                  placeholder="성함을 두 글자 이상 입력하세요"
                  className="h-10 min-w-0 flex-1 bg-transparent text-base text-[var(--memorial-ink)] outline-none placeholder:text-[var(--memorial-slate)]"
                  autoFocus
                />
              </label>
            </div>
          </div>
        </section>

        <section className="py-8 md:py-12">
          <div className="container">
            <div className="mb-5 flex flex-col justify-between gap-3 md:flex-row md:items-center">
              <div>
                <p className="text-sm text-[var(--memorial-ash)]">
                  {!canSearch
                    ? "성함을 입력하면 검색 결과가 표시됩니다."
                    : memorialsQuery.isLoading
                      ? "검색 중"
                      : `검색 결과 ${results.length}건`}
                </p>
              </div>
            </div>

            {!canSearch ? (
              <div className="memorial-panel bg-[var(--memorial-cloud)] px-5 py-14 text-center md:py-20">
                <p className="memorial-serif text-2xl text-[var(--memorial-ink)] md:text-3xl">
                  찾고 싶은 분의 성함을 입력해주세요.
                </p>
                <p className="memorial-body mx-auto mt-5 max-w-md text-sm">
                  가족과 지인이 필요한 순간에 조용히 찾아볼 수 있도록, 기념관은
                  검색을 통해서만 확인합니다.
                </p>
              </div>
            ) : memorialsQuery.isLoading ? (
              <div className="memorial-panel py-20 text-center">
                <p className="text-sm text-[var(--memorial-ash)]">
                  기념관을 검색하고 있습니다.
                </p>
              </div>
            ) : memorialsQuery.isError ? (
              <div className="memorial-panel py-20 text-center">
                <p className="text-sm text-[var(--memorial-ash)]">
                  기념관을 검색하지 못했습니다.
                </p>
              </div>
            ) : results.length === 0 ? (
              <div className="memorial-panel py-20 text-center">
                <p className="text-sm text-[var(--memorial-ash)]">
                  일치하는 기념관이 없습니다.
                </p>
              </div>
            ) : (
              <div className="overflow-hidden border-y memorial-section">
                <div className="hidden grid-cols-[150px_1.1fr_1fr_0.8fr_128px] border-b memorial-section bg-[var(--memorial-cloud)] px-5 py-3 text-[11px] font-medium uppercase text-[var(--memorial-ash)] md:grid">
                  <span>Year</span>
                  <span>Name</span>
                  <span>Church</span>
                  <span>Role</span>
                  <span className="text-right">Link</span>
                </div>

                <div className="divide-y divide-[var(--memorial-line)]">
                  {results.map(memorial => {
                    const href = memorial.isPrivate
                      ? memorial.href
                      : `${memorial.href}/archive`;

                    return (
                      <article
                        key={memorial.slug}
                        className="grid gap-3 bg-white px-4 py-4 transition-colors hover:bg-[var(--memorial-cloud)] md:grid-cols-[150px_1.1fr_1fr_0.8fr_128px] md:items-center md:px-5"
                      >
                        <p className="text-xs text-[var(--memorial-ash)] md:text-sm">
                          {memorial.birthDate} - {memorial.deathDate}
                        </p>
                        <h2 className="memorial-serif flex flex-wrap items-center gap-2 text-2xl md:text-xl">
                          <span>{memorial.name}</span>
                          {memorial.isPrivate && (
                            <span className="inline-flex items-center gap-1 rounded-full border border-[var(--memorial-line)] px-2 py-1 text-[11px] font-sans text-[var(--memorial-ash)]">
                              <LockKeyhole className="h-3 w-3" />
                              비공개
                            </span>
                          )}
                        </h2>
                        <p className="text-sm text-[var(--memorial-ash)]">
                          {memorial.church}
                        </p>
                        <p className="text-sm text-[var(--memorial-ash)]">
                          {memorial.role}
                        </p>
                        <Link href={href}>
                          <button className="memorial-button-secondary group min-h-10 w-fit px-4 text-sm md:ml-auto">
                            {memorial.isPrivate
                              ? "비밀번호 입력"
                              : "기념관 자세히 보기"}
                            <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
                          </button>
                        </Link>
                      </article>
                    );
                  })}
                </div>
              </div>
            )}
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
