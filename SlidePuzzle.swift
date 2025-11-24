//
//  SlidePuzzle.swift
//  project 1
//
//  Created by IM Student on 2025-11-24.
//

import SwiftUI
import Combine

class SlidePuzzleManager: ObservableObject {
    @Published var tiles: [Int] = []
    @Published var moves: Int = 0
    @Published var isWon: Bool = false
    @Published var elapsedTime: Int = 0
    
    let gridSize = 3
    private var timer: Timer?
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        moves = 0
        isWon = false
        elapsedTime = 0
        generatePuzzle()
        startTimer()
    }
    
    private func generatePuzzle() {
        // Create solved puzzle first
        tiles = Array(1...8) + [0] // 0 represents empty space
        
        // Shuffle with valid moves
        for _ in 0..<50 {
            let emptyIndex = tiles.firstIndex(of: 0)!
            let validMoves = getValidMoves(emptyIndex: emptyIndex)
            if let randomMove = validMoves.randomElement() {
                tiles.swapAt(emptyIndex, randomMove)
            }
        }
    }
    
    private func getValidMoves(emptyIndex: Int) -> [Int] {
        var moves: [Int] = []
        let row = emptyIndex / gridSize
        let col = emptyIndex % gridSize
        
        // Up
        if row > 0 {
            moves.append(emptyIndex - gridSize)
        }
        // Down
        if row < gridSize - 1 {
            moves.append(emptyIndex + gridSize)
        }
        // Left
        if col > 0 {
            moves.append(emptyIndex - 1)
        }
        // Right
        if col < gridSize - 1 {
            moves.append(emptyIndex + 1)
        }
        
        return moves
    }
    
    func slideTile(at index: Int) {
        guard let emptyIndex = tiles.firstIndex(of: 0) else { return }
        
        let validMoves = getValidMoves(emptyIndex: emptyIndex)
        
        if validMoves.contains(index) {
            tiles.swapAt(index, emptyIndex)
            moves += 1
            checkWinCondition()
        }
    }
    
    private func checkWinCondition() {
        let solved = Array(1...8) + [0]
        if tiles == solved {
            isWon = true
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
