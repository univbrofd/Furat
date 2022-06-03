//
//  VwBullNote.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/06.
//

import SwiftUI

struct VwBullNote :View{
    //@EnvironmentObject var spr:Spr
    @ObservedObject var bull : BullNote
    let color_bg = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.5, green: 0.5, blue: 1),
        Color(red: 0.7, green: 0.7, blue: 1)
    ]), startPoint: .top, endPoint: .bottom)
    init(_ bull :BullNote){
        self.bull = bull
    }
    var body: some View{
        VStack(spacing:0){
            Text(bull.title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .italic()
                .frame(maxWidth:.infinity)
                .padding([.vertical],20)
                .padding([.horizontal],10)
                .background(LinearGradient(colors: [bull.color1,bull.color2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
            
        }
    }
}

struct VwBullNote_Previews: PreviewProvider {
    static var pre_infoNote = [
        "id":"predt_note1",
        "chara":"note",
        "time":"2022032714452311",
        "ary_tag":["lol","apex","雑談"],
        "note":[
            "uid":"preid015",
            "name":"ペットボルト",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
            "title":"面白い漫画の特徴",
            "ary_cnt":[
                ["headline":"headline1","text":"text1"],
                ["headline":"headline2","text":"texr2"],
                ["headline":"headline3","text":"text3"]
            ],
            "comment":[
                [
                    "name":"samueru",
                    "uid":"note_com1",
                    "text":"夢がある",
                    "time":"2022032720052311"
                ],[
                    "name":"コップ",
                    "uid":"note_com2",
                    "text":"師匠がいて、師匠を途中で力を抜かす",
                    "time":"2022032802052311"
                ],[
                    "name":"lolwwwW",
                    "uid":"note_com3",
                    "text":"唯一無二の秘めたる力を持っていいて途中で覚醒する",
                    "time":"2022032803452311"
                ]
            ]
        ]
    ] as [String : Any]
    static var bull = BullNote(VwBullNote_Previews.pre_infoNote,time: Date())
    
    static var previews: some View {
        GeometryReader{ gmty in
            HStack{
                Spacer().frame(width:(gmty.size.width / 100) * 1)
                VwBullNote(bull)
                Spacer().frame(width:gmty.size.width / 2)
            }
        }
    }
}

