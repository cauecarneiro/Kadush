import SwiftUI

struct CelulaRoteiro: View {
    var title: String
    var description: String
    var editedDate: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(.headline, weight: .bold))
                Text(description)
                    .font(.system(.subheadline))
                    .foregroundColor(.gray)
                Text(editedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(12)
        }
    }
}
