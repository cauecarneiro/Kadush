import SwiftUI
import SwiftData

// Tela para preenchimento de tema, palavras-chave, resumo e duração do roteiro
struct Palavras: View {
   
    // Índice da etapa atual do fluxo (binding para navegação)
    @Binding var pageIndex: Int
    
    // ViewModel responsável pelo roteiro atual
    let viewModel: RoteiroViewModel
    
    // Estado local para o tema principal
    @State private var Tema: String = ""
    
    // Estado local para as palavras-chave
    @State private var palavraschaves: [String] = []
    
    // Palavra-chave em edição
    @State private var novapalavra: String = ""
   
    // Índice da palavra-chave em edição
    @State private var editingIndex: Int? = nil
   
    // Estado local para o resumo
    @State private var resumo: String = ""
   
    // Estado local para a minutagem
    @State private var minutagem: String = ""
  
    // Controle de foco dos campos
    @FocusState private var isEditingTema: Bool
    @FocusState private var isEditingTopic: Bool
    @FocusState private var isEditingKeyword: Bool
    @FocusState private var isEditingResumo: Bool
    @FocusState private var isEditingMinutagem: Bool
    // Controle de exibição do alerta de campos obrigatórios
    @State private var showAlert: Bool = false
    // Controle de visibilidade do teclado
    @State private var isKeyboardVisible: Bool = false
    // Limite máximo de palavras-chave
    let maxKeywords = 4
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Campo para o tema principal
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tema principal")
                            .font(.title2)
                            .bold()
                        TextField("Escreva aqui", text: $Tema)
                            .focused($isEditingTema)
                            .textFieldStyle(PlainTextFieldStyle())
                            // Atualiza o tema no ViewModel em tempo real
                            .onChange(of: Tema) { _, newValue in
                                viewModel.atualizarTemaPrincipal(newValue)
                            }
                    }
                    .frame(width: 350)
                    // Campo para palavras-chave
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Palavras Chave")
                            .font(.title2)
                            .bold()
                        HStack {
                            TextField("Escreva aqui", text: $novapalavra)
                                .focused($isEditingTopic)
                                .submitLabel(.done)
                                .textFieldStyle(PlainTextFieldStyle())
                                // Adiciona nova palavra-chave ao pressionar Enter
                                .onSubmit {
                                    guard !novapalavra.isEmpty,
                                          palavraschaves.count < maxKeywords else { return }
                                    palavraschaves.append(novapalavra)
                                    viewModel.atualizarPalavrasChave(palavraschaves)
                                    novapalavra = ""
                                }
                            Text("\(palavraschaves.count)/\(maxKeywords)")
                                .font(.subheadline)
                                .foregroundColor(palavraschaves.count < maxKeywords ? .gray : .green)
                                .padding(.leading, 8)
                        }
                        // Mensagem de limite atingido
                        if palavraschaves.count >= maxKeywords && !novapalavra.isEmpty {
                            Text("Limite de 4 palavras atingido")
                                .foregroundColor(.red)
                        }
                        // Lista horizontal de palavras-chave
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(palavraschaves.indices, id: \.self) { index in
                                    if editingIndex == index {
                                        // Campo de edição inline da palavra-chave
                                        TextField("Edit", text: Binding(
                                            get: { palavraschaves[index] },
                                            set: { palavraschaves[index] = $0 }
                                        ))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.blue.opacity(0.3))
                                        .foregroundColor(.blue)
                                        .cornerRadius(20)
                                        .fixedSize()
                                        .focused($isEditingKeyword)
                                        .submitLabel(.done)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                isEditingKeyword = true
                                            }
                                        }
                                        .onSubmit {
                                            editingIndex = nil
                                            isEditingKeyword = false
                                            viewModel.atualizarPalavrasChave(palavraschaves)
                                        }
                                    } else {
                                        // Exibe palavra-chave como chip
                                        Text(palavraschaves[index])
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.blue.opacity(0.3))
                                            .foregroundColor(.blue)
                                            .cornerRadius(20)
                                            .onTapGesture {
                                                editingIndex = index
                                                isEditingTopic = false
                                                isEditingTema = false
                                            }
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .frame(width: 350)
                    // Campo para resumo do roteiro
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Resumo do Roteiro")
                            .font(.title2)
                            .bold()
                        TextEditor(text: $resumo)
                            .focused($isEditingResumo)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            // Atualiza o resumo no ViewModel em tempo real
                            .onChange(of: resumo) { _, newValue in
                                viewModel.atualizarResumo(newValue)
                            }
                    }
                    .frame(width: 350)
                    // Campo para duração do vídeo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duração")
                            .font(.title2)
                            .bold()
                        HStack {
                            TextField("Digite a duração", text: $minutagem)
                                .focused($isEditingMinutagem)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                // Atualiza a duração no ViewModel em tempo real
                                .onChange(of: minutagem) { _, newValue in
                                    if let duracao = Int(newValue) {
                                        viewModel.atualizarDuracao(duracao)
                                    }
                                }
                            Text("minutos")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 350)
                    // Espaço extra para garantir que o conteúdo não fique escondido pelo teclado
                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
            // Botão para avançar para a próxima etapa
            if !isKeyboardVisible {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Seguinte") {
                            // Validação dos campos obrigatórios
                            if Tema.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || 
                               palavraschaves.count < 4 ||
                               resumo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                               minutagem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showAlert = true
                            } else {
                                viewModel.salvarRoteiro()
                                pageIndex += 1
                            }
                        }
                        // Alerta caso algum campo obrigatório não esteja preenchido
                        .alert("Preencha todos os campos", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("Você precisa adicionar um tema, pelo menos 4 tópicos, um resumo e a duração para continuar.")
                        }
                        .padding()
                    }
                }
            }
        }
        // Animações de foco
        .animation(.easeInOut, value: isEditingTema)
        .animation(.easeInOut, value: isEditingTopic)
        .animation(.easeInOut, value: isEditingKeyword)
        .animation(.easeInOut, value: isEditingResumo)
        .animation(.easeInOut, value: isEditingMinutagem)
        // Ao tocar fora dos campos, remove o foco
        .onTapGesture {
            isEditingTema = false
            isEditingTopic = false
            isEditingKeyword = false
            isEditingResumo = false
            isEditingMinutagem = false
            editingIndex = nil
        }
        // Observa eventos do teclado para ajustar layout
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .onAppear {
            if let roteiro = viewModel.roteiroAtual {
                // Carrega os dados do viewModel quando a tela aparecer
                Tema = roteiro.temaPrincipal
                palavraschaves = roteiro.palavrasChave
                resumo = roteiro.resumo
                minutagem = String(roteiro.duracao)
            } else {
                viewModel.criarNovoRoteiro()
            }
        }
    }
}

#Preview {
    Palavras(pageIndex: .constant(1), viewModel: RoteiroViewModel(modelContext: try! ModelContainer(for: RoteiroModel.self).mainContext))
}
