# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CitiZen is a SwiftUI iOS app that helps users study for the U.S. citizenship test. It supports four languages (English, Nepali, Spanish, Chinese) with on-device text-to-speech (TTS) and speech-to-text (STT) for voice-based quiz interaction.

## Build & Run

This is an Xcode project (`Citizenship.xcodeproj`). Build and run via Xcode or:
```
xcodebuild -project Citizenship.xcodeproj -scheme Citizenship -destination 'platform=iOS Simulator,name=iPhone 16' build
```
There are no tests, linters, or package managers configured.

## Architecture

### Navigation Flow
`ContentView` → `LanguageSelectionView` (pick language) → `PracticeSelectionView` (pick difficulty 1–5) → `Practice<N>` view (quiz)

### Key Directories
- **`Lok-Citizenship/AppBackbone/`** — Core app infrastructure: app entry point, language enum, service protocols, TTS/STT implementations, shared view model
- **`Lok-Citizenship/English/`** — English quiz views (`Practice1`–`Practice5`) and `QuizLogic`
- **`Lok-Citizenship/Nepali/`**, **`Spanish/`**, **`Chinese/`** — Equivalent quiz views per language with localized questions. Nepali files use Devanagari names (e.g., `अभ्यास1.swift`). Chinese prefixes with `PracticeCN`.
- **`src/components/`** — React Native `.tsx` components (appears to be a separate/earlier prototype, not part of the SwiftUI build)

### Service Layer
- `ServiceLocator` (singleton) provides `TextToSpeechService` and `SpeechToTextService` via lazy properties
- `LocalTTSService` wraps `AVSpeechSynthesizer` with Combine publishers
- `LocalSTTService` wraps `SFSpeechRecognizer` with on-device recognition preference
- `PracticeQuestionViewModel` wires TTS/STT to SwiftUI (currently commented out in its view)

### Quiz Pattern
Each `Practice<N>` view is self-contained: it owns a `QuizLogic` instance, an array of `Question` structs, and inline TTS/STT wiring. `QuizLogic` (one per language) manages score, question index, shuffle, and fail-at-4-mistakes logic. The `Question` struct is defined in `Practice1.swift` (English) and equivalently in each language's first practice file.

### Language Support
`AppLanguage` enum defines all supported languages with locale codes for TTS/STT, display names, and flags. Adding a new language requires: adding a case to `AppLanguage`, creating practice files with questions, and adding entries in `PracticeSelectionView`.

## Conventions
- App is locked to portrait orientation via `AppDelegate`
- Background images with dark overlay (`Color.black.opacity(0.8)`) are used throughout
- Navigation bar titles are forced white via `UINavigationBar.appearance()` in the app init
- The project was renamed from "Lok-Citizenship" to "Citizenship" but the source folder retains the old name `Lok-Citizenship/`
