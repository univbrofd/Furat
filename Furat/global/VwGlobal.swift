//
//  VwGlobal.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/15.
//

import SwiftUI

struct VwGlobal: View {
    @ObservedObject var bull :BullGlobal
    @Environment(\.dismiss) var dismiss
    let make :Bool
    
    init(_ bull:BullGlobal,make:Bool){
        self.bull = bull
        self.make = make
    }
    
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                if let icon = bull.icon {
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }else{
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .padding(30)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                VStack(alignment:.leading){
                    Text(bull.name)
                        .font(.system(size: 20))
                    Text(bull.id)
                        .font(.system(size: 14))
                }
                Spacer()
            }
            Spacer().frame(height:20)
            
            if make {
                TextEditorView($bull.text, font: .system(.body),explain: "今何してる？")
            }else{
                Text(bull.text)
            }
            Spacer()
        }.padding(10)
        .onAppear{
            bull.getImg(.icon)
        }
        .navigationBarItems(trailing:
            Button(action:{
            if bull.text == "" {
                return
            }
            if bull.text.count > 200{
                return
            }
                bull.upload()
                dismiss()
            }){
                Text("投稿する")
            }
        )
    }
}

struct VwGlobal_Pre: PreviewProvider {
    static var pre_infoGlobal = [
        "id":"predt_global1",
        "chara":"global",
        "hight":100,
        "time":"2022022714452311",
        "url_icon":"gs://furat-97153.appspot.com/test/user_icon/kiss-6989996_640.jpg",
        "url_img":"gs://furat-97153.appspot.com/test/user_img1/hyacinths-7013456_640.jpg",
        "global":[
            "uid":"preid015",
            "name":"h",
            "ary_tag":["lol","apex","雑談"],
            "text":""
        ]
    ] as [String:Any]
    
    static var bull = BullGlobal(pre_infoGlobal,time: Date())
    
    static var previews: some View {
        VwGlobal(bull,make: true)
    }
}
