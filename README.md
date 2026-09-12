# Cosmo Pug

Vertical scroll shooter for iOS: space pug, starfield, enemies, and auto-fire.

## Stack

- **Swift** + **SpriteKit** + **SwiftUI** (`SpriteView`)
- Minimum deployment: **iOS 16**
- Open **`CosmoPug.xcodeproj`** in Xcode

## How to play

1. Drag to move the ship (pug).
2. Bullets fire automatically upward.
3. Destroy purple enemies; avoid collisions.
4. After game over, tap to play again.

## Run

1. Open the project in Xcode.
2. In **Signing & Capabilities**, select your **Team** (Apple ID).
3. Run on an iPhone simulator or device (▶ Run).

## Code layout

| Path | Purpose |
|------|---------|
| `CosmoPug/ContentView.swift` | SwiftUI wrapper around the scene |
| `CosmoPug/Game/GameScene.swift` | Game loop, spawn, HUD, collisions |
| `CosmoPug/Game/Nodes/` | Player, enemies, bullets, starfield |

## Next steps (ideas)

- Sprite art instead of shapes (pug, enemies, VFX)
- Bosses and waves
- Sound and music (`SKAction.playSoundFileNamed`)
- Power-ups (triple shot, shield)
- Game Center leaderboards
- Explosions via `SKEmitterNode`

Project with Daria
