//
//  VwChatPre.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/22.
//

import SwiftUI

struct VwChat: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evMypage:EvMypage
    @EnvironmentObject var obMsg : ObMsger
    @ObservedObject var obChat : ObChat
    @State var input_text = ""
    
    init(obChat:ObChat) {
        print("VwChat init1")
        self.obChat = obChat
        print("VwChat init1 end")
    }
    init(person:Person) {
        print("VwChat init2")
        self.obChat = ObChat(person)
        print("VwChat init2 end")
    }
    
    var body: some View {
        VStack{
            ScrollView{
                VStack(spacing:5){
                    Spacer()
                    ForEach(obChat.ary_msg_load,id:\.self){ msg in
                        if msg.id_from == Spr.uid{
                            vwChatR(msg)
                        }else{
                            vwChatL(msg)
                        }
                    }
                }
            }
            HStack{
                TextField("メッセージを入力",text: $input_text)
                    .padding([.horizontal],14)
                    .padding([.vertical],6)
                    .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .cornerRadius(20)
                    .padding([.vertical],5)
                    .padding([.horizontal],10)
                Button(action: {
                    obChat.sendMsg(text: input_text)
                    input_text = ""
                }){
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .padding([.trailing],14)
                }
            }.background(Color.white)
        }.background(Color.white)
    }
    
    func vwChatL(_ msg:RlmMsg) -> some View{
        HStack(alignment:.bottom){
            Image("bull_bg1")
                .resizable()
                .scaledToFill()
                .frame(width: 34, height: 34)
                .cornerRadius(100)
                .padding([.leading],5)
            HStack(alignment:.bottom){
                Text(msg.cnt)
                    .padding([.horizontal],14)
                    .padding([.vertical],6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text(msg.time.date("yyyyMMddHHmm")?.string("h:mm") ?? "")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                    .padding([.bottom],4)
            }.frame(maxWidth:300,alignment:.leading)
            Spacer()
        }
    }
    
    func vwChatR(_ msg:RlmMsg) -> some View{
        HStack(alignment:.bottom){
            Spacer()
            HStack(alignment:.bottom){
                Text(msg.time.date("yyyyMMddHHmm")?.string("h:mm") ?? "")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                    .padding([.bottom],4)
                Text(msg.cnt)
                    .padding([.horizontal],14)
                    .padding([.vertical],6)
                    .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .cornerRadius(20)
                    .padding([.trailing],5)
            }
            .frame(maxWidth:300,alignment:.trailing)
        }
            
    }
}
