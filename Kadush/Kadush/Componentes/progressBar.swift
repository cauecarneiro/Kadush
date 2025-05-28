//
//  progressBar.swift
//  Kadush
//
//  Created by Cauê Carneiro on 14/05/25.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var page: Int
    
    var body: some View {
        HStack {
            ForEach(1...6, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(index <= page ? .blue : .lighgray)
                    .frame(height: 2)
                    .padding(.horizontal, 2)
                    .animation(.linear(duration: 0.3), value: page)
            }
        }
    }
}
