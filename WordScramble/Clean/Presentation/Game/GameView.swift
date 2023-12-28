import SwiftUI

struct GameView: View {    
    @ObservedObject var viewModel: GameViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your word", text: $viewModel.newWord)
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
            .onSubmit(viewModel.addNewWord)
            .onAppear(perform: viewModel.startGame)
            .manage(error: viewModel.error, 
                    when: $viewModel.isThereAnError)
            .toolbar {
                Button("Re-start", action: viewModel.startGame)
            }
        }
    }
}

#Preview {
    GameView()
}
