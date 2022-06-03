//
//  VwBullGlobal.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/02.
//

import SwiftUI

struct VwBullGlobal :View{
    @EnvironmentObject var spr:Spr
    @ObservedObject var bull : BullGlobal
    
    init(_ bull :BullGlobal){
        print("VwPerson")
        self.bull = bull
        print("VwPerson end")
    }
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                if let icon = bull.icon{
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }else{
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .padding(30)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading){
                    Text(bull.name)
                        .padding(0)
                        .font(.system(size: 14, weight: .light, design: .default))
                    Text(bull.id)
                        .font(.system(size: 10, weight: .light, design: .default))
                }
            }
            Text(bull.text)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .font(.system(size: 14, weight: .light, design: .default))
        }
        .padding(5)
        .background(Color.white)
        .shadow(color: .gray, radius: 0.5, x: 0, y: 0)
            .onAppear{
                bull.getImg(.icon)
                //bull.getImg(bull.url_img1, emImg: .img1)
            }
    }
}

struct VwBullGlobal_Previews: PreviewProvider {
    static var pre_infoGlobal = [
        "id":"predt_global1",
        "chara":"global",
        "hight":100,
        "time":"2022022714452311",
        "global":[
            "uid":"preid015",
            "name":"h",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/kiss-6989996_640.jpg",
            "url_img":"gs://furat-97153.appspot.com/test/user_img1/hyacinths-7013456_640.jpg",
            "ary_tag":["lol","apex","雑談"],
            "text":"ここ同じとこ2回繰り返してるので書き直した方がいいですね"
        ]
    ] as [String:Any]
    static var previews: some View {
        GeometryReader{ gmty in
            HStack{
                Spacer().frame(width:(gmty.size.width / 100) * 1)
                VwBullGlobal(BullGlobal(VwBullGlobal_Previews.pre_infoGlobal,time: Date()))
                Spacer().frame(width:gmty.size.width / 2)
            }
        }
    }
}
