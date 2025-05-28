import SwiftUI
import SwiftData

@main
struct KadushApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Script.self)
        } catch {
            fatalError("Erro ao inicializar SwiftData: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
} 