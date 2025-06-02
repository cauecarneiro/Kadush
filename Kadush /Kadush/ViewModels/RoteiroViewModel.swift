import Foundation
import SwiftData
import SwiftUI

// ViewModel responsável por gerenciar o estado do roteiro atual e persistência com SwiftData
class RoteiroViewModel: ObservableObject {
    // Contexto do SwiftData para manipulação dos dados persistentes
    private var modelContext: ModelContext
    // Roteiro atualmente sendo criado/editado
    @Published var roteiroAtual: RoteiroModel?
    
    // Estado da geração do roteiro
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?
    @Published var roteiroGerado: String?
    
    // Inicializa o ViewModel com o contexto do banco de dados
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // Cria um novo roteiro e insere no contexto
    func criarNovoRoteiro() {
        roteiroAtual = RoteiroModel()
        modelContext.insert(roteiroAtual!)
    }
    
    // Atualiza o tipo de conteúdo (ex: Vídeo ou Apresentação)
    func atualizarTipoConteudo(_ tipo: String) {
        roteiroAtual?.tipoConteudo = tipo
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza o modo de criação (ex: Auto IA ou Escrita Guiada)
    func atualizarModoCriacao(_ modo: String) {
        roteiroAtual?.modoCriacao = modo
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza o tom do roteiro (ex: Amigável, Profissional, Conciso)
    func atualizarTomRoteiro(_ tom: String) {
        roteiroAtual?.tomRoteiro = tom
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza o formato da apresentação (ex: Texto Corrido, Gancho-CTA, Checkpoints)
    func atualizarFormatoApresentacao(_ formato: String) {
        roteiroAtual?.formatoApresentacao = formato
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza o tema principal do roteiro
    func atualizarTemaPrincipal(_ tema: String) {
        roteiroAtual?.temaPrincipal = tema
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza as palavras-chave do roteiro
    func atualizarPalavrasChave(_ palavras: [String]) {
        roteiroAtual?.palavrasChave = palavras
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza o resumo do roteiro
    func atualizarResumo(_ resumo: String) {
        roteiroAtual?.resumo = resumo
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Atualiza a duração do roteiro (em minutos)
    func atualizarDuracao(_ duracao: Int) {
        roteiroAtual?.duracao = duracao
        roteiroAtual?.atualizarDataModificacao()
    }
    
    // Salva as alterações do roteiro no banco de dados
    func salvarRoteiro() {
        guard let roteiro = roteiroAtual else { return }
        do {
            try modelContext.save()
        } catch {
            errorMessage = "Erro ao salvar roteiro: \(error.localizedDescription)"
        }
    }
    
    // Carrega um roteiro existente para edição
    func carregarRoteiro(_ roteiro: RoteiroModel) {
        roteiroAtual = roteiro
    }
    
    // Deleta um roteiro do banco de dados
    func deletarRoteiro(_ roteiro: RoteiroModel) {
        modelContext.delete(roteiro)
        do {
            try modelContext.save()
        } catch {
            print("Erro ao deletar roteiro: \(error)")
        }
    }
    
    @MainActor
    func gerarRoteiroComIA() async {
        guard let roteiro = roteiroAtual else {
            errorMessage = "Nenhum roteiro selecionado"
            print("[DEBUG] Nenhum roteiro selecionado")
            return
        }
        
        isGenerating = true
        errorMessage = nil
        roteiroGerado = nil
        print("[DEBUG] Iniciando geração de roteiro com IA...")
        
        do {
            let roteiroGerado = try await OpenAIService.shared.gerarRoteiro(
                tipoConteudo: roteiro.tipoConteudo,
                modoCriacao: roteiro.modoCriacao,
                tomRoteiro: roteiro.tomRoteiro,
                formatoApresentacao: roteiro.formatoApresentacao,
                temaPrincipal: roteiro.temaPrincipal,
                palavrasChave: roteiro.palavrasChave,
                resumo: roteiro.resumo,
                duracao: roteiro.duracao
            )
            print("[DEBUG] ROTEIRO GERADO PELA IA:\n\(roteiroGerado)")
            self.roteiroGerado = roteiroGerado
            roteiro.roteiroCompleto = roteiroGerado
            print("[DEBUG] Estado atualizado - roteiroGerado: \(String(describing: self.roteiroGerado))")
        } catch {
            errorMessage = "Erro ao gerar roteiro: \(error.localizedDescription)"
            print("[DEBUG] ERRO AO GERAR ROTEIRO: \(error.localizedDescription)")
        }
        
        isGenerating = false
        print("[DEBUG] Geração finalizada - isGenerating: \(isGenerating)")
    }
} 
