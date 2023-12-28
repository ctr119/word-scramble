//
//  GameViewModel.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var usedWords = [String]()
    var rootWord = ""
    var newWord = ""
    
    var points: Int = 0
    var largestWord: String = ""
    
    func startGame() {
        guard let fileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let fileContent = try? String(contentsOf: fileUrl) else { fatalError() }
        
        let words = fileContent.components(separatedBy: "\n")
        rootWord = words.randomElement() ?? "silkworm"
        points = 0
        largestWord = ""
        usedWords.removeAll()
    }
    
    func addNewWord() {
        let word = newWord
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            try validate(word: word)
        } catch {
            if let wError = error as? WordError {
                let (title, message) = wError.info
                // TODO: Show the alert with the error
//                errorTitle = title
//                errorMessage = message
//                showingError = true
            }
            return
        }
        
        withAnimation {
            usedWords.insert(word, at: 0)
            points += word.count
            
            if word.count > largestWord.count {
                largestWord = word
            }
        }
        newWord = ""
    }
    
    private func validate(word: String) throws {
        guard newWord.count >= 3 else {
            throw WordError.short
        }
        guard newWord != rootWord else {
            throw WordError.same
        }
        guard !hasAlreadyBeenUsed(word: word) else {
            throw WordError.alreadyUsed
        }
        guard isPossible(word: word) else {
            throw WordError.notPossible
        }
        guard isReal(word: word) else {
            throw WordError.notRecognised
        }
    }
    
    private func hasAlreadyBeenUsed(word: String) -> Bool {
        usedWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
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
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                                                            range: range,
                                                            startingAt: 0,
                                                            wrap: false,
                                                            language: "en")
        return misspelledRange.location == NSNotFound
    }

}
