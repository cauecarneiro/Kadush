//
//  ContentView.swift
//  Kadush
//
//  Created by Cauê Carneiro on 13/05/25.

import SwiftUI
import SwiftData

// Tela inicial do app, exibe mensagem caso não haja roteiros e botão para criar novo roteiro
struct ContentView: View {
    // Controla a navegação para a tela principal de criação de roteiro
    @State private var showVideoApres = false
    @State private var searchText = ""
    @State private var roteiros: [RoteiroModel] = []
    @State private var isLoading = true
    @State private var roteiroSelecionado: RoteiroModel? = nil
    @State private var mostrarEdicao = false
    @State private var mostrarLixeira = false
    @State private var reloadTrigger = UUID()
    @State private var roteiroParaNavegar: RoteiroModel? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Barra de busca
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Buscar pelo tema...", text: $searchText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                         Button(action: { searchText = "" }) {
                            if !searchText.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                // Lista de roteiros filtrados
                let roteirosFiltrados = roteiros
                    .filter { !$0.excluido }
                    .sorted { $0.dataModificacao > $1.dataModificacao }
                    .filter { searchText.isEmpty || $0.temaPrincipal.localizedCaseInsensitiveContains(searchText) }
                if isLoading {
                    Spacer()
                    HStack { Spacer(); ProgressView(); Spacer() }
                    Spacer()
                } else if roteirosFiltrados.isEmpty {
                    Spacer()
                    Text("Você ainda não criou roteiros. Clique no ícone + para começar.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(roteirosFiltrados, id: \.dataCriacao) { roteiro in
                                CelulaRoteiro(
                                    title: roteiro.temaPrincipal,
                                    description: roteiro.resumo,
                                    editedDate: "Editado em " + formatarData(roteiro.dataModificacao)
                                )
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    roteiroParaNavegar = roteiro
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deletarRoteiroManual(roteiro)
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .background(
                        NavigationLink(
                            destination: Group {
                                if let roteiro = roteiroParaNavegar {
                                    DetalheRoteiroView(roteiro: roteiro, onSalvar: carregarRoteiros)
                                }
                            },
                            isActive: Binding(
                                get: { roteiroParaNavegar != nil },
                                set: { if !$0 { roteiroParaNavegar = nil } }
                            )
                        ) { EmptyView() }
                    )
                }
                NavigationLink(
                    destination: PrincipalView().navigationBarHidden(true)
                        .onDisappear {
                            reloadTrigger = UUID()
                        },
                    isActive: $showVideoApres
                ) { EmptyView() }
            }
            .id(reloadTrigger)
            .onAppear {
                carregarRoteiros()
            }
            .navigationTitle("Meus roteiros")
            .sheet(isPresented: $mostrarLixeira, onDismiss: carregarRoteiros) {
                LixeiraView(onClose: { mostrarLixeira = false })
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { showVideoApres = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                        if existeRoteiroExcluido {
                            Button(action: { mostrarLixeira = true }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
            .hideKeyboardOnTap()
        }
    }
    
    func carregarRoteiros() {
        isLoading = true
        DispatchQueue.main.async {
            roteiros = RoteiroService.shared.fetchRoteiros()
            isLoading = false
        }
    }
    
    func formatarData(_ data: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: data, relativeTo: Date())
    }
    
    func deletarRoteiroManual(_ roteiro: RoteiroModel) {
        RoteiroService.shared.deletarRoteiro(roteiro)
        carregarRoteiros()
    }
    
    var existeRoteiroExcluido: Bool {
        roteiros.contains { $0.excluido }
    }
}

#Preview {
    ContentView()
}
