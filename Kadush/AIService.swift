import Foundation

actor AIService {
    static let shared = AIService()
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    private init() throws {
        do {
            self.apiKey = try APIKeys.openAIKey
        } catch {
            throw AIError.apiKeyMissing
        }
    }
    
    func generateScript(with script: Script) async throws -> String {
        let prompt = createPrompt(from: script)
        
        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                [
                    "role": "system",
                    "content": "Você é um especialista em criação de roteiros para vídeos e apresentações. Sua tarefa é criar roteiros detalhados e envolventes baseados nas preferências do usuário."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "temperature": 0.7,
            "max_tokens": 2000
        ]
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AIError.requestFailed
        }
        
        let aiResponse = try JSONDecoder().decode(AIResponse.self, from: data)
        return aiResponse.choices.first?.message.content ?? ""
    }
    
    private func createPrompt(from script: Script) -> String {
        """
        Crie um roteiro detalhado com as seguintes especificações:
        
        Tipo de Conteúdo: \(script.contentType.rawValue)
        Modo de Escrita: \(script.writingMode.rawValue)
        Tom: \(script.tone.rawValue)
        Formato: \(script.format.rawValue)
        Tema Principal: \(script.mainTheme)
        Palavras-chave: \(script.keywords)
        Resumo: \(script.summary)
        Duração: \(script.duration) minutos
        
        Por favor, crie um roteiro detalhado que siga estas especificações. 
        Inclua uma introdução envolvente, desenvolvimento do conteúdo e uma conclusão impactante.
        Se for um vídeo, inclua sugestões de transições e elementos visuais.
        Se for uma apresentação, inclua sugestões de slides e elementos visuais.
        """
    }
}

// MARK: - Supporting Types

struct AIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

enum AIError: Error {
    case requestFailed
    case invalidResponse
    case apiKeyMissing
} 