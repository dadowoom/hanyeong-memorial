const KAKAO_SDK_URL =
  "https://t1.kakaocdn.net/kakao_js_sdk/2.8.1/kakao.min.js";
const KAKAO_SDK_INTEGRITY =
  "sha384-OL+ylM/iuPLtW5U3XcvLSGhE8JzReKDank5InqlHGWPhb4140/yrBw0bg0y7+C9J";

type KakaoSdk = {
  init: (key: string) => void;
  isInitialized: () => boolean;
  Share?: {
    sendScrap: (params: { requestUrl: string }) => void;
  };
};

declare global {
  interface Window {
    Kakao?: KakaoSdk;
  }
}

export type MemorialShareResult =
  | "kakao"
  | "native"
  | "clipboard"
  | "url"
  | "aborted";

type MemorialShareInput = {
  title: string;
  text: string;
  url: string;
};

let kakaoSdkPromise: Promise<KakaoSdk> | null = null;

function getKakaoJavaScriptKey() {
  return import.meta.env.VITE_KAKAO_JAVASCRIPT_KEY?.trim() ?? "";
}

function loadKakaoSdk() {
  if (typeof window === "undefined") {
    return Promise.reject(new Error("Kakao SDK can only be loaded in browser."));
  }

  if (window.Kakao) {
    return Promise.resolve(window.Kakao);
  }

  if (kakaoSdkPromise) {
    return kakaoSdkPromise;
  }

  kakaoSdkPromise = new Promise((resolve, reject) => {
    const existingScript = document.querySelector<HTMLScriptElement>(
      `script[src="${KAKAO_SDK_URL}"]`
    );

    const handleLoad = () => {
      if (window.Kakao) {
        resolve(window.Kakao);
        return;
      }
      kakaoSdkPromise = null;
      reject(new Error("Kakao SDK loaded without global Kakao object."));
    };

    const handleError = () => {
      kakaoSdkPromise = null;
      reject(new Error("Failed to load Kakao SDK."));
    };

    if (existingScript) {
      existingScript.addEventListener("load", handleLoad, { once: true });
      existingScript.addEventListener("error", handleError, { once: true });
      return;
    }

    const script = document.createElement("script");
    script.src = KAKAO_SDK_URL;
    script.integrity = KAKAO_SDK_INTEGRITY;
    script.crossOrigin = "anonymous";
    script.async = true;
    script.addEventListener("load", handleLoad, { once: true });
    script.addEventListener("error", handleError, { once: true });
    document.head.appendChild(script);
  });

  return kakaoSdkPromise;
}

async function getInitializedKakaoSdk() {
  const javaScriptKey = getKakaoJavaScriptKey();
  if (!javaScriptKey) {
    return null;
  }

  const Kakao = await loadKakaoSdk();
  if (!Kakao.isInitialized()) {
    Kakao.init(javaScriptKey);
  }

  return Kakao;
}

async function tryKakaoShare(url: string) {
  try {
    const Kakao = await getInitializedKakaoSdk();
    if (!Kakao?.Share?.sendScrap) {
      return false;
    }

    Kakao.Share.sendScrap({ requestUrl: url });
    return true;
  } catch {
    return false;
  }
}

export async function shareMemorialLink({
  title,
  text,
  url,
}: MemorialShareInput): Promise<MemorialShareResult> {
  if (await tryKakaoShare(url)) {
    return "kakao";
  }

  if (typeof navigator !== "undefined" && navigator.share) {
    try {
      await navigator.share({ title, text, url });
      return "native";
    } catch (error) {
      if ((error as Error).name === "AbortError") {
        return "aborted";
      }
    }
  }

  if (typeof navigator !== "undefined" && navigator.clipboard) {
    try {
      await navigator.clipboard.writeText(url);
      return "clipboard";
    } catch {
      // Fall through and display the URL for manual sharing.
    }
  }

  return "url";
}

export function getMemorialShareMessage(
  result: MemorialShareResult,
  fallbackUrl: string
) {
  switch (result) {
    case "kakao":
      return "카카오톡 공유 창을 열었습니다.";
    case "native":
      return "공유 창을 열었습니다.";
    case "clipboard":
      return "기념관 링크를 복사했습니다.";
    case "url":
      return fallbackUrl;
    case "aborted":
      return "";
  }
}
