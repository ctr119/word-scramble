//
//  WordError.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 28/12/23.
//

import Foundation

enum WordError: Error {
    case short
    case same
    case alreadyUsed
    case notPossible
    case notRecognised
    
    var info: (title: String, description: String) {
        switch self {
        case .short:
            return ("Short word", "Think about words with more than 2 letters")
        case .same:
            return ("Same word", "Use a different word than the root one!")
        case .alreadyUsed:
            return ("Word used already", "Be more original")
        case .notPossible:
            return ("Word not possible", "You can't spell that word from the root one!")
        case .notRecognised:
            return ("Word not recognized", "You can't just make them up, you know!")
        }
    }
}
