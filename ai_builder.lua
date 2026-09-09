-- UCZONE AI Builder - Core System
-- Situation-aware, meta-based item builder for Dota 2

local AIBuilder = {}
AIBuilder.version = "1.0.0"

-- ============================================================================
-- CONFIGURATION & META DATA
-- ============================================================================

AIBuilder.meta = {
    patch = "7.37",
    timestamp = os.time(),
    
    -- Hero position pool
    positions = {
        ["1"] = "Carry",
        ["2"] = "Mid",
        ["3"] = "Offlane",
        ["4"] = "Soft Support",
        ["5"] = "Hard Support"
    },
    
    -- Current meta trending heroes per position
    trending_heroes = {
        carry = {"Anti-Mage", "Luna", "Phantom Assassin", "Terrorblade", "Medusa"},
        mid = {"Invoker", "Puck", "Ember Spirit", "Storm Spirit", "Templar Assassin"},
        offlane = {"Timbersaw", "Underlord", "Dark Seer", "Legion Commander", "Bristleback"},
        support = {"Earthshaker", "Rubick", "Lion", "Grimstroke", "Enchantress"}
    }
}

-- ============================================================================
-- ITEM CATEGORIZATION & STATS
-- ============================================================================

AIBuilder.items = {
    -- Damage/Utility Items
    carry_core = {
        ["boots_of_speed"] = {name = "Boots of Speed", cost = 500, priority = 1},
        ["power_treads"] = {name = "Power Treads", cost = 1400, priority = 2},
        ["phase_boots"] = {name = "Phase Boots", cost = 1500, priority = 2},
        ["hand_of_midas"] = {name = "Hand of Midas", cost = 2700, priority = 2, early_game = true},
        ["blink_dagger"] = {name = "Blink Dagger", cost = 2250, priority = 3, mobility = true},
        ["magic_wand"] = {name = "Magic Wand", cost = 450, priority = 1},
        ["soul_ring"] = {name = "Soul Ring", cost = 610, priority = 1},
        ["wraith_band"] = {name = "Wraith Band", cost = 505, priority = 1},
        ["null_talisman"] = {name = "Null Talisman", cost = 500, priority = 1},
        ["bracer"] = {name = "Bracer", cost = 505, priority = 1},
    },
    
    -- Survivability
    defense = {
        ["black_king_bar"] = {name = "Black King Bar", cost = 3900, priority = 5, magic_immunity = true},
        ["linkens_sphere"] = {name = "Linken's Sphere", cost = 4600, priority = 5, spell_block = true},
        ["mage_slayer"] = {name = "Mage Slayer", cost = 2000, priority = 3},
        ["pipe_of_insight"] = {name = "Pipe of Insight", cost = 3395, priority = 4, magic_defense = true},
        ["dragon_lance"] = {name = "Dragon Lance", cost = 1900, priority = 3},
        ["platemail"] = {name = "Platemail", cost = 1500, priority = 3},
        ["cloak"] = {name = "Cloak", cost = 1100, priority = 2},
    },
    
    -- Utility/Control
    utility = {
        ["force_staff"] = {name = "Force Staff", cost = 1800, priority = 3, utility = true},
        ["hurricane_pike"] = {name = "Hurricane Pike", cost = 4200, priority = 4, utility = true},
        ["rod_of_atos"] = {name = "Rod of Atos", cost = 3100, priority = 3, control = true},
        ["lotus_orb"] = {name = "Lotus Orb", cost = 2750, priority = 3, utility = true},
        ["glimmer_cape"] = {name = "Glimmer Cape", cost = 1900, priority = 3, support = true},
        ["urn_of_shadows"] = {name = "Urn of Shadows", cost = 880, priority = 2},
    },
    
    -- Damage
    damage = {
        ["dagon"] = {name = "Dagon", cost = 2700, priority = 3, burst = true},
        ["ethereal_blade"] = {name = "Ethereal Blade", cost = 4650, priority = 4, burst = true},
        ["desolator"] = {name = "Desolator", cost = 3500, priority = 4},
        ["monkey_king_bar"] = {name = "Monkey King Bar", cost = 4100, priority = 4, evasion_pierce = true},
        ["silver_edge"] = {name = "Silver Edge", cost = 6000, priority = 5},
        ["basher"] = {name = "Basher", cost = 2900, priority = 3},
        ["butterfly"] = {name = "Butterfly", cost = 5000, priority = 5},
    },
    
    -- Late Game
    late_game = {
        ["assault_cuirass"] = {name = "Assault Cuirass", cost = 5675, priority = 5},
        ["shivas_guard"] = {name = "Shiva's Guard", cost = 4800, priority = 5},
        ["heart"] = {name = "Heart of Tarrasque", cost = 5500, priority = 5},
        ["satanic"] = {name = "Satanic", cost = 5000, priority = 5},
        ["bloodthorn"] = {name = "Bloodthorn", cost = 9050, priority = 5},
    }
}

-- ============================================================================
-- THREAT ANALYSIS SYSTEM
-- ============================================================================

AIBuilder.threats = {
    -- Threat types and counters
    magic_heavy = {
        threat_type = "magical_damage",
        indicators = {"burst_mage", "nuke_damage", "magic_caster"},
        counters = {"black_king_bar", "pipe_of_insight", "cloak", "mage_slayer"}
    },
    
    physical_heavy = {
        threat_type = "physical_damage",
        indicators = {"carries", "auto_attack", "physical_damage"},
        counters = {"platemail", "assault_cuirass", "heart", "butterfly"}
    },
    
    control_heavy = {
        threat_type = "crowd_control",
        indicators = {"stuns", "disables", "slows"},
        counters = {"black_king_bar", "linkens_sphere", "force_staff", "rod_of_atos"}
    },
    
    evasion = {
        threat_type = "evasion",
        indicators = {"phantom_assassin", "butterfly", "shade"},
        counters = {"monkey_king_bar", "silver_edge"}
    }
}

-- ============================================================================
-- GAME STATE ANALYZER
-- ============================================================================

function AIBuilder:analyzeGameState()
    if not Engine.IsInGame() then
        return nil
    end
    
    local player = Players.GetLocal()
    if not player then return nil end
    
    local hero = player:GetAssignedHero()
    if not hero then return nil end
    
    local game_time = GameRules.GetGameTime()
    local player_team = hero:GetTeamNum()
    
    -- Determine game phase
    local game_phase = "early"
    if game_time > 1200 then game_phase = "mid" end
    if game_time > 2400 then game_phase = "late" end
    
    local state = {
        time = game_time,
        phase = game_phase,
        hero_name = hero:GetUnitName(),
        hero_level = hero:GetCurrentLevel(),
        current_gold = player:GetTotalGold(),
        player_id = player:GetPlayerID(),
        team = player_team,
        is_losing = self:isTeamLosing(player_team),
        is_winning = self:isTeamWinning(player_team),
    }
    
    return state
end

function AIBuilder:isTeamLosing(team)
    local team_kills = 0
    local enemy_kills = 0
    
    for i = 0, Players.Count() - 1 do
        local p = Players.Get(i)
        if p then
            local data = p:GetPlayerData()
            if data then
                if p:GetTeamNum() == team then
                    team_kills = team_kills + (data.kills or 0)
                else
                    enemy_kills = enemy_kills + (data.kills or 0)
                end
            end
        end
    end
    
    return enemy_kills > team_kills + 3
end

function AIBuilder:isTeamWinning(team)
    local team_kills = 0
    local enemy_kills = 0
    
    for i = 0, Players.Count() - 1 do
        local p = Players.Get(i)
        if p then
            local data = p:GetPlayerData()
            if data then
                if p:GetTeamNum() == team then
                    team_kills = team_kills + (data.kills or 0)
                else
                    enemy_kills = enemy_kills + (data.kills or 0)
                end
            end
        end
    end
    
    return team_kills > enemy_kills + 3
end

-- ============================================================================
-- ENEMY COMPOSITION ANALYZER
-- ============================================================================

function AIBuilder:analyzeEnemyTeam()
    local player = Players.GetLocal()
    if not player then return nil end
    
    local hero = player:GetAssignedHero()
    if not hero then return nil end
    
    local player_team = hero:GetTeamNum()
    local enemy_team = (player_team == 2) and 3 or 2
    
    local analysis = {
        total_heroes = 0,
        damage_types = {magic = 0, physical = 0, pure = 0},
        control_threats = 0,
        evasion_heroes = 0,
        heroes = {}
    }
    
    for i = 0, Players.Count() - 1 do
        local p = Players.Get(i)
        if p and p:GetTeamNum() == enemy_team then
            local assigned_hero = p:GetAssignedHero()
            if assigned_hero and assigned_hero:IsAlive() then
                analysis.total_heroes = analysis.total_heroes + 1
                
                -- Analyze hero threats
                local hero_name = assigned_hero:GetUnitName()
                table.insert(analysis.heroes, {
                    name = hero_name,
                    level = assigned_hero:GetCurrentLevel(),
                })
                
                -- Categorize threat type (simplified)
                if self:heroHasMagicDamage(assigned_hero) then
                    analysis.damage_types.magic = analysis.damage_types.magic + 1
                end
                
                if self:heroHasControl(assigned_hero) then
                    analysis.control_threats = analysis.control_threats + 1
                end
                
                if self:heroHasEvasion(assigned_hero) then
                    analysis.evasion_heroes = analysis.evasion_heroes + 1
                end
            end
        end
    end
    
    return analysis
end

function AIBuilder:heroHasMagicDamage(hero)
    -- Check hero's primary ability for magic damage
    local ability = hero:GetAbilityByIndex(0)
    if ability then
        return ability:GetDamageType() == 1 -- DAMAGE_TYPE_MAGICAL
    end
    return false
end

function AIBuilder:heroHasControl(hero)
    -- Check for disable/control abilities
    for i = 0, 23 do
        local ability = hero:GetAbilityByIndex(i)
        if ability and not ability:IsPassive() then
            local behavior = ability:GetBehavior()
            -- Check if ability has targeting (likely a control ability)
            if ability:GetTargetType() ~= 0 then
                return true
            end
        end
    end
    return false
end

function AIBuilder:heroHasEvasion(hero)
    -- Check for evasion modifiers or items
    return hero:HasModifier("modifier_phantom_assassin_blur") or 
           hero:HasItem("butterfly") or
           hero:HasItem("shade")
end

-- ============================================================================
-- CORE AI BUILDER LOGIC
-- ============================================================================

function AIBuilder:generateBuildRecommendation()
    local game_state = self:analyzeGameState()
    if not game_state then return nil end
    
    local enemy_analysis = self:analyzeEnemyTeam()
    if not enemy_analysis then return nil end
    
    local recommendations = {
        immediate = {},  -- Buy next
        short_term = {},  -- Next 2-3 items
        mid_term = {},   -- Mid game items
        late_term = {},  -- Late game items
        reasoning = ""
    }
    
    -- PHASE 1: Early game decisions
    if game_state.phase == "early" then
        recommendations = self:buildEarlyGame(game_state, enemy_analysis)
    
    -- PHASE 2: Mid game pivoting
    elseif game_state.phase == "mid" then
        recommendations = self:buildMidGame(game_state, enemy_analysis)
    
    -- PHASE 3: Late game scaling
    else
        recommendations = self:buildLateGame(game_state, enemy_analysis)
    end
    
    return recommendations
end

function AIBuilder:buildEarlyGame(game_state, enemy_analysis)
    local recs = {
        immediate = {},
        short_term = {},
        reasoning = ""
    }
    
    -- Priority: Get to safe farm -> Early power spike item
    
    -- Check if we need early survivability
    if enemy_analysis.control_threats >= 2 then
        table.insert(recs.immediate, "magic_wand")
        recs.reasoning = "Enemy team has multiple control abilities - need survivability"
    else
        table.insert(recs.immediate, "wraith_band")
        recs.reasoning = "Standard early game stat item"
    end
    
    -- Always need boots
    table.insert(recs.short_term, "power_treads")
    
    -- If enemy has high magic damage, get cloak early
    if enemy_analysis.damage_types.magic >= 2 then
        table.insert(recs.short_term, "cloak")
    end
    
    return recs
end

function AIBuilder:buildMidGame(game_state, enemy_analysis)
    local recs = {
        immediate = {},
        short_term = {},
        mid_term = {},
        reasoning = ""
    }
    
    -- Mid game is about pivoting based on game state
    
    -- If losing, prioritize survivability
    if game_state.is_losing then
        table.insert(recs.immediate, "black_king_bar")
        recs.reasoning = "Team is losing - need BKB to survive and farm safely"
    
    -- If winning, prioritize damage/utility
    elseif game_state.is_winning then
        table.insert(recs.immediate, "blink_dagger")
        recs.reasoning = "Team is winning - get Blink for positioning advantage"
    
    -- Normal game progression
    else
        table.insert(recs.immediate, "force_staff")
        recs.reasoning = "Neutral game state - Force Staff provides utility and survivability"
    end
    
    -- Counter evasion if needed
    if enemy_analysis.evasion_heroes > 0 then
        table.insert(recs.short_term, "monkey_king_bar")
    end
    
    -- Counter magic if needed
    if enemy_analysis.damage_types.magic >= 3 then
        table.insert(recs.mid_term, "pipe_of_insight")
    end
    
    return recs
end

function AIBuilder:buildLateGame(game_state, enemy_analysis)
    local recs = {
        immediate = {},
        short_term = {},
        late_term = {},
        reasoning = ""
    }
    
    -- Late game: Maximize impact and scaling
    
    table.insert(recs.immediate, "black_king_bar")
    table.insert(recs.short_term, "heart")
    table.insert(recs.late_term, "assault_cuirass")
    
    recs.reasoning = "Late game - BKB for immunity, Heart for durability, AC for sustained damage"
    
    return recs
end

-- ============================================================================
-- CALLBACK: OnDraw (Main Loop)
-- ============================================================================

function AIBuilder:onDraw()
    if not Engine.IsInGame() then return end
    
    local player = Players.GetLocal()
    if not player then return end
    
    local hero = player:GetAssignedHero()
    if not hero then return end
    
    -- Generate recommendations
    local build = self:generateBuildRecommendation()
    if not build then return end
    
    -- Display on screen
    self:renderBuildUI(build)
end

function AIBuilder:renderBuildUI(build)
    local screen_w, screen_h = Renderer.GetScreenSize()
    local x, y = 20, 20
    local line_height = 20
    
    -- Title
    Renderer.SetDrawColor(255, 255, 0, 255)
    Renderer.DrawText(x, y, "=== AI BUILDER ===", nil, 0)
    y = y + line_height
    
    -- Immediate recommendation
    if build.immediate and #build.immediate > 0 then
        Renderer.SetDrawColor(0, 255, 0, 255)
        Renderer.DrawText(x, y, "NEXT: " .. table.concat(build.immediate, ", "), nil, 0)
        y = y + line_height
    end
    
    -- Short term
    if build.short_term and #build.short_term > 0 then
        Renderer.SetDrawColor(255, 165, 0, 255)
        Renderer.DrawText(x, y, "BUILD: " .. table.concat(build.short_term, ", "), nil, 0)
        y = y + line_height
    end
    
    -- Reasoning
    if build.reasoning ~= "" then
        Renderer.SetDrawColor(200, 200, 200, 255)
        Renderer.DrawText(x, y, "REASON: " .. build.reasoning, nil, 0)
        y = y + line_height
    end
end

-- ============================================================================
-- REGISTER CALLBACKS
-- ============================================================================

return AIBuilder
