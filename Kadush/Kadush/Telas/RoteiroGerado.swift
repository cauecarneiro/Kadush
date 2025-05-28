//
//  Untitled.swift
//  Kadush
//
//  Created by Cauê Carneiro on 24/05/25.
//

import SwiftUI
import UIKit

struct RoteiroGerado: View {
    @Binding var pageIndex: Int
    @State private var scriptText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """
    @State private var showingSaveAlert = false
    @Environment(\.dismiss) private var dismiss
    //@State private var isEditing = false
    @State private var undoStack: [String] = []
    @State private var redoStack: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear.contentShape(Rectangle())
                
                Form {
                    Section(header: Text("Visualize e edite seu roteiro").font(.headline)) {
                        Text("Revise seu conteúdo abaixo. Você pode editar livremente e, ao final, salvar ou compartilhar seu roteiro.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        
                        ZStack(alignment: .topLeading) {
                            if scriptText.isEmpty {
                                Text("Digite seu roteiro aqui...")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                            TextEditor(text: Binding(
                                get: { scriptText },
                                set: { newValue in
                                    undoStack.append(scriptText)
                                    scriptText = newValue
                                    redoStack.removeAll()
                                }))
                            .frame(minHeight: 360)
                            .padding(4)
                        }
                    }
                }
            }
            .hideKeyboardOnTap()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ShareLink(item: scriptText) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Button("Salvar") {
                        // Implementar a lógica de salvamento aqui
                    }
                }
            }
            
            
        }
    }
}

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


#Preview {
    RoteiroGerado(pageIndex: .constant(1))
}
