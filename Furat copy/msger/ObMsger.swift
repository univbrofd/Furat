//
//  ObMsger.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//
import Foundation
import SwiftUI

class ObMsger:ObservableObject{
    let qey = Query()
    @Published var dic_chat = [String:ObChat]()
    @Published var ary_id = [String]()
    
    init(){
        //start()
    }
    
    func start(){
        getChats()
        getMsg()
        ary_id = Array(dic_chat.keys)
        sortChats()
    }
    
    func getChats(){
        guard let aryRlmChat = getAryRlmChat() else {
            print("getChats return")
            return}
        for rlmChat in aryRlmChat {
            dic_chat[rlmChat.id_chat] = ObChat(rlmChat)
        }
    }
    
    func getMsg(){
        let ary_msg = qey.getMsg()
        guard ary_msg.count > 0 else{
            return
        }
        for msg in ary_msg {
            let rlmMsg = RlmMsg(value: msg)
            
            if let id = msg["id"]{
                if dic_chat.keys.contains(id){
                    dic_chat[id]?.addMsg(rlmMsg)
                }else{
                    dic_chat[id] = ObChat(rlmMsg)
                }
            }
        }
    }
    
    func sortChats(){
        self.ary_id = ary_id.sorted(by:{
            let time0 = dic_chat[$0]?.pre_time.date("yyyyMMddHHmmssSSSS") ?? Date()
            let time1 = dic_chat[$1]?.pre_time.date("yyyyMMddHHmmssSSSS") ?? Date()
            return (time0 < time1)
        })
    }
}

class ObChat:ObservableObject{
    //g-id,sender,time,type,cnt
    @Published var rlmChat :RlmChat?
    @Published var name_chat = ""
    @Published var pre_text = ""
    @Published var pre_time = ""
    @Published var new_num = 0
    @Published var ary_msg = [RlmMsg]()
    @Published var id_chat : String
    @Published var img_chat : UIImage?
    @Published var ary_person = [Person]()
    var qey = Query()

    init(_ rlmChat:RlmChat){
        self.rlmChat = rlmChat
        self.id_chat = rlmChat.id_chat
        self.name_chat = rlmChat.name
        
        for rlmPerson in Array(rlmChat.persons){
            ary_person.append(Person(rlmPerson))
        }
        
        initCmn()
    }
    init(_ person:Person){
        self.id_chat = person.id
        self.name_chat = person.initial
        
        if let uiimg = person.icon {
            self.img_chat = uiimg
        }
        
        let info = ["id_chat":id_chat,"name":name_chat,"img_url":person.url_icon]
        
        if let rlmChat = getRlmChat(info:info){
             self.rlmChat = rlmChat
        }
        addPerson([person.id])
        
        initCmn()
    }
    init(_ rlmMsg:RlmMsg){
        self.id_chat = rlmMsg.id_chat
        self.name_chat = rlmMsg.name
        let img_url = dic_person[id_chat]?.url_icon
        
        let info = ["id_chat":id_chat,"name":name_chat,"img_url":img_url ?? ""]
        if let rlmChat = getRlmChat(info: info){
             self.rlmChat = rlmChat
        }
        addMsg(rlmMsg)
        addPerson([rlmMsg.id_from])
        
        initCmn()
    }
    
    func initCmn(){
        if let msges = rlmChat?.msges {
            ary_msg = Array(msges)
        }
        if let img_url = rlmChat?.img_url{
            img_chat = qey.getImgFb(img_url)
        }
    }
    
    func addPerson(_ ary_uid:[String]){
        for uid in ary_uid{
            if let person = dic_person[uid] {
                ary_person.append(person)
            }
        }
        addRlmChatPerson(self.ary_person, id_chat: id_chat)
    }
    
    func addMsg(_ rlmMsg:RlmMsg){
        print("addMsg")
        ary_msg.append(rlmMsg)
        switch rlmMsg.type {
            case "text" : self.pre_text = rlmMsg.cnt
            default : self.pre_text = "other than text"
        }
        self.pre_time = rlmMsg.time
        
        new_num += 1
        
        addRlmMsg(rlmMsg,id_chat: id_chat)
    }
    
    func sendMsg(myself:Person,text:String){
        print("sendMsg")
        let id = myself.id
        let name = myself.name
        let time = nowDateStr()
        let dic_msg = [
            "id_chat":id_chat,
            "id_from":id,
            "name":name,
            "time":time,
            "type":"text",
            "cnt":text
        ]
        let rlmMsg = RlmMsg(value:dic_msg)
        addMsg(rlmMsg)
        //qey.sendMsg
    }
    
    func sortMsg(){
        self.ary_msg = ary_msg.sorted(by:{
            let msg0 = $0.id_chat
            let msg1 = $1.id_chat
            return (msg0 < msg1)
        })
    }
    
    func setSmplMsg(){
        if let person = ary_person.first {
            let rlmMsg = RlmMsg(value: [
                "id_chat":id_chat,
                "id_from":person.id,
                "name":person.initial,
                "time":nowDateStr(),
                "type":"text",
                "cnt":"こんにちは"
            ])
            addMsg(rlmMsg)
        }
    }
}
