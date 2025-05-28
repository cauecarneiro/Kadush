////
////  ContentView.swift
////  Kadush
////
////  Created by Cauê Carneiro on 13/05/25.

import SwiftUI

struct ContentView: View {
    @State private var showVideoApres = false
    
    var body: some View {
        NavigationView {
            VStack {
                //Texto no meio da tela
                Text("Você ainda não criou roteiros clique no ícone + para começar")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                NavigationLink(
                    //incerindo a tela princpialview
                    destination: PrincipalView().navigationBarHidden(true),
                    isActive: $showVideoApres
                ) {
                    EmptyView()
                }
            }
            //ToolBar com o titulo e botão de adicionar
            .navigationTitle("Meus Roteiros")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showVideoApres = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
