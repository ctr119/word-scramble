//
//  WordsRepository.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import Foundation

class WordsRepository {
    private let dataSource: FileDataSource
    
    init(dataSource: FileDataSource = .init()) {
        self.dataSource = dataSource
    }
    
    func getWords() -> [String] {
        do {
            let fileContent = try dataSource.getFileContent()
            return fileContent.components(separatedBy: "\n")
        } catch {
            /// Here we might consider propagating another different kind of error
            /// that Domain can understand within its context
            fatalError()
        }
    }
}
