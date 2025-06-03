import SwiftUI

struct GanchoMode: View {
    @Binding var pageIndex: Int
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ExampleHeader(
                        title: "Gancho-Desenvolvimento-CTA",
                        iconName: "megaphone.fill",
                        description: "Formato muito utilizado em redes sociais, focado em estratégias de engajamento"
                    )
                }
                
                Section(header: Text("Exemplo visual da estrutura").font(.subheadline).foregroundColor(.secondary)) {
                    // Exemplo visual agrupado
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gancho:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Você já teve uma ideia e pensou: isso pode realmente ajudar muita gente?")
                            .foregroundColor(.primary)
                        Text("Desenvolvimento:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Foi exatamente assim que esse projeto começou. A partir de um problema comum, desenvolvi uma solução prática, usando ferramentas atuais e muitos testes ao longo do caminho.")
                            .foregroundColor(.primary)
                        Text("CTA (Chamada para a ação):")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Se você curte inovação e quer acompanhar essa jornada, fica comigo e vamos construir algo grande juntos!")
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemBackground))
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Seguinte") {
                            pageIndex += 1
                        }
                        .padding()
                    }
                }
            )
        }
    }
}

#Preview {
    GanchoMode(pageIndex: .constant(1))
}
