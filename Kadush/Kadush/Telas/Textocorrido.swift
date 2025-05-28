//
//  Textocorrido.swift
//  Kadush
//
//  Created by Cauê Carneiro on 17/05/25.
//





import SwiftUI
struct Textocorrido: View {
    @Binding var pageIndex: Int
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ExampleHeader(
                        title: "Texto Corrido",
                        iconName: "text.alignleft",
                        description: "Forma tradicional de parágrafo, usado em artigos, ensaios e legendas mais longas"
                    )
                }
                
                Section(header: Text("Estrutura do conteúdo")) {
                    ScrollView {
                        Text("""
                        Oi, sou eu e quero te mostrar um projeto incrível que estou desenvolvendo com muita dedicação. A ideia surgiu da vontade de resolver um problema real que muita gente enfrenta no dia a dia, de um jeito simples, eficiente e acessível.
                        
                        Ao longo do processo, usei ferramentas modernas, testei diferentes abordagens e fui ajustando cada detalhe com base em feedbacks e experimentação.
                        
                        Ainda estamos no começo, mas os resultados já mostram o potencial que essa solução tem. Estou animado com o que vem por aí — e quero muito te levar junto nessa jornada!
                        """)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical)
                    }
                    .frame(minHeight: 200)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
    Textocorrido(pageIndex: .constant(1))
}
