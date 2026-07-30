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
