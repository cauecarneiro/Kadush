//
//  videoApres.swift
//  Kadush
//
//  Created by Cauê Carneiro on 13/05/25.
//

import SwiftUI

struct videoApres: View {
    @Binding var pageIndex: Int
    @State var tittle: String
    var icons: [IconModel] = []
    var body: some View {
        
        VStack{
            Text(tittle)
                .font(.title3)
            Text("Selecione uma opção")
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.bottom, 67)
            if icons.count <= 2 {
                HStack{
                    ForEach(icons, id: \.id) { index in
                        Button {
                            pageIndex += 1
                        } label: {
                            ButtonSelect(nameButton: index.name, icon: index.icon,)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 38)
            }else{
                VStack{
                    ForEach(icons, id: \.id) { index in
                        Button {
                            pageIndex += 1
                        } label: {
                            ButtonSelect(nameButton: index.name, icon: index.icon,)
                        }
                    }
                }
            }
            
            
        }
        
    }
}


#Preview {
    videoApres(pageIndex: .constant(1), tittle: "")
}

