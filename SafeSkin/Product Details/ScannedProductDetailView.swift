//
//  ScannedProductDetailView.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/12/24.
//

import SwiftUI

struct ScannedProductDetailView: View {
    @Binding var text: String
    @Binding var productName: String
    @ObservedObject var profileModel: ProfileModel
    @State private var isSaved = false
    @State private var isEditing = false 
    
    var body: some View {
        VStack {
            Text(productName)
                .padding()
                .font(.title)
            
            ScrollView {
                if !profileModel.allergies.isEmpty {
                    HighlightIfRedView(text: text, allergies: profileModel.allergies)
                        .padding()
                        .border(Color.gray, width: 1)
                        .cornerRadius(8)
                } else {
                    Text("No allergies specified.")
                        .padding()
                        .border(Color.gray, width: 1)
                        .cornerRadius(8)
                }
            }
            .frame(minHeight: 300)
            
            HStack(spacing: 16) {
                Button(action: saveProductDetails) {
                    Text(isSaved ? "Saved" : "Save Product")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isSaved ? Color("sage") : Color("sage"))
                        .cornerRadius(8)
                }
                .disabled(isSaved)
                
                Button(action: { isEditing = true }) {
                    Text("Edit Text")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationTitle("Product Details")
        .sheet(isPresented: $isEditing) {
            EditTextView(text: $text, onSave: {
                isSaved = false 
                isEditing = false
            })
        }
    }
    
    private func saveProductDetails() {
        let savedProduct = SavedProduct(name: productName, content: text)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedProduct) {
            let key = "savedProduct_\(productName)"
            UserDefaults.standard.set(encoded, forKey: key)
        }

        if let index = profileModel.scanData.firstIndex(where: { $0.productName == productName }) {
            profileModel.scanData[index].content = text
        }


        isSaved = true
    }

    private func saveToUserDefaults(_ product: SavedProduct) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(product) {
            UserDefaults.standard.set(encoded, forKey: "savedProduct_\(productName)")
        }
    }
}




//#Preview {
//    ScannedProductDetailView(text: "", productName: productName )
//}
