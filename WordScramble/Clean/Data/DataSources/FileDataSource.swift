//
//  FileDataSource.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import Foundation

class FileDataSource {
    func getFileContent() throws -> String {
        guard let fileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let fileContent = try? String(contentsOf: fileUrl) else {
            throw FileDataError.cannotLoadContentFromFile
        }
        
        return fileContent
    }
}
