//
//  GameModels.swift
//  project 1
//
//  Created by IM Student on 2025-11-24.
//

import SwiftUI
import Combine

struct Tile: Identifiable {
    let id = UUID()
    let type: Int
    let emoji: String
    let color: Color
    
    static let types = [
        (emoji: "🍎", color: Color.red),
        (emoji: "🍌", color: Color.yellow),
        (emoji: "🍇", color: Color.purple),
        (emoji: "🍊", color: Color.orange)
    ]
    
    init(type: Int) {
        self.type = type
        let typeData = Tile.types[type % Tile.types.count]
        self.emoji = typeData.emoji
        self.color = typeData.color
    }
}

class GameManager: ObservableObject {
    @Published var grid: [[Tile]] = []
    @Published var score: Int = 0
    @Published var moves: Int = 0
    @Published var targetScore: Int = 500
    @Published var gameOver: Bool = false
    @Published var matchMessage: String = ""
    
    let gridSize = 4
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        score = 0
        moves = 0
        targetScore = 500
        gameOver = false
        matchMessage = ""
        generateGrid()
    }
    
    private func generateGrid() {
        grid = []
        for _ in 0..<gridSize {
            var row: [Tile] = []
            for _ in 0..<gridSize {
                let randomType = Int.random(in: 0..<4) // Only 4 types for simpler gameplay
                row.append(Tile(type: randomType))
            }
            grid.append(row)
        }
    }
    
    func swapTiles(row1: Int, col1: Int, row2: Int, col2: Int) {
        // Check if tiles are adjacent
        let rowDiff = abs(row1 - row2)
        let colDiff = abs(col1 - col2)
        
        if (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1) {
            // Swap tiles
            let temp = grid[row1][col1]
            grid[row1][col1] = grid[row2][col2]
            grid[row2][col2] = temp
            
            moves += 1
            
            // Check for matches
            let matchCount = checkForMatches()
            
            if matchCount == 0 {
                // No match, swap back
                let temp = grid[row1][col1]
                grid[row1][col1] = grid[row2][col2]
                grid[row2][col2] = temp
                moves -= 1
                matchMessage = "No match!"
            } else {
                matchMessage = "Match! +\(matchCount * 50)"
            }
            
            // Check win condition
            if score >= targetScore {
                gameOver = true
                matchMessage = "YOU WIN!"
            }
        }
    }
    
    private func checkForMatches() -> Int {
        var tilesToRemove: Set<String> = []
        
        // Check horizontal matches
        for row in 0..<gridSize {
            for col in 0..<gridSize - 2 {
                if grid[row][col].type == grid[row][col + 1].type &&
                   grid[row][col].type == grid[row][col + 2].type &&
                   grid[row][col].type >= 0 {
                    tilesToRemove.insert("\(row),\(col)")
                    tilesToRemove.insert("\(row),\(col + 1)")
                    tilesToRemove.insert("\(row),\(col + 2)")
                }
            }
        }
        
        // Check vertical matches
        for col in 0..<gridSize {
            for row in 0..<gridSize - 2 {
                if grid[row][col].type == grid[row + 1][col].type &&
                   grid[row][col].type == grid[row + 2][col].type &&
                   grid[row][col].type >= 0 {
                    tilesToRemove.insert("\(row),\(col)")
                    tilesToRemove.insert("\(row + 1),\(col)")
                    tilesToRemove.insert("\(row + 2),\(col)")
                }
            }
        }
        
        if !tilesToRemove.isEmpty {
            let matchCount = tilesToRemove.count
            score += matchCount * 50
            removeTiles(tilesToRemove)
            fillGrid()
            return matchCount
        }
        
        return 0
    }
    
    private func removeTiles(_ positions: Set<String>) {
        for position in positions {
            let parts = position.split(separator: ",").map { Int($0)! }
            let row = parts[0]
            let col = parts[1]
            grid[row][col] = Tile(type: -1) // Mark as empty
        }
    }
    
    private func fillGrid() {
        // Drop tiles down
        for col in 0..<gridSize {
            var writePos = gridSize - 1
            for row in (0..<gridSize).reversed() {
                if grid[row][col].type != -1 {
                    grid[writePos][col] = grid[row][col]
                    if writePos != row {
                        grid[row][col] = Tile(type: -1)
                    }
                    writePos -= 1
                }
            }
        }
        
        // Fill empty spaces with new tiles
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col].type == -1 {
                    let randomType = Int.random(in: 0..<4)
                    grid[row][col] = Tile(type: randomType)
                }
            }
        }
    }
}
