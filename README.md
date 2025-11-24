# 📺 tvOS Dual Puzzle Suite

![Platform](https://img.shields.io/badge/Platform-tvOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Language](https://img.shields.io/badge/Language-Swift_5-F05138?style=for-the-badge&logo=swift&logoColor=white)
![Framework](https://img.shields.io/badge/Framework-SwiftUI-007AFF?style=for-the-badge&logo=swift&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> **A native Apple TV puzzle collection featuring classic cognitive challenges optimized for the 10-foot experience.**

---

## 📝 Executive Summary

The **tvOS Dual Puzzle Suite** is a comprehensive application developed specifically for the Apple TV ecosystem. It features a centralized menu system that allows users to seamlessly navigate between two classic cognitive games using the Siri Remote.

### 🌟 Game Modes
* **1️⃣ Slide Puzzle:** A numeric logic game requiring spatial reasoning.
* **2️⃣ Memory Puzzle:** An emoji-based recall game testing short-term memory.

The application is built on the **MVVM architecture** and utilizes the **Focus Engine** for high-contrast, intuitive navigation on large television displays.

---

## 🏗️ Technical Architecture

The project strictly follows the **Model-View-ViewModel (MVVM)** architectural pattern to ensure clean separation of concerns.

### 📂 Project Structure

```text
📦 Project 1
 ┣ 📜 project_1App.swift       # Application Entry Point
 ┣ 📜 ContentView.swift        # 🧭 Router & Main Navigation
 ┣ 📜 SlidePuzzle.swift        # 🧩 ViewModel & Logic for Slide Game
 ┣ 📜 MemoryPuzzle.swift       # 🃏 ViewModel & Logic for Memory Game
 ┗ 📜 Item.swift               # 🍬 (Bonus) Logic for Match-3 Game
```

### 🧠 Logic Breakdown

| File Name | Role | Technical Description |
|-----------|------|-------------|
| **ContentView** | `Router` | Manages state via `enum GameScreen`. Handles global background gradients and transitions between the Menu, Mode Select, and Game Views. |
| **SlidePuzzle** | `ViewModel` | Implements the **8-puzzle algorithm**. Solvability is guaranteed by generating a solved grid first and performing 50 random valid moves backwards. |
| **MemoryPuzzle** | `ViewModel` | Manages a **4x4 grid** of emoji cards. Includes concurrency logic (`DispatchQueue`) for card flip delays (0.6s) and match validation. |
| **Item** | `Model` | *Note:* Contains `GameManager` logic for a "Match-3" style game. Currently implemented in logic but inactive in the UI. |

-----

## ⚙️ Installation Guide

Follow these steps to set up the project locally on your Mac.

### ✅ Prerequisites

  * 💻 Mac running macOS
  * 🛠️ Xcode 15 or later
  * 📺 (Optional) Apple TV for physical testing

### 🚀 Setup Instructions

1. **Initialize Project**
    * Open Xcode and select **Create New Project**.
    * Choose **tvOS** ➔ **App**.
    * Name the project `project 1` and ensure Interface is set to **SwiftUI**.

2. **Import Source Code**
    * Delete the default `ContentView.swift`.
    * Create the following files and paste the provided code:
        * `SlidePuzzle.swift`
        * `MemoryPuzzle.swift`
        * `Item.swift`
        * `ContentView.swift`

3. **Build & Run**
    * Select **Apple TV 4K (Simulator)** as your destination.
    * Press <kbd>Cmd</kbd> + <kbd>R</kbd> to launch the app.

-----

## 🕹️ User Manual & Tutorial

### 🧭 Navigation

  * **Menu:** Swipe **Down** on the Siri Remote to highlight `PLAY`, then click to select.
  * **Mode Selection:** Swipe **Left** or **Right** to choose your game:
      * 🟦 **Cyan:** Slide Puzzle
      * 🌸 **Pink:** Memory Puzzle

### 🧩 Game 1: Slide Puzzle (Logic)

  * **Objective:** Order the numbers **1 through 8** sequentially.
  * **Controls:** Navigate to a blue tile adjacent to the empty black space and **click** to slide it.
  * **Win Condition:** The grid must match the configuration below:

    ```text
    [1] [2] [3]
    [4] [5] [6]
    [7] [8] [ ]
    ```

### 🃏 Game 2: Memory Puzzle (Recall)

  * **Objective:** Find all matching pairs of fruit emojis (🍎, 🍌, 🍇, etc.).
  * **Controls:** Click a card to flip it. Click a second card to try and find a match.
  * **Mechanics:**
      * ✅ **Match:** Cards turn green and remain face up.
      * ❌ **Mismatch:** Cards display for **0.6 seconds** before flipping back down.
  * **Win Condition:** Successfully reveal all **8 pairs**.

-----

## 🔮 Future Improvements

  * 🍬 **Match-3 Integration:** Enable the `Item.swift` logic to add a "Candy Crush" style game mode.
  * 💾 **Persistent Scoring:** Use `UserDefaults` to save high scores.
  * 🔊 **Sound Effects:** Add audio feedback for interactions.

-----

<div align="center">

*Developed by Hasith Bulathgama / Academic Submission - November 26 2025

</div>

