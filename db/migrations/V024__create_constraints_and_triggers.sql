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
