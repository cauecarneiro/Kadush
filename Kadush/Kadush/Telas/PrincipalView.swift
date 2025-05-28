import SwiftUI

struct PrincipalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var pageIndex: Int = 1
    @State private var selectedFormat: String?
    @State private var showExitConfirmation: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if pageIndex != 7 {
                    HStack {
                        Spacer()
                            .padding(.trailing, 30)
                    }
                    ProgressBar(page: $pageIndex)
                        .padding(.horizontal, 8)
                }
                Spacer()
                
                switch pageIndex {
                case 1:
                    videoApres(pageIndex: $pageIndex, tittle: "Você quer um roteiro para:", icons: [
                        IconModel(name: "Vídeo", icon: "camera"),
                        IconModel(name: "Apresentação", icon: "figure.wave"),
                    ])
                case 2:
                    videoApres(pageIndex: $pageIndex, tittle: "Qual modo deseja usar?", icons: [
                        IconModel(name: "Auto IA", icon: "brain"),
                        IconModel(name: "Escrita Guiada", icon: "pencil"),
                    ])
                case 3:
                    videoApres(pageIndex: $pageIndex, tittle: "Qual tom deseja usar?", icons: [
                        IconModel(name: "Amigável", icon: "face.smiling"),
                        IconModel(name: "Profissional", icon: "briefcase"),
                        IconModel(name: "Conciso", icon: "quotelevel"),
                    ])
                case 4:
                    Formas(formatModels: [
                        FormatModel(name: "Texto Corrido", icon: "text.document", text: "Formato tradicional de parágrafo, usado em artigos, ensaios e legendas mais longas.", formatType: .textoCorrido),
                        
                        FormatModel(name: "Gancho-Desenvolvimento-CTA", icon: "megaphone", text: "Formato muito utilizado em redes sociais, focado em estratégias de engajamento", formatType: .ganchoCTA),
                        
                        FormatModel(name: "Checkpoints", icon: "checkmark.circle", text: "Exemplo de texto direto em forma de tópicos. Muito usado para dicas, passo a passo ou resumo", formatType: .checkpoints)
                    ], pageIndex: $pageIndex, selectedFormat: $selectedFormat)
                    
                case 5:
                    if selectedFormat == "checkpoints"{
                        CheckPoints(pageIndex: $pageIndex)
                    } else if selectedFormat == "textoCorrido" {
                        Textocorrido(pageIndex: $pageIndex)
                    } else if selectedFormat == "ganchoCTA" {
                        GanchoMode(pageIndex: $pageIndex)
                    } else {
                        Text("Tela não implementada")
                    }
                    
                case 6:
                    Palavras(pageIndex: $pageIndex)
                    
                case 7:
                    RoteiroGerado(pageIndex: $pageIndex)
                    
                    
//                case 8:
//                    RoteiroGerado(pageIndex: $pageIndex)
                default:
                    Text("Default")
                }
                Spacer()
            }
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
        .alert("Tem certeza que deseja sair?", isPresented: $showExitConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Sim", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    PrincipalView()}
