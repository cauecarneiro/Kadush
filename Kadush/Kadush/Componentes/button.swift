//
//  button.swift
//  Kadush
//
//  Created by Cauê Carneiro on 14/05/25.
//
import SwiftUI

struct ButtonSelect: View {
    var nameButton: String
    var icon: String
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.darkgray)
                .frame(width: 147, height: 100)
            
            HStack{
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(nameButton)
                    .foregroundColor(.white)
            }
            
            
        }
    }
}
