-- ============================================================
-- B2B Travel Platform — Migration V013: Create Notifications Table
-- ============================================================
-- Description: Thông báo push cho người dùng
-- Dependencies: V005 (users), V001 (enums: notification_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS notifications (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type            notification_type NOT NULL,
    title           VARCHAR(255)    NOT NULL,
    body            TEXT,
    reference_id    VARCHAR(100),
    is_read         BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE notifications IS 'Thông báo push — hiển thị trên app và gửi qua FCM';
COMMENT ON COLUMN notifications.reference_id IS 'ID đối tượng liên quan (BookingId, ClaimId...)';
