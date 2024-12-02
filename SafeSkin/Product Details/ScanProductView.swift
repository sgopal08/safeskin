//
//  ScanProductView.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/9/24.
//

import SwiftUI

struct ScanProductView: View {
    @State private var showScannerSheet = false
    @State private var texts: [ScanData] = []
    @State private var productName: String = ""
    @ObservedObject var profileModel: ProfileModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Product Name", text: $productName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
                    .padding(.top)
                                
                if texts.count > 0 {
                    
                    List {
                        ForEach($texts) { $text in
                            NavigationLink(
                                destination: ScannedProductDetailView(
                                    text: $text.content,
                                    productName: $text.productName,
                                    profileModel: profileModel),
                                label: {
                                    VStack(alignment: .leading) {
                                        Text(text.productName)
                                            .font(.headline)
                                    }
                                }
                            )
                        }
                        .onDelete(perform: deleteItem)
                    }
                } else {
                    Text("No Product Scanned").font(.title)
                    Text("Type in the product name and click the camera icon to scan a new product's ingredient label.")
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .navigationTitle("Scan Product")
            .navigationBarItems(trailing: Button(action: {
                self.showScannerSheet = true
            }, label: {
                Image(systemName: "camera.circle")
                    .font(.title)
                    .foregroundColor(Color("sage"))
            })
            .sheet(isPresented: $showScannerSheet, content: {
                self.makeScannerView()
            }))
        }
        .onAppear(perform: loadSavedData)
    }

    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(productName: productName.isEmpty ? "Unnamed Product" : productName, content: outputText)
                self.texts.insert(newScanData, at: 0)
                saveProduct(newScanData) // Save the new product
            }
            self.showScannerSheet = false
            self.productName = ""
        })
    }

    private func loadSavedData() {
        let decoder = JSONDecoder()
        var loadedTexts: [ScanData] = []

        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if key.starts(with: "savedProduct_"), let data = value as? Data {
                if let savedProduct = try? decoder.decode(SavedProduct.self, from: data) {
                    let newScanData = ScanData(productName: savedProduct.name, content: savedProduct.content)
                    if !loadedTexts.contains(where: { $0.productName == newScanData.productName }) {
                        loadedTexts.append(newScanData)
                    }
                }
            }
        }

        texts = loadedTexts
    }


    private func saveProduct(_ product: ScanData) {
        let encoder = JSONEncoder()
        let key = "savedProduct_\(product.productName)"

        if let data = try? encoder.encode(SavedProduct(name: product.productName, content: product.content)) {
            UserDefaults.standard.set(data, forKey: key)
        }

        if let index = texts.firstIndex(where: { $0.productName == product.productName }) {
            texts[index] = product
        } else {
            texts.insert(product, at: 0)
        }
    }


    private func deleteItem(at offsets: IndexSet) {
        let decoder = JSONDecoder()
        let keysToRemove = offsets.map { index in
            texts[index]
        }
        
        for keyToRemove in keysToRemove {
            if let savedKey = UserDefaults.standard.dictionaryRepresentation().first(where: { (_, value) in
                guard let data = value as? Data,
                      let product = try? decoder.decode(SavedProduct.self, from: data) else {
                    return false
                }
                return product == SavedProduct(name: keyToRemove.productName, content: keyToRemove.content)
            })?.key {
                UserDefaults.standard.removeObject(forKey: savedKey)
            }
        }

        texts.remove(atOffsets: offsets)
    }
}

struct SavedProduct: Codable, Equatable {
    var name: String
    var content: String
}

//#Preview {
//    ScanProductView(profileModel: ProfileModel)
//}
