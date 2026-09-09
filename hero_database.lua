-- UCZONE AI Builder - Hero Database & Threat Detection
-- Comprehensive hero analysis with item recommendations per hero

local HeroDatabase = {}

-- ============================================================================
-- HERO DATABASE - Stats, Roles, and Itemization Patterns
-- ============================================================================

HeroDatabase.heroes = {
    -- CARRIES
    ["npc_dota_hero_anti_mage"] = {
        name = "Anti-Mage",
        position = "1",
        role = "carry",
        primary_attribute = "agility",
        damage_type = "physical",
        playstyle = "farm_dependent",
        item_progression = {
            early = {"power_treads", "magic_wand", "wraith_band"},
            mid = {"blink_dagger", "manta_style", "black_king_bar"},
            late = {"heart", "butterfly", "assault_cuirass"}
        },
        counters = {
            abilities = {"scythe_of_vyse", "blink_dagger", "rod_of_atos"},
            items = {"black_king_bar", "linkens_sphere"}
        },
        threats_to = {"magic_users", "immobile_heroes"},
        item_flexibility = 0.3  -- Low flexibility, very farm dependent
    },
    
    ["npc_dota_hero_phantom_assassin"] = {
        name = "Phantom Assassin",
        position = "1",
        role = "carry",
        primary_attribute = "agility",
        damage_type = "physical",
        playstyle = "burst_damage",
        item_progression = {
            early = {"power_treads", "wraith_band"},
            mid = {"blink_dagger", "black_king_bar", "monkey_king_bar"},
            late = {"butterfly", "silver_edge", "abyssal_blade"}
        },
        counters = {
            abilities = {"riki_backstab", "axe_counter_helix"},
            items = {"monkey_king_bar", "evasion_pierce"}
        },
        threats_to = {"supports", "low_armor_heroes"},
        item_flexibility = 0.5
    },
    
    ["npc_dota_hero_luna"] = {
        name = "Luna",
        position = "1",
        role = "carry",
        primary_attribute = "agility",
        damage_type = "physical",
        playstyle = "teamfight_carry",
        item_progression = {
            early = {"power_treads", "magic_wand", "wraith_band"},
            mid = {"black_king_bar", "manta_style", "dragon_lance"},
            late = {"butterfly", "assault_cuirass", "skadi"}
        },
        counters = {
            abilities = {"silences", "stuns"},
            items = {"black_king_bar", "linkens_sphere"}
        },
        threats_to = {"teamfight_dependent"},
        item_flexibility = 0.6
    },
    
    -- MIDS
    ["npc_dota_hero_invoker"] = {
        name = "Invoker",
        position = "2",
        role = "mid",
        primary_attribute = "intelligence",
        damage_type = "magical",
        playstyle = "spell_caster",
        item_progression = {
            early = {"null_talisman", "magic_wand", "boots_of_speed"},
            mid = {"blink_dagger", "force_staff", "black_king_bar"},
            late = {"aghanims_scepter", "shivas_guard", "octarine_core"}
        },
        counters = {
            abilities = {"silences", "interrupts"},
            items = {"black_king_bar", "linkens_sphere"}
        },
        threats_to = {"immobile_heroes", "teamfight"},
        item_flexibility = 0.7
    },
    
    ["npc_dota_hero_puck"] = {
        name = "Puck",
        position = "2",
        role = "mid",
        primary_attribute = "intelligence",
        damage_type = "magical",
        playstyle = "burst_mobility",
        item_progression = {
            early = {"null_talisman", "magic_wand", "phase_boots"},
            mid = {"blink_dagger", "black_king_bar", "force_staff"},
            late = {"shivas_guard", "bloodthorn", "aghanims_scepter"}
        },
        counters = {
            abilities = {"silences"},
            items = {"black_king_bar"}
        },
        threats_to = {"immobile_carries"},
        item_flexibility = 0.65
    },
    
    -- OFFLANE
    ["npc_dota_hero_timbersaw"] = {
        name = "Timbersaw",
        position = "3",
        role = "offlane",
        primary_attribute = "intelligence",
        damage_type = "physical_magical",
        playstyle = "tanky_initiate",
        item_progression = {
            early = {"ring_of_basilius", "boots_of_speed", "magic_wand"},
            mid = {"euls_scepter", "blink_dagger", "force_staff"},
            late = {"heart", "shivas_guard", "lotus_orb"}
        },
        counters = {
            abilities = {"silences", "mana_burn"},
            items = {"lotus_orb", "pipe_of_insight"}
        },
        threats_to = {"mana_dependent", "grouping_enemies"},
        item_flexibility = 0.7
    },
    
    -- SUPPORTS
    ["npc_dota_hero_earthshaker"] = {
        name = "Earthshaker",
        position = "5",
        role = "support",
        primary_attribute = "intelligence",
        damage_type = "magical",
        playstyle = "disable_support",
        item_progression = {
            early = {"magic_wand", "boots_of_speed", "urn_of_shadows"},
            mid = {"blink_dagger", "force_staff", "glimmer_cape"},
            late = {"aghanims_scepter", "force_staff", "lotus_orb"}
        },
        counters = {
            abilities = {"silences"},
            items = {"black_king_bar"}
        },
        threats_to = {"grouped_enemies", "low_hp_heroes"},
        item_flexibility = 0.8
    },
    
    ["npc_dota_hero_rubick"] = {
        name = "Rubick",
        position = "4",
        role = "support",
        primary_attribute = "intelligence",
        damage_type = "magical",
        playstyle = "utility_support",
        item_progression = {
            early = {"magic_wand", "boots_of_speed", "force_staff"},
            mid = {"force_staff", "glimmer_cape", "blink_dagger"},
            late = {"aghanims_scepter", "shivas_guard", "lotus_orb"}
        },
        counters = {
            abilities = {"high_cooldown_reliance"},
            items = {"glimmer_cape", "force_staff"}
        },
        threats_to = {"ability_dependent", "teamfight"},
        item_flexibility = 0.8
    },
}

-- ============================================================================
-- THREAT DETECTION SYSTEM
-- ============================================================================

HeroDatabase.threat_indicators = {
    -- Magic damage threats
    magic_damage = {
        heroes = {"lina", "lion", "invoker", "puck", "templar_assassin"},
        abilities = {"lina_laguna_blade", "lion_finger_of_death"},
        recommended_defense = {"pipe_of_insight", "cloak", "mage_slayer", "black_king_bar"}
    },
    
    -- Physical damage threats
    physical_damage = {
        heroes = {"luna", "anti_mage", "phantom_assassin", "drow_ranger"},
        abilities = {"drow_ranger_multishot", "luna_eclipse"},
        recommended_defense = {"platemail", "assault_cuirass", "heart", "butterfly"}
    },
    
    -- Control/Disable threats
    crowd_control = {
        heroes = {"earthshaker", "rubick", "lion", "dark_willow"},
        abilities = {"earthshaker_echo_slam", "rubick_telekinesis"},
        recommended_defense = {"black_king_bar", "linkens_sphere", "force_staff"}
    },
    
    -- Evasion threats
    evasion = {
        heroes = {"phantom_assassin", "brew_master"},
        abilities = {"phantom_assassin_blur", "brewmaster_drunken_haze"},
        recommended_defense = {"monkey_king_bar", "silver_edge"}
    },
    
    -- Armor/Resistance threats
    high_armor = {
        heroes = {"anti_mage", "bristleback", "centaur_warrunner"},
        recommended_defense = {"desolator", "assault_cuirass", "ethereal_blade"}
    },
    
    -- Mana burn threats
    mana_burn = {
        heroes = {"anti_mage", "lion"},
        abilities = {"anti_mage_mana_break"},
        recommended_defense = {"heart", "pipe_of_insight", "linkens_sphere"}
    },
    
    -- Silences
    silence_threat = {
        heroes = {"silencer", "dark_willow", "bloodseeker"},
        recommended_defense = {"black_king_bar", "linkens_sphere"}
    }
}

-- ============================================================================
-- ITEM COUNTER MATRIX
-- ============================================================================

HeroDatabase.item_counters = {
    -- Item -> What it counters
    ["black_king_bar"] = {"magic_damage", "crowd_control", "silences"},
    ["linkens_sphere"] = {"targeted_spells", "crowd_control", "single_target_abilities"},
    ["monkey_king_bar"] = {"evasion", "phantom_assassin", "brew_master"},
    ["pipe_of_insight"] = {"magic_damage", "nuke_damage", "magic_heavy_teams"},
    ["mage_slayer"] = {"magic_damage", "mana_burn", "spell_damage"},
    ["cloak"] = {"magic_damage", "magical_harassment"},
    ["force_staff"] = {"crowd_control", "catching", "initiation"},
    ["glimmer_cape"] = {"targeted_spells", "vision", "burst_damage"},
    ["desolator"] = {"high_armor", "armor_stacking"},
    ["assault_cuirass"] = {"physical_damage", "armor_stacking"},
    ["heart"] = {"burst_damage", "sustained_damage"},
    ["butterfly"] = {"physical_damage", "auto_attackers"},
    ["satanic"] = {"sustained_damage", "health_dependent"},
    ["silver_edge"] = {"evasion", "passive_abilities"},
    ["lotus_orb"] = {"targeted_spells", "team_buffs"},
    ["rod_of_atos"] = {"mobile_heroes", "escape_heroes"},
}

-- ============================================================================
-- GAME SITUATION EVALUATOR
-- ============================================================================

function HeroDatabase:evaluateTeamThreatLevel(enemy_team_analysis)
    local threat_score = {
        magic = 0,
        physical = 0,
        control = 0,
        evasion = 0,
        average = 0
    }
    
    -- Analyze each enemy hero
    for _, enemy in ipairs(enemy_team_analysis.heroes or {}) do
        local hero_data = self.heroes[enemy.name]
        if hero_data then
            if hero_data.damage_type == "magical" then
                threat_score.magic = threat_score.magic + 1
            elseif hero_data.damage_type == "physical" then
                threat_score.physical = threat_score.physical + 1
            elseif hero_data.damage_type == "physical_magical" then
                threat_score.physical = threat_score.physical + 0.5
                threat_score.magic = threat_score.magic + 0.5
            end
        end
    end
    
    threat_score.average = (threat_score.magic + threat_score.physical + threat_score.control) / 3
    return threat_score
end

function HeroDatabase:getPriorityCounterItems(threat_type, budget)
    local counters = self.threat_indicators[threat_type]
    if not counters then return {} end
    
    local items = {}
    for _, item in ipairs(counters.recommended_defense or {}) do
        table.insert(items, item)
    end
    
    return items
end

function HeroDatabase:getHeroData(hero_name)
    -- Normalize hero name
    local normalized = string.lower(hero_name)
    for key, data in pairs(self.heroes) do
        if string.find(key, normalized) then
            return data
        end
    end
    return nil
end

function HeroDatabase:shouldBuyItem(item_name, enemy_composition, player_hero)
    local counters = self.item_counters[item_name]
    if not counters then return false end
    
    -- Check if any threat is present in enemy composition
    for _, threat in ipairs(counters) do
        if self:isThreatPresent(threat, enemy_composition) then
            return true
        end
    end
    
    return false
end

function HeroDatabase:isThreatPresent(threat_type, enemy_composition)
    local threat = self.threat_indicators[threat_type]
    if not threat then return false end
    
    -- Count threat heroes
    local count = 0
    for _, enemy in ipairs(enemy_composition.heroes or {}) do
        for _, threat_hero in ipairs(threat.heroes) do
            if string.find(enemy.name, threat_hero) then
                count = count + 1
                break
            end
        end
    end
    
    return count >= 1
end

function HeroDatabase:getItemBudgetNeeded(item_name)
    -- Returns recommended gold amount before considering this item
    local budgets = {
        ["black_king_bar"] = 3900,
        ["linkens_sphere"] = 4600,
        ["monkey_king_bar"] = 4100,
        ["pipe_of_insight"] = 3395,
        ["force_staff"] = 1800,
        ["blink_dagger"] = 2250,
        ["glimmer_cape"] = 1900,
    }
    
    return budgets[item_name] or 0
end

function HeroDatabase:getItemPriority(threat_score)
    -- Returns items to prioritize based on threat analysis
    local priorities = {}
    
    if threat_score.magic > 2 then
        table.insert(priorities, "pipe_of_insight")
        table.insert(priorities, "cloak")
    end
    
    if threat_score.physical > 2 then
        table.insert(priorities, "platemail")
        table.insert(priorities, "heart")
    end
    
    if threat_score.control > 1 then
        table.insert(priorities, "black_king_bar")
        table.insert(priorities, "force_staff")
    end
    
    if threat_score.evasion > 0 then
        table.insert(priorities, "monkey_king_bar")
    end
    
    return priorities
end

-- ============================================================================
-- BUILD ADAPTATION SYSTEM
-- ============================================================================

function HeroDatabase:adaptBuildToGamePhase(base_build, game_time, game_state)
    local adapted_build = table.copy(base_build) or {}
    
    -- Early game: Prioritize survivability and early power spike
    if game_time < 1200 then
        adapted_build.phase = "early"
        adapted_build.priority = "survive_and_farm"
    
    -- Mid game: Pivot based on game state
    elseif game_time < 2400 then
        adapted_build.phase = "mid"
        if game_state.is_losing then
            adapted_build.priority = "catch_up_with_utility"
        elseif game_state.is_winning then
            adapted_build.priority = "close_out_game"
        else
            adapted_build.priority = "scale_and_control"
        end
    
    -- Late game: Focus on teamfight items
    else
        adapted_build.phase = "late"
        adapted_build.priority = "teamfight_dominance"
    end
    
    return adapted_build
end

function HeroDatabase:shouldPivotBuild(current_build, threat_score, budget)
    -- Determine if we should pivot away from original plan
    
    -- If enemy has overwhelming magic damage and we don't have defense
    if threat_score.magic > 2 and not self:hasDefenseItem(current_build, "magic") then
        return true, "magic_heavy"
    end
    
    -- If enemy has physical carries and we don't have armor
    if threat_score.physical > 2 and not self:hasDefenseItem(current_build, "physical") then
        return true, "physical_heavy"
    end
    
    -- If many controls and no BKB ready
    if threat_score.control > 1 and not self:hasDefenseItem(current_build, "control") then
        if budget >= 3900 then
            return true, "control_heavy"
        end
    end
    
    return false, nil
end

function HeroDatabase:hasDefenseItem(build, defense_type)
    if defense_type == "magic" then
        return self:itemInBuild(build, "pipe_of_insight") or 
               self:itemInBuild(build, "cloak")
    elseif defense_type == "physical" then
        return self:itemInBuild(build, "platemail") or 
               self:itemInBuild(build, "heart") or
               self:itemInBuild(build, "assault_cuirass")
    elseif defense_type == "control" then
        return self:itemInBuild(build, "black_king_bar") or 
               self:itemInBuild(build, "linkens_sphere")
    end
    return false
end

function HeroDatabase:itemInBuild(build, item_name)
    for _, phase in ipairs({"immediate", "short_term", "mid_term", "late_term"}) do
        if build[phase] then
            for _, item in ipairs(build[phase]) do
                if item == item_name then
                    return true
                end
            end
        end
    end
    return false
end

return HeroDatabase
