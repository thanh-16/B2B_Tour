-- ============================================================
-- B2B Travel Platform — Migration V016: Create Bookings Table
-- ============================================================
-- Description: Đơn đặt chỗ — core entity của hệ thống
-- Dependencies: V003 (agencies), V005 (users), V001 (enums: booking_status)
-- ============================================================

CREATE TABLE IF NOT EXISTS bookings (
    id                          UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id                   UUID            NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    created_by                  UUID            NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    pnr_code                    VARCHAR(10)     NOT NULL,
    group_id                    VARCHAR(50),
    status                      booking_status  NOT NULL DEFAULT 'HELD',
    total_net_amount            DECIMAL(18,2)   NOT NULL,
    total_markup_amount         DECIMAL(18,2)   NOT NULL DEFAULT 0,
    total_amount                DECIMAL(18,2)   NOT NULL,
    cancellation_reason         TEXT,
    hold_expires_at             TIMESTAMPTZ,
    supplier_approval_deadline  TIMESTAMPTZ,
    created_at                  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_bookings_pnr UNIQUE (pnr_code),
    CONSTRAINT chk_bookings_amount_positive CHECK (total_amount > 0),
    CONSTRAINT chk_bookings_net_positive CHECK (total_net_amount > 0),
    CONSTRAINT chk_bookings_markup_non_negative CHECK (total_markup_amount >= 0),
    CONSTRAINT chk_bookings_total_math CHECK (total_amount = total_net_amount + total_markup_amount),
    CONSTRAINT chk_bookings_held_has_expires CHECK (status != 'HELD' OR hold_expires_at IS NOT NULL),
    CONSTRAINT chk_bookings_pending_approval_has_deadline CHECK (status != 'PENDING_SUPPLIER_APPROVAL' OR supplier_approval_deadline IS NOT NULL)
);

COMMENT ON TABLE bookings IS 'Đơn đặt chỗ — core entity, State Machine: HELD → PAID → COMPLETED';
COMMENT ON COLUMN bookings.pnr_code IS 'Mã PNR 6-10 ký tự alfanumeric unique — dùng tra cứu nhanh';
COMMENT ON COLUMN bookings.group_id IS 'Nhóm combo — các booking cùng group_id thuộc 1 giỏ hàng';
COMMENT ON COLUMN bookings.total_net_amount IS 'Tổng giá gốc (Net price từ NCC)';
COMMENT ON COLUMN bookings.total_markup_amount IS 'Tổng tiền markup (lợi nhuận đại lý)';
COMMENT ON COLUMN bookings.total_amount IS 'Tổng thanh toán = Net + Markup';
COMMENT ON COLUMN bookings.hold_expires_at IS 'Thời điểm hết hạn giữ chỗ — Hangfire Job dùng để auto-cancel';
COMMENT ON COLUMN bookings.supplier_approval_deadline IS 'Deadline cho NCC duyệt đơn On-Request';
