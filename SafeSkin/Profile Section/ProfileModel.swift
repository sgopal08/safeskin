//
//  ProfileModel.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/7/24.
//


import Foundation
import SwiftUI

class ProfileModel: ObservableObject {
    @Published var scanData: [ScanData] = []

    @Published var name: String = "" {
        didSet { saveProfileData() }
    }
    @Published var skinType: String = "Dry" {
        didSet { saveProfileData() }
    }
    @Published var ethnicity: String = "Select" {
        didSet { saveProfileData() }
    }
    @Published var skinColor: Color = .clear {
        didSet { saveProfileData() }
    }
    @Published var allergies: String = "" {
        didSet {
            parseAllergies()
            saveProfileData()
        }
    }
    @Published var formatAllergies: [String] = [] // formatted allergies
    @Published var matches: [String] = [] // matched words

    private let userDefaultsKey = "UserProfile"

    init() {
        loadProfileData()
    }

    func parseAllergies() {
        formatAllergies = allergies.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
    }

    private func saveProfileData() {
        let profileData = ProfileData(
            name: name,
            skinType: skinType,
            ethnicity: ethnicity,
//            skinColor: UIColor(skinColor),
            allergies: allergies
        )
        if let encodedData = try? JSONEncoder().encode(profileData) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    private func loadProfileData() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedProfile = try? JSONDecoder().decode(ProfileData.self, from: savedData) {
            name = decodedProfile.name
            skinType = decodedProfile.skinType
            ethnicity = decodedProfile.ethnicity
//            skinColor = Color(decodedProfile.skinColor)
            allergies = decodedProfile.allergies
            parseAllergies()
        }
    }
}

struct ProfileData: Codable {
    var name: String
    var skinType: String
    var ethnicity: String
//    var skinColor: UIColor
    var allergies: String
}



