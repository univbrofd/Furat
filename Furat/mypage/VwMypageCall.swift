//
//  VwMypageCall.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/07.
//

import SwiftUI

struct VwMypageCall: View {
    @EnvironmentObject var evMypage:EvMypage
    var body: some View {
        VStack{
            if let uiImage = evMypage.call_icon{
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
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
            }
            Text(evMypage.call_name)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                .multilineTextAlignment(.center)
            Text(evMypage.call_skypeId)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                .multilineTextAlignment(.center)
            Text(evMypage.call_dicordId)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                .multilineTextAlignment(.center)
        }
    }
}

struct VwMypageCall_Previews: PreviewProvider {
    static var previews: some View {
        VwMypageCall()
    }
}
