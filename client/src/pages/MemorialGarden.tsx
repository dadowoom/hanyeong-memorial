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
    desc: "사진첩, 영상, 책장, 연표를 통해 고인의 믿음과 사랑을 차분하게 보존합니다.",
    icon: BookOpenText,
  },
  {
    label: "공유",
    title: "필요한 만큼 열어두기",
    desc: "공개 추모관과 비공개 추모관을 선택하고, 가족관은 별도 비밀번호로 보호합니다.",
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
    <div className="min-h-screen bg-white text-[#121212]">
      <Navbar />

      <main className="pt-16">
        <section className="relative overflow-hidden border-b border-[#dbdad7] bg-[#f6f5f2]">
          <div className="absolute inset-0 bg-[linear-gradient(120deg,#ffffff_0%,#f7f5f0_52%,#ebe7dd_100%)]" />
          <div className="absolute right-0 top-0 hidden h-full w-1/2 border-l border-white/70 bg-[radial-gradient(circle_at_40%_35%,rgba(255,255,255,0.78),transparent_32%),linear-gradient(180deg,rgba(255,255,255,0.4),rgba(219,218,215,0.2))] md:block" />
          <div className="container relative grid gap-10 py-14 md:grid-cols-[minmax(0,0.82fr)_minmax(300px,0.7fr)] md:py-20 md:items-center">
            <div>
              <p className="mb-5 text-[11px] font-medium uppercase tracking-[0.28em] text-[#616161]">
                Memorial Garden
              </p>
              <h1
                className="max-w-3xl text-5xl font-normal leading-[1.12] md:text-7xl"
                style={{ fontFamily: "'Noto Serif KR', serif" }}
              >
                기억의 동산
              </h1>
              <p className="mt-8 max-w-2xl text-base leading-8 text-[#4f4f4f]">
                {churchConfig.churchName} 성도들의 삶과 믿음을 가족과 교회가
                함께 돌아보는 온라인 기억 공간입니다. 실제 추모관 기능은
                그대로 유지하면서, 한영교회에 맞는 차분한 언어로 정리했습니다.
              </p>
              <div className="mt-10 flex flex-col gap-3 sm:flex-row">
                <Link href={routes.memorialSearch}>
                  <button className="inline-flex h-12 items-center justify-center gap-2 bg-[#18181b] px-6 text-sm font-medium text-white transition-opacity hover:opacity-90">
                    <Search className="h-4 w-4" />
                    추모관 찾기
                  </button>
                </Link>
                <Link href={routes.memorialCreate}>
                  <button className="inline-flex h-12 items-center justify-center gap-2 border border-[#dbdad7] bg-white px-6 text-sm font-medium text-[#121212] transition-colors hover:bg-[#f6f5f2]">
                    <Plus className="h-4 w-4" />
                    추모관 만들기
                  </button>
                </Link>
              </div>
            </div>

            <div className="border border-[#dbdad7] bg-white/74 p-6 backdrop-blur md:p-8">
              <TreePine className="h-8 w-8 text-[#18181b]" strokeWidth={1.5} />
              <p
                className="mt-8 text-2xl font-normal leading-10"
                style={{ fontFamily: "'Noto Serif KR', serif" }}
              >
                “한 사람의 믿음은 가족의 기억에 머물고,
                <br />
                교회의 길 위에 조용히 이어집니다.”
              </p>
              <div className="mt-8 h-px bg-[#dbdad7]" />
              <div className="mt-6 grid gap-px bg-[#dbdad7] sm:grid-cols-3">
                <InfoTile label="공개" value="검색 가능" />
                <InfoTile label="비공개" value="비밀번호" />
                <InfoTile label="가족관" value="별도 보호" />
              </div>
            </div>
          </div>
        </section>

        <section className="border-b border-[#dbdad7] bg-white py-16 md:py-24">
          <div className="container">
            <div className="mb-10 flex flex-col justify-between gap-6 md:flex-row md:items-end">
              <div>
                <p className="mb-4 text-[11px] font-medium uppercase tracking-[0.28em] text-[#616161]">
                  Functions
                </p>
                <h2
                  className="text-3xl font-normal md:text-5xl"
                  style={{ fontFamily: "'Noto Serif KR', serif" }}
                >
                  한영교회를 위한 기억 방식
                </h2>
              </div>
              <p className="max-w-md text-sm leading-7 text-[#616161]">
                기존 추모관의 핵심 기능은 유지하고, 교회명과 서비스 언어를
                한영교회 기준으로 정리했습니다.
              </p>
            </div>

            <div className="grid grid-cols-1 gap-px bg-[#dbdad7] md:grid-cols-3">
              {FEATURES.map(feature => {
                const Icon = feature.icon;
                return (
                  <article key={feature.label} className="bg-[#faf9f6] p-6 md:p-8">
                    <div className="mb-12 flex items-start justify-between">
                      <span className="text-xs uppercase tracking-[0.18em] text-[#616161]">
                        {feature.label}
                      </span>
                      <Icon className="h-5 w-5 text-[#18181b]" strokeWidth={1.5} />
                    </div>
                    <h3
                      className="text-xl font-normal"
                      style={{ fontFamily: "'Noto Serif KR', serif" }}
                    >
                      {feature.title}
                    </h3>
                    <p className="mt-4 text-sm leading-7 text-[#616161]">
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
            <div className="grid gap-8 border border-[#dbdad7] p-6 md:grid-cols-[1fr_auto] md:items-center md:p-10">
              <div>
                <p className="mb-4 text-[11px] font-medium uppercase tracking-[0.28em] text-[#616161]">
                  Next
                </p>
                <h2
                  className="text-3xl font-normal md:text-5xl"
                  style={{ fontFamily: "'Noto Serif KR', serif" }}
                >
                  등록된 추모관으로 이동
                </h2>
                <p className="mt-5 max-w-xl text-sm leading-7 text-[#616161]">
                  고인의 성함으로 추모관을 검색하거나, 로그인 후 새 추모관을
                  만들 수 있습니다.
                </p>
              </div>

              <Link href={routes.memorialSearch}>
                <button className="inline-flex h-12 items-center justify-center gap-2 bg-[#18181b] px-5 text-sm font-medium text-white transition-opacity hover:opacity-90">
                  추모관 보기
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
      <p className="text-xs text-[#616161]">{label}</p>
      <p
        className="mt-3 text-lg font-normal"
        style={{ fontFamily: "'Noto Serif KR', serif" }}
      >
        {value}
      </p>
    </div>
  );
}
