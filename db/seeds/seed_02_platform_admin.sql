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
