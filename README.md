# Screenshot Brain - Smart Screenshot OCR & Categorization

Intelligent iOS utility that analyzes screenshots from the camera roll using Apple's Vision framework OCR, automatically classifying them into receipts, codes, articles, and chat threads.

---

## 🛠️ Tech Stack & Architecture
`SwiftUI` `Apple Vision Framework (OCR)` `XCTest Suite` `MVVM` `Swift`

- **Platform:** iOS 16.0+
- **Language:** Swift 5.10+
- **Framework:** SwiftUI
- **Architecture:** MVVM / Clean Architecture

---

## ✨ Key Features
- On-device text recognition and optical character recognition (OCR) via Vision
- Automated screenshot categorization heuristics (Financial, Tech, Social, Documents)
- Searchable text index across all captured screenshots
- Extensive XCTest suite for OCR accuracy, metadata parsing, and categorizer reliability

---

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma or newer
- Xcode 15.0 or newer
- iOS Simulator or physical device running iOS 16+

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Devendrakumar16/Screenshot-Brain-iOS.git
   cd Screenshot-Brain-iOS
   ```
2. Open the project in Xcode:
   ```bash
   open *.xcodeproj 2>/dev/null || open *.xcworkspace
   ```
3. If CocoaPods is used:
   ```bash
   pod install
   open *.xcworkspace
   ```
4. Select your target simulator (e.g., iPhone 15 Pro) and press `Cmd + R` to build and run!

---

## 👨‍💻 Author
- **Devendra Kumar** ([@Devendrakumar16](https://github.com/Devendrakumar16))

---

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
