-- B2B Travel Platform — Seed All Demo Data
-- Run this file in Supabase SQL Editor AFTER full_schema.sql
-- Generated: 2026-07-28T16:04:47.693Z

-- ========== seed_01_system_configs.sql ==========
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


-- ========== seed_02_platform_admin.sql ==========
-- ============================================================
-- Seed 02: Platform Admin Account
-- ============================================================
-- Username: admin
-- Password: Admin@123 (BCrypt Hash)

INSERT INTO users (
    id, agency_id, supplier_id, username, email, phone, full_name, password_hash, role, is_active
) VALUES (
    'a0000000-0000-0000-0000-000000000001',
    NULL,
    NULL,
    'admin',
    'admin@b2btravel.com',
    '0900000000',
    'Platform Administrator',
    '$2a$11$qM5W2c3E5b7Y9k1L3m5n7eO9pQ1rS3tU5vW7xY9zA1bC3dE5fG7hI', -- Password: Admin@123
    'PLATFORM_ADMIN',
    TRUE
) ON CONFLICT (username) DO NOTHING;


-- ========== seed_03_demo_suppliers.sql ==========
-- ============================================================
-- Seed 03: Demo Suppliers
-- ============================================================

INSERT INTO suppliers (id, name, contact_email, contact_phone, address, is_active)
VALUES 
    (
        'b0000000-0000-0000-0000-000000000001',
        'Mường Thanh Hospitality Group',
        'booking@muongthanh.vn',
        '02438889999',
        '60 Trần Phú, Lộc Thọ, Nha Trang, Khánh Hòa',
        TRUE
    ),
    (
        'b0000000-0000-0000-0000-000000000002',
        'Phú Quốc Explorer Travel',
        'info@phuquocexplorer.com',
        '02973998877',
        '123 Đường Trần Hưng Đạo, Dương Đông, Phú Quốc',
        TRUE
    )
ON CONFLICT (id) DO NOTHING;


-- ========== seed_04_demo_agencies.sql ==========
-- ============================================================
-- Seed 04: Demo Agencies & Wallets
-- ============================================================

-- 1. Agency 1: Vietnam Travel Corp (APPROVED)
INSERT INTO agencies (
    id, name, tax_code, business_license_url, travel_license_url, address, contact_email, contact_phone, kyc_status, kyc_approved_at, kyc_expires_at, is_active
) VALUES (
    'c0000000-0000-0000-0000-000000000001',
    'Công Ty TNHH Du Lịch Việt Nam (VietTravel B2B)',
    '0101234567',
    'https://storage.b2btravel.com/licenses/biz_0101234567.pdf',
    'https://storage.b2btravel.com/licenses/travel_0101234567.pdf',
    '152 Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    'b2b@viettravel.com.vn',
    '02838228888',
    'APPROVED',
    NOW() - INTERVAL '30 days',
    NOW() + INTERVAL '335 days',
    TRUE
) ON CONFLICT (tax_code) DO NOTHING;

-- Wallet cho Agency 1 (Balance: 50,000,000 VND, Credit Limit: 20,000,000 VND)
INSERT INTO wallets (
    id, agency_id, balance, reserved_balance, credit_limit, version, is_locked
) VALUES (
    'd0000000-0000-0000-0000-000000000001',
    'c0000000-0000-0000-0000-000000000001',
    50000000.00,
    0.00,
    20000000.00,
    1,
    FALSE
) ON CONFLICT (agency_id) DO NOTHING;

-- Ledger nạp tiền ban đầu cho Agency 1
INSERT INTO wallet_ledgers (
    id, wallet_id, transaction_type, amount, balance_after, reference_id, description
) VALUES (
    'e1000000-0000-0000-0000-000000000001',
    'd0000000-0000-0000-0000-000000000001',
    'CREDIT',
    50000000.00,
    50000000.00,
    'INIT_BALANCE',
    'Ký quỹ số dư ban đầu cho đại lý VietTravel B2B'
) ON CONFLICT (id) DO NOTHING;


-- 2. Agency 2: SunTravel Agency (PENDING_KYC)
INSERT INTO agencies (
    id, name, tax_code, business_license_url, travel_license_url, address, contact_email, contact_phone, kyc_status, is_active
) VALUES (
    'c0000000-0000-0000-0000-000000000002',
    'Đại Lý Du Lịch Mới SunTravel',
    '0309876543',
    'https://storage.b2btravel.com/licenses/biz_0309876543.pdf',
    NULL,
    '45 Lê Lợi, Quận Hải Châu, Đà Nẵng',
    'contact@suntravel.vn',
    '02363555777',
    'PENDING_KYC',
    TRUE
) ON CONFLICT (tax_code) DO NOTHING;

-- Wallet cho Agency 2 (Balance: 0 VND)
INSERT INTO wallets (
    id, agency_id, balance, reserved_balance, credit_limit, version, is_locked
) VALUES (
    'd0000000-0000-0000-0000-000000000002',
    'c0000000-0000-0000-0000-000000000002',
    0.00,
    0.00,
    0.00,
    1,
    FALSE
) ON CONFLICT (agency_id) DO NOTHING;


-- ========== seed_05_demo_users.sql ==========
-- ============================================================
-- Seed 05: Demo Users (Agency Manager, Staff, Supplier Admin, Delivery Staff)
-- ============================================================
-- Passwords: AgencyManager@123, Staff@123, Supplier@123, Driver@123

INSERT INTO users (
    id, agency_id, supplier_id, username, email, phone, full_name, password_hash, role, is_active
) VALUES 
    -- 1. Agency Manager (VietTravel)
    (
        'e0000000-0000-0000-0000-000000000001',
        'c0000000-0000-0000-0000-000000000001',
        NULL,
        'agency_manager',
        'manager@viettravel.com.vn',
        '0912345678',
        'Nguyễn Văn Trưởng (Manager)',
        '$2a$11$qM5W2c3E5b7Y9k1L3m5n7eO9pQ1rS3tU5vW7xY9zA1bC3dE5fG7hI',
        'AGENCY_MANAGER',
        TRUE
    ),
    -- 2. Agency Staff 1 (VietTravel)
    (
        'e0000000-0000-0000-0000-000000000002',
        'c0000000-0000-0000-0000-000000000001',
        NULL,
        'agency_staff1',
        'staff1@viettravel.com.vn',
        '0923456789',
        'Trần Thị Mai (Booker)',
        '$2a$11$qM5W2c3E5b7Y9k1L3m5n7eO9pQ1rS3tU5vW7xY9zA1bC3dE5fG7hI',
        'AGENCY_STAFF',
        TRUE
    ),
    -- 3. Agency Staff 2 (VietTravel)
    (
        'e0000000-0000-0000-0000-000000000003',
        'c0000000-0000-0000-0000-000000000001',
        NULL,
        'agency_staff2',
        'staff2@viettravel.com.vn',
        '0934567890',
        'Lê Hoàng Nam (Booker)',
        '$2a$11$qM5W2c3E5b7Y9k1L3m5n7eO9pQ1rS3tU5vW7xY9zA1bC3dE5fG7hI',
        'AGENCY_STAFF',
        TRUE
    ),
    -- 4. Supplier Admin (Mường Thanh)
    (
        'e0000000-0000-0000-0000-000000000004',
        NULL,
        'b0000000-0000-0000-0000-000000000001',
        'supplier_admin',
        'admin@muongthanh.vn',
        '0945678901',
        'Phạm Thanh Tùng (Mường Thanh)',
        '$2a$11$qM5W2c3E5b7Y9k1L3m5n7eO9pQ1rS3tU5vW7xY9zA1bC3dE5fG7hI',
        'SUPPLIER_ADMIN',
        TRUE
    ),
    -- 5. Delivery Staff / Driver (Phú Quốc Explorer)
    (
        'e0000000-0000-0000-0000-000000000005',
        NULL,
        'b0000000-0000-0000-0000-000000000002',
        'driver_staff',
        'driver@phuquocexplorer.com',
        '0956789012',
        'Võ Văn Tài (Tài Xế/HDV)',
        '$2a$11$qM5W2c3E5b7Y9k1L3m5n7eO9pQ1rS3tU5vW7xY9zA1bC3dE5fG7hI',
        'DELIVERY_STAFF',
        TRUE
    )
ON CONFLICT (username) DO NOTHING;


-- ========== seed_06_demo_inventories.sql ==========
-- ============================================================
-- Seed 06: Demo Inventories & Daily Slots
-- ============================================================

-- 1. Inventory 1: Phòng Deluxe Hướng Biển - Mường Thanh Nha Trang
INSERT INTO inventories (
    id, supplier_id, name, description, service_type, location, thumbnail_url, requires_approval, is_active, metadata
) VALUES (
    'f0000000-0000-0000-0000-000000000001',
    'b0000000-0000-0000-0000-000000000001',
    'Phòng Deluxe Ocean View — Mường Thanh Nha Trang',
    'Phòng rộng 35m2 hướng biển trực diện, bao gồm ăn sáng buffet 2 khách',
    'HOTEL',
    'Nha Trang, Khánh Hòa',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945',
    FALSE, -- Giữ chỗ tự động
    TRUE,
    '{"stars": 5, "wifi": true, "breakfast_included": true, "pool": true}'::jsonb
) ON CONFLICT (id) DO NOTHING;

-- 2. Inventory 2: Tour 4 Đảo Phú Quốc 1 Ngày (On-Request)
INSERT INTO inventories (
    id, supplier_id, name, description, service_type, location, thumbnail_url, requires_approval, is_active, metadata
) VALUES (
    'f0000000-0000-0000-0000-000000000002',
    'b0000000-0000-0000-0000-000000000002',
    'Tour 4 Đảo Phú Quốc Bằng Cano + Cáp Treo Hòn Thơm',
    'Hành trình khám phá Hòn Mây Rút, Hòn Móng Tay, Hòn Gầm Ghì, cáp treo Hòn Thơm ăn trưa buffet',
    'TOUR',
    'Phú Quốc, Kiên Giang',
    'https://images.unsplash.com/photo-1540555700478-4be289fbecef',
    TRUE, -- On-Request: Cần NCC duyệt
    TRUE,
    '{"duration": "1 ngày", "pickup_service": true, "lunch_included": true}'::jsonb
) ON CONFLICT (id) DO NOTHING;


-- Sinh Daily Slots cho 7 ngày tới (từ hôm nay)
DO $$
DECLARE
    curr_date DATE := CURRENT_DATE;
    i INT;
BEGIN
    FOR i IN 0..7 LOOP
        -- Slots cho Hotel (Giá gốc 1.200.000 VND, 10 phòng/ngày)
        INSERT INTO inventory_slots (
            inventory_id, service_date, base_price, total_slots, available_slots, version
        ) VALUES (
            'f0000000-0000-0000-0000-000000000001',
            curr_date + i,
            1200000.00,
            10,
            10,
            1
        ) ON CONFLICT (inventory_id, service_date) DO NOTHING;

        -- Slots cho Tour (Giá gốc 850.000 VND, 30 chỗ/ngày)
        INSERT INTO inventory_slots (
            inventory_id, service_date, base_price, total_slots, available_slots, version
        ) VALUES (
            'f0000000-0000-0000-0000-000000000002',
            curr_date + i,
            850000.00,
            30,
            30,
            1
        ) ON CONFLICT (inventory_id, service_date) DO NOTHING;
    END LOOP;
END $$;


-- ========== seed_07_demo_markup.sql ==========
-- ============================================================
-- Seed 07: Demo Markup Configurations
-- ============================================================

-- Cấu hình Markup cho VietTravel (Agency 1):
-- Hotel: +5% markup
-- Tour: +50,000 VND fixed markup
-- Bus: +10% markup

INSERT INTO markup_configs (agency_id, service_type, percent_markup, fixed_markup)
VALUES
    ('c0000000-0000-0000-0000-000000000001', 'HOTEL', 5.00, 0.00),
    ('c0000000-0000-0000-0000-000000000001', 'TOUR', 0.00, 50000.00),
    ('c0000000-0000-0000-0000-000000000001', 'BUS_TRANSFER', 10.00, 0.00)
ON CONFLICT (agency_id, service_type) DO UPDATE
SET percent_markup = EXCLUDED.percent_markup, fixed_markup = EXCLUDED.fixed_markup;


