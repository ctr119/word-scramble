# Hola! 👋 👾 🎲

The typical game of switching letter's position to create new words. 

With a point based system consisting of summing the length of each valid word, you will challenge yourself to find all possible combinations 🤔 💪

## Highligths

In this project you will find:
- An example of Clean Architecture
- Use of different `Error` kinds based on the layer they are generated from
- How to load file's content into a `String`
- A nice custom modifier for presenting alert errors ✨
- Use of `UITextChecker` for checking that a given word really exists 💥
- **SwiftUI's Inflect parameter** 😱
```Swift
@State private var points = 1 // 2
...
Text("^[\(points) point](inflect: true)")
...
```
