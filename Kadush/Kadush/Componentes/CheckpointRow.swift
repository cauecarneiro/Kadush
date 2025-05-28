//
//  CheckpointRow.swift
//  Kadush
//
//  Created by Cauê Carneiro on 17/05/25.
//

import SwiftUI

struct CheckpointRow: View {
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundColor(.blue)
                .font(.system(size: 10))
                .opacity(0.7)
            Text(text)
        }
        .padding(.bottom, 5)
    }
}
