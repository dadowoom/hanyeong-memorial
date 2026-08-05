import AdminLayout from "@/components/admin/AdminLayout";
import HistoryAdminPanel from "@/components/history/HistoryAdminPanel";
import { ExternalLink } from "lucide-react";
import { Link } from "wouter";

export default function AdminHistory() {
  return (
    <AdminLayout
      title="교회 연혁 관리"
      description="한영교회 연대를 만들고 기록을 추가한 뒤 공개 여부와 표시 순서를 관리합니다."
      action={
        <Link href="/history">
          <span className="memorial-button-secondary inline-flex cursor-pointer">
            공개 화면 보기
            <ExternalLink className="h-4 w-4" />
          </span>
        </Link>
      }
    >
      <HistoryAdminPanel mode="page" />
    </AdminLayout>
  );
}
