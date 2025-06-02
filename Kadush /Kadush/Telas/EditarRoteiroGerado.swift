import SwiftUI

struct EditarRoteiroGerado: View {
    @State var roteiro: String
    var onSalvar: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Roteiro Gerado")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            Text("Você pode editar o roteiro abaixo antes de salvar.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if roteiro.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView("Carregando roteiro...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                Spacer()
            } else {
                TextEditor(text: $roteiro)
                    .font(.body)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .frame(minHeight: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                Spacer()
                Button(action: {
                    onSalvar(roteiro)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Salvar e Voltar para Home")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.bottom)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .hideKeyboardOnTap()
    }
}

#Preview {
    EditarRoteiroGerado(roteiro: "Exemplo de roteiro gerado pela IA.") { _ in }
} 