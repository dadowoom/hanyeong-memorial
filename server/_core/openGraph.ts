import type { Request } from "express";
import { churchConfig } from "@shared/church";
import { getMemorialShareBySlug } from "../db";

const MEMORIAL_PATH = /^\/memorial\/([^/?#]+)(?:\/(?:archive|family))?\/?$/;
const RESERVED_MEMORIAL_SLUGS = new Set([
  "create",
  "dark",
  "demo",
  "search",
  "warm",
]);

type PageMeta = {
  title: string;
  description: string;
  url: string;
  image: string;
  imageAlt: string;
  type?: string;
};

function escapeHtml(value: string) {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function escapeRegExp(value: string) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function truncate(value: string, maxLength: number) {
  const normalized = value.replace(/\s+/g, " ").trim();
  if (normalized.length <= maxLength) return normalized;
  return `${normalized.slice(0, maxLength - 1).trimEnd()}…`;
}

function getSiteOrigin(req: Request) {
  const configuredOrigin =
    process.env.PUBLIC_SITE_URL?.trim() || churchConfig.domain;
  if (configuredOrigin) return configuredOrigin.replace(/\/+$/, "");

  const forwardedProto = req.get("x-forwarded-proto")?.split(",")[0]?.trim();
  const proto = forwardedProto || req.protocol || "http";
  return `${proto}://${req.get("host")}`;
}

function getRequestPath(req: Request, origin: string) {
  return new URL(req.originalUrl || req.url || "/", origin).pathname;
}

function getPageUrl(req: Request, origin: string) {
  const pathname = getRequestPath(req, origin);
  return new URL(pathname, origin).toString();
}

function toAbsoluteUrl(url: string | null | undefined, origin: string) {
  if (!url) return new URL(churchConfig.ogImage, origin).toString();

  try {
    return new URL(url).toString();
  } catch {
    const path = url.startsWith("/") ? url : `/${url}`;
    return new URL(path, origin).toString();
  }
}

function replaceTitle(html: string, title: string) {
  return html.replace(
    /<title>[\s\S]*?<\/title>/i,
    `<title>${escapeHtml(title)}</title>`
  );
}

function replaceMetaContent(
  html: string,
  attributeName: "name" | "property",
  attributeValue: string,
  content: string
) {
  const attributePattern = escapeRegExp(attributeValue);
  const tagPattern = new RegExp(
    `<meta\\s+[^>]*\\b${attributeName}=["']${attributePattern}["'][^>]*>`,
    "i"
  );
  const tag = `<meta ${attributeName}="${attributeValue}" content="${escapeHtml(content)}" />`;

  if (tagPattern.test(html)) {
    return html.replace(tagPattern, tag);
  }

  return html.replace("</head>", `    ${tag}\n  </head>`);
}

function injectMeta(html: string, meta: PageMeta) {
  let next = replaceTitle(html, meta.title);

  next = replaceMetaContent(next, "name", "description", meta.description);
  next = replaceMetaContent(
    next,
    "property",
    "og:type",
    meta.type || "website"
  );
  next = replaceMetaContent(
    next,
    "property",
    "og:site_name",
    churchConfig.serviceTitle
  );
  next = replaceMetaContent(next, "property", "og:title", meta.title);
  next = replaceMetaContent(
    next,
    "property",
    "og:description",
    meta.description
  );
  next = replaceMetaContent(next, "property", "og:url", meta.url);
  next = replaceMetaContent(next, "property", "og:image", meta.image);
  next = replaceMetaContent(next, "property", "og:image:alt", meta.imageAlt);
  next = replaceMetaContent(
    next,
    "name",
    "twitter:card",
    "summary_large_image"
  );
  next = replaceMetaContent(next, "name", "twitter:title", meta.title);
  next = replaceMetaContent(
    next,
    "name",
    "twitter:description",
    meta.description
  );
  next = replaceMetaContent(next, "name", "twitter:image", meta.image);
  next = replaceMetaContent(next, "name", "twitter:image:alt", meta.imageAlt);

  return next;
}

async function getMemorialMeta(req: Request): Promise<PageMeta | null> {
  const origin = getSiteOrigin(req);
  const requestPath = getRequestPath(req, origin);
  const match = requestPath.match(MEMORIAL_PATH);
  if (!match) return null;

  const slug = decodeURIComponent(match[1] || "");
  if (!slug || RESERVED_MEMORIAL_SLUGS.has(slug)) return null;

  const memorial = await getMemorialShareBySlug(slug);
  if (!memorial) return null;

  const url = getPageUrl(req, origin);
  const isShareable =
    memorial.status === "published" && memorial.visibility !== "private";

  if (!isShareable) {
    return {
      title: `비공개 추모관 | ${churchConfig.serviceTitle}`,
      description:
        "비밀번호로 보호된 추모관입니다. 가족과 허락된 분들만 내용을 확인할 수 있습니다.",
      url,
      image: toAbsoluteUrl(churchConfig.ogImage, origin),
      imageAlt: churchConfig.serviceTitle,
    };
  }

  const role = memorial.role ? ` ${memorial.role}` : "";
  const period =
    memorial.birthDate || memorial.deathDate
      ? ` (${[memorial.birthDate, memorial.deathDate].filter(Boolean).join(" - ")})`
      : "";
  const description = `${memorial.name}${role}님의 ${churchConfig.serviceName}입니다.`;

  return {
    title: `${memorial.name}${role} | ${churchConfig.serviceTitle}`,
    description,
    url,
    image: toAbsoluteUrl(memorial.photoUrl || churchConfig.ogImage, origin),
    imageAlt:
      memorial.photoCaption ||
      `${memorial.name}${role}${period} ${churchConfig.serviceName}`,
    type: "profile",
  };
}

export async function injectOpenGraphMeta(html: string, req: Request) {
  const defaultOrigin = getSiteOrigin(req);
  const defaultMeta: PageMeta = {
    title: churchConfig.serviceTitle,
    description: churchConfig.shortDescription,
    url: getPageUrl(req, defaultOrigin),
    image: toAbsoluteUrl(churchConfig.ogImage, defaultOrigin),
    imageAlt: churchConfig.serviceTitle,
  };

  let meta: PageMeta | null = null;
  try {
    meta = await getMemorialMeta(req);
  } catch (error) {
    console.warn("[OpenGraph] Falling back to default meta:", error);
  }

  meta = meta || defaultMeta;
  return injectMeta(html, meta);
}
