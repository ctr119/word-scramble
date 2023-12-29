//
//  GetNewWordUseCase.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import Foundation

class GetNewWordUseCase {
    private let wordsRepository: WordsRepository
    
    init(wordsRepository: WordsRepository = .init()) {
        self.wordsRepository = wordsRepository
    }
    
    func callAsFunction() -> String {
        let words = wordsRepository.getWords()
        return words.randomElement() ?? "silkworm"
    }
}
