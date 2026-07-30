-- ============================================================
-- B2B Travel Platform — Migration V022: Create Fraud Alerts Table
-- ============================================================
-- Description: Cảnh báo gian lận QR check-in (double scan, invalid signature)
-- Dependencies: V020 (vouchers), V021 (checkin_logs)
-- ============================================================

CREATE TABLE IF NOT EXISTS fraud_alerts (
    id                      UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    voucher_id              UUID        NOT NULL REFERENCES vouchers(id) ON DELETE RESTRICT,
    online_checkin_log_id   UUID        REFERENCES checkin_logs(id) ON DELETE SET NULL,
    offline_checkin_log_id  UUID        REFERENCES checkin_logs(id) ON DELETE SET NULL,
    alert_type              fraud_alert_type NOT NULL,
    details                 JSONB,
    is_resolved             BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE fraud_alerts IS 'Cảnh báo gian lận: double check-in, invalid signature, GPS mismatch';
COMMENT ON COLUMN fraud_alerts.alert_type IS 'DOUBLE_CHECKIN | INVALID_SIGNATURE | GPS_MISMATCH';
COMMENT ON COLUMN fraud_alerts.details IS 'Chi tiết: GPS coords, timestamps, signature comparison...';
