//
//  progressBar.swift
//  Kadush
//
//  Created by Cauê Carneiro on 14/05/25.
//

import SwiftUI

// Componente visual que exibe a barra de progresso das etapas do fluxo de criação do roteiro
struct ProgressBar: View {
    // Índice da página/etapa atual (ligado ao fluxo principal)
    @Binding var page: Int
    
    var body: some View {
        HStack {
            // Cria 6 retângulos representando as etapas
            ForEach(1...6, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    // Destaca as etapas já concluídas em azul, as demais em cinza
                    .foregroundStyle(index <= page ? .blue : .lighgray)
                    .frame(height: 2)
                    .padding(.horizontal, 2)
                    // Animação suave ao mudar de etapa
                    .animation(.linear(duration: 0.3), value: page)
            }
        }
    }
}
