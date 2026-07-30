-- ============================================================
-- B2B Travel Platform — Migration V003: Create Agencies Table
-- ============================================================
-- Description: Đại lý du lịch đăng ký sử dụng nền tảng B2B
-- Dependencies: V001 (enums: kyc_status)
-- ============================================================

CREATE TABLE IF NOT EXISTS agencies (
    id                      UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name                    VARCHAR(255) NOT NULL,
    tax_code                VARCHAR(20) NOT NULL,
    business_license_url    TEXT,
    travel_license_url      TEXT,
    address                 TEXT,
    contact_email           VARCHAR(255),
    contact_phone           VARCHAR(20),
    kyc_status              kyc_status  NOT NULL DEFAULT 'PENDING_KYC',
    kyc_approved_at         TIMESTAMPTZ,
    kyc_expires_at          TIMESTAMPTZ,
    rejection_reason        TEXT,
    is_active               BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_agencies_tax_code UNIQUE (tax_code)
);

COMMENT ON TABLE agencies IS 'Đại lý du lịch đăng ký sử dụng nền tảng B2B';
COMMENT ON COLUMN agencies.tax_code IS 'Mã số thuế doanh nghiệp — unique, chống đăng ký trùng';
COMMENT ON COLUMN agencies.kyc_status IS 'Vòng đời KYC: PENDING_KYC → APPROVED / REJECTED / SUSPENDED';
COMMENT ON COLUMN agencies.kyc_expires_at IS 'Ngày hết hạn KYC — hệ thống nhắc 30 ngày trước';
