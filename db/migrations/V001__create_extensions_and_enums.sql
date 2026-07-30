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
