//
//  MemoryPuzzle.swift
//  project 1
//
//  Created by IM Student on 2025-11-24.
//

import SwiftUI
import Combine

class MemoryPuzzleManager: ObservableObject {
    @Published var cards: [MemoryCard] = []
    @Published var moves: Int = 0
    @Published var matches: Int = 0
    @Published var isWon: Bool = false
    @Published var elapsedTime: Int = 0
    
    private var canTap: Bool = true
    private var timer: Timer?
    
    let gridSize = 4
    let totalPairs = 8
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        moves = 0
        matches = 0
        isWon = false
        elapsedTime = 0
        canTap = true
        generateCards()
        startTimer()
    }
    
    private func generateCards() {
        let emojis = ["🍎", "🍌", "🍇", "🍊", "🍓", "🥝", "🍉", "🍒"]
        var cardArray: [MemoryCard] = []
        
        for (index, emoji) in emojis.enumerated() {
            cardArray.append(MemoryCard(id: index * 2, emoji: emoji, isFlipped: false, isMatched: false))
            cardArray.append(MemoryCard(id: index * 2 + 1, emoji: emoji, isFlipped: false, isMatched: false))
        }
        
        cards = cardArray.shuffled()
    }
    
    func tapCard(_ card: MemoryCard) {
        guard canTap, !card.isFlipped, !card.isMatched else { return }
        
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFlipped = true
            
            if firstCard == nil {
                firstCard = (index, cards[index])
            } else if secondCard == nil {
                secondCard = (index, cards[index])
                canTap = false
                moves += 1
                checkForMatch()
            }
        }
    }
    
    private var firstCard: (Int, MemoryCard)?
    private var secondCard: (Int, MemoryCard)?
    
    private func checkForMatch() {
        guard let (firstIdx, first) = firstCard, let (secondIdx, second) = secondCard else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if first.emoji == second.emoji {
                // Match found
                self.cards[firstIdx].isMatched = true
                self.cards[secondIdx].isMatched = true
                self.matches += 1
                
                if self.matches == self.totalPairs {
                    self.isWon = true
                    self.timer?.invalidate()
                }
            } else {
                // No match
                self.cards[firstIdx].isFlipped = false
                self.cards[secondIdx].isFlipped = false
            }
            
            self.firstCard = nil
            self.secondCard = nil
            self.canTap = true
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

struct MemoryCard: Identifiable, Equatable {
    let id: Int
    let emoji: String
    var isFlipped: Bool
    var isMatched: Bool
    
    static func == (lhs: MemoryCard, rhs: MemoryCard) -> Bool {
        lhs.id == rhs.id
    }
}
