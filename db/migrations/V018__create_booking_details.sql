-- ============================================================
-- B2B Travel Platform — Migration V018: Create Booking Details Table
-- ============================================================
-- Description: Chi tiết từng dịch vụ trong đơn đặt chỗ (liên kết Booking ↔ Slot)
-- Dependencies: V016 (bookings), V012 (inventory_slots)
-- ============================================================

CREATE TABLE IF NOT EXISTS booking_details (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id          UUID        NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    inventory_slot_id   UUID        NOT NULL REFERENCES inventory_slots(id) ON DELETE RESTRICT,
    quantity            INTEGER     NOT NULL DEFAULT 1,
    locked_unit_price   DECIMAL(18,2) NOT NULL,
    locked_markup       DECIMAL(18,2) NOT NULL DEFAULT 0,
    subtotal            DECIMAL(18,2) NOT NULL,

    CONSTRAINT chk_detail_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_detail_price_positive CHECK (locked_unit_price > 0),
    CONSTRAINT chk_detail_markup_non_negative CHECK (locked_markup >= 0),
    CONSTRAINT chk_detail_subtotal_positive CHECK (subtotal > 0),
    CONSTRAINT chk_detail_subtotal_math CHECK (subtotal = quantity * (locked_unit_price + locked_markup))
);

COMMENT ON TABLE booking_details IS 'Chi tiết dịch vụ trong booking — lock giá tại thời điểm Hold';
COMMENT ON COLUMN booking_details.locked_unit_price IS 'Giá gốc tại thời điểm Hold — không đổi dù NCC sửa giá sau';
COMMENT ON COLUMN booking_details.locked_markup IS 'Markup tại thời điểm Hold — đảm bảo đại lý nhận đúng lợi nhuận';
COMMENT ON COLUMN booking_details.subtotal IS 'Tổng = quantity × (locked_unit_price + locked_markup)';
