import SwiftUI

struct ScriptView: View {
    @State private var scriptText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """
    @State private var showingSaveAlert = false
    
    var body: some View {
        NavigationView {
            TextEditor(text: $scriptText)
                .font(.body)
                .padding()
                .background(Color(UIColor.systemBackground))
                .navigationTitle("Roteiro")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: saveScript) {
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundColor(.blue)
                            }
                            
                            ShareLink(
                                item: scriptText,
                                subject: Text("Meu Roteiro"),
                                message: Text(scriptText)
                            ) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .alert("Salvo com Sucesso", isPresented: $showingSaveAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
    }
    
    private func saveScript() {
        // Implementar a lógica de salvamento aqui
        showingSaveAlert = true
    }
}

#Preview {
    ScriptView()
} 