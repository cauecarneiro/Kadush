import SwiftUI

struct DetalheRoteiroView: View {
    var roteiro: RoteiroModel
    @State private var texto: String
    var onSalvar: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    init(roteiro: RoteiroModel, onSalvar: @escaping () -> Void) {
        self.roteiro = roteiro
        self._texto = State(initialValue: roteiro.roteiroCompleto)
        self.onSalvar = onSalvar
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Roteiro Gerado")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            Text("Você pode editar o roteiro abaixo.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            TextEditor(text: $texto)
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
                roteiro.roteiroCompleto = texto
                roteiro.atualizarDataModificacao()
                RoteiroService.shared.addRoteiro(roteiro)
                onSalvar()
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Salvar e Voltar")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.bottom)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .hideKeyboardOnTap()
    }
} 