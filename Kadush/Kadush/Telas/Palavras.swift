import SwiftUI

struct Palavras: View {
    @Binding var pageIndex: Int
    @State private var Tema: String = ""
    @State private var palavraschaves: [String] = []
    @State private var novapalavra: String = ""
    @State private var editingIndex: Int? = nil
    @State private var resumo: String = ""
    @State private var minutagem: String = ""
    @FocusState private var isEditingTema: Bool
    @FocusState private var isEditingTopic: Bool
    @FocusState private var isEditingKeyword: Bool
    @FocusState private var isEditingResumo: Bool
    @FocusState private var isEditingMinutagem: Bool
    @State private var showAlert: Bool = false
    @State private var isKeyboardVisible: Bool = false
    let maxKeywords = 4
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Tema Principal
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tema principal")
                            .font(.title2)
                            .bold()
                        
                        TextField("Escreva aqui", text: $Tema)
                            .focused($isEditingTema)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .frame(width: 350)
                    
                    // Palavras Chave
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Palavras Chave")
                            .font(.title2)
                            .bold()
                        
                        TextField("Escreva aqui", text: $novapalavra)
                            .focused($isEditingTopic)
                            .submitLabel(.done)
                            .textFieldStyle(PlainTextFieldStyle())
                            .onSubmit {
                                guard !novapalavra.isEmpty,
                                      palavraschaves.count < maxKeywords else { return }
                                palavraschaves.append(novapalavra)
                                novapalavra = ""
                            }
                        
                        if palavraschaves.count >= maxKeywords && !novapalavra.isEmpty {
                            Text("Limite de 4 palavras atingido")
                                .foregroundColor(.red)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(palavraschaves.indices, id: \.self) { index in
                                    if editingIndex == index {
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
                                        }
                                    } else {
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
                    
                    // Resumo
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
                    }
                    .frame(width: 350)
                    
                    // Duração
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duração do Vídeo")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            TextField("Digite a duração", text: $minutagem)
                                .focused($isEditingMinutagem)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                            
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
            
            // Botão Seguinte
            if !isKeyboardVisible {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Seguinte") {
                            if Tema.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || 
                               palavraschaves.count < 4 ||
                               resumo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                               minutagem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showAlert = true
                            } else {
                                pageIndex += 1
                            }
                        }
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
        .animation(.easeInOut, value: isEditingTema)
        .animation(.easeInOut, value: isEditingTopic)
        .animation(.easeInOut, value: isEditingKeyword)
        .animation(.easeInOut, value: isEditingResumo)
        .animation(.easeInOut, value: isEditingMinutagem)
        .onTapGesture {
            isEditingTema = false
            isEditingTopic = false
            isEditingKeyword = false
            isEditingResumo = false
            isEditingMinutagem = false
            editingIndex = nil
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
    }
}

#Preview {
    Palavras(pageIndex: .constant(1))
}
