import Navbar from "@/components/Navbar";
import { routes } from "@/config/church";
import { trpc } from "@/lib/trpc";
import {
  ArrowRight,
  Check,
  LockKeyhole,
  Mail,
  Phone,
  User,
} from "lucide-react";
import type { ReactNode } from "react";
import { FormEvent, useEffect, useMemo, useState } from "react";
import { Link, useLocation } from "wouter";

type Mode = "login" | "signup";

const inputClass =
  "h-12 w-full border-0 border-b border-[var(--memorial-line)] bg-transparent px-0 text-sm text-[var(--memorial-ink)] outline-none transition-colors placeholder:text-[var(--memorial-slate)] focus:border-[var(--memorial-ink)]";
const labelClass = "mb-2 block text-xs font-medium text-[var(--memorial-ash)]";

function getRedirectPath() {
  if (typeof window === "undefined") return "/";
  const params = new URLSearchParams(window.location.search);
  const redirect = params.get("redirect");
  if (!redirect || !redirect.startsWith("/") || redirect.startsWith("/login")) {
    return "/";
  }
  return redirect;
}

function getInitialMode(): Mode {
  if (typeof window === "undefined") return "login";
  const params = new URLSearchParams(window.location.search);
  const mode = params.get("mode");
  const redirect = params.get("redirect");

  if (mode === "signup" || redirect === routes.memorialCreate) {
    return "signup";
  }

  return "login";
}

export default function Login() {
  const utils = trpc.useUtils();
  const [, setLocation] = useLocation();
  const [mode, setMode] = useState<Mode>(getInitialMode);
  const [message, setMessage] = useState("");
  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");
  const [signupName, setSignupName] = useState("");
  const [signupEmail, setSignupEmail] = useState("");
  const [signupPhone, setSignupPhone] = useState("");
  const [signupPassword, setSignupPassword] = useState("");
  const [signupPasswordConfirm, setSignupPasswordConfirm] = useState("");
  const [signupConsent, setSignupConsent] = useState(false);

  const meQuery = trpc.auth.me.useQuery(undefined, {
    retry: false,
    refetchOnWindowFocus: false,
  });
  const loginMutation = trpc.auth.login.useMutation();
  const signupMutation = trpc.auth.signup.useMutation();
  const redirectPath = useMemo(getRedirectPath, []);
  const isCreateRedirect = redirectPath === routes.memorialCreate;

  useEffect(() => {
    if (meQuery.data) {
      setLocation(redirectPath);
    }
  }, [meQuery.data, redirectPath, setLocation]);

  const submitLogin = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setMessage("");

    try {
      await loginMutation.mutateAsync({
        email: loginEmail,
        password: loginPassword,
      });
      await utils.auth.me.invalidate();
      setLocation(redirectPath);
    } catch (error) {
      setMessage(
        error instanceof Error ? error.message : "로그인 중 문제가 생겼습니다."
      );
    }
  };

  const submitSignup = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setMessage("");

    if (signupPassword.length < 8) {
      setMessage("비밀번호는 8자 이상으로 입력해 주세요.");
      return;
    }

    if (signupPassword !== signupPasswordConfirm) {
      setMessage("비밀번호 확인이 일치하지 않습니다.");
      return;
    }

    if (!signupConsent) {
      setMessage("회원가입과 기념관 생성을 위한 필수 동의가 필요합니다.");
      return;
    }

    try {
      const result = await signupMutation.mutateAsync({
        name: signupName,
        email: signupEmail,
        phone: signupPhone || undefined,
        password: signupPassword,
      });

      await utils.auth.me.invalidate();
      setMessage(
        result.firstAdmin
          ? "최초 관리자 계정으로 가입되었습니다."
          : "가입이 완료되었습니다."
      );
      setLocation(redirectPath);
    } catch (error) {
      setMessage(
        error instanceof Error
          ? error.message
          : "회원가입 중 문제가 생겼습니다."
      );
    }
  };

  return (
    <div className="memorial-shell min-h-screen">
      <Navbar />

      <main className="pt-16">
        <section className="border-b memorial-section">
          <div className="container grid gap-10 py-16 md:py-24 lg:grid-cols-[minmax(0,0.9fr)_minmax(320px,0.72fr)] lg:items-start">
            <div>
              <p className="memorial-eyebrow mb-5">HANYEONG ACCOUNT</p>
              <h1 className="memorial-serif text-4xl leading-tight md:text-6xl">
                회원가입 후 바로
                <br />
                기억을 남깁니다
              </h1>
              <p className="memorial-body mt-6 max-w-lg text-sm">
                기념관 만들기는 회원가입 또는 로그인 후 이용할 수 있습니다.
                가입을 마치면 바로 기념관 생성 화면으로 이어집니다.
              </p>

              <div className="mt-10 grid gap-px overflow-hidden rounded-lg border border-[var(--memorial-line)] bg-[var(--memorial-line)] sm:grid-cols-3">
                {[
                  ["01", "회원가입"],
                  ["02", "기념관 만들기"],
                  ["03", "기념관 생성"],
                ].map(([number, text]) => (
                  <div key={number} className="bg-white p-5">
                    <p className="text-xs text-[var(--memorial-slate)]">
                      {number}
                    </p>
                    <p className="mt-4 text-sm font-medium">{text}</p>
                  </div>
                ))}
              </div>
            </div>

            <div className="memorial-panel p-5 md:p-7">
              <div className="grid grid-cols-2 gap-px overflow-hidden rounded-full bg-[var(--memorial-line)] p-px">
                {(["login", "signup"] as Mode[]).map(value => (
                  <button
                    key={value}
                    type="button"
                    onClick={() => {
                      setMode(value);
                      setMessage("");
                    }}
                    className={`h-12 rounded-full text-sm font-semibold transition-colors ${
                      mode === value
                        ? "bg-[var(--memorial-ink)] text-white"
                        : "bg-white text-[var(--memorial-ash)] hover:bg-[var(--memorial-cloud)]"
                    }`}
                  >
                    {value === "login" ? "로그인" : "회원가입"}
                  </button>
                ))}
              </div>

              {mode === "login" ? (
                <form onSubmit={submitLogin} className="mt-8 space-y-6">
                  {isCreateRedirect && (
                    <div className="memorial-panel bg-[var(--memorial-cloud)] p-4 text-sm leading-6 text-[var(--memorial-ash)]">
                      이미 계정이 있다면 로그인 후 기념관 만들기를 이어갈 수
                      있습니다.
                    </div>
                  )}
                  <Field label="이메일">
                    <div className="relative">
                      <input
                        type="email"
                        value={loginEmail}
                        onChange={event => setLoginEmail(event.target.value)}
                        className={`${inputClass} pr-9`}
                        placeholder="name@example.com"
                        autoComplete="email"
                        required
                      />
                      <Mail className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                  </Field>
                  <Field label="비밀번호">
                    <div className="relative">
                      <input
                        type="password"
                        value={loginPassword}
                        onChange={event => setLoginPassword(event.target.value)}
                        className={`${inputClass} pr-9`}
                        placeholder="비밀번호"
                        autoComplete="current-password"
                        required
                      />
                      <LockKeyhole className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                  </Field>

                  <SubmitButton
                    pending={loginMutation.isPending}
                    label="로그인"
                    pendingLabel="확인 중"
                  />
                </form>
              ) : (
                <form onSubmit={submitSignup} className="mt-8 space-y-6">
                  {isCreateRedirect && (
                    <div className="memorial-panel bg-[var(--memorial-cloud)] p-4 text-sm leading-6 text-[var(--memorial-ash)]">
                      처음 이용하시는 경우 회원가입을 마치면 바로 기념관 만들기
                      화면으로 이동합니다.
                    </div>
                  )}
                  <Field label="성함">
                    <div className="relative">
                      <input
                        value={signupName}
                        onChange={event => setSignupName(event.target.value)}
                        className={`${inputClass} pr-9`}
                        placeholder="홍길동"
                        autoComplete="name"
                        required
                      />
                      <User className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                  </Field>
                  <Field label="이메일">
                    <div className="relative">
                      <input
                        type="email"
                        value={signupEmail}
                        onChange={event => setSignupEmail(event.target.value)}
                        className={`${inputClass} pr-9`}
                        placeholder="name@example.com"
                        autoComplete="email"
                        required
                      />
                      <Mail className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                  </Field>
                  <Field label="휴대폰 번호">
                    <div className="relative">
                      <input
                        value={signupPhone}
                        onChange={event => setSignupPhone(event.target.value)}
                        className={`${inputClass} pr-9`}
                        placeholder="010-0000-0000"
                        autoComplete="tel"
                      />
                      <Phone className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                    <p className="mt-2 text-xs leading-5 text-[var(--memorial-slate)]">
                      기념관 작성과 안내 확인에 필요한 연락처입니다.
                    </p>
                  </Field>
                  <Field label="비밀번호">
                    <div className="relative">
                      <input
                        type="password"
                        value={signupPassword}
                        onChange={event =>
                          setSignupPassword(event.target.value)
                        }
                        className={`${inputClass} pr-9`}
                        placeholder="8자 이상"
                        autoComplete="new-password"
                        minLength={8}
                        required
                      />
                      <LockKeyhole className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                  </Field>
                  <Field label="비밀번호 확인">
                    <div className="relative">
                      <input
                        type="password"
                        value={signupPasswordConfirm}
                        onChange={event =>
                          setSignupPasswordConfirm(event.target.value)
                        }
                        className={`${inputClass} pr-9`}
                        placeholder="한 번 더 입력"
                        autoComplete="new-password"
                        minLength={8}
                        required
                      />
                      <LockKeyhole className="pointer-events-none absolute right-0 top-3.5 h-4 w-4 text-[var(--memorial-slate)]" />
                    </div>
                  </Field>

                  <label className="memorial-panel flex gap-3 p-4 text-sm leading-6 text-[var(--memorial-ash)]">
                    <input
                      type="checkbox"
                      checked={signupConsent}
                      onChange={event => setSignupConsent(event.target.checked)}
                      className="mt-1 h-4 w-4 accent-[var(--memorial-ink)]"
                      required
                    />
                    <span>
                      회원가입과 기념관 생성에 필요한 개인정보 수집 및 이용에
                      동의합니다.
                    </span>
                  </label>

                  <SubmitButton
                    pending={signupMutation.isPending}
                    label="회원가입하고 시작하기"
                    pendingLabel="가입 중"
                  />
                </form>
              )}

              {message && (
                <div className="memorial-panel mt-6 p-4 text-sm leading-6 text-[var(--memorial-ash)]">
                  {message}
                </div>
              )}

              <Link href="/">
                <span className="mt-6 inline-block text-xs text-[var(--memorial-ash)] transition-colors hover:text-[var(--memorial-ink)]">
                  홈으로 돌아가기
                </span>
              </Link>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}

function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <label className="block">
      <span className={labelClass}>{label}</span>
      {children}
    </label>
  );
}

function SubmitButton({
  pending,
  label,
  pendingLabel,
}: {
  pending: boolean;
  label: string;
  pendingLabel: string;
}) {
  return (
    <button
      type="submit"
      disabled={pending}
      className="memorial-button-primary w-full px-5 disabled:cursor-not-allowed disabled:opacity-50"
    >
      {pending ? pendingLabel : label}
      {pending ? (
        <Check className="h-4 w-4" strokeWidth={1.7} />
      ) : (
        <ArrowRight className="h-4 w-4" strokeWidth={1.7} />
      )}
    </button>
  );
}
