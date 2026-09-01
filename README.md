# VYLO — Flutter lib

Package: `com.vylo.arcade`

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.3.2
```

Then run:

```bash
flutter pub get
flutter run
```

## Gameplay
VYLO is a lightweight offline reflex game. Incoming color orbs approach the center from four lanes. The player rotates a four-color core left or right. At impact, the sector facing the orb must match its color.

## Included
- Classic mode: 3 lives
- Endless mode: one miss ends the run
- Daily mode: deterministic daily sequence
- Progressive speed and spawn difficulty
- Combo system
- Bonus orbs
- Score and best score persistence
- Bolts / local currency
- Theme unlock shop
- 4 visual themes
- Achievements
- Statistics
- Sound toggle
- Haptics toggle
- Pause / resume
- Safe exit confirmation
- Run results
- Full local progress persistence with SharedPreferences
- Reset all progress

## Visual identity
Premium neon-arcade direction: deep navy/black backgrounds with Electric Cyan, Vivid Purple, Hot Orange and Acid Lime. Gameplay uses a custom-painted central color core, orbit lanes, glow particles, feedback flashes, and large tactile left/right controls.

No network, login, server, or external game engine is required by this implementation.
