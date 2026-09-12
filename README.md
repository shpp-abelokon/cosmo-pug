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

## Prerequisites

- **macOS** with [Xcode](https://developer.apple.com/xcode/) installed (this project was built with Xcode 14+; iOS 16 SDK).
- An **Apple ID** (free) for code signing on the simulator or your iPhone.

No CocoaPods, Swift Package Manager dependencies, or extra install steps are required.

## How to run the project

### 1. Open in Xcode

**From Finder:** open the repo folder and double-click `CosmoPug.xcodeproj`.

**From Terminal:**

```bash
open /Users/dashabilokon/PycharmProjects/cosmo-pug/CosmoPug.xcodeproj
```

Wait for Xcode to finish indexing (status bar at the top).

### 2. Select scheme and destination

1. In the Xcode toolbar, confirm the scheme is **CosmoPug** (not another target).
2. Next to it, pick a **run destination**:
   - **iPhone simulator** (e.g. *iPhone 14*) — easiest for development; signing is usually automatic.
   - **Your iPhone** — connect the device via USB or Wi‑Fi debugging; unlock the phone and trust the computer if prompted.

### 3. Configure signing (first time)

1. In the Project navigator (left sidebar), click the blue **CosmoPug** project icon.
2. Select the **CosmoPug** target → **Signing & Capabilities**.
3. Check **Automatically manage signing**.
4. Choose your **Team** (sign in with Apple ID under Xcode → Settings → Accounts if needed).
5. If the bundle ID `com.daria.cosmopug` conflicts, change **Bundle Identifier** to something unique (e.g. `com.yourname.cosmopug`).

### 4. Build and run

- Press **⌘R** or click the **Run** (▶) button.
- Xcode builds the app, launches the simulator or installs on the device, and opens **Cosmo Pug**.

**Controls in the simulator:** click and drag with the mouse to move the ship (same as touch on a device).

### 5. Run from Terminal (optional)

After Xcode has built at least once:

```bash
xcodebuild -scheme CosmoPug -destination 'platform=iOS Simulator,name=iPhone 14' build
```

Use **Run** in Xcode to launch the app on a simulator; `xcodebuild build` only compiles.

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| *Signing for "CosmoPug" requires a development team* | Set **Team** under Signing & Capabilities (step 3). |
| Simulator not listed | Xcode → Settings → Platforms → install an iOS simulator runtime. |
| App does not install on device | Enable **Developer Mode** on iOS (Settings → Privacy & Security). Trust the developer certificate on the device. |
| Black screen | Clean build folder (**⇧⌘K**), then run again (**⌘R**). |

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
