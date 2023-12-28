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
}
