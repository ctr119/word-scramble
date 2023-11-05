import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    
    private func startGame() {
        guard let fileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let fileContent = try? String(contentsOf: fileUrl) else { fatalError() }
        
        let words = fileContent.components(separatedBy: "\n")
        rootWord = words.randomElement() ?? "silkworm"
    }
    
    private func addNewWord() {
        guard newWord.count > 0 else { return }
        let word = newWord
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        withAnimation {
            usedWords.insert(word, at: 0)
        }
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension ContentView {
    private var genuineDynamicList: some View {
        List(0..<5) {
            Text("Dynamic row \($0)")
        }
    }
    
    private var mixedList: some View {
        List {
            Section("Section 1") {
                Text("Static row 1")
                Text("Static row 2")
            }

            Section("Section 2") {
                ForEach(0..<5) {
                    Text("Dynamic row \($0)")
                }
            }

            Section("Section 3") {
                Text("Static row 3")
                Text("Static row 4")
            }
        }
        .listStyle(.grouped)
    }
    
    private func loadResourcesFromAppBundle() {
        guard let fileUrl = Bundle.main.url(forResource: "test", withExtension: "txt"),
              let fileContent = try? String(contentsOf: fileUrl) else {
            return
        }
        
        print(fileContent) // Content loaded!
    }
    
    private func meetUIChecker() {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                                                            range: range,
                                                            startingAt: 0,
                                                            wrap: false,
                                                            language: "en")
        let allGood = misspelledRange.location == NSNotFound
        print(allGood)
    }
}
