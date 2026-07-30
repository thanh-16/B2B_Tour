-- ============================================================
-- B2B Travel Platform — Migration V007: Create Markup Configs Table
-- ============================================================
-- Description: Cấu hình markup (% + cố định) theo đại lý và loại dịch vụ
-- Dependencies: V003 (agencies), V001 (enums: service_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS markup_configs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id       UUID        NOT NULL REFERENCES agencies(id) ON DELETE CASCADE,
    service_type    service_type NOT NULL,
    percent_markup  DECIMAL(5,2) NOT NULL DEFAULT 0,
    fixed_markup    DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_markup_agency_service UNIQUE (agency_id, service_type),
    CONSTRAINT chk_markup_non_negative CHECK (percent_markup >= 0 AND fixed_markup >= 0),
    CONSTRAINT chk_markup_max_percent CHECK (percent_markup <= 50)
);

COMMENT ON TABLE markup_configs IS 'Cấu hình markup lợi nhuận đại lý theo loại dịch vụ';
COMMENT ON COLUMN markup_configs.percent_markup IS 'Tỷ lệ % cộng thêm vào giá gốc (0-50%)';
COMMENT ON COLUMN markup_configs.fixed_markup IS 'Số tiền VND cố định cộng thêm vào giá gốc';
COMMENT ON CONSTRAINT uq_markup_agency_service ON markup_configs IS '1 đại lý + 1 loại dịch vụ = 1 config duy nhất';
