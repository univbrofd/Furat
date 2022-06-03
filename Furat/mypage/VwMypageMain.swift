//
//  VwMypageGlobal.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/07.
//

import SwiftUI

struct VwMypageMain: View {
    @EnvironmentObject var evMypage:EvMypage
    var body: some View {
        VStack{
            ZStack{
                if let uiImage = evMypage.main_icon{
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }else{
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .padding(30)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.gray))
                }
            }
            if evMypage.main_name == ""{
                Text("None")
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    .multilineTextAlignment(.center)
            }else{
                Text(evMypage.main_name)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct VwMypageMain_Previews: PreviewProvider {
    static var previews: some View {
        VwMypageMain()
    }
}
