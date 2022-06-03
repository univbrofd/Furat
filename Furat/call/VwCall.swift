//
//  VwCall.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/16.
//

import SwiftUI

struct VwCall: View {
    @ObservedObject var bull :BullCall
    var obChata :ObChat? = nil
    let make:Bool
    init(_ bull:BullCall,make:Bool){
        self.bull = bull
        self.make = make
    }
    var body: some View {
        GeometryReader{gmty in
            ZStack(alignment:.top){
                VStack{
                    if let icon = bull.icon{
                        Image(uiImage: icon)
                    }else{
                        Image(systemName: "person")
                    }
                    Text(bull.name)
                    Spacer().frame(maxHeight:gmty.size.height * 0.5)
                }
            }.onAppear(){
                bull.getImg(.icon)
            }
        }
    }
}

struct VwCall_Previews: PreviewProvider {
    static var pre_infoCall = [
        "id":"predt_call1",
        "chara":"call",
        "hight":100,
        "ary_tag":["lol","apex","雑談"],
        "time":"2022021304203111",
        "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
        "call":[
            "uid":"preid001",
            "name":"Ak",
            "sex": 1,
            "id_sky" : "hiro.346fdfhkfhjcudkgkfycfjcfjfkfyjfyjffcjhvj",
            "id_dis" : "fdfa.dfa",
            "text":"アンレート@4か空いてるとこ入れてください"
        ]
    ] as [String : Any]
    
    static var bull = BullCall(VwBullCall_Previews.pre_infoCall,time: Date())
    
    static var previews: some View {
        VwCall(bull,make: true)
            .environmentObject(Spr())
            .environmentObject(ObMsger())
    }
}
