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
