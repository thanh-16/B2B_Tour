-- ============================================================
-- B2B Travel Platform — Migration V009: Create Refresh Tokens Table
-- ============================================================
-- Description: JWT Refresh Token storage — hỗ trợ Token Rotation
-- Dependencies: V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(255) NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    is_revoked  BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_refresh_tokens_hash UNIQUE (token_hash)
);

COMMENT ON TABLE refresh_tokens IS 'JWT Refresh Token — lưu hash, hỗ trợ Token Rotation chống đánh cắp';
COMMENT ON COLUMN refresh_tokens.token_hash IS 'SHA256 hash của refresh token — KHÔNG lưu plain text';
COMMENT ON COLUMN refresh_tokens.is_revoked IS 'TRUE = token đã bị thu hồi (do rotate hoặc logout)';
