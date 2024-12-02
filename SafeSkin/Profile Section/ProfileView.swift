//
//  ProfileView.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/7/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileModel: ProfileModel
    @State private var isSubmitted = false
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            Form {
                // Display the My Info section if submitted
                if isSubmitted && !isEditing {
                    Section(header: Text("My Info")) {
                        Text("Name: \(profileModel.name)")
                        Text("Skin Type: \(profileModel.skinType)")
                        Text("Race/Ethnicity: \(profileModel.ethnicity)")
                        HStack {
                            Text("Skin Color: ")
                            Circle()
                                .fill(profileModel.skinColor)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                        }
                        
                        Text("Ingredients: \(profileModel.allergies)")
                    }

                    Button(action: {
                        // Set isEditing to true to show the "Personal Information" section
                        isEditing = true
                        // Reset the submitted state to allow for re-editing
                        isSubmitted = false
                    }) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                
                // Display the Personal Information section if not submitted or while editing
                if !isSubmitted || isEditing {
                    Section(header: Text("Personal Information")) {
                        TextField("Name", text: $profileModel.name)
                        
                        Picker("Skin Type", selection: $profileModel.skinType) {
                            ForEach(["Dry", "Oily", "Combination", "Sensitive"], id: \.self) { Text($0) }
                        }

                        VStack(alignment: .leading) {
                            Text("Skin Color")
                                .font(.headline)
                            SkinColorPicker(selectedColor: $profileModel.skinColor)
                        }
                        
                        VStack{
                            Text("Allergens or Ingredient:")
                                .multilineTextAlignment(.leading)
                                .bold()
                                .padding(.top, 15)
                            TextField("Enter (Comma Separated)", text: $profileModel.allergies)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 350)
                        }
                        
                        Button(action: {
                            profileModel.parseAllergies()
                            // When submitted, update isSubmitted and reset isEditing to false
                            isSubmitted = true
                            isEditing = false  // Ensure editing mode is turned off after submission
                            print("Parsed Allergies: \(profileModel.formatAllergies)")
                            print("Allergies Text: \(profileModel.allergies)")
                        }) {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}


struct SkinColorPicker: View {
    @Binding var selectedColor: Color
    
    let skinColors: [Color] = [
        .init(red: 1.0, green: 0.97, blue: 0.90),
        .init(red: 1.0, green: 0.95, blue: 0.85),
        .init(red: 1.0, green: 0.87, blue: 0.77),
        .init(red: 0.96, green: 0.76, blue: 0.65),
        .init(red: 0.87, green: 0.60, blue: 0.47),
        .init(red: 0.80, green: 0.55, blue: 0.43),
        .init(red: 0.69, green: 0.43, blue: 0.33),
        .init(red: 0.60, green: 0.40, blue: 0.30),
        .init(red: 0.53, green: 0.31, blue: 0.21),
        .init(red: 0.47, green: 0.27, blue: 0.19),
        .init(red: 0.40, green: 0.24, blue: 0.16)
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select your skin color:")
                .font(.subheadline)
                .padding(.bottom, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(skinColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                selectedColor = color
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .shadow(radius: selectedColor == color ? 4 : 0)
                    }
                }
            }
            .padding(.vertical)
            
            HStack {
                Text("Your Skin:")
                Circle()
                    .fill(selectedColor)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            }
            .font(.footnote)
            .padding(.top, 8)
        }
    }
}



#Preview {
    let mockProfileModel = ProfileModel()
    mockProfileModel.name = "Sanjana"
    mockProfileModel.skinType = "Combination"
    mockProfileModel.skinColor = .init(red: 1.0, green: 0.87, blue: 0.77)
    mockProfileModel.allergies = "Parabens"
    
    return ProfileView(profileModel: mockProfileModel)
}
