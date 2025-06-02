import SwiftUI

// Componente visual para exibir um roteiro salvo em formato de célula/lista
struct CelulaRoteiro: View {
    // Título do roteiro
    var title: String
    // Descrição/resumo do roteiro
    var description: String
    // Data da última edição
    var editedDate: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 6) {
                // Título em negrito
                Text(title)
                    .font(.system(.headline, weight: .bold))
                // Descrição em cinza
                Text(description)
                    .font(.system(.subheadline))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)
                // Data da última edição
                Text(editedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(12)
        }
    }
}


