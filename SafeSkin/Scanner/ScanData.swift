//
//  ScanData.swift
//  Final Project Apprenticeship
//
//  Created by Sanjana G on 11/9/24.
//

import Foundation
//for saving product name and contents
struct ScanData: Identifiable {
    let id = UUID()
    var productName: String
    var content: String
}

