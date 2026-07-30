-- ============================================================
-- B2B Travel Platform — Migration V019: Create Booking Passengers Table
-- ============================================================
-- Description: Thông tin hành khách định danh cho mỗi booking
-- Dependencies: V016 (bookings), V001 (enums: passenger_type, gender_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS booking_passengers (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id      UUID            NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    full_name       VARCHAR(255)    NOT NULL,
    identity_number VARCHAR(20),
    phone_number    VARCHAR(20),
    date_of_birth   DATE,
    passenger_type  passenger_type  NOT NULL DEFAULT 'ADULT',
    gender          gender_type
);

COMMENT ON TABLE booking_passengers IS 'Hành khách định danh — dùng cho check-in và xuất vé';
COMMENT ON COLUMN booking_passengers.identity_number IS 'CCCD hoặc số Hộ chiếu — dùng đối chiếu tại điểm đón';
COMMENT ON COLUMN booking_passengers.passenger_type IS 'ADULT / CHILD / INFANT — ảnh hưởng giá vé';
