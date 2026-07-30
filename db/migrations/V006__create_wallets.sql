-- ============================================================
-- B2B Travel Platform — Migration V006: Create Wallets Table
-- ============================================================
-- Description: Ví tài chính đại lý — 1 agency = 1 wallet (1:1)
-- Dependencies: V003 (agencies)
-- ============================================================

CREATE TABLE IF NOT EXISTS wallets (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id           UUID        NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    balance             DECIMAL(18,2) NOT NULL DEFAULT 0,
    reserved_balance    DECIMAL(18,2) NOT NULL DEFAULT 0,
    credit_limit        DECIMAL(18,2) NOT NULL DEFAULT 0,
    version             INTEGER     NOT NULL DEFAULT 1,
    is_locked           BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_wallets_agency UNIQUE (agency_id),
    CONSTRAINT chk_wallet_balance_within_limit CHECK (balance >= -credit_limit),
    CONSTRAINT chk_wallet_available_balance CHECK (balance - reserved_balance >= -credit_limit),
    CONSTRAINT chk_wallet_reserved_non_negative CHECK (reserved_balance >= 0),
    CONSTRAINT chk_wallet_credit_limit_non_negative CHECK (credit_limit >= 0)
);

COMMENT ON TABLE wallets IS 'Ví tài chính đại lý — mỗi đại lý có đúng 1 ví (1:1)';
COMMENT ON COLUMN wallets.balance IS 'Số dư thực tế — có thể âm (trong phạm vi credit_limit)';
COMMENT ON COLUMN wallets.reserved_balance IS 'Số tiền tạm giữ cho đơn On-Request chờ NCC duyệt';
COMMENT ON COLUMN wallets.credit_limit IS 'Hạn mức nợ — cho phép balance âm tối đa bằng credit_limit';
COMMENT ON COLUMN wallets.version IS 'Optimistic Concurrency Control — tăng 1 mỗi lần UPDATE';
COMMENT ON COLUMN wallets.is_locked IS 'TRUE = ví bị khóa giao dịch (do Admin hoặc vi phạm)';
