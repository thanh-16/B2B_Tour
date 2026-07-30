-- ============================================================
-- B2B Travel Platform — Migration V021: Create Check-in Logs Table
-- ============================================================
-- Description: Lịch sử quét QR check-in (online + offline)
-- Dependencies: V020 (vouchers), V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS checkin_logs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    voucher_id      UUID        NOT NULL REFERENCES vouchers(id) ON DELETE RESTRICT,
    scanned_by      UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    is_online       BOOLEAN     NOT NULL,
    gps_latitude    DECIMAL(10,7),
    gps_longitude   DECIMAL(10,7),
    scanned_at      TIMESTAMPTZ NOT NULL,
    synced_at       TIMESTAMPTZ,
    is_fraud_flagged BOOLEAN    NOT NULL DEFAULT FALSE,

    CONSTRAINT chk_gps_latitude_range CHECK (gps_latitude IS NULL OR (gps_latitude >= -90 AND gps_latitude <= 90)),
    CONSTRAINT chk_gps_longitude_range CHECK (gps_longitude IS NULL OR (gps_longitude >= -180 AND gps_longitude <= 180))
);

COMMENT ON TABLE checkin_logs IS 'Lịch sử quét QR — ghi nhận cả online lẫn offline scan';
COMMENT ON COLUMN checkin_logs.is_online IS 'TRUE = quét trực tuyến (verify API); FALSE = quét offline (verify HMAC local)';
COMMENT ON COLUMN checkin_logs.synced_at IS 'NULL = chưa sync lên server (offline); có giá trị = đã sync';
COMMENT ON COLUMN checkin_logs.is_fraud_flagged IS 'TRUE = nghi gian lận (double scan, invalid signature...)';
