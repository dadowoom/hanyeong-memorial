type LogoMarkProps = {
  className?: string;
  title?: string;
};

export default function LogoMark({
  className = "h-9 w-9",
  title = "한영교회 신앙기념관",
}: LogoMarkProps) {
  return (
    <svg
      viewBox="0 0 128 128"
      role="img"
      aria-label={title}
      className={className}
    >
      <circle cx="64" cy="64" r="58" fill="white" />
      <path
        d="M21 50C29 26 47 14 68 14C96 14 118 36 118 64C118 93 95 116 66 116C36 116 12 93 12 64C12 57 13 51 16 45"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeWidth="7"
      />
      <path
        d="M17 52C26 35 37 25 51 20"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeWidth="3.5"
      />
      <path
        d="M112 76C108 92 96 105 82 111"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeWidth="3.5"
      />
      <path
        d="M56 25C58 31 59 36 59 42V55H41C35 55 29 54 24 52V66C29 64 35 63 41 63H59V96C59 104 58 109 55 114H73C70 109 69 104 69 96V63H88C94 63 100 64 105 66V52C100 54 94 55 88 55H69V42C69 36 70 31 72 25H56Z"
        fill="currentColor"
      />
    </svg>
  );
}
