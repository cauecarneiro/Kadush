import SwiftUI

struct Script: Identifiable {
    let id = UUID()
    let title: String
    let preview: String
    let date: Date
}

struct HomeView: View {
    @State private var searchText = ""
    @State private var showingNewScriptSheet = false
    
    // Sample data
    let recentScripts: [Script] = [
        Script(
            title: "Review de Produto",
            preview: "Introdução sobre o novo smartphone...",
            date: Date().addingTimeInterval(-86400)
        ),
        Script(
            title: "Tutorial de Maquiagem",
            preview: "Neste vídeo vamos explorar...",
            date: Date().addingTimeInterval(-172800)
        ),
        Script(
            title: "Vlog de Viagem",
            preview: "Hoje vou mostrar minha experiência...",
            date: Date().addingTimeInterval(-259200)
        )
    ]
    
    let categories = [
        "Tutorial", "Vlog", "Review",
        "Storytelling", "Entrevista", "Documentário"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Create New Script Button
                    Button(action: { showingNewScriptSheet = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Criar Novo Roteiro")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Use IA para gerar seu roteiro")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue.opacity(0.1))
                        )
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categorias")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { category in
                                    VStack {
                                        Image(systemName: categoryIcon(for: category))
                                            .font(.system(size: 30))
                                            .foregroundColor(.blue)
                                            .frame(width: 60, height: 60)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Circle())
                                        
                                        Text(category)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent Scripts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Roteiros Recentes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(recentScripts) { script in
                            NavigationLink(destination: ScriptView()) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(script.title)
                                            .font(.headline)
                                        Spacer()
                                        Text(formatDate(script.date))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text(script.preview)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: .black.opacity(0.1), radius: 5)
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Meus Roteiros")
            .searchable(text: $searchText, prompt: "Buscar roteiros")
            .sheet(isPresented: $showingNewScriptSheet) {
                NewScriptView()
            }
        }
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category {
        case "Tutorial": return "graduationcap"
        case "Vlog": return "video"
        case "Review": return "star"
        case "Storytelling": return "book"
        case "Entrevista": return "person.2"
        case "Documentário": return "film"
        default: return "doc.text"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct NewScriptView: View {
    @Environment(\.dismiss) var dismiss
    @State private var scriptType = "Tutorial"
    @State private var scriptDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tipo de Conteúdo")) {
                    Picker("Tipo", selection: $scriptType) {
                        Text("Tutorial").tag("Tutorial")
                        Text("Vlog").tag("Vlog")
                        Text("Review").tag("Review")
                        Text("Storytelling").tag("Storytelling")
                        Text("Entrevista").tag("Entrevista")
                        Text("Documentário").tag("Documentário")
                    }
                }
                
                Section(header: Text("Sobre o que é seu vídeo?")) {
                    TextEditor(text: $scriptDescription)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Gerar Roteiro") {
                        // Implementar geração do roteiro
                        dismiss()
                    }
                }
            }
            .navigationTitle("Novo Roteiro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
} 