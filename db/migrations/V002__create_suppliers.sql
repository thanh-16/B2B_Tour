-- ============================================================
-- B2B Travel Platform — Migration V002: Create Suppliers Table
-- ============================================================
-- Description: Nhà cung cấp dịch vụ du lịch (khách sạn, tour, nhà xe, hãng bay)
-- Dependencies: V001 (extensions)
-- ============================================================

CREATE TABLE IF NOT EXISTS suppliers (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(255) NOT NULL,
    contact_email   VARCHAR(255),
    contact_phone   VARCHAR(20),
    address         TEXT,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE suppliers IS 'Nhà cung cấp dịch vụ du lịch (khách sạn, tour operator, nhà xe, hãng bay)';
COMMENT ON COLUMN suppliers.is_active IS 'FALSE = ngưng hợp tác (soft delete)';
