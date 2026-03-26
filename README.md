# Flodo Task Management App 🚀

A high-end, visually polished Task Management application built with Flutter. This project was developed as a take-home assessment for the **Flodo AI Team**, focusing on premium UI design, robust state management, and reliable offline persistence.

![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)

---

## 🏗️ Project Architecture & Scope

### Track Selected
- **Track B: Mobile Specialist**
  - Focus: UI/UX, state management (Riverpod), and local task persistence.

### Stretch Goal
- **Stretch Goal 1: Debounced Autocomplete Search**
  - Features real-time text highlighting and efficient search debouncing to reduce UI rebuilds.

---

## ✨ Key Features

- **Pristine Studio Design System**: A custom-built, minimalist light-mode theme using Manrope & Inter typography for an editorial feel.
- **Task Dependency (Blocker Logic)**: Tasks blocked by incomplete dependencies are visually distinguished and interaction-disabled.
- **Offline Persistence**: Full CRUD state and persistent drafts are managed via `SharedPreferences`.
- **2s Simulated Latency**: Write operations include a mandatory 2-second delay with visual loading indicators to demonstrate UX robustness.
- **Draft Auto-save**: Task creation screens automatically save progress as you type, preventing data loss.

---

## 🛠️ Setup Instructions

Follow these steps to run the application locally:

1.  **Prerequisites**: Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your machine.
2.  **Clone the Repository**:
    ```bash
    git clone https://github.com/ayushsoni05/Flodo.git
    cd Flodo
    ```
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Device Preparation**: Connect a physical device or start an emulator/simulator.
5.  **Run the App**:
    ```bash
    flutter run
    ```

---

## 🤖 AI Usage Report

### Prompts Used
- *"Implement a premium minimalist light theme for a Flutter task app using the 'Pristine Studio' design concept."*
- *"Create a debounced search provider in Riverpod that handles text highlighting for matching substrings."*
- *"Architect a local persistence layer for complex Task objects using SharedPreferences and JSON serialization."*

### AI Efficiency
The AI was instrumental in scaffolding the custom design system and optimizing the `TextSpan` painting logic for the search highlighter, which significantly reduced development time for complex UI elements.

### Issues & Resolutions
- **Issue**: Initial AI-generated theme logic attempted to use `const` themes which prevented dynamic runtime color changes.
- **Resolution**: Refactored the theme to use a dynamic `ThemeData` factory and non-const widget providers, ensuring smooth theme reactivity.

---

## 📦 Dependencies

- `flutter_riverpod`: Reactive state management.
- `shared_preferences`: Local data and draft persistence.
- `google_fonts`: High-end typography.
- `intl`: Date and time formatting.
- `animate_do`: Subtle micro-animations.

---
Built by ayushsoni05 for the **Flodo AI** Team.
