import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var points: Int = 0
    @State private var largestWord: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                
                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                }
                .listStyle(.inset)
                
                VStack(alignment: .center, spacing: 20) {
                    Text("^[\(points) point](inflect: true)")
                        .font(.largeTitle.monospaced())
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Largest word")
                            .font(.caption)
                        Text(largestWord.isEmpty ? "-" : largestWord)
                            .font(.body.italic())
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Re-start", action: startGame)
            }
        }
    }
    
    private func startGame() {
        guard let fileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let fileContent = try? String(contentsOf: fileUrl) else { fatalError() }
        
        let words = fileContent.components(separatedBy: "\n")
        rootWord = words.randomElement() ?? "silkworm"
        points = 0
        largestWord = ""
        usedWords.removeAll()
    }
    
    private func addNewWord() {
        let word = newWord
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            try validate(word: word)
        } catch {
            if let wError = error as? WordError {
                let (title, message) = wError.info
                errorTitle = title
                errorMessage = message
                showingError = true
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

#Preview {
    ContentView()
}
