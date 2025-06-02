//
//  FormatModel.swift
//  Kadush
//
//  Created by Cauê Carneiro on 16/05/25.
//


import SwiftUI

// Modelo que representa um formato de roteiro disponível no app
struct FormatModel: Identifiable {
    // Identificador único para cada formato
    let id = UUID()
    // Nome do formato (ex: Texto Corrido, Gancho-CTA, Checkpoints)
    let name: String
    // Nome do ícone SF Symbol associado ao formato
    let icon: String
    // Descrição do formato
    let text: String
    // Tipo do formato (enum abaixo)
    let formatType: FormatType
}

// Enum que define os tipos de formato disponíveis
enum FormatType: String {
    case textoCorrido      // Formato tradicional de parágrafo
    case ganchoCTA         // Formato com gancho, desenvolvimento e call-to-action
    case checkpoints       // Formato em tópicos/checkpoints
}
