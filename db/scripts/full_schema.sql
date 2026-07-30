-- B2B Travel Platform — Full Schema (Auto-generated)
-- Run this file in Supabase SQL Editor to create all tables
-- Generated: 2026-07-29T07:30:00.600Z

-- ========== V001__create_extensions_and_enums.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V001: Extensions & Enum Types
-- ============================================================
-- Description: Enable PostgreSQL extensions and create all custom enum types
-- Dependencies: None (first migration)
-- Run on: Supabase SQL Editor or psql
-- ============================================================

-- ============================================================
-- EXTENSIONS
-- ============================================================

-- UUID generation functions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Cryptographic functions (for password hashing, HMAC)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- ENUM TYPES (12 types)
-- ============================================================

-- Vai trò người dùng trong hệ thống
CREATE TYPE user_role AS ENUM (
    'PLATFORM_ADMIN',       -- Quản trị viên nền tảng
    'AGENCY_MANAGER',       -- Chủ đại lý du lịch
    'AGENCY_STAFF',         -- Nhân viên đại lý
    'SUPPLIER_ADMIN',       -- Quản trị nhà cung cấp
    'DELIVERY_STAFF'        -- Tài xế / Hướng dẫn viên
);

-- Trạng thái thẩm định KYC đại lý
CREATE TYPE kyc_status AS ENUM (
    'PENDING_KYC',          -- Chờ thẩm định
    'APPROVED',             -- Đã duyệt
    'REJECTED',             -- Bị từ chối
    'SUSPENDED'             -- Bị đình chỉ
);

-- Trạng thái đơn đặt chỗ (State Machine)
CREATE TYPE booking_status AS ENUM (
    'HELD',                         -- Đã giữ chỗ (15 phút)
    'PENDING_SUPPLIER_APPROVAL',    -- Chờ NCC duyệt (On-Request)
    'CONFIRMED',                    -- NCC đã duyệt
    'PAID',                         -- Đã thanh toán
    'COMPLETED',                    -- Đã hoàn thành (check-in xong)
    'CANCELLED',                    -- Đã hủy
    'REFUNDED',                     -- Đã hoàn tiền
    'PENDING_REFUND'                -- Chờ hoàn tiền
);

-- Loại giao dịch tài chính trong sổ cái
CREATE TYPE transaction_type AS ENUM (
    'CREDIT',               -- Nạp tiền vào ví
    'DEBIT',                -- Trừ tiền khỏi ví (thanh toán)
    'REFUND',               -- Hoàn tiền
    'RESERVE_HOLD',         -- Tạm giữ số dư (On-Request booking)
    'RESERVE_RELEASE',      -- Giải phóng số dư tạm giữ (NCC từ chối)
    'RESERVE_CONFIRM'       -- Xác nhận trừ số dư tạm giữ (NCC duyệt)
);

-- Loại dịch vụ du lịch
CREATE TYPE service_type AS ENUM (
    'HOTEL',                -- Khách sạn
    'TOUR',                 -- Tour du lịch
    'BUS_TRANSFER',         -- Vé xe khách
    'FLIGHT'                -- Vé máy bay
);

-- Trạng thái yêu cầu nạp tiền
CREATE TYPE topup_status AS ENUM (
    'PENDING',              -- Đang chờ xử lý
    'SUCCESS',              -- Thành công
    'CANCELLED',            -- Đã hủy
    'FAILED'                -- Thất bại
);

-- Loại khiếu nại sau bán hàng
CREATE TYPE claim_type AS ENUM (
    'REFUND',               -- Yêu cầu hoàn tiền
    'DATE_CHANGE',          -- Yêu cầu đổi ngày
    'COMPLAINT'             -- Khiếu nại chung
);

-- Trạng thái xử lý khiếu nại
CREATE TYPE claim_status AS ENUM (
    'PENDING',              -- Chờ xử lý
    'APPROVED',             -- Đã duyệt
    'REJECTED'              -- Đã từ chối
);

-- Loại thông báo push
CREATE TYPE notification_type AS ENUM (
    'BOOKING_HELD',                 -- Giữ chỗ thành công
    'BOOKING_PAID',                 -- Thanh toán thành công
    'BOOKING_CANCELLED',            -- Đơn đã hủy
    'WALLET_CREDITED',              -- Nạp ví thành công
    'KYC_APPROVED',                 -- KYC được duyệt
    'KYC_REJECTED',                 -- KYC bị từ chối
    'SUPPLIER_APPROVAL_REQUIRED',   -- Cần NCC duyệt đơn
    'SUPPLIER_APPROVED',            -- NCC đã duyệt
    'SUPPLIER_REJECTED',            -- NCC từ chối
    'CLAIM_RESOLVED',               -- Khiếu nại đã xử lý
    'HOLD_EXPIRING',                -- Sắp hết hạn giữ chỗ
    'KYC_EXPIRY_REMINDER'           -- Nhắc gia hạn KYC
);

-- Loại hành khách
CREATE TYPE passenger_type AS ENUM (
    'ADULT',                -- Người lớn
    'CHILD',                -- Trẻ em (2-11 tuổi)
    'INFANT'                -- Em bé (< 2 tuổi)
);

-- Trạng thái E-Voucher
CREATE TYPE voucher_status AS ENUM (
    'ACTIVE',               -- Đang hoạt động
    'CHECKED_IN',           -- Đã check-in
    'EXPIRED',              -- Hết hạn
    'CANCELLED'             -- Đã hủy
);

-- Phương thức thanh toán nạp ví
CREATE TYPE payment_method AS ENUM (
    'VNPAY',                -- Cổng VNPay
    'BANK_TRANSFER',        -- Chuyển khoản ngân hàng
    'MANUAL'                -- Admin nạp thủ công
);

-- Giới tính hành khách
CREATE TYPE gender_type AS ENUM (
    'MALE',                 -- Nam
    'FEMALE',               -- Nữ
    'OTHER'                 -- Khác
);

-- Loại cảnh báo gian lận QR
CREATE TYPE fraud_alert_type AS ENUM (
    'DOUBLE_CHECKIN',       -- Quét trùng lặp
    'INVALID_SIGNATURE',    -- Chữ ký HMAC không hợp lệ
    'GPS_MISMATCH'          -- Tọa độ GPS bất thường
);


-- ========== V002__create_suppliers.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V002: Create Suppliers Table
-- ============================================================
-- Description: Nhà cung cấp dịch vụ du lịch (khách sạn, tour, nhà xe, hãng bay)
-- Dependencies: V001 (extensions)
-- ============================================================

CREATE TABLE IF NOT EXISTS suppliers (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            VARCHAR(255) NOT NULL,
    contact_email   VARCHAR(255),
    contact_phone   VARCHAR(20),
    address         TEXT,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE suppliers IS 'Nhà cung cấp dịch vụ du lịch (khách sạn, tour operator, nhà xe, hãng bay)';
COMMENT ON COLUMN suppliers.is_active IS 'FALSE = ngưng hợp tác (soft delete)';


-- ========== V003__create_agencies.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V003: Create Agencies Table
-- ============================================================
-- Description: Đại lý du lịch đăng ký sử dụng nền tảng B2B
-- Dependencies: V001 (enums: kyc_status)
-- ============================================================

CREATE TABLE IF NOT EXISTS agencies (
    id                      UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name                    VARCHAR(255) NOT NULL,
    tax_code                VARCHAR(20) NOT NULL,
    business_license_url    TEXT,
    travel_license_url      TEXT,
    address                 TEXT,
    contact_email           VARCHAR(255),
    contact_phone           VARCHAR(20),
    kyc_status              kyc_status  NOT NULL DEFAULT 'PENDING_KYC',
    kyc_approved_at         TIMESTAMPTZ,
    kyc_expires_at          TIMESTAMPTZ,
    rejection_reason        TEXT,
    is_active               BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_agencies_tax_code UNIQUE (tax_code)
);

COMMENT ON TABLE agencies IS 'Đại lý du lịch đăng ký sử dụng nền tảng B2B';
COMMENT ON COLUMN agencies.tax_code IS 'Mã số thuế doanh nghiệp — unique, chống đăng ký trùng';
COMMENT ON COLUMN agencies.kyc_status IS 'Vòng đời KYC: PENDING_KYC → APPROVED / REJECTED / SUSPENDED';
COMMENT ON COLUMN agencies.kyc_expires_at IS 'Ngày hết hạn KYC — hệ thống nhắc 30 ngày trước';


-- ========== V004__create_system_configs.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V004: Create System Configs Table
-- ============================================================
-- Description: Cấu hình hệ thống dạng key-value (hold timeout, max markup...)
-- Dependencies: V001 (extensions)
-- ============================================================

CREATE TABLE IF NOT EXISTS system_configs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    config_key      VARCHAR(100) NOT NULL,
    config_value    TEXT        NOT NULL,
    description     TEXT,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by      UUID,

    CONSTRAINT uq_system_configs_key UNIQUE (config_key)
);

COMMENT ON TABLE system_configs IS 'Cấu hình hệ thống dạng key-value, thay đổi bởi PlatformAdmin';
COMMENT ON COLUMN system_configs.config_key IS 'Khóa cấu hình: hold_timeout_minutes, max_markup_percent...';
COMMENT ON COLUMN system_configs.updated_by IS 'FK → users.id (sẽ thêm FK sau khi bảng users được tạo)';


-- ========== V005__create_users.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V005: Create Users Table
-- ============================================================
-- Description: Tất cả người dùng hệ thống (admin, đại lý, NCC, tài xế)
-- Dependencies: V001 (enums: user_role), V002 (suppliers), V003 (agencies)
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id       UUID        REFERENCES agencies(id) ON DELETE RESTRICT,
    supplier_id     UUID        REFERENCES suppliers(id) ON DELETE RESTRICT,
    username        VARCHAR(100) NOT NULL,
    email           VARCHAR(255),
    phone           VARCHAR(20),
    full_name       VARCHAR(255) NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    role            user_role   NOT NULL,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    avatar_url      TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT chk_users_role_agency CHECK (
        (role = 'PLATFORM_ADMIN' AND agency_id IS NULL AND supplier_id IS NULL)
        OR (role IN ('AGENCY_MANAGER', 'AGENCY_STAFF') AND agency_id IS NOT NULL AND supplier_id IS NULL)
        OR (role IN ('SUPPLIER_ADMIN', 'DELIVERY_STAFF') AND agency_id IS NULL AND supplier_id IS NOT NULL)
    )
);

-- Thêm FK cho system_configs.updated_by (đã tạo trước đó)
ALTER TABLE system_configs
    ADD CONSTRAINT fk_system_configs_updated_by
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON TABLE users IS 'Tất cả người dùng: PlatformAdmin, AgencyManager/Staff, SupplierAdmin, DeliveryStaff';
COMMENT ON COLUMN users.agency_id IS 'NULL nếu PlatformAdmin; NOT NULL nếu Agency staff';
COMMENT ON COLUMN users.supplier_id IS 'NULL nếu không thuộc Supplier; NOT NULL nếu SupplierAdmin/DeliveryStaff';
COMMENT ON COLUMN users.password_hash IS 'BCrypt hash — KHÔNG lưu plain text';
COMMENT ON CONSTRAINT chk_users_role_agency ON users IS 'Đảm bảo role khớp với agency_id/supplier_id';


-- ========== V006__create_wallets.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V006: Create Wallets Table
-- ============================================================
-- Description: Ví tài chính đại lý — 1 agency = 1 wallet (1:1)
-- Dependencies: V003 (agencies)
-- ============================================================

CREATE TABLE IF NOT EXISTS wallets (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id           UUID        NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    balance             DECIMAL(18,2) NOT NULL DEFAULT 0,
    reserved_balance    DECIMAL(18,2) NOT NULL DEFAULT 0,
    credit_limit        DECIMAL(18,2) NOT NULL DEFAULT 0,
    version             INTEGER     NOT NULL DEFAULT 1,
    is_locked           BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_wallets_agency UNIQUE (agency_id),
    CONSTRAINT chk_wallet_balance_within_limit CHECK (balance >= -credit_limit),
    CONSTRAINT chk_wallet_available_balance CHECK (balance - reserved_balance >= -credit_limit),
    CONSTRAINT chk_wallet_reserved_non_negative CHECK (reserved_balance >= 0),
    CONSTRAINT chk_wallet_credit_limit_non_negative CHECK (credit_limit >= 0)
);

COMMENT ON TABLE wallets IS 'Ví tài chính đại lý — mỗi đại lý có đúng 1 ví (1:1)';
COMMENT ON COLUMN wallets.balance IS 'Số dư thực tế — có thể âm (trong phạm vi credit_limit)';
COMMENT ON COLUMN wallets.reserved_balance IS 'Số tiền tạm giữ cho đơn On-Request chờ NCC duyệt';
COMMENT ON COLUMN wallets.credit_limit IS 'Hạn mức nợ — cho phép balance âm tối đa bằng credit_limit';
COMMENT ON COLUMN wallets.version IS 'Optimistic Concurrency Control — tăng 1 mỗi lần UPDATE';
COMMENT ON COLUMN wallets.is_locked IS 'TRUE = ví bị khóa giao dịch (do Admin hoặc vi phạm)';


-- ========== V007__create_markup_configs.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V007: Create Markup Configs Table
-- ============================================================
-- Description: Cấu hình markup (% + cố định) theo đại lý và loại dịch vụ
-- Dependencies: V003 (agencies), V001 (enums: service_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS markup_configs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id       UUID        NOT NULL REFERENCES agencies(id) ON DELETE CASCADE,
    service_type    service_type NOT NULL,
    percent_markup  DECIMAL(5,2) NOT NULL DEFAULT 0,
    fixed_markup    DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_markup_agency_service UNIQUE (agency_id, service_type),
    CONSTRAINT chk_markup_non_negative CHECK (percent_markup >= 0 AND fixed_markup >= 0),
    CONSTRAINT chk_markup_max_percent CHECK (percent_markup <= 50)
);

COMMENT ON TABLE markup_configs IS 'Cấu hình markup lợi nhuận đại lý theo loại dịch vụ';
COMMENT ON COLUMN markup_configs.percent_markup IS 'Tỷ lệ % cộng thêm vào giá gốc (0-50%)';
COMMENT ON COLUMN markup_configs.fixed_markup IS 'Số tiền VND cố định cộng thêm vào giá gốc';
COMMENT ON CONSTRAINT uq_markup_agency_service ON markup_configs IS '1 đại lý + 1 loại dịch vụ = 1 config duy nhất';


-- ========== V008__create_inventories.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V008: Create Inventories Table
-- ============================================================
-- Description: Kho dịch vụ du lịch do NCC đăng tải (khách sạn, tour, xe, bay)
-- Dependencies: V002 (suppliers), V001 (enums: service_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS inventories (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_id         UUID        NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    name                VARCHAR(255) NOT NULL,
    description         TEXT,
    service_type        service_type NOT NULL,
    location            VARCHAR(255),
    thumbnail_url       TEXT,
    requires_approval   BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN     NOT NULL DEFAULT TRUE,
    metadata            JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE inventories IS 'Kho dịch vụ du lịch: khách sạn, tour, vé xe, vé bay';
COMMENT ON COLUMN inventories.requires_approval IS 'TRUE = On-Request (NCC phải duyệt thủ công trước khi confirm)';
COMMENT ON COLUMN inventories.metadata IS 'Thông tin mở rộng dạng JSON: tiện ích, rating, hình ảnh gallery...';
COMMENT ON COLUMN inventories.is_active IS 'FALSE = tạm ngưng bán (soft delete)';


-- ========== V009__create_refresh_tokens.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V009: Create Refresh Tokens Table
-- ============================================================
-- Description: JWT Refresh Token storage — hỗ trợ Token Rotation
-- Dependencies: V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(255) NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    is_revoked  BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_refresh_tokens_hash UNIQUE (token_hash)
);

COMMENT ON TABLE refresh_tokens IS 'JWT Refresh Token — lưu hash, hỗ trợ Token Rotation chống đánh cắp';
COMMENT ON COLUMN refresh_tokens.token_hash IS 'SHA256 hash của refresh token — KHÔNG lưu plain text';
COMMENT ON COLUMN refresh_tokens.is_revoked IS 'TRUE = token đã bị thu hồi (do rotate hoặc logout)';


-- ========== V010__create_wallet_ledgers.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V010: Create Wallet Ledgers Table
-- ============================================================
-- Description: Sổ cái giao dịch tài chính — APPEND-ONLY (không UPDATE/DELETE)
-- Dependencies: V006 (wallets), V001 (enums: transaction_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS wallet_ledgers (
    id                  UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id           UUID            NOT NULL REFERENCES wallets(id) ON DELETE RESTRICT,
    transaction_type    transaction_type NOT NULL,
    amount              DECIMAL(18,2)   NOT NULL,
    balance_after       DECIMAL(18,2)   NOT NULL,
    reference_id        VARCHAR(100),
    description         TEXT,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_ledger_amount_positive CHECK (amount > 0)
);

COMMENT ON TABLE wallet_ledgers IS 'Sổ cái giao dịch — APPEND-ONLY: chỉ INSERT, KHÔNG UPDATE/DELETE';
COMMENT ON COLUMN wallet_ledgers.amount IS 'Số tiền giao dịch (luôn dương — loại giao dịch xác định +/-)';
COMMENT ON COLUMN wallet_ledgers.balance_after IS 'Số dư ví SAU giao dịch — dùng để audit trail và đối soát';
COMMENT ON COLUMN wallet_ledgers.reference_id IS 'ID tham chiếu: BookingId, TopupRequestId, ClaimId...';


-- ========== V011__create_topup_requests.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V011: Create Topup Requests Table
-- ============================================================
-- Description: Yêu cầu nạp tiền ví qua VNPay hoặc chuyển khoản
-- Dependencies: V006 (wallets), V003 (agencies), V001 (enums)
-- ============================================================

CREATE TABLE IF NOT EXISTS topup_requests (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id           UUID        NOT NULL REFERENCES wallets(id) ON DELETE RESTRICT,
    agency_id           UUID        NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    amount              DECIMAL(18,2) NOT NULL,
    payment_method      payment_method NOT NULL,
    transaction_code    VARCHAR(100) NOT NULL,
    status              topup_status NOT NULL DEFAULT 'PENDING',
    vnpay_txn_ref       VARCHAR(100),
    vnpay_response_data JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_topup_transaction_code UNIQUE (transaction_code),
    CONSTRAINT chk_topup_amount_positive CHECK (amount > 0)
);

COMMENT ON TABLE topup_requests IS 'Yêu cầu nạp tiền ví — theo dõi trạng thái thanh toán VNPay/Bank';
COMMENT ON COLUMN topup_requests.transaction_code IS 'Mã giao dịch duy nhất — dùng làm Idempotent Key chống duplicate';
COMMENT ON COLUMN topup_requests.vnpay_response_data IS 'Raw response từ VNPay IPN — lưu để audit';


-- ========== V012__create_inventory_slots.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V012: Create Inventory Slots Table
-- ============================================================
-- Description: Slot chỗ theo ngày cho mỗi dịch vụ — đơn vị bán nhỏ nhất
-- Dependencies: V008 (inventories)
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory_slots (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    inventory_id    UUID        NOT NULL REFERENCES inventories(id) ON DELETE CASCADE,
    service_date    DATE        NOT NULL,
    base_price      DECIMAL(18,2) NOT NULL,
    total_slots     INTEGER     NOT NULL,
    available_slots INTEGER     NOT NULL,
    version         INTEGER     NOT NULL DEFAULT 1,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_slot_inventory_date UNIQUE (inventory_id, service_date),
    CONSTRAINT chk_slots_non_negative CHECK (available_slots >= 0),
    CONSTRAINT chk_slots_not_exceed_total CHECK (available_slots <= total_slots),
    CONSTRAINT chk_total_slots_positive CHECK (total_slots > 0),
    CONSTRAINT chk_base_price_positive CHECK (base_price > 0)
);

COMMENT ON TABLE inventory_slots IS 'Slot chỗ theo ngày — 1 dịch vụ + 1 ngày = 1 slot duy nhất';
COMMENT ON COLUMN inventory_slots.base_price IS 'Giá gốc (Net price) — đại lý cộng markup lên giá này';
COMMENT ON COLUMN inventory_slots.available_slots IS 'Số chỗ còn trống — giảm khi Hold, tăng khi Cancel';
COMMENT ON COLUMN inventory_slots.version IS 'OCC — mỗi lần UPDATE phải kiểm tra version khớp, tránh overbooking';


-- ========== V013__create_notifications.sql ==========
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


-- ========== V014__create_audit_logs.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V014: Create Audit Logs Table
-- ============================================================
-- Description: Nhật ký hành động hệ thống — append-only, phục vụ audit
-- Dependencies: V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    action          VARCHAR(100) NOT NULL,
    entity_type     VARCHAR(100),
    entity_id       VARCHAR(100),
    old_values      JSONB,
    new_values      JSONB,
    ip_address      VARCHAR(45),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE audit_logs IS 'Nhật ký hành động — lưu mọi thay đổi cấu hình, duyệt KYC, credit/debit ví...';
COMMENT ON COLUMN audit_logs.action IS 'Tên hành động: CONFIG_CHANGED, KYC_APPROVED, WALLET_MANUAL_CREDIT...';
COMMENT ON COLUMN audit_logs.old_values IS 'Giá trị CŨ trước khi thay đổi (JSON)';
COMMENT ON COLUMN audit_logs.new_values IS 'Giá trị MỚI sau khi thay đổi (JSON)';


-- ========== V015__create_driver_keys.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V015: Create Driver Keys Table
-- ============================================================
-- Description: Khóa bí mật HMAC-SHA256 cho tài xế quét QR offline
-- Dependencies: V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS driver_keys (
    id                      UUID    PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id                 UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    secret_key_encrypted    TEXT    NOT NULL,
    valid_date              DATE    NOT NULL,
    is_revoked              BOOLEAN NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_driver_keys_user_date UNIQUE (user_id, valid_date)
);

COMMENT ON TABLE driver_keys IS 'Khóa HMAC-SHA256 per-driver — xoay vòng mỗi 24h cho QR offline verification';
COMMENT ON COLUMN driver_keys.secret_key_encrypted IS 'AES-256 encrypted secret key — giải mã khi cần verify QR';
COMMENT ON COLUMN driver_keys.valid_date IS 'Ngày có hiệu lực — mỗi ngày có 1 key mới';


-- ========== V016__create_bookings.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V016: Create Bookings Table
-- ============================================================
-- Description: Đơn đặt chỗ — core entity của hệ thống
-- Dependencies: V003 (agencies), V005 (users), V001 (enums: booking_status)
-- ============================================================

CREATE TABLE IF NOT EXISTS bookings (
    id                          UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id                   UUID            NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    created_by                  UUID            NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    pnr_code                    VARCHAR(10)     NOT NULL,
    group_id                    VARCHAR(50),
    status                      booking_status  NOT NULL DEFAULT 'HELD',
    total_net_amount            DECIMAL(18,2)   NOT NULL,
    total_markup_amount         DECIMAL(18,2)   NOT NULL DEFAULT 0,
    total_amount                DECIMAL(18,2)   NOT NULL,
    cancellation_reason         TEXT,
    hold_expires_at             TIMESTAMPTZ,
    supplier_approval_deadline  TIMESTAMPTZ,
    created_at                  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_bookings_pnr UNIQUE (pnr_code),
    CONSTRAINT chk_bookings_amount_positive CHECK (total_amount > 0),
    CONSTRAINT chk_bookings_net_positive CHECK (total_net_amount > 0),
    CONSTRAINT chk_bookings_markup_non_negative CHECK (total_markup_amount >= 0),
    CONSTRAINT chk_bookings_total_math CHECK (total_amount = total_net_amount + total_markup_amount),
    CONSTRAINT chk_bookings_held_has_expires CHECK (status != 'HELD' OR hold_expires_at IS NOT NULL),
    CONSTRAINT chk_bookings_pending_approval_has_deadline CHECK (status != 'PENDING_SUPPLIER_APPROVAL' OR supplier_approval_deadline IS NOT NULL)
);

COMMENT ON TABLE bookings IS 'Đơn đặt chỗ — core entity, State Machine: HELD → PAID → COMPLETED';
COMMENT ON COLUMN bookings.pnr_code IS 'Mã PNR 6-10 ký tự alfanumeric unique — dùng tra cứu nhanh';
COMMENT ON COLUMN bookings.group_id IS 'Nhóm combo — các booking cùng group_id thuộc 1 giỏ hàng';
COMMENT ON COLUMN bookings.total_net_amount IS 'Tổng giá gốc (Net price từ NCC)';
COMMENT ON COLUMN bookings.total_markup_amount IS 'Tổng tiền markup (lợi nhuận đại lý)';
COMMENT ON COLUMN bookings.total_amount IS 'Tổng thanh toán = Net + Markup';
COMMENT ON COLUMN bookings.hold_expires_at IS 'Thời điểm hết hạn giữ chỗ — Hangfire Job dùng để auto-cancel';
COMMENT ON COLUMN bookings.supplier_approval_deadline IS 'Deadline cho NCC duyệt đơn On-Request';


-- ========== V017__create_claims.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V017: Create Claims Table
-- ============================================================
-- Description: Khiếu nại after-sales (hoàn tiền, đổi ngày, khiếu nại chung)
-- Dependencies: V016 (bookings), V003 (agencies), V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS claims (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id      UUID        NOT NULL REFERENCES bookings(id) ON DELETE RESTRICT,
    agency_id       UUID        NOT NULL REFERENCES agencies(id) ON DELETE RESTRICT,
    submitted_by    UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    claim_type      claim_type  NOT NULL,
    status          claim_status NOT NULL DEFAULT 'PENDING',
    reason          TEXT        NOT NULL,
    penalty_amount  DECIMAL(18,2),
    refund_amount   DECIMAL(18,2),
    resolution_note TEXT,
    resolved_by     UUID        REFERENCES users(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ
);

COMMENT ON TABLE claims IS 'Khiếu nại after-sales: hoàn tiền, đổi ngày, complaint';
COMMENT ON COLUMN claims.penalty_amount IS 'Phí phạt hủy/đổi (nếu có) — trừ vào refund_amount';
COMMENT ON COLUMN claims.refund_amount IS 'Số tiền thực hoàn = giá booking - penalty';


-- ========== V018__create_booking_details.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V018: Create Booking Details Table
-- ============================================================
-- Description: Chi tiết từng dịch vụ trong đơn đặt chỗ (liên kết Booking ↔ Slot)
-- Dependencies: V016 (bookings), V012 (inventory_slots)
-- ============================================================

CREATE TABLE IF NOT EXISTS booking_details (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id          UUID        NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    inventory_slot_id   UUID        NOT NULL REFERENCES inventory_slots(id) ON DELETE RESTRICT,
    quantity            INTEGER     NOT NULL DEFAULT 1,
    locked_unit_price   DECIMAL(18,2) NOT NULL,
    locked_markup       DECIMAL(18,2) NOT NULL DEFAULT 0,
    subtotal            DECIMAL(18,2) NOT NULL,

    CONSTRAINT chk_detail_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_detail_price_positive CHECK (locked_unit_price > 0),
    CONSTRAINT chk_detail_markup_non_negative CHECK (locked_markup >= 0),
    CONSTRAINT chk_detail_subtotal_positive CHECK (subtotal > 0),
    CONSTRAINT chk_detail_subtotal_math CHECK (subtotal = quantity * (locked_unit_price + locked_markup))
);

COMMENT ON TABLE booking_details IS 'Chi tiết dịch vụ trong booking — lock giá tại thời điểm Hold';
COMMENT ON COLUMN booking_details.locked_unit_price IS 'Giá gốc tại thời điểm Hold — không đổi dù NCC sửa giá sau';
COMMENT ON COLUMN booking_details.locked_markup IS 'Markup tại thời điểm Hold — đảm bảo đại lý nhận đúng lợi nhuận';
COMMENT ON COLUMN booking_details.subtotal IS 'Tổng = quantity × (locked_unit_price + locked_markup)';


-- ========== V019__create_booking_passengers.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V019: Create Booking Passengers Table
-- ============================================================
-- Description: Thông tin hành khách định danh cho mỗi booking
-- Dependencies: V016 (bookings), V001 (enums: passenger_type, gender_type)
-- ============================================================

CREATE TABLE IF NOT EXISTS booking_passengers (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id      UUID            NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    full_name       VARCHAR(255)    NOT NULL,
    identity_number VARCHAR(20),
    phone_number    VARCHAR(20),
    date_of_birth   DATE,
    passenger_type  passenger_type  NOT NULL DEFAULT 'ADULT',
    gender          gender_type
);

COMMENT ON TABLE booking_passengers IS 'Hành khách định danh — dùng cho check-in và xuất vé';
COMMENT ON COLUMN booking_passengers.identity_number IS 'CCCD hoặc số Hộ chiếu — dùng đối chiếu tại điểm đón';
COMMENT ON COLUMN booking_passengers.passenger_type IS 'ADULT / CHILD / INFANT — ảnh hưởng giá vé';


-- ========== V020__create_vouchers.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V020: Create Vouchers Table
-- ============================================================
-- Description: E-Voucher điện tử — QR Code + PDF cho mỗi booking
-- Dependencies: V016 (bookings), V005 (users), V001 (enums: voucher_status)
-- ============================================================

CREATE TABLE IF NOT EXISTS vouchers (
    id                  UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id          UUID            NOT NULL REFERENCES bookings(id) ON DELETE RESTRICT,
    voucher_code        VARCHAR(20)     NOT NULL,
    qr_payload          TEXT            NOT NULL,
    pdf_url             TEXT,
    status              voucher_status  NOT NULL DEFAULT 'ACTIVE',
    assigned_driver_id  UUID            REFERENCES users(id) ON DELETE SET NULL,
    issued_at           TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    expires_at          TIMESTAMPTZ     NOT NULL,

    CONSTRAINT uq_vouchers_booking UNIQUE (booking_id),
    CONSTRAINT uq_vouchers_code UNIQUE (voucher_code)
);

COMMENT ON TABLE vouchers IS 'E-Voucher điện tử — 1 booking = 1 voucher (1:1)';
COMMENT ON COLUMN vouchers.qr_payload IS 'JSON data ký bằng HMAC-SHA256: {bookingId, voucherCode, expiry, timestamp}';
COMMENT ON COLUMN vouchers.pdf_url IS 'URL file PDF voucher trên S3/GCS';
COMMENT ON COLUMN vouchers.assigned_driver_id IS 'Tài xế/guide phụ trách — dùng per-driver key để verify QR offline';


-- ========== V021__create_checkin_logs.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V021: Create Check-in Logs Table
-- ============================================================
-- Description: Lịch sử quét QR check-in (online + offline)
-- Dependencies: V020 (vouchers), V005 (users)
-- ============================================================

CREATE TABLE IF NOT EXISTS checkin_logs (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    voucher_id      UUID        NOT NULL REFERENCES vouchers(id) ON DELETE RESTRICT,
    scanned_by      UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    is_online       BOOLEAN     NOT NULL,
    gps_latitude    DECIMAL(10,7),
    gps_longitude   DECIMAL(10,7),
    scanned_at      TIMESTAMPTZ NOT NULL,
    synced_at       TIMESTAMPTZ,
    is_fraud_flagged BOOLEAN    NOT NULL DEFAULT FALSE,

    CONSTRAINT chk_gps_latitude_range CHECK (gps_latitude IS NULL OR (gps_latitude >= -90 AND gps_latitude <= 90)),
    CONSTRAINT chk_gps_longitude_range CHECK (gps_longitude IS NULL OR (gps_longitude >= -180 AND gps_longitude <= 180))
);

COMMENT ON TABLE checkin_logs IS 'Lịch sử quét QR — ghi nhận cả online lẫn offline scan';
COMMENT ON COLUMN checkin_logs.is_online IS 'TRUE = quét trực tuyến (verify API); FALSE = quét offline (verify HMAC local)';
COMMENT ON COLUMN checkin_logs.synced_at IS 'NULL = chưa sync lên server (offline); có giá trị = đã sync';
COMMENT ON COLUMN checkin_logs.is_fraud_flagged IS 'TRUE = nghi gian lận (double scan, invalid signature...)';


-- ========== V022__create_fraud_alerts.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V022: Create Fraud Alerts Table
-- ============================================================
-- Description: Cảnh báo gian lận QR check-in (double scan, invalid signature)
-- Dependencies: V020 (vouchers), V021 (checkin_logs)
-- ============================================================

CREATE TABLE IF NOT EXISTS fraud_alerts (
    id                      UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    voucher_id              UUID        NOT NULL REFERENCES vouchers(id) ON DELETE RESTRICT,
    online_checkin_log_id   UUID        REFERENCES checkin_logs(id) ON DELETE SET NULL,
    offline_checkin_log_id  UUID        REFERENCES checkin_logs(id) ON DELETE SET NULL,
    alert_type              fraud_alert_type NOT NULL,
    details                 JSONB,
    is_resolved             BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE fraud_alerts IS 'Cảnh báo gian lận: double check-in, invalid signature, GPS mismatch';
COMMENT ON COLUMN fraud_alerts.alert_type IS 'DOUBLE_CHECKIN | INVALID_SIGNATURE | GPS_MISMATCH';
COMMENT ON COLUMN fraud_alerts.details IS 'Chi tiết: GPS coords, timestamps, signature comparison...';


-- ========== V023__create_indexes.sql ==========
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


-- ========== V024__create_constraints_and_triggers.sql ==========
-- ============================================================
-- B2B Travel Platform — Migration V024: Constraints, Triggers & RLS
-- ============================================================
-- Description: CHECK constraints, Triggers bảo vệ sổ cái & Cross-Tenant Validation, Row Level Security (RLS)
-- Dependencies: Tất cả bảng V002-V022 phải đã tạo
-- ============================================================

-- ============================================================
-- TRIGGER 1: Chặn UPDATE/DELETE trên wallet_ledgers (Sổ cái bất biến)
-- ============================================================

CREATE OR REPLACE FUNCTION fn_prevent_ledger_modification()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'wallet_ledgers is APPEND-ONLY. UPDATE and DELETE are prohibited. Transaction ID: %. This is a security constraint to ensure financial integrity.', OLD.id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_ledger_update
    BEFORE UPDATE ON wallet_ledgers
    FOR EACH ROW
    EXECUTE FUNCTION fn_prevent_ledger_modification();

CREATE TRIGGER trg_prevent_ledger_delete
    BEFORE DELETE ON wallet_ledgers
    FOR EACH ROW
    EXECUTE FUNCTION fn_prevent_ledger_modification();

-- ============================================================
-- TRIGGER 1B: Chặn UPDATE/DELETE trên audit_logs (Nhật ký hành động bất biến)
-- ============================================================

CREATE OR REPLACE FUNCTION fn_prevent_audit_log_modification()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'audit_logs is APPEND-ONLY. UPDATE and DELETE are prohibited. Log ID: %', OLD.id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_audit_log_update
    BEFORE UPDATE ON audit_logs
    FOR EACH ROW
    EXECUTE FUNCTION fn_prevent_audit_log_modification();

CREATE TRIGGER trg_prevent_audit_log_delete
    BEFORE DELETE ON audit_logs
    FOR EACH ROW
    EXECUTE FUNCTION fn_prevent_audit_log_modification();

-- ============================================================
-- TRIGGER 2: Auto-update updated_at timestamp
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auto_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_updated_at_suppliers
    BEFORE UPDATE ON suppliers FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_agencies
    BEFORE UPDATE ON agencies FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_users
    BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_wallets
    BEFORE UPDATE ON wallets FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_markup_configs
    BEFORE UPDATE ON markup_configs FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_inventories
    BEFORE UPDATE ON inventories FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_inventory_slots
    BEFORE UPDATE ON inventory_slots FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_topup_requests
    BEFORE UPDATE ON topup_requests FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_bookings
    BEFORE UPDATE ON bookings FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

CREATE TRIGGER trg_updated_at_system_configs
    BEFORE UPDATE ON system_configs FOR EACH ROW EXECUTE FUNCTION fn_auto_updated_at();

-- ============================================================
-- TRIGGER 3: Cross-Tenant Data Validation (Topup, Booking, Claim)
-- ============================================================

CREATE OR REPLACE FUNCTION fn_validate_tenant_cross_reference()
RETURNS TRIGGER AS $$
DECLARE
    v_wallet_agency_id UUID;
    v_user_agency_id UUID;
BEGIN
    -- Validate topup_requests: wallet_id phải thuộc về agency_id
    IF TG_TABLE_NAME = 'topup_requests' THEN
        SELECT agency_id INTO v_wallet_agency_id FROM wallets WHERE id = NEW.wallet_id;
        IF v_wallet_agency_id IS DISTINCT FROM NEW.agency_id THEN
            RAISE EXCEPTION 'Tenant Violation: Topup wallet % does not belong to agency %', NEW.wallet_id, NEW.agency_id;
        END IF;
    END IF;

    -- Validate bookings: created_by user phải thuộc về agency_id
    IF TG_TABLE_NAME = 'bookings' THEN
        SELECT agency_id INTO v_user_agency_id FROM users WHERE id = NEW.created_by;
        IF v_user_agency_id IS DISTINCT FROM NEW.agency_id THEN
            RAISE EXCEPTION 'Tenant Violation: User % does not belong to agency %', NEW.created_by, NEW.agency_id;
        END IF;
    END IF;

    -- Validate claims: submitted_by user phải thuộc về agency_id
    IF TG_TABLE_NAME = 'claims' THEN
        SELECT agency_id INTO v_user_agency_id FROM users WHERE id = NEW.submitted_by;
        IF v_user_agency_id IS DISTINCT FROM NEW.agency_id THEN
            RAISE EXCEPTION 'Tenant Violation: User % does not belong to agency %', NEW.submitted_by, NEW.agency_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_topup_tenant
    BEFORE INSERT OR UPDATE ON topup_requests
    FOR EACH ROW EXECUTE FUNCTION fn_validate_tenant_cross_reference();

CREATE TRIGGER trg_validate_booking_tenant
    BEFORE INSERT OR UPDATE ON bookings
    FOR EACH ROW EXECUTE FUNCTION fn_validate_tenant_cross_reference();

CREATE TRIGGER trg_validate_claim_tenant
    BEFORE INSERT OR UPDATE ON claims
    FOR EACH ROW EXECUTE FUNCTION fn_validate_tenant_cross_reference();

-- ============================================================
-- ROW LEVEL SECURITY (RLS) — Backend-Only Access Policy
-- ============================================================
-- Default Deny All direct Supabase REST API requests for security.
-- All client interactions MUST go through ASP.NET Core Backend API.

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE agencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallet_ledgers ENABLE ROW LEVEL SECURITY;
ALTER TABLE topup_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE markup_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventories ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_passengers ENABLE ROW LEVEL SECURITY;
ALTER TABLE vouchers ENABLE ROW LEVEL SECURITY;
ALTER TABLE driver_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkin_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE fraud_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE refresh_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_configs ENABLE ROW LEVEL SECURITY;


