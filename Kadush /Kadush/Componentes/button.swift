//lalala
//  button.swift
//  Kadush
//
//  Created by Cauê Carneiro on 14/05/25.
//
import SwiftUI

// Componente de botão customizado usado para seleção de opções visuais no app
struct ButtonSelect: View {
    // Nome do botão (texto exibido)
    var nameButton: String
    // Nome do SF Symbol do ícone
    var icon: String
    var body: some View {
        ZStack{
            // Fundo arredondado do botão
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.darkgray)
                .frame(width: 147, height: 100)
            // Conteúdo do botão: ícone + texto
            HStack{
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(nameButton)
                    .foregroundColor(.white)
            }
        }
    }
}
