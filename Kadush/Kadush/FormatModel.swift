//
//  FormatModel.swift
//  Kadush
//
//  Created by Cauê Carneiro on 16/05/25.
//


import SwiftUI

struct FormatModel: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let text: String
    let formatType: FormatType
}

enum FormatType: String {
    case textoCorrido
    case ganchoCTA
    case checkpoints
}
