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
