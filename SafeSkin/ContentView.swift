import SwiftUI

//sharedmodel
class WordCheckerModel: ObservableObject {
    @Published var wordsOrPhrases: String = "" //user profile input allergies
    @Published var blockOfText: String = "" //scanned data check if this is public?
    @Published var matchedWords: [String] = [] //matched words computed by checkForMatches
}


struct ContentView: View {
    @StateObject private var wordCheckerModel = WordCheckerModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    "Step 1: Enter Words or Phrases",
                    destination: InputWordsView(model: wordCheckerModel)
                )
                .padding()
                
                NavigationLink(
                    "Step 2: Check Text",
                    destination: CheckTextView(model: wordCheckerModel)
                )
                .padding()
            }
            .navigationTitle("Word Checker")
        }
    }
}


struct InputWordsView: View { //profile view
    @ObservedObject var model: WordCheckerModel
    
    var body: some View {
        VStack {
            Text("Enter comma-separated words or phrases:")
                .font(.headline)
                .padding()
            
            TextField("e.g., allergy, sensitive skin, peanut", text: $model.wordsOrPhrases)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Input Words/Phrases")
    }
}

struct CheckTextView: View { //highlight if it contains
    @ObservedObject var model: WordCheckerModel
    
    var body: some View {
        VStack {
            Text("Enter a block of text:")
                .font(.headline)
                .padding()
            
            TextEditor(text: $model.blockOfText)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding()
            
            Button("Check for Matches") {
                let keywords = model.wordsOrPhrases
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                let lowercasedText = model.blockOfText.lowercased()
                
                model.matchedWords = keywords.filter { lowercasedText.contains($0) }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if !model.matchedWords.isEmpty {
                Text("Matched Words:")
                    .font(.headline)
                    .padding(.top)
                
                HighlightedTextView(text: model.blockOfText, highlights: model.matchedWords)
            } else {
                Text("No matches found yet.")
                    .italic()
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Check Text")
    }
}


struct HighlightedTextView: View {
    let text: String //scan data
    let highlights: [String] //matched words array, lists the words/phrases found in scan data
    
    var body: some View {
        Text(buildAttributedText())
            .lineLimit(nil)
    }

    func buildAttributedText() -> AttributedString {
        print("Original text: \(text)") //scan data
        var attributedText = AttributedString(text)
        
        for word in highlights {
            print("Searching for word: \(word)")
            
            let lowercasedText = text.lowercased()
            let lowercasedWord = word.lowercased()
            
            var searchRange: Range<String.Index>? = lowercasedText.startIndex..<lowercasedText.endIndex
            
            while let range = lowercasedText.range(of: lowercasedWord, options: .caseInsensitive, range: searchRange) {
                let nsRange = NSRange(range, in: text)
                if let attributedRange = Range(nsRange, in: attributedText) {
                    attributedText[attributedRange].foregroundColor = .red
                }
                searchRange = range.upperBound..<lowercasedText.endIndex
            }
        }
        
        return attributedText
    }
}



#Preview {
    ContentView()
}

