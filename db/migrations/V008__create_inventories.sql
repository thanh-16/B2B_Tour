-- ============================================================
-- B2B Travel Platform — Migration V008: Create Inventories Table
-- ============================================================
-- Description: Kho dịch vụ du lịch do NCC đăng tải (khách sạn, tour, xe, bay)
-- Dependencies: V002 (suppliers), V001 (enums: service_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS inventories (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_id         UUID        NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    name                VARCHAR(255) NOT NULL,
    description         TEXT,
    service_type        service_type NOT NULL,
    location            VARCHAR(255),
    thumbnail_url       TEXT,
    requires_approval   BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN     NOT NULL DEFAULT TRUE,
    metadata            JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE inventories IS 'Kho dịch vụ du lịch: khách sạn, tour, vé xe, vé bay';
COMMENT ON COLUMN inventories.requires_approval IS 'TRUE = On-Request (NCC phải duyệt thủ công trước khi confirm)';
COMMENT ON COLUMN inventories.metadata IS 'Thông tin mở rộng dạng JSON: tiện ích, rating, hình ảnh gallery...';
COMMENT ON COLUMN inventories.is_active IS 'FALSE = tạm ngưng bán (soft delete)';
