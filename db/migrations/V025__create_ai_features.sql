-- ============================================================================
-- MIGRATION V025: CREATE AI FEATURES SCHEMA (4 CORE AI MODULES)
-- Description: Tables for AI Itinerary Drafts, Demand Forecasts, TextToSql Logs, and Marketing Kits
-- ============================================================================

-- 1. Enum Types for AI Module
CREATE TYPE ai_conversation_type AS ENUM ('ITINERARY_COPILOT', 'TEXT_TO_SQL', 'MARKETING_GEN', 'DEMAND_FORECAST');

-- 2. AI Conversations Log Table
CREATE TABLE ai_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    conversation_type ai_conversation_type NOT NULL,
    prompt_text TEXT NOT NULL,
    response_json JSONB NOT NULL,
    tokens_used INT NOT NULL DEFAULT 0,
    execution_time_ms INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. AI Itinerary Drafts (Combo Co-Pilot - Feature 1)
CREATE TABLE ai_itinerary_drafts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agency_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    created_by_user_id UUID NOT NULL REFERENCES users(id),
    prompt_summary TEXT NOT NULL,
    destination VARCHAR(100) NOT NULL,
    duration_days INT NOT NULL,
    pax_count INT NOT NULL,
    total_wholesale_price NUMERIC(18,2) NOT NULL,
    suggested_retail_price NUMERIC(18,2) NOT NULL,
    margin_amount NUMERIC(18,2) NOT NULL,
    proposal_pdf_url TEXT,
    hold_expires_at TIMESTAMPTZ NOT NULL,
    is_converted_to_booking BOOLEAN NOT NULL DEFAULT FALSE,
    itinerary_data JSONB NOT NULL, -- Full JSON structure of daily items
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. AI Dynamic Pricing & Demand Forecasts (Yield Management - Feature 2)
CREATE TABLE ai_demand_forecasts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    product_id UUID NOT NULL,
    forecast_period_start DATE NOT NULL,
    forecast_period_end DATE NOT NULL,
    predicted_demand_increase_pct NUMERIC(5,2) NOT NULL, -- e.g. 250.00%
    recommended_price_change_pct NUMERIC(5,2) NOT NULL, -- e.g. +15.00%
    current_wholesale_price NUMERIC(18,2) NOT NULL,
    recommended_wholesale_price NUMERIC(18,2) NOT NULL,
    reasoning_text TEXT NOT NULL,
    is_applied BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. AI Marketing Kits (Feature 5)
CREATE TABLE ai_marketing_kits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agency_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    product_type VARCHAR(50) NOT NULL, -- Tour, Hotel
    product_id UUID NOT NULL,
    facebook_copy TEXT NOT NULL,
    zalo_copy TEXT NOT NULL,
    tiktok_script TEXT NOT NULL,
    generated_banner_url TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Indexes for High-Performance Querying
CREATE INDEX idx_ai_conversations_tenant ON ai_conversations(tenant_id, created_at DESC);
CREATE INDEX idx_ai_itinerary_agency ON ai_itinerary_drafts(agency_id, created_at DESC);
CREATE INDEX idx_ai_forecasts_supplier ON ai_demand_forecasts(supplier_id, forecast_period_start);
CREATE INDEX idx_ai_marketing_agency ON ai_marketing_kits(agency_id, created_at DESC);

-- Ghi chú xác nhận hoàn thành
COMMENT ON TABLE ai_itinerary_drafts IS 'Lưu trữ các phương án Combo du lịch được sinh tự động bởi AI Co-Pilot';
COMMENT ON TABLE ai_demand_forecasts IS 'Lưu trữ gợi ý tối ưu giá sỉ và dự báo nhu cầu cho Supplier';
COMMENT ON TABLE ai_marketing_kits IS 'Lưu trữ bộ Content & Banner Marketing tự động cho Đại lý';
