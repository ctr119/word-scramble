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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
