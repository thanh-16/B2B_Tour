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
