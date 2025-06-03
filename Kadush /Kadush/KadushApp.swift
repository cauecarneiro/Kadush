//
//  KadushApp.swift
//  Kadush
//
//  Created by Cauê Carneiro on 13/05/25.
//

import SwiftUI
import SwiftData

@main
struct KadushApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: RoteiroModel.self)
        } catch {
            fatalError("Falha ao criar o container do SwiftData: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Forçar tema escuro
                .modelContainer(container)
        }
    }
}
