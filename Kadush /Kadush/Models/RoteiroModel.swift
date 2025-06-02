import Foundation
import SwiftData

// Modelo principal do roteiro, persistido com SwiftData
@Model
final class RoteiroModel {
    var tipoConteudo: String
    var modoCriacao: String
    
    var tomRoteiro: String
    var formatoApresentacao: String
    var temaPrincipal: String
    var palavrasChave: [String]
    var resumo: String
    var duracao: Int
    
    var dataCriacao: Date
    var dataModificacao: Date
    var excluido: Bool = false
    
    var roteiroCompleto: String = "" // Novo campo para o roteiro gerado completo
    
    // Inicializador padrão com valores opcionais
    init(
        tipoConteudo: String = "",
        modoCriacao: String = "",
        tomRoteiro: String = "",
        formatoApresentacao: String = "",
        temaPrincipal: String = "",
        palavrasChave: [String] = [],
        resumo: String = "",
        duracao: Int = 0
    ) {
        self.tipoConteudo = tipoConteudo
        self.modoCriacao = modoCriacao
        self.tomRoteiro = tomRoteiro
        self.formatoApresentacao = formatoApresentacao
        self.temaPrincipal = temaPrincipal
        self.palavrasChave = palavrasChave
        self.resumo = resumo
        self.duracao = duracao
        self.dataCriacao = Date()
        self.dataModificacao = Date()
    }
    
    // Atualiza a data de modificação sempre que algum campo é alterado
    func atualizarDataModificacao() {
        self.dataModificacao = Date()
    }
} 
