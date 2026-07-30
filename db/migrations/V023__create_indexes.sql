-- ============================================================
-- B2B Travel Platform — Migration V023: Create All Indexes
-- ============================================================
-- Description: Indexes cho tất cả truy vấn chính — tối ưu hiệu năng
-- Dependencies: Tất cả bảng V002-V022 phải đã tạo
-- ============================================================

-- ============================================================
-- NHÓM 1: Identity & Access
-- ============================================================

-- Users: filter theo đại lý + role (dashboard đại lý)
CREATE INDEX IF NOT EXISTS idx_users_agency_role
    ON users (agency_id, role) WHERE agency_id IS NOT NULL;

-- Users: filter theo supplier
CREATE INDEX IF NOT EXISTS idx_users_supplier
    ON users (supplier_id) WHERE supplier_id IS NOT NULL;

-- Refresh Tokens: cleanup expired tokens
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_expires
    ON refresh_tokens (user_id, expires_at);

-- ============================================================
-- NHÓM 2: Financial
-- ============================================================

-- Wallet Ledgers: lịch sử giao dịch (mới nhất trước)
CREATE INDEX IF NOT EXISTS idx_ledgers_wallet_created
    ON wallet_ledgers (wallet_id, created_at DESC);

-- Topup Requests: tra cứu theo agency + status
CREATE INDEX IF NOT EXISTS idx_topup_agency_status
    ON topup_requests (agency_id, status);

-- ============================================================
-- NHÓM 3: Inventory
-- ============================================================

-- Inventories: tìm kiếm theo NCC + loại dịch vụ + active
CREATE INDEX IF NOT EXISTS idx_inventories_supplier_type
    ON inventories (supplier_id, service_type) WHERE is_active = TRUE;

-- Inventories: tìm kiếm theo địa điểm
CREATE INDEX IF NOT EXISTS idx_inventories_location
    ON inventories (location) WHERE is_active = TRUE;

-- Inventory Slots: tìm kiếm kho theo ngày + có sẵn chỗ
CREATE INDEX IF NOT EXISTS idx_inventory_slots_search
    ON inventory_slots (service_date, available_slots, inventory_id)
    WHERE available_slots > 0;

-- ============================================================
-- NHÓM 4: Booking
-- ============================================================

-- Bookings: dashboard đại lý (filter agency + status)
CREATE INDEX IF NOT EXISTS idx_bookings_agency_status
    ON bookings (agency_id, status);

-- Bookings: AutoCancel Job quét nhanh (HELD + hết hạn)
CREATE INDEX IF NOT EXISTS idx_bookings_held_expires
    ON bookings (status, hold_expires_at)
    WHERE status = 'HELD';

-- Bookings: tra nhóm combo
CREATE INDEX IF NOT EXISTS idx_bookings_group
    ON bookings (group_id) WHERE group_id IS NOT NULL;

-- Bookings: pending supplier approval scan
CREATE INDEX IF NOT EXISTS idx_bookings_pending_approval
    ON bookings (status, supplier_approval_deadline)
    WHERE status = 'PENDING_SUPPLIER_APPROVAL';

-- Booking Details: tra chi tiết theo booking
CREATE INDEX IF NOT EXISTS idx_booking_details_booking
    ON booking_details (booking_id);

-- Booking Passengers: tra hành khách theo booking
CREATE INDEX IF NOT EXISTS idx_booking_passengers_booking
    ON booking_passengers (booking_id);

-- ============================================================
-- NHÓM 5: Delivery & QR
-- ============================================================

-- Check-in Logs: lịch sử check-in theo voucher
CREATE INDEX IF NOT EXISTS idx_checkin_voucher_time
    ON checkin_logs (voucher_id, scanned_at);

-- Driver Keys: tra key theo user + ngày hiệu lực
CREATE INDEX IF NOT EXISTS idx_driver_keys_user_date
    ON driver_keys (user_id, valid_date) WHERE is_revoked = FALSE;

-- Fraud Alerts: unresolved alerts
CREATE INDEX IF NOT EXISTS idx_fraud_unresolved
    ON fraud_alerts (is_resolved, created_at DESC)
    WHERE is_resolved = FALSE;

-- ============================================================
-- NHÓM 6: System & Support
-- ============================================================

-- Notifications: unread notifications (user inbox)
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread
    ON notifications (user_id, is_read, created_at DESC);

-- Claims: pending claims for admin
CREATE INDEX IF NOT EXISTS idx_claims_status
    ON claims (status, created_at DESC)
    WHERE status = 'PENDING';

-- Audit Logs: tra theo entity
CREATE INDEX IF NOT EXISTS idx_audit_entity
    ON audit_logs (entity_type, entity_id);
