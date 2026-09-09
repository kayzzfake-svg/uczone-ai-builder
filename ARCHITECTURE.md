# AI Builder - Technical Architecture & Implementation

Complete technical documentation for developers and advanced users.

---

## 🏗️ Architecture Overview

### High-Level Structure

```
┌─────────────────────────────────────────────────────────────┐
│                    UCZONE AI Builder v1.0                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           Main Integration Layer (main.lua)          │   │
│  │  - Menu Creation & UI Management                     │   │
│  │  - Callback Handling (OnDraw, OnScriptsLoaded)       │   │
│  │  - Rendering Pipeline                               │   │
│  └──────────────────────────────────────────────────────┘   │
│                          ▲                                    │
│                          │                                    │
│  ┌──────────────────────┴──────────────────────────────┐    │
│  │                                                      │    │
│  ▼                                                      ▼    │
│ ┌─────────────────────┐              ┌─────────────────────┐│
│ │  Core AI Engine     │              │   Hero Database     ││
│ │  (ai_builder.lua)   │              │ (hero_database.lua) ││
│ ├─────────────────────┤              ├─────────────────────┤│
│ │ - Game State Anal.  │              │ - Hero Profiles     ││
│ │ - Enemy Analysis    │              │ - Threat Detection  ││
│ │ - Phase Logic       │              │ - Counter Matrix    ││
│ │ - Rendering         │              │ - Build Adaptation  ││
│ └─────────────────────┘              └─────────────────────┘│
│          ▲                                       ▲            │
│          │                                       │            │
│          └───────────────────┬───────────────────┘            │
│                              │                                │
│                    ┌─────────▼────────┐                      │
│                    │  Config Manager  │                      │
│                    │  (config.lua)    │                      │
│                    └──────────────────┘                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Module Breakdown

### 1. **main.lua** - Integration & UI

**Responsibilities:**
- Menu creation and management
- Callback registration (OnDraw, OnScriptsLoaded)
- Overlay rendering
- User interaction handling

**Key Functions:**

```lua
createMenu()
  ├─ Creates Settings tab
  ├─ Creates Recommendations tab
  ├─ Creates Threats tab
  └─ Creates Progression tab

generateAdvancedRecommendation()
  ├─ Analyzes game state
  ├─ Analyzes enemy team
  ├─ Evaluates threats
  ├─ Applies phase logic
  ├─ Checks for pivots
  └─ Returns recommendation table

renderBuildOverlay()
  ├─ Draws background panel
  ├─ Renders title
  ├─ Shows phase indicator
  ├─ Displays immediate item
  ├─ Shows pivot warning
  └─ Renders threat levels

renderDebugInfo()
  ├─ Shows phase
  ├─ Shows immediate item
  └─ Shows last update time
```

**Dependencies:**
- `ai_builder.lua`
- `hero_database.lua`
- UCZONE API (Engine, Players, Renderer, Menu, etc.)

---

### 2. **ai_builder.lua** - Core AI Engine

**Responsibilities:**
- Game state analysis
- Enemy composition evaluation
- Phase-based decision logic
- Build progression

**Key Functions:**

```lua
analyzeGameState()
  ├─ Get current player
  ├─ Get assigned hero
  ├─ Calculate game time
  ├─ Determine phase (early/mid/late)
  └─ Return state table

analyzeEnemyTeam()
  ├─ Iterate all players
  ├─ Find enemies
  ├─ Categorize damage types
  ├─ Count control threats
  ├─ Count evasion heroes
  └─ Return analysis table

isTeamLosing(team)
  ├─ Count team kills
  ├─ Count enemy kills
  └─ Return boolean

generateBuildRecommendation()
  ├─ Get game state
  ├─ Get enemy analysis
  ├─ Call phase-specific logic
  └─ Return recommendation

buildEarlyGame(game_state, enemy_analysis)
  ├─ Prioritize survivability
  ├─ Check magic threats
  ├─ Add stat items
  └─ Return early recommendations

buildMidGame(game_state, enemy_analysis)
  ├─ Check if losing/winning/even
  ├─ Suggest appropriate items
  ├─ Check for pivots
  ├─ Add counter items
  └─ Return mid game recommendations

buildLateGame(game_state, enemy_analysis)
  ├─ Prioritize teamfight items
  ├─ Add scaling items
  └─ Return late game recommendations
```

**Data Structures:**

```lua
GameState {
  time: number,
  phase: "early" | "mid" | "late",
  hero_name: string,
  hero_level: number,
  current_gold: number,
  player_id: number,
  team: number,
  is_losing: boolean,
  is_winning: boolean
}

EnemyAnalysis {
  total_heroes: number,
  damage_types: {
    magic: number,
    physical: number,
    pure: number
  },
  control_threats: number,
  evasion_heroes: number,
  heroes: [{
    name: string,
    level: number
  }, ...]
}

Recommendation {
  immediate: string[],
  short_term: string[],
  mid_term: string[],
  late_term: string[],
  reasoning: string,
  threat_analysis: {
    magic: number,
    physical: number,
    control: number,
    evasion: number
  },
  game_phase: string,
  pivot_suggested: boolean
}
```

---

### 3. **hero_database.lua** - Knowledge Base

**Responsibilities:**
- Hero data and itemization patterns
- Threat detection and categorization
- Counter-item matching
- Build adaptation logic

**Key Functions:**

```lua
evaluateTeamThreatLevel(enemy_team_analysis)
  ├─ Count magic damage heroes
  ├─ Count physical damage heroes
  ├─ Count control heroes
  ├─ Calculate average
  └─ Return threat_score

getPriorityCounterItems(threat_type, budget)
  ├─ Look up threat type
  ├─ Get recommended counters
  └─ Return item list

getHeroData(hero_name)
  ├─ Normalize hero name
  ├─ Search database
  └─ Return hero profile

shouldBuyItem(item_name, enemy_composition, player_hero)
  ├─ Get item counters
  ├─ Check if threats present
  └─ Return boolean

isThreatPresent(threat_type, enemy_composition)
  ├─ Get threat indicators
  ├─ Count matching enemies
  └─ Return boolean

adaptBuildToGamePhase(base_build, game_time, game_state)
  ├─ Determine phase priority
  ├─ Adjust recommendation weight
  └─ Return adapted build

shouldPivotBuild(current_build, threat_score, budget)
  ├─ Check magic threat level
  ├─ Check physical threat level
  ├─ Check control threat level
  ├─ Determine if pivot needed
  └─ Return (boolean, reason)
```

**Data Structures:**

```lua
HeroProfile {
  name: string,
  position: "1" | "2" | "3" | "4" | "5",
  role: string,
  primary_attribute: string,
  damage_type: string,
  playstyle: string,
  item_progression: {
    early: string[],
    mid: string[],
    late: string[]
  },
  counters: {
    abilities: string[],
    items: string[]
  },
  threats_to: string[],
  item_flexibility: number
}

ThreatScore {
  magic: number,
  physical: number,
  control: number,
  evasion: number,
  average: number
}

ItemCounterMatrix {
  [item_name]: string[]
}
```

---

### 4. **config.lua** - Configuration Management

**Responsibilities:**
- User-configurable settings
- Preset management
- Setting helpers

**Key Sections:**

```lua
Config.general
  ├─ enabled
  ├─ update_interval
  ├─ show_debug
  └─ chat_notifications

Config.ui
  ├─ overlay_position
  ├─ overlay_width
  ├─ show_threats
  ├─ show_progression
  ├─ font_scale
  ├─ background_alpha
  └─ border_width

Config.threats
  ├─ magic_defense_threshold
  ├─ physical_defense_threshold
  ├─ control_defense_threshold
  └─ threat_weight

Config.builds
  ├─ allow_pivots
  ├─ pivot_aggressiveness
  ├─ consider_game_state
  ├─ auto_counter
  └─ win_loss_threshold

Config.phases
  ├─ early_game_end
  ├─ mid_game_end
  ├─ early (priorities)
  ├─ mid (priorities)
  └─ late (priorities)

Config.presets
  ├─ conservative
  ├─ balanced
  ├─ aggressive
  ├─ meta_focused
  └─ situation_first
```

---

## 🔄 Decision Logic Flow

### Early Game Decision Tree

```
EarlyGame (time < 1200s)
├─ Check magic threat level
│  ├─ Yes (threat > 1)
│  │  └─ RECOMMEND: Magic Wand
│  └─ No
│     └─ RECOMMEND: Wraith Band
├─ Always: Power Treads
└─ If evasion threat
   └─ RECOMMEND: Additional defense
```

### Mid Game Decision Tree

```
MidGame (1200s < time < 2400s)
├─ Evaluate team kills
│  ├─ LOSING (enemy kills > team kills + 3)
│  │  ├─ RECOMMEND: Black King Bar
│  │  ├─ RECOMMEND: Force Staff
│  │  └─ Focus: Survival + Catch-up
│  │
│  ├─ WINNING (team kills > enemy kills + 3)
│  │  ├─ RECOMMEND: Blink Dagger
│  │  ├─ RECOMMEND: Manta Style
│  │  └─ Focus: Leverage + Close game
│  │
│  └─ EVEN
│     ├─ Follow hero progression
│     └─ Focus: Standard scaling
│
├─ Check for pivots
│  ├─ Magic threat > 2
│  │  └─ PIVOT: Pipe of Insight
│  ├─ Physical threat > 2
│  │  └─ PIVOT: Platemail/Heart
│  └─ Control threat > 1
│     └─ PIVOT: BKB
│
└─ Counter specific threats
   ├─ Evasion present
   │  └─ ADD: Monkey King Bar
   └─ High armor
      └─ ADD: Desolator
```

### Late Game Decision Tree

```
LateGame (time > 2400s)
├─ Ensure Black King Bar
├─ Add Heart for durability
├─ Add scaling items
│  ├─ Assault Cuirass (for armor)
│  ├─ Butterfly (for evasion)
│  └─ Satanic (for sustain)
└─ Focus: Teamfight dominance
```

---

## 🔗 API Integration Points

### UCZONE Engine API Used

```lua
-- Game State
Engine.IsInGame()
GameRules.GetGameTime()
GameRules.IsPaused()

-- Player & Hero Data
Players.GetLocal()
Players.Get(index)
Players.Count()
player:GetAssignedHero()
player:GetTotalGold()
player:GetPlayerID()
player:GetTeamNum()

-- Hero Abilities & Items
hero:GetUnitName()
hero:GetCurrentLevel()
hero:GetAbilityByIndex(index)
hero:IsAlive()
hero:GetTeamNum()
hero:HasModifier(modifier_name)
hero:HasItem(item_name)

-- Rendering
Renderer.GetScreenSize()
Renderer.SetDrawColor(r, g, b, a)
Renderer.DrawText(x, y, text, font, flags)
Renderer.DrawFilledRect(x1, y1, x2, y2, radius)
Renderer.DrawOutlineRect(x1, y1, x2, y2, width)

-- Menu & Chat
Menu.Create(name, id)
Chat.Print(message)

-- Callbacks
OnDraw()
OnScriptsLoaded()
```

---

## 💾 Data Flow Diagram

```
┌─────────────────┐
│  Game Running   │
└────────┬────────┘
         │
         ▼
    ┌─────────────────────────────────┐
    │  OnDraw() Callback (Every Frame) │
    └────────┬────────────────────────┘
             │
             ▼
    ┌──────────────────────────────────┐
    │  Check Time Since Last Update    │
    │  (Default: 1 second)             │
    └────────┬─────────────────────────┘
             │
             ├─── No ──→ Skip Update
             │
             └─── Yes
                   │
                   ▼
         ┌──────────────────────┐
         │ analyzeGameState()   │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │ analyzeEnemyTeam()   │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ evaluateTeamThreatLevel()        │
         └────────┬─────────────────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ getHeroData()                    │
         └────────┬─────────────────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ Phase-Based Decision Logic       │
         │ (buildEarlyGame/Mid/Late)        │
         └────────┬─────────────────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ shouldPivotBuild()               │
         └────────┬─────────────────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ Generate Recommendation          │
         └────────┬─────────────────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ renderBuildOverlay()             │
         └────────┬─────────────────────────┘
                  │
                  ▼
         ┌──────────────────────────────────┐
         │ renderDebugInfo() (if enabled)   │
         └──────────────────────────────────┘
```

---

## ⚡ Performance Characteristics

### Time Complexity

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| analyzeGameState() | O(1) | Constant time lookup |
| analyzeEnemyTeam() | O(n) | n = players (max 10) |
| evaluateTeamThreatLevel() | O(n) | n = enemy heroes (max 5) |
| getHeroData() | O(1) | Direct lookup |
| shouldBuyItem() | O(m) | m = threats per item (avg 3-4) |
| Full recommendation | O(n) | n = enemy count |

### Memory Usage

| Component | Estimated |
|-----------|-----------|
| Hero Database | ~500 KB |
| Config Data | ~50 KB |
| Runtime State | ~100 KB |
| Overlay Buffers | ~50 KB |
| **Total** | **~700 KB** |

### Update Frequency

- **Default**: 1.0 second update interval
- **Configurable**: 0.5 - 5.0 seconds
- **Per-frame rendering**: Always (OnDraw callback)
- **CPU Impact**: <1% additional load

---

## 🔧 Extension Points

### Adding New Heroes

Edit `hero_database.lua`:

```lua
HeroDatabase.heroes["npc_dota_hero_new_hero"] = {
    name = "New Hero",
    position = "1",
    role = "carry",
    primary_attribute = "agility",
    damage_type = "physical",
    playstyle = "burst_damage",
    item_progression = {
        early = {"power_treads", "wraith_band"},
        mid = {"blink_dagger", "black_king_bar"},
        late = {"butterfly", "silver_edge"}
    },
    counters = {
        abilities = {"disable_ability"},
        items = {"counter_item"}
    },
    threats_to = {"threat_type"},
    item_flexibility = 0.6
}
```

### Adding New Threats

Edit `hero_database.lua`:

```lua
HeroDatabase.threat_indicators["new_threat"] = {
    heroes = {"hero1", "hero2"},
    abilities = {"ability1"},
    recommended_defense = {"item1", "item2"}
}
```

### Adding Item Counters

Edit `hero_database.lua`:

```lua
HeroDatabase.item_counters["new_item"] = {
    "threat_type_1",
    "threat_type_2"
}
```

### Custom Decision Logic

Edit `main.lua` `generateAdvancedRecommendation()`:

```lua
-- Add custom logic before recommendation return
if custom_condition then
    recommendation.immediate = {"custom_item"}
    recommendation.reasoning = "Custom logic triggered"
end
```

---

## 🐛 Debugging

### Enable Debug Mode

1. Open menu: Scripts → AI Builder
2. Toggle "Show Debug Info" ON
3. Watch top-right corner for calculations

### Debug Output Shows

```
Phase: mid
Immediate: Black King Bar
Last Update: 2s ago
```

### Log File Analysis

Enable logging in `config.lua`:

```lua
Config.logging.enabled = true
Config.logging.level = "debug"
```

Logs will be written to:
```
<cheat_dir>/logs/ai_builder.log
```

---

## 🚀 Future Architecture Improvements

### Planned v2.0 Features

- [ ] **Machine Learning**: Learn from pro player builds
- [ ] **Win Rate Tracking**: Track which builds work best
- [ ] **Team Analysis**: Consider full team composition
- [ ] **Ability Cooldowns**: Factor in ability availability
- [ ] **Item Synergies**: Build items that work together
- [ ] **Multi-language**: Support for different languages
- [ ] **Cloud Sync**: Sync builds across accounts
- [ ] **A/B Testing**: Test different strategies

---

## 📝 Code Style Guidelines

### Naming Conventions

```lua
-- Local variables: snake_case
local player_team = hero:GetTeamNum()

-- Functions: camelCase
function aiBuilder:analyzeGameState()

-- Constants: UPPER_SNAKE_CASE
local EARLY_GAME_END = 1200

-- Booleans: is_, has_, should_
local is_winning = true
local has_modifier = hero:HasModifier("modifier")
local should_pivot = true
```

### Comment Style

```lua
-- Single line comment for brief explanations

-- ========================================================================
-- SECTION HEADERS - Use for major code sections
-- ========================================================================

-- Multi-line comment for complex logic:
-- This function analyzes the game state and returns a table
-- containing information about the current game phase, hero, and status.
-- It's called once per update cycle.
```

---

## 📚 References

- UCZONE Documentation: See DocumentationUCZONE.md
- Dota 2 API Docs: https://docs.dota2.com/
- Script Examples: See `/examples/` folder

---

**Version**: 1.0.0  
**Last Updated**: 2026-09-09  
**Maintainer**: UCZONE AI Builder Team
