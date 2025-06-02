import Foundation
import OpenAI

class OpenAIService {
    static let shared = OpenAIService()
    private var client: OpenAI?
    
    private init() {
        // Chave da API da OpenAI - Substitua pela sua chave
        let apiKey = "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"
        
        // Inicializa o cliente OpenAI com a chave da API
        self.client = OpenAI(apiToken: apiKey)
    }
    
    func gerarRoteiro(
        tipoConteudo: String,
        modoCriacao: String,
        tomRoteiro: String,
        formatoApresentacao: String,
        temaPrincipal: String,
        palavrasChave: [String],
        resumo: String,
        duracao: Int
    ) async throws -> String {
        guard let client = client else {
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cliente OpenAI não inicializado"])
        }
        
        // Construir o prompt baseado nos dados do roteiro
        let prompt = """
        Você é um roteirista profissional com foco em storytelling envolvente e original. Com base nas informações abaixo, desenvolva um roteiro totalmente alinhado às especificações:

        Tipo de conteúdo: \(tipoConteudo)  
        Modo de criação: \(modoCriacao)  
        Tom: \(tomRoteiro)  
        Formato de apresentação: \(formatoApresentacao)  
        Tema principal: \(temaPrincipal)  
        Palavras-chave: \(palavrasChave.joined(separator: ", "))  
        Resumo da ideia: \(resumo)  
        Duração estimada: \(duracao) minutos

        Regras importantes:
        - Estruture com introdução, desenvolvimento e conclusão.  
        - Utilize todas as palavras-chave de forma natural ao longo do roteiro.  
        - Adote o tom indicado de forma coerente.  
        - Respeite a duração, ajustando o ritmo e densidade do conteúdo.  
        - NÃO utilize asteriscos (*), negrito, itálico, sublinhado, emojis, bullets ou qualquer outro símbolo visual ou formatação Markdown.  
        - O roteiro deve ser entregue como texto corrido, limpo e com boa fluidez visual, como se tivesse sido escrito por um roteirista humano experiente.  
        - Evite repetições, exageros e clichês.

        Crie um texto impactante, bem escrito e pronto para uso real.
        """
        
        let query = ChatQuery(
            messages: [ChatQuery.ChatCompletionMessageParam(role: .user, content: prompt)!],
            model: .gpt4_o_mini
        )
        
        let result = try await client.chats(query: query)
        
        guard let firstChoice = result.choices.first,
              let content = firstChoice.message.content else {
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida da API"])
        }
        
        print("[DEBUG] Resposta da API recebida: \(content)")
        return content
    }
} 
