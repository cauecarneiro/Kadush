import SwiftUI
import OpenAI // 1. Certifique-se de que o pacote MacPaw/OpenAI foi adicionado

// --- Estrutura Principal da View ---
struct TesteMacPawOpenAIView: View {

    // --- Configuração da Chave de API ---
    // 🔴 !! IMPORTANTE !! 🔴
    // Substitua "COLOQUE_SUA_CHAVE_API_AQUI" pela sua chave de API real da OpenAI.
    // Isto é APENAS para TESTE neste arquivo único.
    private let suaChaveAPIOpenAI = " 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"

    // --- Cliente OpenAI ---
    // Será inicializado no init() ou onAppear()
    @State private var openAIClient: OpenAI?

    // --- Variáveis de Estado para a UI ---
    @State var userPrompt: String = "Conte uma piada curta sobre IA."
    @State private var aiResponse: String = "Aguardando seu comando..."
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    // --- Corpo da UI ---
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Teste MacPaw OpenAI")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                TextEditor(text: $userPrompt)
                    .frame(height: 100)
                    .border(Color.gray.opacity(0.5), width: 1)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .accessibilityLabel("Digite seu prompt aqui")

                Button(action: enviarMensagem) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text(isLoading ? "Enviando..." : "Enviar para OpenAI")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isLoading || openAIClient == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(isLoading || userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || openAIClient == nil)

                Divider().padding(.vertical, 10)

                Text("Resposta da IA:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                if isLoading {
                    ProgressView()
                        .padding()
                    Text("Aguardando resposta...")
                        .foregroundColor(.gray)
                } else if let errorMsg = errorMessage {
                    VStack {
                        Image(systemName: "xmark.octagon.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                        Text("Erro: \(errorMsg)")
                            .foregroundColor(.red)
                            .textSelection(.enabled)
                    }
                    .padding()
                } else {
                    ScrollView {
                        Text(aiResponse)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            .padding(.horizontal)
                            .textSelection(.enabled)
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = aiResponse
                                } label: {
                                    Label("Copiar Texto", systemImage: "doc.on.doc")
                                }
                            }
                    }
                    .frame(minHeight: 100, maxHeight: .infinity)
                }
                Spacer()
            }
            .navigationTitle("Teste OpenAI")
            .onAppear {
                if suaChaveAPIOpenAI.starts(with: "COLOQUE_SUA_CHAVE_API_AQUI") || suaChaveAPIOpenAI.isEmpty {
                    self.errorMessage = "Configure sua API Key no código (linha 14) antes de usar."
                    self.aiResponse = "API Key não configurada no código-fonte."
                    self.openAIClient = nil
                } else {
                    // Inicializa o cliente OpenAI quando a view aparece e a chave é válida
                    self.openAIClient = OpenAI(apiToken: suaChaveAPIOpenAI)
                    self.errorMessage = nil
                    self.aiResponse = "Cliente OpenAI inicializado. Pronto para o prompt!"
                    print("Cliente OpenAI inicializado com sucesso.")
                }
            }
        }
    }

    // --- Função para Enviar a Mensagem ---
    func enviarMensagem() {
        guard let client = openAIClient else {
            self.errorMessage = "Cliente OpenAI não foi inicializado. Verifique a API Key."
            self.aiResponse = "Erro: Cliente não inicializado."
            print("Tentativa de enviar mensagem, mas o cliente OpenAI não está inicializado.")
            return
        }

        guard !userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.aiResponse = "Por favor, digite um prompt."
            self.errorMessage = "Prompt não pode ser vazio."
            return
        }

        isLoading = true
        errorMessage = nil
        aiResponse = "Pensando..." // Feedback para o usuário

        Task {
            do {
                // Conforme o README da MacPaw/OpenAI:
                // Usaremos .gpt4_o_mini, que é um modelo eficiente e você o usou no seu teste curl.
                // Se preferir outro, como .gpt3_5Turbo, pode alterar.
                guard let userMessage = ChatQuery.ChatCompletionMessageParam(role: .user, content: userPrompt) else {
                    self.errorMessage = "Erro ao criar mensagem para OpenAI. Prompt inválido?"
                    self.isLoading = false
                    return
                }

                let query = ChatQuery(
                    messages: [userMessage],
                    model: .gpt4_o_mini
                )


                
                print("Enviando query para OpenAI: \(query)")

                let result = try await client.chats(query: query)
                
                DispatchQueue.main.async {
                    isLoading = false
                    if let firstChoice = result.choices.first {
                        aiResponse = firstChoice.message.content ?? "Nenhuma mensagem de texto recebida."
                    } else {
                        aiResponse = "Nenhuma escolha retornada pela API."
                        errorMessage = "Resposta da API vazia."
                    }
                   // userPrompt = "" // Opcional: Limpar o campo de prompt após o envio
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    let errorDescription = error.localizedDescription
                    errorMessage = errorDescription
                    aiResponse = "Falha ao obter resposta da IA. Verifique o console."
                    print("---------------- DEBUG ERRO SWIFT (MacPaw OpenAI) START ----------------")
                    print("Erro ao chamar API OpenAI: \(error)")
                    print("Descrição Localizada: \(errorDescription)")
                    // A biblioteca MacPaw/OpenAI pode ter um tipo de erro específico
                    if let openAIError = error as? OpenAIError {
                        print("Erro OpenAI: \(openAIError)")
                        switch openAIError {
                        case .emptyData:
                            print("Erro: dados vazios retornados.")
                        case .statusError(let response, let statusCode):
                            print("Erro de status HTTP: \(statusCode)")
                            print("Response: \(response)")
                        }
                    }

                    print("---------------- DEBUG ERRO SWIFT (MacPaw OpenAI) END ------------------")
                }
            }
        }
    }
}

// --- Provedor de Pré-visualização para o Xcode ---
#Preview {
    TesteMacPawOpenAIView()
}

// --- Ponto de Entrada do App (se você criar um projeto novo) ---
// Se você criou um novo projeto no Xcode (ex: "App" para SwiftUI),
// pode substituir o conteúdo do arquivo principal (ex: NomeDoSeuAppApp.swift)
// por algo assim para rodar esta view:
/*
@main
struct TesteOpenAIApp: App {
    var body: some Scene {
        WindowGroup {
            TesteMacPawOpenAIView()
        }
    }
}
*/
