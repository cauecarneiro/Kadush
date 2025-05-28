import Foundation
import SwiftData

@MainActor
class ScriptService {
    static let shared = ScriptService()
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    private init() {
        do {
            modelContainer = try ModelContainer(for: Script.self)
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("Erro ao inicializar SwiftData: \(error)")
        }
    }
    
    // MARK: - Script Management
    
    func saveScript(_ script: Script) async throws {
        modelContext.insert(script)
        try modelContext.save()
    }
    
    func getAllScripts() -> [Script] {
        let descriptor = FetchDescriptor<Script>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Erro ao buscar scripts: \(error)")
            return []
        }
    }
    
    func deleteScript(_ script: Script) async throws {
        modelContext.delete(script)
        try modelContext.save()
    }
    
    // MARK: - AI Integration
    
    func generateScript(with script: Script) async throws -> String {
        do {
            // Gerar o conteúdo usando a IA
            let generatedContent = try await AIService.shared.generateScript(with: script)
            
            // Atualizar o script com o conteúdo gerado
            script.generatedContent = generatedContent
            try modelContext.save()
            
            return generatedContent
        } catch AIError.apiKeyMissing {
            throw AIError.apiKeyMissing
        } catch {
            print("Erro ao gerar roteiro: \(error)")
            throw error
        }
    }
} 