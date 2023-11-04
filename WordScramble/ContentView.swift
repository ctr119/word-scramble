import SwiftUI

struct ContentView: View {
    var body: some View {
        genuineDynamicList
    }
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
