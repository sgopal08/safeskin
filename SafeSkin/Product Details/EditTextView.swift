//
//  EditTextView.swift
//  SafeSkin
//
//  Created by Sanjana G on 12/1/24.
//

import SwiftUI

struct EditTextView: View {
    @Binding var text: String
    var onSave: () -> Void 
    
    var body: some View {
        VStack {
            Text("Edit Product Text")
                .font(.title2)
                .padding(.bottom, 16)
            
            TextEditor(text: $text)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(8)
                .frame(minHeight: 300)
            
            Button(action: onSave) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("sage"))
                    .cornerRadius(8)
            }
            .padding(.top, 16)
        }
        .padding()
    }
}


//#Preview {
//    EditTextView()
//}
