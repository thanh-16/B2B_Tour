-- ============================================================
-- B2B Travel Platform — Migration V005: Create Users Table
-- ============================================================
-- Description: Tất cả người dùng hệ thống (admin, đại lý, NCC, tài xế)
-- Dependencies: V001 (enums: user_role), V002 (suppliers), V003 (agencies)
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id       UUID        REFERENCES agencies(id) ON DELETE RESTRICT,
    supplier_id     UUID        REFERENCES suppliers(id) ON DELETE RESTRICT,
    username        VARCHAR(100) NOT NULL,
    email           VARCHAR(255),
    phone           VARCHAR(20),
    full_name       VARCHAR(255) NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    role            user_role   NOT NULL,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    avatar_url      TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT chk_users_role_agency CHECK (
        (role = 'PLATFORM_ADMIN' AND agency_id IS NULL AND supplier_id IS NULL)
        OR (role IN ('AGENCY_MANAGER', 'AGENCY_STAFF') AND agency_id IS NOT NULL AND supplier_id IS NULL)
        OR (role IN ('SUPPLIER_ADMIN', 'DELIVERY_STAFF') AND agency_id IS NULL AND supplier_id IS NOT NULL)
    )
);

-- Thêm FK cho system_configs.updated_by (đã tạo trước đó)
ALTER TABLE system_configs
    ADD CONSTRAINT fk_system_configs_updated_by
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON TABLE users IS 'Tất cả người dùng: PlatformAdmin, AgencyManager/Staff, SupplierAdmin, DeliveryStaff';
COMMENT ON COLUMN users.agency_id IS 'NULL nếu PlatformAdmin; NOT NULL nếu Agency staff';
COMMENT ON COLUMN users.supplier_id IS 'NULL nếu không thuộc Supplier; NOT NULL nếu SupplierAdmin/DeliveryStaff';
COMMENT ON COLUMN users.password_hash IS 'BCrypt hash — KHÔNG lưu plain text';
COMMENT ON CONSTRAINT chk_users_role_agency ON users IS 'Đảm bảo role khớp với agency_id/supplier_id';
