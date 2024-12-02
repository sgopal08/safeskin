//
//  HighlightIfRed.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/19/24.
//

import SwiftUI

struct HighlightIfRedView: View {
    let text: String
    let allergies: String
    
    var body: some View {
        let highlights = allergies
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        
        Text(buildAttributedText(highlights: highlights))
            .lineLimit(nil)
    }

    private func buildAttributedText(highlights: [String]) -> AttributedString {
        print("Original text: \(text)")
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



