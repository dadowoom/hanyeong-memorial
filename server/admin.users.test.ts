import { describe, expect, it } from "vitest";
import { validateManagedUserUpdate } from "./db";

describe("admin user management safeguards", () => {
  it("blocks changes to the current administrator", () => {
    expect(() =>
      validateManagedUserUpdate({
        actorId: 1,
        target: { id: 1, role: "admin", approvalStatus: "approved" },
        nextRole: "user",
        nextApprovalStatus: "approved",
        activeAdminCount: 2,
      })
    ).toThrow("현재 로그인한 관리자 계정");
  });

  it("blocks removing the final active administrator", () => {
    expect(() =>
      validateManagedUserUpdate({
        actorId: 1,
        target: { id: 2, role: "admin", approvalStatus: "approved" },
        nextRole: "user",
        nextApprovalStatus: "approved",
        activeAdminCount: 1,
      })
    ).toThrow("마지막 활성 관리자 계정");
  });

  it("allows managing another regular user", () => {
    expect(() =>
      validateManagedUserUpdate({
        actorId: 1,
        target: { id: 2, role: "user", approvalStatus: "approved" },
        nextRole: "admin",
        nextApprovalStatus: "approved",
        activeAdminCount: 1,
      })
    ).not.toThrow();
  });
});
