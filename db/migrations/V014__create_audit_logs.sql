-- ============================================================
-- B2B Travel Platform — Migration V014: Create Audit Logs Table
-- ============================================================
-- Description: Nhật ký hành động hệ thống — append-only, phục vụ audit
-- Dependencies: V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    action          VARCHAR(100) NOT NULL,
    entity_type     VARCHAR(100),
    entity_id       VARCHAR(100),
    old_values      JSONB,
    new_values      JSONB,
    ip_address      VARCHAR(45),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE audit_logs IS 'Nhật ký hành động — lưu mọi thay đổi cấu hình, duyệt KYC, credit/debit ví...';
COMMENT ON COLUMN audit_logs.action IS 'Tên hành động: CONFIG_CHANGED, KYC_APPROVED, WALLET_MANUAL_CREDIT...';
COMMENT ON COLUMN audit_logs.old_values IS 'Giá trị CŨ trước khi thay đổi (JSON)';
COMMENT ON COLUMN audit_logs.new_values IS 'Giá trị MỚI sau khi thay đổi (JSON)';
