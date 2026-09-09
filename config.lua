-- UCZONE AI Builder - Configuration & Customization Guide
-- Modify this file to customize AI Builder behavior

local Config = {}

-- ============================================================================
-- BASIC SETTINGS
-- ============================================================================

Config.general = {
    -- Enable/disable the entire script
    enabled = true,
    
    -- How often to update recommendations (in seconds)
    update_interval = 1.0,
    
    -- Show debug information overlay
    show_debug = false,
    
    -- Chat notifications when pivots are suggested
    chat_notifications = true,
}

-- ============================================================================
-- UI & DISPLAY SETTINGS
-- ============================================================================

Config.ui = {
    -- Position of main overlay (x, y)
    overlay_position = {20, 20},
    
    -- Width of overlay box
    overlay_width = 300,
    
    -- Show threat analysis breakdown
    show_threats = true,
    
    -- Show build progression stages
    show_progression = true,
    
    -- Font size multiplier
    font_scale = 1.0,
    
    -- Transparency (0-255, where 255 is fully opaque)
    background_alpha = 200,
    border_width = 2,
}

-- ============================================================================
-- THREAT DETECTION SETTINGS
-- ============================================================================

Config.threats = {
    -- Minimum number of threats to trigger a defense recommendation
    magic_defense_threshold = 2,
    physical_defense_threshold = 2,
    control_defense_threshold = 1,
    
    -- How much weight to give to threat analysis
    threat_weight = 0.7,  -- 0-1 scale (higher = more important)
}

-- ============================================================================
-- BUILD ADAPTATION SETTINGS
-- ============================================================================

Config.builds = {
    -- Allow pivoting from original build
    allow_pivots = true,
    
    -- Pivot aggressiveness (0.3 = conservative, 1.0 = aggressive)
    pivot_aggressiveness = 0.7,
    
    -- Consider game state (winning/losing)
    consider_game_state = true,
    
    -- Auto-counter enemy picks
    auto_counter = true,
    
    -- Minimum kill difference to trigger losing/winning mode
    win_loss_threshold = 3,
}

-- ============================================================================
-- GAME PHASE SETTINGS
-- ============================================================================

Config.phases = {
    -- Game time thresholds (in seconds)
    early_game_end = 1200,    -- 20 minutes
    mid_game_end = 2400,      -- 40 minutes
    
    -- Early game priorities
    early = {
        survival_weight = 0.7,  -- 70% focus on survival
        power_spike_weight = 0.3,
    },
    
    -- Mid game priorities
    mid = {
        adaptation_weight = 0.8,  -- Heavy adaptation to game state
        hero_progression_weight = 0.2,
    },
    
    -- Late game priorities
    late = {
        teamfight_weight = 0.9,
        scaling_weight = 0.1,
    }
}

-- ============================================================================
-- HERO CUSTOMIZATION
-- ============================================================================

Config.hero_overrides = {
    -- Override hero data here if needed
    -- Format: ["npc_dota_hero_name"] = { modified_data }
    
    -- Example: Custom build for Anti-Mage
    -- ["npc_dota_hero_anti_mage"] = {
    --     item_progression = {
    --         early = {"power_treads", "magic_wand"},
    --         mid = {"blink_dagger", "manta_style"},
    --         late = {"heart", "butterfly"}
    --     }
    -- }
}

-- ============================================================================
-- ITEM PREFERENCES
-- ============================================================================

Config.items = {
    -- Custom item priority (higher = more priority)
    priorities = {
        ["black_king_bar"] = 10,      -- Highest priority for survival
        ["force_staff"] = 8,
        ["heart"] = 7,
        ["blink_dagger"] = 6,
        ["butterfly"] = 5,
    },
    
    -- Items to never recommend
    blacklist = {
        -- "some_item_you_dont_like"
    },
    
    -- Items to always try to get early
    must_have_early = {
        "power_treads",
        "magic_wand",
    }
}

-- ============================================================================
-- LOGGING & DEBUG
-- ============================================================================

Config.logging = {
    -- Enable detailed logging
    enabled = false,
    
    -- Log file path (relative to cheat directory)
    log_file = "logs/ai_builder.log",
    
    -- Log level: "debug", "info", "warning", "error"
    level = "info",
}

-- ============================================================================
-- ADVANCED OPTIONS
-- ============================================================================

Config.advanced = {
    -- Calculate threat scores in real-time
    realtime_threat_calculation = true,
    
    -- Consider ability cooldowns in recommendations
    consider_cooldowns = true,
    
    -- Factor in hero level progression
    level_aware_recommendations = true,
    
    -- Use custom algorithm weights (advanced)
    algorithm_weights = {
        threat_factor = 0.4,
        game_state_factor = 0.3,
        hero_role_factor = 0.2,
        phase_factor = 0.1,
    }
}

-- ============================================================================
-- QUICK PRESETS
-- ============================================================================

-- Preset: Conservative (Less aggressive pivoting)
Config.presets = {
    conservative = {
        pivot_aggressiveness = 0.4,
        threat_weight = 0.5,
        update_interval = 2.0,
    },
    
    -- Preset: Balanced (Default)
    balanced = {
        pivot_aggressiveness = 0.7,
        threat_weight = 0.7,
        update_interval = 1.0,
    },
    
    -- Preset: Aggressive (Quick adaptation)
    aggressive = {
        pivot_aggressiveness = 1.0,
        threat_weight = 0.9,
        update_interval = 0.5,
    },
    
    -- Preset: Meta-Focused (Follow meta builds strictly)
    meta_focused = {
        allow_pivots = false,
        auto_counter = true,
        pivot_aggressiveness = 0.3,
    },
    
    -- Preset: Situation-First (Heavily adapt to game situation)
    situation_first = {
        allow_pivots = true,
        consider_game_state = true,
        pivot_aggressiveness = 1.0,
    }
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

function Config:ApplyPreset(preset_name)
    local preset = self.presets[preset_name]
    if not preset then
        print("[AI Builder] Unknown preset: " .. preset_name)
        return false
    end
    
    -- Merge preset into current config
    for key, value in pairs(preset) do
        if self.general[key] then
            self.general[key] = value
        elseif self.builds[key] then
            self.builds[key] = value
        end
    end
    
    print("[AI Builder] Applied preset: " .. preset_name)
    return true
end

function Config:ResetToDefault()
    -- Reset all settings to defaults
    self.general.enabled = true
    self.general.update_interval = 1.0
    self.general.show_debug = false
    self.builds.pivot_aggressiveness = 0.7
    print("[AI Builder] Reset to default configuration")
end

function Config:GetSetting(category, key)
    if self[category] and self[category][key] then
        return self[category][key]
    end
    return nil
end

function Config:SetSetting(category, key, value)
    if self[category] then
        self[category][key] = value
        return true
    end
    return false
end

return Config
