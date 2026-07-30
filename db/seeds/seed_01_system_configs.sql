-- ============================================================
-- Seed 01: System Configurations
-- ============================================================

INSERT INTO system_configs (id, config_key, config_value, description)
VALUES 
    (uuid_generate_v4(), 'hold_timeout_minutes', '15', 'Thời gian giữ chỗ mặc định (phút) trước khi đơn HELD tự động hủy'),
    (uuid_generate_v4(), 'max_markup_percent', '50', 'Tỷ lệ % markup tối đa đại lý được phép thiết lập'),
    (uuid_generate_v4(), 'supplier_approval_timeout_hours', '24', 'Thời gian tối đa (giờ) để NCC phê duyệt đơn On-Request'),
    (uuid_generate_v4(), 'vnpay_topup_min_amount', '100000', 'Số tiền nạp tối thiểu qua VNPay (VND)'),
    (uuid_generate_v4(), 'vnpay_topup_max_amount', '500000000', 'Số tiền nạp tối đa qua VNPay (VND) mỗi lần'),
    (uuid_generate_v4(), 'kyc_expiry_reminder_days', '30', 'Gửi thông báo nhắc nhở gia hạn KYC trước số ngày này')
ON CONFLICT (config_key) DO UPDATE 
SET config_value = EXCLUDED.config_value, description = EXCLUDED.description;
