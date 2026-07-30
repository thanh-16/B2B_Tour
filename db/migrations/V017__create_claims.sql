-- ============================================================
-- B2B Travel Platform — Migration V017: Create Claims Table
-- ============================================================
-- Description: Khiếu nại after-sales (hoàn tiền, đổi ngày, khiếu nại chung)
-- Dependencies: V016 (bookings), V003 (agencies), V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS claims (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id      UUID        NOT NULL REFERENCES bookings(id) ON DELETE RESTRICT,
    agency_id       UUID        NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    submitted_by    UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    claim_type      claim_type  NOT NULL,
    status          claim_status NOT NULL DEFAULT 'PENDING',
    reason          TEXT        NOT NULL,
    penalty_amount  DECIMAL(18,2),
    refund_amount   DECIMAL(18,2),
    resolution_note TEXT,
    resolved_by     UUID        REFERENCES users(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ
);

COMMENT ON TABLE claims IS 'Khiếu nại after-sales: hoàn tiền, đổi ngày, complaint';
COMMENT ON COLUMN claims.penalty_amount IS 'Phí phạt hủy/đổi (nếu có) — trừ vào refund_amount';
COMMENT ON COLUMN claims.refund_amount IS 'Số tiền thực hoàn = giá booking - penalty';
