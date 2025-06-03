//
//  CheckpointRow.swift
//  Kadush
//
//  Created by Cauê Carneiro on 17/05/25.
//

import SwiftUI

// Componente visual para exibir um item de checkpoint (tópico) com ícone
struct CheckpointRow: View {
    // Texto do checkpoint
    var text: String
    
    var body: some View {
        HStack {
            // Ícone circular azul
            Image(systemName: "circle.fill")
                .foregroundColor(.blue)
                .font(.system(size: 10))
                .opacity(0.7)
            // Texto do checkpoint
            Text(text)
        }
        .padding(.bottom, 5)
    }
}
