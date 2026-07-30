-- ============================================================
-- B2B Travel Platform — Migration V012: Create Inventory Slots Table
-- ============================================================
-- Description: Slot chỗ theo ngày cho mỗi dịch vụ — đơn vị bán nhỏ nhất
-- Dependencies: V008 (inventories)
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory_slots (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    inventory_id    UUID        NOT NULL REFERENCES inventories(id) ON DELETE CASCADE,
    service_date    DATE        NOT NULL,
    base_price      DECIMAL(18,2) NOT NULL,
    total_slots     INTEGER     NOT NULL,
    available_slots INTEGER     NOT NULL,
    version         INTEGER     NOT NULL DEFAULT 1,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_slot_inventory_date UNIQUE (inventory_id, service_date),
    CONSTRAINT chk_slots_non_negative CHECK (available_slots >= 0),
    CONSTRAINT chk_slots_not_exceed_total CHECK (available_slots <= total_slots),
    CONSTRAINT chk_total_slots_positive CHECK (total_slots > 0),
    CONSTRAINT chk_base_price_positive CHECK (base_price > 0)
);

COMMENT ON TABLE inventory_slots IS 'Slot chỗ theo ngày — 1 dịch vụ + 1 ngày = 1 slot duy nhất';
COMMENT ON COLUMN inventory_slots.base_price IS 'Giá gốc (Net price) — đại lý cộng markup lên giá này';
COMMENT ON COLUMN inventory_slots.available_slots IS 'Số chỗ còn trống — giảm khi Hold, tăng khi Cancel';
COMMENT ON COLUMN inventory_slots.version IS 'OCC — mỗi lần UPDATE phải kiểm tra version khớp, tránh overbooking';
