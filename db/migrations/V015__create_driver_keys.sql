-- ============================================================
-- B2B Travel Platform — Migration V015: Create Driver Keys Table
-- ============================================================
-- Description: Khóa bí mật HMAC-SHA256 cho tài xế quét QR offline
-- Dependencies: V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS driver_keys (
    id                      UUID    PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id                 UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    secret_key_encrypted    TEXT    NOT NULL,
    valid_date              DATE    NOT NULL,
    is_revoked              BOOLEAN NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_driver_keys_user_date UNIQUE (user_id, valid_date)
);

COMMENT ON TABLE driver_keys IS 'Khóa HMAC-SHA256 per-driver — xoay vòng mỗi 24h cho QR offline verification';
COMMENT ON COLUMN driver_keys.secret_key_encrypted IS 'AES-256 encrypted secret key — giải mã khi cần verify QR';
COMMENT ON COLUMN driver_keys.valid_date IS 'Ngày có hiệu lực — mỗi ngày có 1 key mới';
