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
