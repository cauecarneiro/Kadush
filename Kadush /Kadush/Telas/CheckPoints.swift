import SwiftUI

struct CheckPoints: View {
    @Binding var pageIndex: Int
    var body: some View {
        NavigationStack {
            Form {
                //Seção de introdução com um exemplo ampliado do botão que foi clicado
                Section {
                    ExampleHeader(
                        title: "Checkpoints",
                        iconName: "checkmark.circle",
                        description: "Exemplo de texto direto em forma de tópicos. Muito usado para dicas, passo a passo ou resumo"
                    )
                }
                //Seção de exemplo de texto em estilo checkpoints
                Section(header: Text("Exemplo visual da estrutura").font(.subheadline).foregroundColor(.secondary)) {
                    CheckpointRow(text: "Introdução: Oi, sou eu e quero te mostrar um projeto incrível que estou desenvolvendo. Vem ver!")
                    CheckpointRow(text: "Desenvolvimento 1: Esse projeto nasceu da vontade de resolver um problema real de forma simples e eficiente.")
                    CheckpointRow(text: "Desenvolvimento 2: Foram usadas ferramentas modernas e muito teste prático até chegar nesse resultado.")
                    CheckpointRow(text: "Finalização: É só o começo, mas já dá pra ver o impacto que ele pode causar. Vamos juntos nessa!")
                }
            }
            //overlay adiciona uma camada visual extra por cima da tela inteira, no caso coloca um botão de seguinte
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
    CheckPoints(pageIndex: .constant(1))
}
