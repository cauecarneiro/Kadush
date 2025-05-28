import SwiftUI
import SwiftData

// Modelo de dados para o roteiro
struct ScriptPreferences: Codable {
    var contentType: ContentType
    var writingMode: WritingMode
    var tone: Tone
    var format: Format
    var mainTheme: String
    var keywords: String
    var summary: String
    var duration: Int
    var createdAt: Date
    
    enum ContentType: String, Codable, CaseIterable {
        case video = "Vídeo"
        case presentation = "Apresentação"
    }
    
    enum WritingMode: String, Codable, CaseIterable {
        case guided = "Escrita Guiada"
        case ai = "Auto IA"
    }
    
    enum Tone: String, Codable, CaseIterable {
        case formal = "Formal"
        case casual = "Casual"
        case technical = "Técnico"
        case humorous = "Humorístico"
        case inspirational = "Inspiracional"
    }
    
    enum Format: String, Codable, CaseIterable {
        case story = "Narrativa"
        case bulletPoints = "Tópicos"
        case dialogue = "Diálogo"
        case tutorial = "Tutorial"
    }
}

struct CreateScriptView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var script = Script()
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var isGenerating = false
    
    private let durations = [3, 5, 7, 10, 15, 20, 30]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Tipo de Conteúdo
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Tipo de Conteúdo", systemImage: "film.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Picker("Tipo de Conteúdo", selection: $script.contentType) {
                                    ForEach([ContentType.video, .presentation], id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        
                        // Modo de Escrita
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Modo de Escrita", systemImage: "pencil.and.scribble")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Picker("Modo de Escrita", selection: $script.writingMode) {
                                    ForEach([WritingMode.guided, .ai], id: \.self) { mode in
                                        Text(mode.rawValue).tag(mode)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        
                        // Tom do Roteiro
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Tom do Roteiro", systemImage: "person.wave.2.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Picker("Tom", selection: $script.tone) {
                                    ForEach([
                                        Tone.formal,
                                        .casual,
                                        .technical,
                                        .humorous,
                                        .inspirational
                                    ], id: \.self) { tone in
                                        Text(tone.rawValue).tag(tone)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        
                        // Formato
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Formato", systemImage: "doc.text.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Picker("Formato", selection: $script.format) {
                                    ForEach([
                                        Format.story,
                                        .bulletPoints,
                                        .dialogue,
                                        .tutorial
                                    ], id: \.self) { format in
                                        Text(format.rawValue).tag(format)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        
                        // Tema Principal
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Tema Principal", systemImage: "lightbulb.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                TextField("Ex: Lançamento do novo iPhone 15", text: $script.mainTheme)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        // Resumo
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Breve Resumo", systemImage: "text.justify")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                TextEditor(text: $script.summary)
                                    .frame(height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                                    .background(Color(.systemBackground))
                            }
                        }
                        
                        // Duração
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Duração", systemImage: "clock.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Picker("Duração", selection: $script.duration) {
                                    ForEach(durations, id: \.self) { minutes in
                                        Text("\(minutes) minutos")
                                            .tag(minutes)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        
                        // Palavras-chave
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Palavras-chave", systemImage: "tag.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                TextField("Separe por vírgulas: tech, review, apple", text: $script.keywords)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        // Botão Gerar
                        Button(action: generateScript) {
                            HStack {
                                if isGenerating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "wand.and.stars")
                                }
                                Text(isGenerating ? "Gerando..." : "Gerar Roteiro com IA")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                isFormValid && !isGenerating ?
                                Color.blue :
                                Color.blue.opacity(0.3)
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!isFormValid || isGenerating)
                        .padding(.top)
                    }
                    .padding()
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
            .alert("Roteiro Gerado!", isPresented: $showingSuccessAlert) {
                Button("Ver Roteiro", role: .none) {
                    // TODO: Navegar para a tela do roteiro
                }
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Seu roteiro foi gerado com sucesso!")
            }
            .alert("Erro", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !script.mainTheme.isEmpty && !script.summary.isEmpty && !script.keywords.isEmpty
    }
    
    private func generateScript() {
        isGenerating = true
        
        Task {
            do {
                // Salvar o script
                modelContext.insert(script)
                try modelContext.save()
                
                // Gerar o roteiro com IA
                _ = try await ScriptService.shared.generateScript(with: script)
                
                await MainActor.run {
                    showingSuccessAlert = true
                    isGenerating = false
                }
            } catch AIError.apiKeyMissing {
                await MainActor.run {
                    errorMessage = "Chave da API não configurada. Por favor, configure sua chave da OpenAI no arquivo Info.plist."
                    showingErrorAlert = true
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Erro ao gerar roteiro: \(error.localizedDescription)"
                    showingErrorAlert = true
                    isGenerating = false
                }
            }
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CreateScriptView()
} 