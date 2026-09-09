# 🚀 QUICKSTART Guide - AI Builder

Get up and running with AI Builder in **5 minutes**!

---

## ⚡ Step 1: Installation (1 min)

1. **Download** all files from the repository:
   - `main.lua`
   - `ai_builder.lua`
   - `hero_database.lua`
   - `config.lua`

2. **Place them** in your UCZONE scripts folder:
   ```
   C:\Users\YourName\AppData\Roaming\UCZONE\scripts\
   ```
   (Or wherever your UCZONE cheat directory is)

3. **Restart** UCZONE or reload scripts

✅ **You're installed!**

---

## 🎮 Step 2: First Game (30 seconds)

1. **Start a Dota 2 game**
2. **Open the UCZONE menu** (default: Insert key)
3. **Navigate to**: Scripts → AI Builder
4. **Toggle "Enabled"** to ON
5. **Look at top-left corner** for recommendations

✅ **AI Builder is running!**

---

## 📊 Step 3: Understanding the Overlay

The overlay shows 3 key pieces of information:

```
=== AI BUILDER ===              ← Title
[MID GAME]                       ← Current game phase
NEXT: Black King Bar             ← What to buy NEXT
⚠ BUILD PIVOT SUGGESTED         ← Warning: change your build!
REASON: Enemy team has 3...     ← Why this recommendation
Threats: M:3 P:1                ← Magic=3, Physical=1
```

### What Each Part Means:

| Part | Meaning | Action |
|------|---------|--------|
| **[PHASE]** | Early/Mid/Late | Adjust expectations based on phase |
| **NEXT** | Item to buy immediately | Save gold and get this item |
| **⚠ PIVOT** | Red warning appears | Your situation changed - adapt! |
| **REASON** | Why it recommends this | Understand the decision |
| **Threats** | Enemy threat levels | Higher = more dangerous |

---

## 🎯 Step 4: Making Decisions

### Trust the AI When:
✅ Early game - getting boots and stat items  
✅ Mid game - you're losing and need defense  
✅ See a PIVOT warning - game situation changed  
✅ Enemy has obvious threats (3+ mages, etc.)

### Use Judgment When:
⚠️ Your team has a specific strategy  
⚠️ You need to cover a role no one else has  
⚠️ The game is in a unique situation  
⚠️ Your playstyle is very different from meta

**Remember**: AI Builder is a **guide**, not gospel!

---

## 🔧 Step 5: Basic Configuration

### Access Settings
1. Open UCZONE menu → AI Builder
2. Click on **Settings** tab
3. Adjust these 3 things:

#### 1️⃣ Enable/Disable
```
Toggle: Enabled [ON/OFF]
```
Turn off if you want to play without recommendations.

#### 2️⃣ Update Speed
```
Slider: Update Interval (0.5 - 5 seconds)
Default: 1.0 second
```
- **Faster (0.5s)**: More responsive, chattier updates
- **Slower (5s)**: Less screen clutter, less responsive

#### 3️⃣ Debug Info
```
Toggle: Show Debug Info [ON/OFF]
```
Turn ON to see detailed calculations (top-right corner).

---

## 🎓 Common Scenarios

### Scenario 1: Enemy Has 3 Magic Damage Dealers
```
You see: NEXT: Pipe of Insight
Reason: "Enemy team has magic damage - get early defense"

What to do:
1. Save up 3395 gold
2. Buy Pipe before your original plan
3. Survive the teamfights
```

### Scenario 2: You're Getting Crushed
```
You see: ⚠ BUILD PIVOT SUGGESTED
        NEXT: Black King Bar
        
What to do:
1. Stop building for damage
2. Get BKB to survive in fights
3. Catch back into the game
```

### Scenario 3: You're Stomping
```
You see: NEXT: Blink Dagger
Reason: "Team is winning - leverage advantage"

What to do:
1. Get mobility to close out the game
2. End before they scale up
3. Secure the win
```

### Scenario 4: Even Game
```
You see: NEXT: Manta Style
Reason: "Even game - scaling based on hero role"

What to do:
1. Follow standard progression
2. Farm safely
3. Prepare for late game
```

---

## 🎨 Understanding Threat Levels

The display shows `Threats: M:3 P:1` - what does this mean?

```
M = Magic damage threat
P = Physical damage threat

0 = No threat
1 = Low (1 hero of this type)
2 = Moderate (2 heroes, consider buying defense)
3+ = High (3+ heroes, MUST buy defense)
```

### Examples:

**M:3 P:1** = Enemy has 3 mages, 1 physical carry
- Buy: Pipe, Cloak, Mage Slayer
- Skip: Armor items for now

**M:1 P:3** = Enemy has 1 mage, 3 physical carries  
- Buy: Platemail, Heart, Armor items
- Skip: Magic defense for now

**M:2 P:2** = Balanced threat
- Buy: Mix of defenses
- Versatile build needed

---

## 🏆 Pro Tips

### Tip 1: Early Game Efficiency
AI Builder recommends early game items efficiently. Follow them to maximize farm.

### Tip 2: Check Before Major Decisions
Before spending 5000+ gold, check if AI Builder suggests a pivot.

### Tip 3: Threat Analysis is Key
If you see a high threat level (M:3 or P:3), that's worth adapting to.

### Tip 4: Use Debug Mode
Enable **Show Debug Info** to learn WHY decisions are made.

### Tip 5: Experiment with Presets
In `config.lua`, try different presets:
- **Conservative**: Less radical changes
- **Aggressive**: Adapt quickly to threats
- **Meta-Focused**: Follow pro builds strictly

---

## 🐛 Troubleshooting

### Problem: No overlay showing

**Solution:**
1. Check that you enabled AI Builder (Settings → Enabled: ON)
2. Make sure you're in an actual game (not lobby)
3. Try `/reload` in console to reload scripts

### Problem: Recommendations seem wrong

**Solution:**
1. Enable "Show Debug Info" to see calculations
2. Check threat analysis - is it accurate?
3. Make sure the game phase is correct

### Problem: Script not loading at all

**Solution:**
1. Check file location: `scripts/` folder
2. Ensure all 4 files are present
3. Check UCZONE console for errors
4. Try restarting UCZONE completely

---

## 🎓 Learning Path

### Day 1: Getting Started
- [ ] Install the script
- [ ] Play 1 game, just watch the recommendations
- [ ] Don't change your normal build yet
- [ ] Get comfortable with the overlay

### Day 2: Start Following
- [ ] Play 2-3 games following AI Builder recommendations
- [ ] Notice when it suggests pivots
- [ ] Pay attention to threats
- [ ] See if your win rate improves

### Day 3: Master It
- [ ] Enable debug info and study the logic
- [ ] Try different configuration presets
- [ ] Use it to understand better itemization
- [ ] Teach your teammates about it

---

## 📚 Next Steps

### Want to Learn More?
- Read the full **README.md** for detailed explanations
- Check **config.lua** for advanced customization options
- Look at **hero_database.lua** to see hero-specific data

### Want to Customize?
1. Open `config.lua`
2. Modify settings under your category
3. Use presets for quick configuration
4. Save and reload

### Want to Contribute?
- Found a bug? Report it on GitHub
- Have a suggestion? Open an issue
- Want to add heroes? Modify `hero_database.lua`

---

## ✨ Key Takeaways

✅ **AI Builder gives you recommendations, not commands**  
✅ **Use common sense when making final decisions**  
✅ **Early game: follow recommendations closely**  
✅ **Mid/Late game: use your judgment combined with AI**  
✅ **When you see ⚠ PIVOT - seriously consider changing**  
✅ **Higher threat numbers = higher priority to counter**

---

## 🚀 You're Ready!

You now know everything to use AI Builder effectively. Jump into a game and start improving your itemization!

**Good luck, and may your builds be ever situational!** 🎮

---

### Quick Cheat Sheet

| Situation | Action |
|-----------|--------|
| Early game | Follow AI recommendations closely |
| Losing mid game | Look for BKB/Force Staff suggestion |
| Winning mid game | Look for mobility items |
| See high threat (3+) | Prioritize countering that threat |
| See ⚠ PIVOT | Your situation changed - consider it |
| Unsure about item | Check "Show Debug Info" for explanation |

---

**Questions?** Check the full README.md or enable Debug Info mode!

**Last Updated**: 2026-09-09  
**Version**: 1.0.0
