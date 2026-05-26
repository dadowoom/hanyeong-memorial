import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { churchConfig, routes } from "@/config/church";
import {
  ArrowRight,
  BookOpenText,
  Mail,
  Plus,
  Search,
  TreePine,
} from "lucide-react";
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
    title: "하늘로 보내는 편지",
    desc: "가족과 교우가 남기는 편지를 통해 기억이 조용히 이어지도록 돕습니다.",
    icon: Mail,
  },
];

export default function MemorialGarden() {
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
                연표, 편지 기능을 한영교회에 맞는 차분한 언어로 정리했습니다.
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
