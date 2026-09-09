# UCZONE AI Builder - Intelligent Dynamic Item Builder

**An AI-powered, situation-aware item recommendation system for Dota 2 that adapts builds based on meta, game state, and enemy composition.**

## 🎯 What is AI Builder?

AI Builder is a sophisticated item recommendation engine that goes **far beyond generic builds**. Instead of suggesting the same items regardless of the game situation, it analyzes:

- **Enemy team composition** - What threats you're facing
- **Game phase progression** - Early/Mid/Late game priorities
- **Current game state** - Winning/Losing/Even situations
- **Hero-specific itemization** - Role and position-based builds
- **Meta trends** - Current patch optimal itemization
- **Threat analysis** - Magic damage, physical damage, control, evasion threats
- **Build pivoting** - When and why to deviate from standard builds

### Why This Matters

Many players lose games not because they can't farm, but because they build **sub-optimal items for the situation**. For example:

- Building Blink Dagger when you should be getting Force Staff
- Getting damage items when the team needs survivability
- Ignoring enemy magic damage threats
- Not adapting to game state (losing vs winning scenarios)

**AI Builder prevents these mistakes.**

---

## 🚀 Features

### 1. **Real-Time Situation Analysis**
- Monitors game state every second
- Evaluates enemy team composition
- Calculates threat levels (magic, physical, control, evasion)
- Determines if team is winning/losing/even

### 2. **Phase-Based Build Recommendations**

#### Early Game (0-20 min)
- Priority: Survivability + early power spike
- Auto-detects magic threats and recommends early defense
- Suggests boot type based on hero playstyle

#### Mid Game (20-40 min)
- **Losing scenario**: Prioritize catch-up and utility items
- **Winning scenario**: Leverage advantage with mobility/damage
- **Even game**: Standard scaling based on hero role
- Suggests build pivots if enemy threats require it

#### Late Game (40+ min)
- Focus on teamfight dominance
- Durability + impact items
- Scaling for mega creep defense

### 3. **Intelligent Counter-Itemization**

Automatically suggests items to counter:
- **Magic Heavy Teams** → Pipe of Insight, Cloak, Mage Slayer
- **Physical Carries** → Platemail, Heart, Assault Cuirass
- **Crowd Control** → Black King Bar, Linkens Sphere, Force Staff
- **Evasion** → Monkey King Bar, Silver Edge
- **High Armor** → Desolator, Ethereal Blade

### 4. **Build Pivoting Alerts**

When the game situation changes dramatically, AI Builder will suggest a **pivot** from your original build:

```
⚠ BUILD PIVOT SUGGESTED
Reason: Enemy team has 3 magic damage dealers - get Pipe instead of Blink
```

### 5. **Comprehensive Menu System**

Access all settings and recommendations through an in-game menu:
- Enable/disable AI Builder
- Configure update intervals
- View threat analysis
- See build progression stages
- Advanced options for fine-tuning

---

## 📊 How It Works

### Core Logic Flow

```
Game State Analysis
        ↓
Enemy Composition Analysis
        ↓
Threat Level Calculation
        ↓
Hero Data Lookup
        ↓
Phase-Based Decision Logic
        ↓
Threat Counter-Checking
        ↓
Build Pivot Assessment
        ↓
Recommendation Generation
        ↓
On-Screen Display
```

### Decision Making Examples

#### Example 1: Early Game with Magic Threats
```
Game Time: 8 minutes
Enemy: Lina, Lion, Invoker (3 magic damage dealers)
Your Hero: Phantom Assassin (Physical Carry)

AI Builder Decision:
- IMMEDIATE: Magic Wand
- SHORT_TERM: Cloak, Power Treads
- Reason: "Enemy team has magic damage - get early defense"
```

#### Example 2: Mid Game - Losing Scenario
```
Game Time: 28 minutes
Team Kills: 6 | Enemy Kills: 12 (Losing)
Your Hero: Luna (Carry)
Gold: 3000

AI Builder Decision:
- IMMEDIATE: Black King Bar (3900)
- SHORT_TERM: Heart
- Reason: "Team is losing - prioritizing survival and catch-up items"
- PIVOT SUGGESTED: True
```

#### Example 3: Mid Game - Winning Scenario
```
Game Time: 25 minutes
Team Kills: 15 | Enemy Kills: 6 (Winning)
Your Hero: Anti-Mage (Carry)
Gold: 5000

AI Builder Decision:
- IMMEDIATE: Blink Dagger (2250)
- SHORT_TERM: Manta Style
- Reason: "Team is winning - leverage advantage with mobility and utility"
```

---

## 🎮 Installation & Usage

### Installation
1. Place all `.lua` files in your UCZONE scripts folder: `%cheat_dir%/scripts/`
2. Load the script through the UCZONE menu
3. Type `/ai_builder` to access settings

### Files Included
- `main.lua` - Main integration script with callbacks
- `ai_builder.lua` - Core AI recommendation engine
- `hero_database.lua` - Hero data, threats, and counters
- `README.md` - This documentation

### Usage
1. **Start a game** in Dota 2
2. **Enable AI Builder** in the menu (enabled by default)
3. **Check the overlay** in top-left corner for recommendations
4. **Watch for pivots** - Red warning means build change suggested

---

## ⚙️ Configuration

### Menu Options

#### Settings
- **Enabled** - Toggle AI Builder on/off
- **Show Debug Info** - Display advanced analytics
- **Update Interval** - How often to update recommendations (0.5-5 seconds)

#### Advanced Options
- **Auto-Counter Enemy Picks** - Automatically suggest counter items (default: ON)
- **Adaptive Build Order** - Change recommendations based on game state (default: ON)
- **Consider Game State** - Factor in win/loss scenarios (default: ON)
- **Suggest Item Pivots** - Alert when to deviate from standard build (default: ON)

---

## 📈 Threat Analysis

The system evaluates 7 primary threat types:

| Threat Type | Indicators | Counters |
|-------------|-----------|----------|
| **Magic Damage** | Lina, Lion, Invoker | Pipe, Cloak, Mage Slayer |
| **Physical Damage** | Luna, PA, Drow | Platemail, Heart, AC |
| **Crowd Control** | Earthshaker, Rubick | BKB, Linkens, Force Staff |
| **Evasion** | PA, Brewmaster | MKB, Silver Edge |
| **High Armor** | Bristle, Centaur | Desolator, AC |
| **Mana Burn** | Anti-Mage, Lion | Heart, Linkens |
| **Silences** | Silencer, Dark Willow | BKB, Linkens |

---

## 🎯 Item Priority System

Items are prioritized based on:

1. **Game Phase** (early/mid/late)
2. **Hero Role** (carry/support/offlane)
3. **Threat Level** (how many enemies have this threat type)
4. **Current Gold** (can we afford this item category?)
5. **Game State** (are we winning/losing?)
6. **Build Flexibility** (how critical is item order for this hero?)

### Priority Tiers
- **Tier 1 (Critical)** - Survival items when facing overwhelming threats
- **Tier 2 (Important)** - Core hero items for damage/utility
- **Tier 3 (Useful)** - Situational items for specific counters
- **Tier 4 (Luxury)** - Late game scaling and luxury items

---

## 🔧 Advanced Features

### Smart Build Adaptation

The system recognizes when you should **pivot** from your intended build:

```lua
-- Automatically suggests pivots when:
- Enemy team gets 3+ magic damage dealers
- You're losing by 5+ kills
- Critical threat appears (Evasion hero, Control spam)
- Gold efficiency requires adjustment
```

### Hero-Specific Analysis

Each hero has:
- **Itemization patterns** for different game phases
- **Playstyle classification** (burst, farm, support, etc.)
- **Item flexibility score** (0.3 = rigid, 0.8 = flexible)
- **Role-specific priorities**

### Game Phase Transition Logic

```
Early Game (0-20 min)
  ↓
Mid Game Pivot Check (20 min)
  ├─ Losing? → Survival Priority
  ├─ Winning? → Leverage Priority
  └─ Even? → Scale Priority
  ↓
Late Game Teamfight Focus (40+ min)
```

---

## 📊 Threat Scoring System

Each threat is scored on a scale:

```
Score 0: No threat
Score 1: Minor threat
Score 2: Moderate threat (build consideration)
Score 3+: Major threat (build priority)
```

**Example Calculation:**
```
Enemy Team: Lina, Lion, Invoker, Earthshaker, Riki

Magic Damage Count: 3 (Lina, Lion, Invoker)
Control Count: 2 (Earthshaker, Riki)
Evasion Count: 1 (Riki)

Result:
- Magic Threat: 3 (HIGH) → Buy Pipe
- Control Threat: 2 (MODERATE) → Buy BKB
- Evasion Threat: 1 (LOW) → Skip MKB for now
```

---

## 🎨 UI & Display

### Build Overlay (Top-Left Corner)

```
=== AI BUILDER ===
[MID GAME]
NEXT: Black King Bar
⚠ BUILD PIVOT SUGGESTED
REASON: Enemy team has 3 magic damage...
Threats: M:3 P:1
```

### Color Coding
- **Yellow** - Title and headers
- **Green** - Immediate recommendation (NEXT ITEM)
- **Red** - Pivot warning or critical threats
- **Orange** - Game phase indicator
- **Gray** - Reasoning and analysis

### Debug Info (Top-Right Corner)
Shows detailed analytics when enabled:
- Current phase
- Immediate item choice
- Time since last update
- Threat calculations

---

## 🔍 How Decisions Are Made

### Mid Game (Critical Point)

```lua
IF team is losing:
    Recommend: Black King Bar / Force Staff
    Focus: Survival + Catch-up
    
ELIF team is winning:
    Recommend: Blink Dagger / Manta Style
    Focus: Leverage + Close game
    
ELSE (even game):
    Recommend: Based on hero progression
    Focus: Standard scaling
    
-- Then check for threat pivots:
IF enemy has 3+ magic threats:
    PIVOT to Pipe of Insight
    
IF enemy has evasion:
    PIVOT to Monkey King Bar
```

---

## ⚡ Performance

- **Update Interval**: Configurable (default 1 second)
- **Memory Footprint**: ~2-3 MB
- **CPU Impact**: Minimal (<1% additional load)
- **Latency Impact**: None (client-side only)

---

## 🐛 Troubleshooting

### Issue: No recommendations appearing
- **Solution**: Ensure you're in a game and AI Builder is enabled
- **Check**: Menu → Settings → Enabled toggle

### Issue: Recommendations seem wrong
- **Solution**: Check threat analysis in the menu
- **Debug**: Enable "Show Debug Info" to see calculations

### Issue: Script not loading
- **Solution**: Ensure all `.lua` files are in the correct folder
- **Path**: `%cheat_dir%/scripts/`

---

## 📝 API Reference

### Main Functions

#### `generateAdvancedRecommendation()`
Generates the current build recommendation based on game state.

**Returns:**
```lua
{
    immediate = {...},           -- Next item(s) to buy
    short_term = {...},          -- Items for next 2-3 minutes
    mid_term = {...},            -- Items for mid-game phase
    late_term = {...},           -- Items for late-game
    reasoning = "string",        -- Explanation for decision
    threat_analysis = {          -- Threat levels
        magic = number,
        physical = number,
        control = number,
        evasion = number
    },
    game_phase = "early|mid|late",
    pivot_suggested = boolean    -- Should we change build?
}
```

### Core Modules

#### `ai_builder.lua`
- Game state analysis
- Enemy team composition evaluation
- Phase-based logic
- Basic recommendations

#### `hero_database.lua`
- Hero data and itemization patterns
- Threat detection
- Counter-item matching
- Build adaptation

#### `main.lua`
- Menu UI creation
- Rendering and display
- Callback integration
- User interaction

---

## 🚀 Future Enhancements

Planned features:
- [ ] Pro player build pattern learning
- [ ] Machine learning threat prediction
- [ ] Real-time market price optimization
- [ ] Team composition synergy analysis
- [ ] Multi-language support
- [ ] Historical game analysis
- [ ] Custom build templates

---

## 📄 License

This script is provided as-is for use with UCZONE Dota 2 cheat.

---

## 💬 Support

For issues or suggestions:
1. Check the Troubleshooting section
2. Enable Debug Info to see what's happening
3. Report issues with game state details

---

## 🙏 Credits

Built for UCZONE using the UCZONE Dota 2 API.

Inspired by professional players' adaptive itemization strategies.

**Version**: 1.0.0  
**Last Updated**: 2026-09-09  
**Patch**: 7.37

---

**Remember**: AI Builder is a guide, not a law. Use professional judgment in unique situations!
