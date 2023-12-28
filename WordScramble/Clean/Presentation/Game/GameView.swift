import SwiftUI

struct GameView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var points: Int = 0
    @State private var largestWord: String = ""
    
    @ObservedObject var viewModel: GameViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                
                List(viewModel.usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                }
                .listStyle(.inset)
                
                VStack(alignment: .center, spacing: 20) {
                    Text("^[\(viewModel.points) point](inflect: true)")
                        .font(.largeTitle.monospaced())
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Largest word")
                            .font(.caption)
                        Text(viewModel.largestWord.isEmpty ? "-" : viewModel.largestWord)
                            .font(.body.italic())
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle(viewModel.rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: viewModel.startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Re-start", action: viewModel.startGame)
            }
        }
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
    GameView()
}
