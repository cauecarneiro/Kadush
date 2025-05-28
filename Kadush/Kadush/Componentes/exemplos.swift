//////
//////  formatos.swift
//////  Kadush
//////
//////  Created by Cauê Carneiro on 15/05/25.
//////
//
//import SwiftUI


import SwiftUI

struct ExampleHeader: View {
    let title: String
    let iconName: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    ExampleHeader(title: "ad", iconName: "asd", description: "~asdasdasdasdasdasdasdasdasd~")
}
