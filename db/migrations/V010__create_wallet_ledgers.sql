-- ============================================================
-- B2B Travel Platform — Migration V010: Create Wallet Ledgers Table
-- ============================================================
-- Description: Sổ cái giao dịch tài chính — APPEND-ONLY (không UPDATE/DELETE)
-- Dependencies: V006 (wallets), V001 (enums: transaction_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS wallet_ledgers (
    id                  UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id           UUID            NOT NULL REFERENCES wallets(id) ON DELETE RESTRICT,
    transaction_type    transaction_type NOT NULL,
    amount              DECIMAL(18,2)   NOT NULL,
    balance_after       DECIMAL(18,2)   NOT NULL,
    reference_id        VARCHAR(100),
    description         TEXT,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_ledger_amount_positive CHECK (amount > 0)
);

COMMENT ON TABLE wallet_ledgers IS 'Sổ cái giao dịch — APPEND-ONLY: chỉ INSERT, KHÔNG UPDATE/DELETE';
COMMENT ON COLUMN wallet_ledgers.amount IS 'Số tiền giao dịch (luôn dương — loại giao dịch xác định +/-)';
COMMENT ON COLUMN wallet_ledgers.balance_after IS 'Số dư ví SAU giao dịch — dùng để audit trail và đối soát';
COMMENT ON COLUMN wallet_ledgers.reference_id IS 'ID tham chiếu: BookingId, TopupRequestId, ClaimId...';
