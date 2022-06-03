//
//  VwImageSave.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/10.
//

import SwiftUI

struct VwImageSave: View {
    //@Environment(\.presentationMode) var presentation
    @Binding var resizedImage: Image?
    var body: some View {
        VStack{
            resizedImage?.resizable()
                .cornerRadius(100)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100,height: 100)
            Spacer().frame(height: 50)
            
            Button(action: {
                //self.presentation.wrappedValue.dismiss()
            }, label: {
                Text("保存")
                    .padding(10)
                    .padding([.leading,.trailing],30)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                    .padding([.bottom],30)
            })
        }
    }
}
