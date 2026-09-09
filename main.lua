-- UCZONE AI Builder - Main Integration Script
-- Complete implementation with menu UI and real-time recommendations

local AIBuilder = require("ai_builder")
local HeroDatabase = require("hero_database")

-- ============================================================================
-- INITIALIZATION & STATE
-- ============================================================================

local BuilderState = {
    enabled = true,
    current_recommendation = nil,
    last_update = 0,
    update_interval = 1.0,  -- Update every 1 second
    menu_tab = nil,
    show_debug = false,
}

-- ============================================================================
-- MENU CREATION
-- ============================================================================

function createMenu()
    if BuilderState.menu_tab then
        return BuilderState.menu_tab
    end
    
    -- Create main tab
    local main_tab = Menu.Create("AI Builder", "ai_builder_main")
    
    -- General Settings
    local settings = main_tab:Create("Settings")
    settings:Switch("Enabled", "ai_builder_enabled", true):SetCallback(function(val)
        BuilderState.enabled = val
    end)
    
    settings:Switch("Show Debug Info", "ai_builder_debug", false):SetCallback(function(val)
        BuilderState.show_debug = val
    end)
    
    settings:Slider("Update Interval (s)", "ai_builder_update_interval", 0.5, 5, 1, 0.5):SetCallback(function(val)
        BuilderState.update_interval = val
    end)
    
    -- Current Recommendation Section
    local recommendations = main_tab:Create("Build Recommendations")
    recommendations:Label("Next Item to Buy:")
    recommendations:Label("Reason:")
    recommendations:Label("Game Phase:")
    recommendations:Label("Game State:")
    
    -- Threat Analysis Section
    local threats = main_tab:Create("Enemy Threats")
    threats:Label("Magic Damage Threat:")
    threats:Label("Physical Damage Threat:")
    threats:Label("Control Threat:")
    threats:Label("Evasion Threat:")
    
    -- Build Progression Section
    local progression = main_tab:Create("Build Progression")
    progression:Label("Early Game Items:")
    progression:Label("Mid Game Items:")
    progression:Label("Late Game Items:")
    
    -- Advanced Settings
    local advanced = main_tab:Create("Advanced Options")
    advanced:Switch("Auto-Counter Enemy Picks", "ai_builder_auto_counter", true)
    advanced:Switch("Adaptive Build Order", "ai_builder_adaptive", true)
    advanced:Switch("Consider Game State", "ai_builder_game_state", true)
    advanced:Switch("Suggest Item Pivots", "ai_builder_pivots", true)
    
    BuilderState.menu_tab = main_tab
    return main_tab
end

-- ============================================================================
-- CORE RECOMMENDATION ENGINE
-- ============================================================================

function generateAdvancedRecommendation()
    if not Engine.IsInGame() then
        return nil
    end
    
    local player = Players.GetLocal()
    if not player then return nil end
    
    local hero = player:GetAssignedHero()
    if not hero then return nil end
    
    -- Get game state
    local game_state = AIBuilder:analyzeGameState()
    if not game_state then return nil end
    
    -- Get enemy composition
    local enemy_analysis = AIBuilder:analyzeEnemyTeam()
    if not enemy_analysis then return nil end
    
    -- Evaluate threats
    local threat_score = HeroDatabase:evaluateTeamThreatLevel(enemy_analysis)
    
    -- Get hero data
    local hero_data = HeroDatabase:getHeroData(game_state.hero_name)
    if not hero_data then
        return AIBuilder:generateBuildRecommendation()  -- Fallback to basic
    end
    
    -- ========================================================================
    -- PHASE-BASED BUILD DECISION LOGIC
    -- ========================================================================
    
    local recommendation = {
        immediate = {},
        short_term = {},
        mid_term = {},
        late_term = {},
        reasoning = "",
        threat_analysis = threat_score,
        game_phase = game_state.phase,
        pivot_suggested = false,
    }
    
    -- ========================================================================
    -- EARLY GAME (0-1200s)
    -- ========================================================================
    if game_state.phase == "early" then
        -- Priority: Get boots and early survivability
        table.insert(recommendation.immediate, "power_treads")
        
        -- Check for early threats
        if threat_score.magic > 1 then
            table.insert(recommendation.immediate, "magic_wand")
            recommendation.reasoning = "Enemy team has magic damage - get early defense"
        else
            table.insert(recommendation.immediate, "wraith_band")
            recommendation.reasoning = "Standard early game stat item for survivability"
        end
        
        -- Item recommendations for early game based on hero
        if hero_data.item_progression and hero_data.item_progression.early then
            for _, item in ipairs(hero_data.item_progression.early) do
                if not tableContains(recommendation.immediate, item) then
                    table.insert(recommendation.short_term, item)
                end
            end
        end
    
    -- ========================================================================
    -- MID GAME (1200-2400s) - CRITICAL DECISION POINT
    -- ========================================================================
    elseif game_state.phase == "mid" then
        local should_pivot, pivot_reason = HeroDatabase:shouldPivotBuild(
            hero_data.item_progression.mid,
            threat_score,
            game_state.current_gold
        )
        
        -- LOSING SCENARIO
        if game_state.is_losing then
            recommendation.reasoning = "Team is losing - prioritizing survival and catch-up items"
            recommendation.pivot_suggested = true
            
            if threat_score.control > 1 then
                table.insert(recommendation.immediate, "black_king_bar")
            elseif threat_score.magic > 2 then
                table.insert(recommendation.immediate, "pipe_of_insight")
            else
                table.insert(recommendation.immediate, "force_staff")
            end
            
            table.insert(recommendation.short_term, "heart")
        
        -- WINNING SCENARIO
        elseif game_state.is_winning then
            recommendation.reasoning = "Team is winning - leverage advantage with mobility and utility"
            
            if tableContains(hero_data.item_progression.mid, "blink_dagger") then
                table.insert(recommendation.immediate, "blink_dagger")
            else
                table.insert(recommendation.immediate, "force_staff")
            end
            
            -- Add offensive mid-game items
            if hero_data.playstyle == "burst_damage" then
                table.insert(recommendation.short_term, "black_king_bar")
            else
                table.insert(recommendation.short_term, "manta_style")
            end
        
        -- NEUTRAL GAME STATE
        else
            recommendation.reasoning = "Even game - scaling based on hero role and threats"
            
            -- Standard mid-game progression
            if hero_data.item_progression and hero_data.item_progression.mid then
                for i, item in ipairs(hero_data.item_progression.mid) do
                    if i == 1 then
                        table.insert(recommendation.immediate, item)
                    elseif i <= 3 then
                        table.insert(recommendation.short_term, item)
                    end
                end
            end
        end
        
        -- THREAT-BASED PIVOTING
        if should_pivot then
            recommendation.pivot_suggested = true
            recommendation.reasoning = recommendation.reasoning .. " (PIVOT: " .. pivot_reason .. ")"
            
            local pivot_items = HeroDatabase:getItemPriority(threat_score)
            if #pivot_items > 0 then
                recommendation.immediate = {pivot_items[1]}
                recommendation.short_term = pivot_items
            end
        end
        
        -- Counter evasion if needed
        if threat_score.evasion > 0 and game_state.current_gold >= 4100 then
            if not tableContains(recommendation.short_term, "monkey_king_bar") then
                table.insert(recommendation.mid_term, "monkey_king_bar")
            end
        end
    
    -- ========================================================================
    -- LATE GAME (2400s+)
    -- ========================================================================
    else
        recommendation.reasoning = "Late game - maximize teamfight impact and durability"
        
        -- Core late game survivability
        if not hero:HasModifier("modifier_black_king_bar_immune") then
            if game_state.current_gold >= 3900 then
                table.insert(recommendation.immediate, "black_king_bar")
            end
        end
        
        -- Standard late game progression
        if hero_data.item_progression and hero_data.item_progression.late then
            for i, item in ipairs(hero_data.item_progression.late) do
                if i == 1 and #recommendation.immediate == 0 then
                    table.insert(recommendation.immediate, item)
                else
                    table.insert(recommendation.late_term, item)
                end
            end
        else
            -- Fallback late game items
            table.insert(recommendation.late_term, "heart")
            table.insert(recommendation.late_term, "assault_cuirass")
            table.insert(recommendation.late_term, "butterfly")
        end
    end
    
    return recommendation
end

function tableContains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then return true end
    end
    return false
end

-- ============================================================================
-- RENDERING SYSTEM
-- ============================================================================

function renderBuildOverlay()
    if not BuilderState.enabled or not BuilderState.current_recommendation then
        return
    end
    
    local screen_w, screen_h = Renderer.GetScreenSize()
    local x, y = 20, 20
    local line_height = 18
    local box_width = 300
    
    -- Background panel
    Renderer.SetDrawColor(0, 0, 0, 200)
    Renderer.DrawFilledRect(x, y, x + box_width, y + 200, 5)
    
    Renderer.SetDrawColor(255, 255, 0, 255)
    Renderer.DrawOutlineRect(x, y, x + box_width, y + 200, 2)
    
    -- Title
    Renderer.SetDrawColor(255, 255, 0, 255)
    Renderer.DrawText(x + 10, y + 5, "=== AI BUILDER ===", nil, 0)
    y = y + line_height + 5
    
    local recommendation = BuilderState.current_recommendation
    
    -- Phase indicator
    local phase_color = {early = {100, 255, 100}, mid = {255, 200, 100}, late = {255, 100, 100}}
    local phase_clr = phase_color[recommendation.game_phase] or {200, 200, 200}
    Renderer.SetDrawColor(phase_clr[1], phase_clr[2], phase_clr[3], 255)
    Renderer.DrawText(x + 10, y, "[" .. string.upper(recommendation.game_phase) .. " GAME]", nil, 0)
    y = y + line_height
    
    -- Immediate recommendation (MOST IMPORTANT)
    if recommendation.immediate and #recommendation.immediate > 0 then
        Renderer.SetDrawColor(0, 255, 0, 255)
        Renderer.DrawText(x + 10, y, "NEXT: " .. recommendation.immediate[1], nil, 0)
        y = y + line_height
    end
    
    -- Pivot warning
    if recommendation.pivot_suggested then
        Renderer.SetDrawColor(255, 0, 0, 255)
        Renderer.DrawText(x + 10, y, "⚠ BUILD PIVOT SUGGESTED", nil, 0)
        y = y + line_height
    end
    
    -- Reasoning
    if recommendation.reasoning ~= "" then
        Renderer.SetDrawColor(200, 200, 200, 255)
        local reason_short = string.sub(recommendation.reasoning, 1, 40)
        Renderer.DrawText(x + 10, y, reason_short, nil, 0)
        y = y + line_height
    end
    
    -- Threat levels
    Renderer.SetDrawColor(255, 100, 100, 255)
    local threats = recommendation.threat_analysis
    Renderer.DrawText(x + 10, y, "Threats: M:" .. math.floor(threats.magic) .. " P:" .. math.floor(threats.physical), nil, 0)
end

function renderDebugInfo()
    if not BuilderState.show_debug then return end
    
    local screen_w, screen_h = Renderer.GetScreenSize()
    local x, y = screen_w - 250, 20
    
    if not BuilderState.current_recommendation then return end
    
    local rec = BuilderState.current_recommendation
    
    Renderer.SetDrawColor(100, 100, 200, 200)
    Renderer.DrawFilledRect(x, y, screen_w - 10, y + 150)
    
    Renderer.SetDrawColor(255, 255, 255, 255)
    Renderer.DrawText(x + 10, y + 5, "DEBUG INFO", nil, 0)
    
    y = y + 20
    Renderer.DrawText(x + 10, y, "Phase: " .. rec.game_phase, nil, 0)
    y = y + 15
    
    if rec.immediate and #rec.immediate > 0 then
        Renderer.DrawText(x + 10, y, "Immediate: " .. rec.immediate[1], nil, 0)
        y = y + 15
    end
    
    Renderer.SetDrawColor(200, 200, 200, 255)
    Renderer.DrawText(x + 10, y, "Last Update: " .. os.time() - BuilderState.last_update .. "s ago", nil, 0)
end

-- ============================================================================
-- CALLBACKS
-- ============================================================================

function onDraw()
    if not BuilderState.enabled then return end
    
    -- Update recommendations periodically
    local current_time = os.time()
    if current_time - BuilderState.last_update > BuilderState.update_interval then
        BuilderState.current_recommendation = generateAdvancedRecommendation()
        BuilderState.last_update = current_time
    end
    
    -- Render overlays
    renderBuildOverlay()
    renderDebugInfo()
end

function onScriptsLoaded()
    createMenu()
    Chat.Print("[AI Builder] Loaded successfully! Type /ai_builder for settings")
end

-- ============================================================================
-- SCRIPT ENTRY POINT
-- ============================================================================

return {
    OnScriptsLoaded = onScriptsLoaded,
    OnDraw = onDraw,
}
