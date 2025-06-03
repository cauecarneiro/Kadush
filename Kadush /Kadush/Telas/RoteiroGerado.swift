//
//  Untitled.swift
//  Kadush
//
//  Created by Cauê Carneiro on 24/05/25.
//

import SwiftUI
import UIKit
import SwiftData

// Tela final que exibe todos os dados do roteiro preenchido pelo usuário
struct RoteiroGerado: View {
    // Índice da etapa atual do fluxo (binding para navegação)
    @Binding var pageIndex: Int
    // ViewModel responsável pelo roteiro atual
    @ObservedObject var viewModel: RoteiroViewModel
    
    @State private var mostrarSheetRoteiro = false
    @Environment(\.presentationMode) var presentationMode
    var onFinalizar: (() -> Void)? = nil // Novo callback opcional
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                if let roteiro = viewModel.roteiroAtual {
                    // Tema principal em destaque
                    VStack(alignment: .leading, spacing: 12) {
                        Text(roteiro.temaPrincipal)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Divider()
                        // Palavras-chave em chips
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Palavras-chave")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            FlowLayout(spacing: 8) {
                                ForEach(roteiro.palavrasChave, id: \.self) { palavra in
                                    Text(palavra)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(15)
                                }
                            }
                        }
                        Divider()
                        // Resumo e duração lado a lado
                        HStack(alignment: .top, spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Resumo")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text(roteiro.resumo)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Duração")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                HStack(spacing: 6) {
                                    Image(systemName: "clock")
                                        .foregroundColor(.blue)
                                    Text("\(roteiro.duracao) min")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    // Botão para gerar roteiro com IA
                    VStack(alignment: .leading, spacing: 12) {
                        if viewModel.isGenerating {
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Gerando roteiro...")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        } else if let error = viewModel.errorMessage {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.title)
                                    .foregroundColor(.red)
                                Text(error)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        } else {
                            VStack(spacing: 16) {
                                Button(action: {
                                    Task {
                                        await viewModel.gerarRoteiroComIA()
                                        if let texto = viewModel.roteiroGerado, !texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            mostrarSheetRoteiro = true
                                        }
                                    }
                                }) {
                                    Text("Gerar Roteiro")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.isGenerating ? Color.gray : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .disabled(viewModel.isGenerating)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        }
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
        .sheet(isPresented: $mostrarSheetRoteiro) {
            if let roteiroGerado = viewModel.roteiroGerado, let roteiro = viewModel.roteiroAtual {
                RoteiroGeradoSheetView(roteiro: roteiroGerado, dataCriacao: roteiro.dataCriacao) {
                    viewModel.salvarRoteiro()
                    mostrarSheetRoteiro = false
                    onFinalizar?() // Chama o callback para finalizar o fluxo
                }
            }
        }
    }
}

// Sheet com título e data/hora
struct RoteiroGeradoSheetView: View {
    let roteiro: String
    let dataCriacao: Date
    let onSalvar: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Roteiro Gerado")
                    .font(.title)
                    .bold()
                Text("Criado em: \(dataCriacao.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Divider()
                ScrollView {
                    Text(roteiro)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .font(.body)
                }
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        ShareLink(
                            item: roteiro,
                            subject: Text("Roteiro Gerado"),
                            message: Text("Confira este roteiro gerado pelo Kadush")
                        ) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button("Salvar") {
                            onSalvar()
                        }
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
}

// Componente para exibir uma seção de informação do roteiro
struct InfoSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .foregroundColor(.secondary)
        }
    }
}

// Layout customizado para exibir chips de palavras-chave em múltiplas linhas
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        let width = proposal.width ?? .infinity
        var offsets: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxY: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > width {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            offsets.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxY = max(maxY, currentY + rowHeight)
        }
        
        return (offsets, CGSize(width: width, height: maxY))
    }
}

// Extensão para esconder o teclado ao tocar fora dos campos (caso precise em outras telas)
extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    RoteiroGerado(pageIndex: .constant(7), viewModel: RoteiroViewModel(modelContext: try! ModelContainer(for: RoteiroModel.self).mainContext))
}
