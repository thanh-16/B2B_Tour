-- ============================================================
-- B2B Travel Platform — Migration V004: Create System Configs Table
-- ============================================================
-- Description: Cấu hình hệ thống dạng key-value (hold timeout, max markup...)
-- Dependencies: V001 (extensions)
-- ============================================================

CREATE TABLE IF NOT EXISTS system_configs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    config_key      VARCHAR(100) NOT NULL,
    config_value    TEXT        NOT NULL,
    description     TEXT,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by      UUID,

    CONSTRAINT uq_system_configs_key UNIQUE (config_key)
);

COMMENT ON TABLE system_configs IS 'Cấu hình hệ thống dạng key-value, thay đổi bởi PlatformAdmin';
COMMENT ON COLUMN system_configs.config_key IS 'Khóa cấu hình: hold_timeout_minutes, max_markup_percent...';
COMMENT ON COLUMN system_configs.updated_by IS 'FK → users.id (sẽ thêm FK sau khi bảng users được tạo)';
