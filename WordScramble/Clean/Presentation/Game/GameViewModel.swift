//
//  GameViewModel.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var usedWords = [String]()
    @Published var newWord = ""
    @Published var isThereAnError = false
    
    var rootWord = ""
    var points: Int = 0
    var largestWord: String = ""
    var error: WordError?
    
    private let getNewWordUseCase: GetNewWordUseCase
    private let validateWordUseCase: ValidateWordUseCase
    
    init(getNewWordUseCase: GetNewWordUseCase = .init(),
         validateWordUseCase: ValidateWordUseCase = .init()) {
        self.getNewWordUseCase = getNewWordUseCase
        self.validateWordUseCase = validateWordUseCase
    }
    
    func startGame() {
        rootWord = getNewWordUseCase()
        points = 0
        largestWord = ""
        newWord = ""
        usedWords.removeAll()
    }
    
    func addNewWord() {
        let word = newWord
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            try validateWordUseCase(word: word,
                                    rootWord: rootWord,
                                    usedWords: usedWords)
            
            if !isReal(word: word) {
                throw WordError.notRecognised
            }
        } catch {
            if let wError = error as? WordError {
                self.error = wError
                isThereAnError = true
            }
            return
        }
        
        
        usedWords.insert(word, at: 0)
        points += word.count
        
        if word.count > largestWord.count {
            largestWord = word
        }
        
        newWord = ""
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
