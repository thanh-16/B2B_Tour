-- ============================================================
-- B2B Travel Platform — Migration V020: Create Vouchers Table
-- ============================================================
-- Description: E-Voucher điện tử — QR Code + PDF cho mỗi booking
-- Dependencies: V016 (bookings), V005 (users), V001 (enums: voucher_status)
-- ============================================================

CREATE TABLE IF NOT EXISTS vouchers (
    id                  UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id          UUID            NOT NULL REFERENCES bookings(id) ON DELETE RESTRICT,
    voucher_code        VARCHAR(20)     NOT NULL,
    qr_payload          TEXT            NOT NULL,
    pdf_url             TEXT,
    status              voucher_status  NOT NULL DEFAULT 'ACTIVE',
    assigned_driver_id  UUID            REFERENCES users(id) ON DELETE SET NULL,
    issued_at           TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    expires_at          TIMESTAMPTZ     NOT NULL,

    CONSTRAINT uq_vouchers_booking UNIQUE (booking_id),
    CONSTRAINT uq_vouchers_code UNIQUE (voucher_code)
);

COMMENT ON TABLE vouchers IS 'E-Voucher điện tử — 1 booking = 1 voucher (1:1)';
COMMENT ON COLUMN vouchers.qr_payload IS 'JSON data ký bằng HMAC-SHA256: {bookingId, voucherCode, expiry, timestamp}';
COMMENT ON COLUMN vouchers.pdf_url IS 'URL file PDF voucher trên S3/GCS';
COMMENT ON COLUMN vouchers.assigned_driver_id IS 'Tài xế/guide phụ trách — dùng per-driver key để verify QR offline';
