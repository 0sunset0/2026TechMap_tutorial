# AR Domino Chain Reaction Tutorial

[한국어](README.md)

![A row of dominoes falling in a chain reaction](ARDominoChainReaction/ARDominoChainReaction.docc/Resources/domino-blender-demo.gif)

*This scene recreates the finished app's chain reaction in Blender, using a recording from a physical device as a reference.*

This repository teaches you how to build an AR domino chain reaction app with ARKit and RealityKit. Place dominoes in your space and push one to make its neighbors fall through physics simulation.

**👉 [Start the tutorial](https://0sunset0.github.io/2026TechMap_tutorial/en/tutorials/ardominochainreactiontutorials/)**

[한국어](https://0sunset0.github.io/2026TechMap_tutorial/ko/tutorials/ardominochainreactiontutorials/) · [English](https://0sunset0.github.io/2026TechMap_tutorial/en/tutorials/ardominochainreactiontutorials/)

## Chapters

| Chapter | Title | Key concepts |
| --- | --- | --- |
| 1 | Set Up Your Project | Why AR apps need camera permission and a physical device |
| 2 | Display Your First AR Scene | ARSession, plane detection, and UIKit–SwiftUI integration |
| 3 | Build a Single Domino | RealityKit's Entity-Component-System architecture |
| 4 | Place Dominoes with Taps | Raycasting and an invisible physics floor |
| 5 | Push Dominoes with a Drag | Coordinate conversion and impulses |
| 6 | Polish with a USDZ Model | Replacing a procedural mesh with a USDZ asset |

## Requirements

- Xcode 15 or later
- A physical device running iOS 17.0 or later with an A12 chip or newer (iPhone XS/XR or later), supporting both ARKit world tracking and People Occlusion
- A physical device is required because the simulator has no camera and cannot run the AR session
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Build

The `.xcodeproj` is generated from `project.yml` and is not committed to this repository.

```bash
brew install xcodegen   # One-time setup
cd ARDominoChainReaction
xcodegen generate
open ARDominoChainReaction.xcodeproj
```

In Xcode, select the `ARDominoChainReaction` scheme for Korean or `ARDominoChainReaction-English` for English.

## Repository Structure

```text
ARDominoChainReaction/
├── project.yml                    # XcodeGen definition connecting the Korean and English targets
├── app-project.yml                # Shared app project definition
├── Sources/ARDominoChainReaction/  # Completed app code through Chapter 6 and domino.usdz
├── ARDominoChainReaction.docc/     # Korean DocC tutorials (Chapters/, Resources/)
├── English/                       # English tutorials, translation mappings, and images
└── Docs/                          # Design documents and development notes
```

## Reference Documents

These documents are written in Korean.

- [Decision Log](ARDominoChainReaction/Docs/Decision-Log.md): Decisions made while building the app and tutorials, and their reasoning
- [SPEC](ARDominoChainReaction/Docs/SPEC.md): App goals, scope, and milestones
