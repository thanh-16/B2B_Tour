-- ============================================================
-- B2B Travel Platform — Migration V011: Create Topup Requests Table
-- ============================================================
-- Description: Yêu cầu nạp tiền ví qua VNPay hoặc chuyển khoản
-- Dependencies: V006 (wallets), V003 (agencies), V001 (enums)
-- ============================================================

CREATE TABLE IF NOT EXISTS topup_requests (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id           UUID        NOT NULL REFERENCES wallets(id) ON DELETE RESTRICT,
    agency_id           UUID        NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    amount              DECIMAL(18,2) NOT NULL,
    payment_method      payment_method NOT NULL,
    transaction_code    VARCHAR(100) NOT NULL,
    status              topup_status NOT NULL DEFAULT 'PENDING',
    vnpay_txn_ref       VARCHAR(100),
    vnpay_response_data JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_topup_transaction_code UNIQUE (transaction_code),
    CONSTRAINT chk_topup_amount_positive CHECK (amount > 0)
);

COMMENT ON TABLE topup_requests IS 'Yêu cầu nạp tiền ví — theo dõi trạng thái thanh toán VNPay/Bank';
COMMENT ON COLUMN topup_requests.transaction_code IS 'Mã giao dịch duy nhất — dùng làm Idempotent Key chống duplicate';
COMMENT ON COLUMN topup_requests.vnpay_response_data IS 'Raw response từ VNPay IPN — lưu để audit';
