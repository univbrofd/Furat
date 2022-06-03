//
//  VwMsger.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import SwiftUI

struct VwMsger: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMsg : ObMsger
    @EnvironmentObject var evMypage:EvMypage
    var body: some View {
        VStack{
            if obMsg.ary_id.count == 0{
                Text("メッセージがありません")
            }
            ForEach(obMsg.ary_id,id:\.self){ id in
                if let chat = obMsg.dic_chat[id]{
                    NavigationLink(destination: VwChat(obChat: chat).environmentObject(spr)
                        .environmentObject(evMypage)){
                        VwPreChat(chat)
                    }
                }
            }
            Spacer()
        }.onAppear(){
            print("VwMsger onapper")
            print(obMsg.dic_chat)
            print(obMsg.ary_id)
            
            obMsg.start()
            print("VwMsger onapper end")
        }
    }
}

struct VwPreChat:View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evMypage:EvMypage
    @State var elapsedTime = ""
    @ObservedObject var obChat: ObChat
    init(_ obChat: ObChat){
        print("VwPreChat")
        self.obChat = obChat
        print("VwPreChat end")
    }
    var body: some View{
        HStack(alignment: .top){
            Spacer().frame(width: 10)
            if let img = obChat.img_chat {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
            }else{
                Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding(10)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(Color.gray)
                .clipShape(Circle())
            }
            Spacer().frame(width: 10)
            VStack(alignment: .leading){
                Spacer().frame(height: 5)
                Text(obChat.name_chat)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(obChat.pre_text)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            Spacer()
            VStack{
                Text(elapsedTime)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer().frame(width: 10)
        }.onChange(of: obChat.pre_time){newValue in
            print("VwPreChat onChange")
            getElaTIme(newValue)
            print("VwPreChat onChange end")
        }
        .onAppear(){
            print("VwPreChat onApper")
            getElaTIme(obChat.pre_time)
            switch obChat.chara {
            case .love:obChat.name_from = evMypage.love_name
            default :obChat.name_from = evMypage.main_name
            }
            if obChat.name_from == ""{
                obChat.name_from = "Someone"
            }
            print("VwPreChat onApper end")
        }
    }
    
    func getElaTIme(_ time:String){
        print("getElaTIme")
        self.elapsedTime = getElapsedTime(timeN: nowDateStr(), timeT: time)
        print("getElaTIme end")
    }
}

struct VwChatCnt :View{
    let msg :RlmMsg
    @ObservedObject var obChat : ObChat
    let color:Color
    
    init(_ obChat:ObChat,msg:RlmMsg) {
        print("VwChatCnt")
        self.obChat = obChat
        self.msg = msg
        if msg.id_from == Spr.uid{
            color = Color(UIColor(red: 50, green: 255, blue: 50, alpha: 255))
        }else{
            color = .white
        }
        print("VwChatCnt end")
    }
    var body: some View{
        switch msg.type {
        case "text":
            Text(msg.cnt)
                .padding(10)
                .cornerRadius(10)
        default:
            Text("other msg type")
        }
    }
}
