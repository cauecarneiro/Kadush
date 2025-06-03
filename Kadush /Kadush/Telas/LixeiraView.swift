import SwiftUI

struct LixeiraView: View {
    @State private var roteirosExcluidos: [RoteiroModel] = []
    @State private var mostrarAlertaExclusao = false
    @State private var roteiroParaExcluir: RoteiroModel? = nil
    @State private var mostrarAlertaExclusaoTodos = false
    var onClose: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                if roteirosExcluidos.isEmpty {
                    Spacer()
                    Text("Nenhum roteiro na lixeira.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(roteirosExcluidos, id: \.dataCriacao) { roteiro in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(roteiro.temaPrincipal)
                                    .font(.headline)
                                Text(roteiro.resumo)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                Text("Excluído em " + formatarData(roteiro.dataModificacao))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Button("Restaurar") {
                                    restaurarRoteiro(roteiro)
                                }
                                .foregroundColor(.blue)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    roteiroParaExcluir = roteiro
                                    mostrarAlertaExclusao = true
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: deletarPermanentemente)
                    }
                    .listStyle(PlainListStyle())
                    Button("Excluir todos permanentemente", role: .destructive) {
                        mostrarAlertaExclusaoTodos = true
                    }
                    .padding()
                }
            }
            .navigationTitle("Lixeira")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") { onClose() }
                }
            }
            .alert("Deseja excluir permanentemente este roteiro?", isPresented: $mostrarAlertaExclusao) {
                Button("Cancelar", role: .cancel) {}
                Button("Excluir", role: .destructive) {
                    if let roteiro = roteiroParaExcluir {
                        RoteiroService.shared.deletarRoteiroPermanentemente(roteiro)
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        carregarRoteirosExcluidos()
                    }
                    roteiroParaExcluir = nil
                }
            } message: {
                Text("Esta ação não pode ser desfeita.")
            }
            .alert("Deseja excluir todos os roteiros da lixeira permanentemente?", isPresented: $mostrarAlertaExclusaoTodos) {
                Button("Cancelar", role: .cancel) {}
                Button("Excluir todos", role: .destructive) {
                    RoteiroService.shared.deletarTodosExcluidosPermanentemente()
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    carregarRoteirosExcluidos()
                }
            } message: {
                Text("Esta ação não pode ser desfeita.")
            }
        }
        .onAppear(perform: carregarRoteirosExcluidos)
    }
    
    func carregarRoteirosExcluidos() {
        roteirosExcluidos = RoteiroService.shared.fetchRoteirosExcluidos()
    }
    
    func restaurarRoteiro(_ roteiro: RoteiroModel) {
        roteiro.excluido = false
        roteiro.atualizarDataModificacao()
        RoteiroService.shared.addRoteiro(roteiro)
        carregarRoteirosExcluidos()
    }
    
    func deletarPermanentemente(at offsets: IndexSet) {
        offsets.forEach { index in
            let roteiro = roteirosExcluidos[index]
            RoteiroService.shared.deletarRoteiroPermanentemente(roteiro)
        }
        carregarRoteirosExcluidos()
    }
    
    func formatarData(_ data: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: data, relativeTo: Date())
    }
} 