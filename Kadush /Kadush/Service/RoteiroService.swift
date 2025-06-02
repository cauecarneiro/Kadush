//
//  RoteiroService.swift
//  Kadush
//
//  Created by Cauê Carneiro on 28/05/25.
//
import SwiftData

class RoteiroService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = RoteiroService()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: RoteiroModel.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchRoteiros() -> [RoteiroModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<RoteiroModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addRoteiro(_ Roteiro: RoteiroModel) {
        modelContext.insert(Roteiro)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deletarRoteiro(_ roteiro: RoteiroModel) {
        roteiro.excluido = true
        roteiro.atualizarDataModificacao()
        do {
            try modelContext.save()
        } catch {
            print("Erro ao mover roteiro para lixeira: \(error)")
        }
    }
    
    func deletarRoteiroPermanentemente(_ roteiro: RoteiroModel) {
        modelContext.delete(roteiro)
        do {
            try modelContext.save()
        } catch {
            print("Erro ao excluir roteiro permanentemente: \(error)")
        }
    }
    
    func fetchRoteirosExcluidos() -> [RoteiroModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<RoteiroModel>()).filter { $0.excluido }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deletarTodosExcluidosPermanentemente() {
        let excluidos = fetchRoteirosExcluidos()
        for roteiro in excluidos {
            modelContext.delete(roteiro)
        }
        do {
            try modelContext.save()
        } catch {
            print("Erro ao excluir todos permanentemente: \(error)")
        }
    }
}
