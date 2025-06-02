//
//  IconModel.swift
//  Kadush
//
//  Created by Cauê Carneiro on 14/05/25.
//

import SwiftUI

// Modelo para representar um ícone customizado usado nas opções do app
struct IconModel  {
    // Nome do ícone (ex: Vídeo, Apresentação, etc)
    var name: String
    // Nome do SF Symbol associado ao ícone
    var icon: String
    // Identificador único para cada ícone
    var id = UUID()
}
