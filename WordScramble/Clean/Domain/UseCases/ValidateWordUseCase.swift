//
//  ValidateWordUseCase.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import Foundation

class ValidateWordUseCase {
    func callAsFunction(word: String, rootWord: String, usedWords: [String]) throws {
        guard word.count >= 3 else {
            throw WordError.short
        }
        guard word != rootWord else {
            throw WordError.same
        }
        guard !hasAlreadyBeenUsed(in: usedWords, word: word) else {
            throw WordError.alreadyUsed
        }
        guard isPossible(word: word, from: rootWord) else {
            throw WordError.notPossible
        }
    }
    
    private func hasAlreadyBeenUsed(in words: [String], word: String) -> Bool {
        words.contains(word)
    }
    
    private func isPossible(word: String, from rootWord: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
}
