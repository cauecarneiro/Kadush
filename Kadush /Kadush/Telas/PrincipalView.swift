import SwiftUI
import SwiftData

// Tela principal do fluxo de criação de roteiro (wizard)
struct PrincipalView: View {
    // Controla a navegação de retorno
    @Environment(\.presentationMode) var presentationMode
    // Contexto do SwiftData para persistência
    @Environment(\.modelContext) private var modelContext
    // ViewModel responsável pelo roteiro atual
    @State private var viewModel: RoteiroViewModel? = nil
    // Índice da etapa atual do fluxo
    @State var pageIndex: Int = 1
    // Formato selecionado pelo usuário
    @State private var selectedFormat: String?
    // Controla exibição do alerta de saída
    @State private var showExitConfirmation: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra de progresso (não exibe na última etapa)
                if pageIndex != 7 {
                    HStack {
                        Spacer()
                            .padding(.trailing, 30)
                    }
                    ProgressBar(page: $pageIndex)
                        .padding(.horizontal, 8)
                }
                Spacer()
                // Switch para exibir a tela/componentes de cada etapa
                switch pageIndex {
                case 1:
                    // Etapa 1: Seleção do tipo de conteúdo
                    videoApres(pageIndex: $pageIndex, tittle: "Você quer um roteiro para:", icons: [
                        IconModel(name: "Vídeo", icon: "camera"),
                        IconModel(name: "Apresentação", icon: "figure.wave"),
                    ])
                    // Ao avançar para a etapa 2, cria um novo roteiro
                    .onChange(of: pageIndex) { _, newValue in
                        if newValue == 2 {
                            viewModel?.criarNovoRoteiro()
                        }
                    }

                case 2:
                    // Etapa 3: Seleção do tom do roteiro
                    videoApres(pageIndex: $pageIndex, tittle: "Qual tom deseja usar?", icons: [
                        IconModel(name: "Amigável", icon: "face.smiling"),
                        IconModel(name: "Profissional", icon: "briefcase"),
                        IconModel(name: "Conciso", icon: "quotelevel"),
                    ])
                case 3:
                    // Etapa 4: Seleção do formato do roteiro
                    Formas(formatModels: [
                        FormatModel(name: "Texto Corrido", icon: "text.document", text: "Formato tradicional de parágrafo, usado em artigos, ensaios e legendas mais longas.", formatType: .textoCorrido),
                        FormatModel(name: "Gancho-Desenvolvimento-CTA", icon: "megaphone", text: "Formato muito utilizado em redes sociais, focado em estratégias de engajamento", formatType: .ganchoCTA),
                        FormatModel(name: "Checkpoints", icon: "checkmark.circle", text: "Exemplo de texto direto em forma de tópicos. Muito usado para dicas, passo a passo ou resumo", formatType: .checkpoints)
                    ], pageIndex: $pageIndex, selectedFormat: $selectedFormat)
                case 4:
                    // Etapa 5: Tela específica para o formato selecionado
                    if selectedFormat == "checkpoints"{
                        CheckPoints(pageIndex: $pageIndex)
                    } else if selectedFormat == "textoCorrido" {
                        Textocorrido(pageIndex: $pageIndex)
                    } else if selectedFormat == "ganchoCTA" {
                        GanchoMode(pageIndex: $pageIndex)
                    } else {
                        Text("Tela não implementada")
                    }
                case 5:
                    // Etapa 6: Preenchimento de tema, palavras-chave, resumo e duração
                    if let viewModel = viewModel {
                        Palavras(pageIndex: $pageIndex, viewModel: viewModel)
                    }
                case 6:
                    // Etapa 7: Exibição do roteiro gerado e botão para gerar com IA
                    if let viewModel = viewModel {
                        RoteiroGerado(pageIndex: $pageIndex, viewModel: viewModel, onFinalizar: {
                            presentationMode.wrappedValue.dismiss()
                        })
                        .onChange(of: viewModel.roteiroGerado) { _, newValue in
                            if let texto = newValue, !texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                pageIndex = 8
                            }
                        }
                    }
                case 7:
                    // Etapa 8: Edição e visualização do roteiro gerado
                    if let viewModel = viewModel {
                        EditarRoteiroGerado(roteiro: viewModel.roteiroGerado ?? "") { textoEditado in
                            viewModel.atualizarResumo(textoEditado)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                default:
                    Text("Default")
                }
                Spacer()
            }
            // ToolBar com botões de voltar e fechar
            .toolbar {
                if pageIndex != 7 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Voltar") {
                            if pageIndex > 1 {
                                pageIndex -= 1
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Fechar") {
                            showExitConfirmation = true
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        // Alerta de confirmação ao tentar sair
        .alert("Tem certeza que deseja sair?", isPresented: $showExitConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Sim", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        // Inicializa o ViewModel com o contexto do ambiente
        .onAppear {
            if viewModel == nil {
                viewModel = RoteiroViewModel(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    PrincipalView()
}
