//
//  ContentView.swift
//  project 1
//
//  Created by IM Student on 2025-11-24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var slidePuzzleManager = SlidePuzzleManager()
    @StateObject private var memoryPuzzleManager = MemoryPuzzleManager()
    @State private var currentScreen: GameScreen = .menu
    
    enum GameScreen {
        case menu
        case modeSelect
        case slideGame
        case memoryGame
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.1, blue: 0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            switch currentScreen {
            case .menu:
                MenuView(currentScreen: $currentScreen)
            case .modeSelect:
                ModeSelectView(currentScreen: $currentScreen, slidePuzzleManager: slidePuzzleManager, memoryPuzzleManager: memoryPuzzleManager)
            case .slideGame:
                SlidePuzzleView(slidePuzzleManager: slidePuzzleManager, currentScreen: $currentScreen)
            case .memoryGame:
                MemoryPuzzleView(memoryPuzzleManager: memoryPuzzleManager, currentScreen: $currentScreen)
            }
        }
    }
}

struct MenuView: View {
    @Binding var currentScreen: ContentView.GameScreen
    @FocusState private var focusedButton: String?
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 20) {
                Text("PUZZLE GAMES")
                    .font(.system(size: 80, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
                Text("Choose your puzzle adventure")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 30) {
                Button(action: {
                    currentScreen = .modeSelect
                }) {
                    Text("PLAY")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 80)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .focused($focusedButton, equals: "play")
                .onPlayPauseCommand {
                    currentScreen = .modeSelect
                }
                
                Button(action: {
                    // Exit app
                }) {
                    Text("EXIT")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 80)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(20)
                }
                .focused($focusedButton, equals: "exit")
            }
            
            Spacer()
        }
        .padding(.top, 100)
        .onAppear {
            focusedButton = "play"
        }
    }
}

struct ModeSelectView: View {
    @Binding var currentScreen: ContentView.GameScreen
    @ObservedObject var slidePuzzleManager: SlidePuzzleManager
    @ObservedObject var memoryPuzzleManager: MemoryPuzzleManager
    @FocusState private var focusedButton: String?
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 20) {
                Text("SELECT GAME MODE")
                    .font(.system(size: 60, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
                Text("Pick your puzzle type")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 30) {
                Button(action: {
                    slidePuzzleManager.startNewGame()
                    currentScreen = .slideGame
                }) {
                    VStack(spacing: 10) {
                        Text("🔢 SLIDE PUZZLE")
                            .font(.system(size: 28, weight: .semibold))
                        Text("Arrange numbers in order")
                            .font(.system(size: 18, weight: .light))
                    }
                    .foregroundColor(.white)
                    .frame(width: 350, height: 100)
                    .background(Color.cyan)
                    .cornerRadius(20)
                }
                .focused($focusedButton, equals: "slide")
                
                Button(action: {
                    memoryPuzzleManager.startNewGame()
                    currentScreen = .memoryGame
                }) {
                    VStack(spacing: 10) {
                        Text("🎴 MEMORY PUZZLE")
                            .font(.system(size: 28, weight: .semibold))
                        Text("Match pairs of cards")
                            .font(.system(size: 18, weight: .light))
                    }
                    .foregroundColor(.white)
                    .frame(width: 350, height: 100)
                    .background(Color.pink)
                    .cornerRadius(20)
                }
                .focused($focusedButton, equals: "memory")
            }
            
            Button(action: {
                currentScreen = .menu
            }) {
                Text("BACK")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(Color.gray)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding(.top, 80)
        .onAppear {
            focusedButton = "slide"
        }
    }
}

struct MemoryPuzzleView: View {
    @ObservedObject var memoryPuzzleManager: MemoryPuzzleManager
    @Binding var currentScreen: ContentView.GameScreen
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("MATCHES")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                    Text("\(memoryPuzzleManager.matches) / \(memoryPuzzleManager.totalPairs)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text("MOVES")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                    Text("\(memoryPuzzleManager.moves)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 60)
            
            VStack(spacing: 15) {
                ForEach(0..<memoryPuzzleManager.gridSize, id: \.self) { row in
                    HStack(spacing: 15) {
                        ForEach(0..<memoryPuzzleManager.gridSize, id: \.self) { col in
                            let index = row * memoryPuzzleManager.gridSize + col
                            let card = memoryPuzzleManager.cards[index]
                            
                            Button(action: {
                                memoryPuzzleManager.tapCard(card)
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(card.isMatched ? Color.green.opacity(0.5) : (card.isFlipped ? Color.blue : Color.purple))
                                    
                                    if card.isFlipped || card.isMatched {
                                        Text(card.emoji)
                                            .font(.system(size: 44))
                                    } else {
                                        Text("?")
                                            .font(.system(size: 44, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(height: 120)
                            }
                            .disabled(card.isMatched)
                        }
                    }
                }
            }
            .padding(40)
            .background(Color.black.opacity(0.3))
            .cornerRadius(30)
            .padding(.horizontal, 40)
            
            if memoryPuzzleManager.isWon {
                VStack(spacing: 30) {
                    Text("🎉 YOU WON! 🎉")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.yellow)
                    
                    Text("Moves: \(memoryPuzzleManager.moves)")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Time: \(formatTime(memoryPuzzleManager.elapsedTime))")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                .padding(40)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
            }
            
            HStack(spacing: 40) {
                Button(action: {
                    memoryPuzzleManager.startNewGame()
                }) {
                    Text("NEW GAME")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                
                Button(action: {
                    withAnimation {
                        currentScreen = .modeSelect
                    }
                }) {
                    Text("MENU")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.orange)
                        .cornerRadius(15)
                }
            }
            
            Spacer()
        }
        .padding(.top, 40)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct SlidePuzzleView: View {
    @ObservedObject var slidePuzzleManager: SlidePuzzleManager
    @Binding var currentScreen: ContentView.GameScreen
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("MOVES")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                    Text("\(slidePuzzleManager.moves)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text("TIME")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                    Text(formatTime(slidePuzzleManager.elapsedTime))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 60)
            
            VStack(spacing: 15) {
                ForEach(0..<slidePuzzleManager.gridSize, id: \.self) { row in
                    HStack(spacing: 15) {
                        ForEach(0..<slidePuzzleManager.gridSize, id: \.self) { col in
                            let index = row * slidePuzzleManager.gridSize + col
                            let tile = slidePuzzleManager.tiles[index]
                            
                            Button(action: {
                                slidePuzzleManager.slideTile(at: index)
                            }) {
                                ZStack {
                                    if tile == 0 {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.black.opacity(0.3))
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.blue.opacity(0.7))
                                        
                                        Text("\(tile)")
                                            .font(.system(size: 44, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(height: 120)
                            }
                        }
                    }
                }
            }
            .padding(40)
            .background(Color.black.opacity(0.3))
            .cornerRadius(30)
            .padding(.horizontal, 40)
            
            if slidePuzzleManager.isWon {
                VStack(spacing: 30) {
                    Text("🎉 SOLVED! 🎉")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.yellow)
                    
                    Text("Moves: \(slidePuzzleManager.moves)")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Time: \(formatTime(slidePuzzleManager.elapsedTime))")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                .padding(40)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
            }
            
            HStack(spacing: 40) {
                Button(action: {
                    slidePuzzleManager.startNewGame()
                }) {
                    Text("NEW GAME")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                
                Button(action: {
                    withAnimation {
                        currentScreen = .modeSelect
                    }
                }) {
                    Text("MENU")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.orange)
                        .cornerRadius(15)
                }
            }
            
            Spacer()
        }
        .padding(.top, 40)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    ContentView()
}
