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
    var body: some View {
        VStack{
            ForEach(obMsg.ary_id,id:\.self){ id in
                if let chat = obMsg.dic_chat[id]{
                    NavigationLink(destination: VwChat(obChat: chat).environmentObject(spr)){
                        VwPreChat(chat)
                    }
                }
            }
        }.onAppear(){
            print("onapper vwmsger")
            print(obMsg.dic_chat)
            print(obMsg.ary_id)
            
            obMsg.start()
        }
    }
}

struct VwPreChat:View {
    @EnvironmentObject var spr:Spr
    @State var elapsedTime = ""
    var obChat: ObChat
    init(_ obChat: ObChat){
        self.obChat = obChat
    }
    var body: some View{
        HStack{
            if let img = obChat.img_chat {
                Image(uiImage: img)
            }else{
                Image(systemName: "person.fill")
            }
            VStack{
                Text(obChat.name_chat)
                Text(obChat.pre_text)
            }
            Spacer()
            VStack{
                Text(elapsedTime)
            }
        }.onChange(of: obChat.pre_time){newValue in
            getElaTIme(newValue)
        }
        .onAppear(){
            getElaTIme(obChat.pre_time)
        }
    }
    
    func getElaTIme(_ time:String){
        self.elapsedTime = getElapsedTime(timeN: nowDateStr(), timeT: time)
    }
}

struct VwChat:View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMsg : ObMsger
    @State var input_text:String = ""
    @ObservedObject var obChat : ObChat
    @State var inp_text = ""
    init(obChat:ObChat) {
        self.obChat = obChat
    }
    init(person:Person) {
        self.obChat = ObChat(person)
    }
    var body: some View{
        ZStack{
            ScrollView{
                VStack{
                    ForEach(obChat.ary_msg,id:\.self){ msg in
                        VwChatRow(msg)
                    }
                }
                Spacer()
            }
            VStack{
                Spacer()
                HStack{
                    Spacer().frame(width:2)
                    TextField(
                        "メッセージを入力",
                        text: $inp_text
                    )
                    Spacer().frame(width:2)
                    Button(action: {
                        if let myself = spr.myself {
                            obChat.sendMsg(myself: myself,text: inp_text)
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill")
                    })
                    Spacer().frame(width:2)
                }.frame(height:50)
            }
        }.navigationBarTitle(obChat.name_chat,displayMode: .inline)
        .navigationBarHidden(false)
        .onAppear(){
            obChat.setSmplMsg()
        }
    }
}

struct VwChatRow:View{
    @EnvironmentObject var spr:Spr
    let msg:RlmMsg
    init(_ msg:RlmMsg) {
        self.msg = msg
    }
    var body :some View{
        if self.msg.id_from == spr.myself!.id{
            VwChatRowR(msg: self.msg)
        }else{
            VwChatRowL(msg: self.msg)
        }
    }
}

struct VwChatRowR :View{
    let msg :RlmMsg
    
    init(msg:RlmMsg) {
        self.msg = msg
    }
    var body : some View{
        HStack{
            Spacer()
            VwChatCnt(msg.type,cnt: msg.cnt)
        }
    }
}

struct VwChatRowL:View {
    let msg :RlmMsg
    
    init(msg:RlmMsg) {
        self.msg = msg
    }
    var body: some View {
        HStack(alignment: .top){
            VwChatIcon(id:msg.id_from)
            Text(msg.cnt)
            Spacer()
        }
    }
}

struct VwChatCnt :View{
    let typ :String
    let cnt :String
    init(_ typ:String,cnt:String) {
        self.typ = typ
        self.cnt = cnt
    }
    var body: some View{
        switch typ {
        case "text":
            Text(cnt)
        default:
            Text("other msg type")
        }
    }
}

struct VwChatIcon:View {
    init(id:String) {
        
    }
    var body: some View{
        Image(systemName: "paperplane.fill")
    }
}
