//
//  GetNewWordUseCase.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import Foundation

class GetNewWordUseCase {
    func callAsFunction() -> String {
        guard let fileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let fileContent = try? String(contentsOf: fileUrl) else { fatalError() }
        
        let words = fileContent.components(separatedBy: "\n")
        return words.randomElement() ?? "silkworm"
    }
}
