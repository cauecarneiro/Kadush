//
//  Form2.swift
//  Kadush
//
//  Created by Cauê Carneiro on 15/05/25.

import SwiftUI

struct FormatCard: View {
    let name: String
    let iconName: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // MARK: - Icon
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 32, height: 32)
            // MARK: - Text
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                // MARK: - Description
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct Formas: View {
    let formatModels: [FormatModel]
    @Binding var pageIndex: Int
    @Binding var selectedFormat: String?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("Em qual formato deseja visualizar?")
                    .font(.title3)
                Text("Selecione uma opção")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            
            
            LazyVStack(spacing: 16) {
                ForEach(formatModels) { model in
                    Button {
                        selectedFormat = model.formatType.rawValue
                        pageIndex = 5
                    } label: {
                        FormatCard(
                            name: model.name,
                            iconName: model.icon,
                            description: model.text
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 24)
                }
            }
        }
        .padding(.vertical, 32)
    }
}

#Preview {
    Formas(
        formatModels: [
            FormatModel(name: "Texto Corrido", icon: "text.document", text: "Formato tradicional de parágrafo, usado em artigos, ensaios e legendas mais longas.", formatType: .textoCorrido),
        ],
        pageIndex: .constant(1),
        selectedFormat: .constant("teste")
    )
}
