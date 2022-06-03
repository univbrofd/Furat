//
//  ObMsger.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//
import Foundation
import SwiftUI

class ObMsger:ObservableObject{
    @Published var dic_chat = [String:ObChat]()
    @Published var ary_id = [String]()
    
    init(){
        print("ObMsger init")
        start()
        print("ObMsger init end")
    }
    
    func start(){
        print("start")
        getChats()
        getMsg()
        ary_id = Array(dic_chat.keys)
        sortChats()
        print("start end")
    }
    
    func getChats(){
        print("getChats")
        guard let aryRlmChat = getAryRlmChat() else {
            print("getChats end1")
            return}
        for rlmChat in aryRlmChat {
            dic_chat[rlmChat.id_chat] = ObChat(rlmChat)
        }
        print("getChats end2")
    }
    
    var ary_msg = [[String:String]]()
    
    func getMsg(){
        print("getMsg")
        guard !pTst["msger"]! else{
            print("getMsg end1")
            ary_msg = [[String:String]]()
            return
        }
        
        let ref = rtdb.child("msg/\(Spr.uid)")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            print("snapshot get sucess snapshot:\(snapshot)")
            ref.removeValue()
            if let values = snapshot.value as? [String:Any]{
                values.forEach({(key, value) in
                    if let info = value as? [String:String]{
                        self.ary_msg.append(info)
                    }
                })
                self.loadMsg()
            }
        }){error in
            print(error.localizedDescription)
            print("getMsg end4")
        }
        
        print("getMsg end2")
    }
    
    func loadMsg(){
        print("loadMsg")
        for msg in ary_msg {
            let rlmMsg = RlmMsg(value: msg)
            
            print(dic_chat)
            print(ary_id)
            if let id = msg["id_from"]{
                print(id)
                print(dic_chat[id])
                if dic_chat.keys.contains(id){
                    dic_chat[id]?.addMsg(rlmMsg)
                }else{
                    dic_chat[id] = ObChat(rlmMsg)
                    ary_id.append(id)
                }
            }
        }
        ary_msg = [[String:String]]()
        print("loadMsg end")
    }
    
    func sortChats(){
        print("sortChats")
        self.ary_id = ary_id.sorted(by:{
            let time0 = dic_chat[$0]?.pre_time.date("yyyyMMddHHmmssSSSS") ?? Date()
            let time1 = dic_chat[$1]?.pre_time.date("yyyyMMddHHmmssSSSS") ?? Date()
            print("sortChats end1")
            return (time0 < time1)
        })
        print("sortChats end2")
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
    @Published var ary_msg_load = [RlmMsg]()
    var idx_load = 0
    var url_icon = ""
    @Published var id_chat : String
    @Published var img_chat : UIImage?
    @Published var ary_uid = [String]()
    let chara:EmBullChara
    var name_from = ""
    
    init(_ rlmChat:RlmChat){
        print("ObChat inti1")
        self.rlmChat = rlmChat
        self.id_chat = rlmChat.id_chat
        self.name_chat = rlmChat.name
        self.chara = EmBullChara.init(rawValue: rlmChat.chara) ?? .global
        
        for rlmPerson in Array(rlmChat.persons){
            let person = getPerson(rlmPerson)
            ary_uid.append(person.id)
        }
        
        initCmn()
        print("ObChat inti1 end")
    }
    init(_ person:Person){
        print("ObChat inti2")
        self.id_chat = person.id
        self.name_chat = person.name
        self.url_icon = person.url_icon
        self.chara = person.chara
        let info = ["id_chat":id_chat,"name":name_chat,"img_url":url_icon]
        if let rlmChat = getRlmChat(info:info){
             self.rlmChat = rlmChat
        }
        addPerson([person.id])
        
        initCmn()
        print("ObChat inti2 end")
    }
    init(_ rlmMsg:RlmMsg){
        print("ObChat inti3")
        self.id_chat = rlmMsg.id_chat
        self.name_chat = rlmMsg.name_from
        self.chara = EmBullChara.init(rawValue: rlmMsg.chara) ?? .global
        self.url_icon = Spr.dic_person[id_chat]?.url_icon ?? ""
        let info = ["id_chat":id_chat,"name":name_chat,"img_url":url_icon]
        if let rlmChat = getRlmChat(info: info){
             self.rlmChat = rlmChat
        }
        addMsg(rlmMsg)
        addPerson([rlmMsg.id_from])
        
        initCmn()
        print("ObChat inti3 end")
    }
    func initCmn(){
        print("initCmn")
        
        if let msges = rlmChat?.msges {
            print(msges.count)
            ary_msg = Array(msges)
            idx_load = ary_msg.count
            if let rlm_msg = ary_msg.last{
                setMsgPreData(rlmMsg: rlm_msg)
            }
            loadMsg()
        }
        if let img_url = rlmChat?.img_url{
            getImg(img_url)
        }
        print("initCmn end")
    }
    
    func addPerson(_ ary_uid:[String]){
        print("addPerson")
        for uid in ary_uid{
           self.ary_uid.append(uid)
        }
        addRlmChatPerson(ary_uid, id_chat: id_chat)
        print("addPerson end")
    }
    
    func addMsg(_ rlmMsg:RlmMsg){
        print("addMsg")
        if ary_msg.contains(where: {$0.time == rlmMsg.time}){
            print("addMsg end1`")
            return
        }
        
        ary_msg.append(rlmMsg)
        ary_msg_load.append(rlmMsg)
        setMsgPreData(rlmMsg: rlmMsg)
        
        new_num += 1
        
        addRlmMsg(rlmMsg,id_chat: id_chat)
        print("addMsg end")
    }
    
    func setMsgPreData(rlmMsg:RlmMsg){
        print("setMsgPre")
        
        switch rlmMsg.type {
            case "text" : self.pre_text = rlmMsg.cnt
            default : self.pre_text = "other than text"
        }
        self.pre_time = rlmMsg.time
        
        print("setMsgPre end")
    }
    
    func sendMsg(text:String){
        print("sendMsg")
        if self.name_from == "" {
            self.name_from = "Someone"
        }
        let time = nowDateStr()
        let dic_msg = [
            "id_chat":id_chat,
            "id_from":Spr.uid,
            "name_from":name_from,
            "time":time,
            "type":"text",
            "cnt":text,
            "chara":chara.rawValue
        ]
        print(ary_uid)
        for uid in ary_uid{
            Qey.sendMsg(msg: dic_msg,uid:uid)
        }
        let rlmMsg = RlmMsg(value:dic_msg)
        addMsg(rlmMsg)
        print("sendMsg end")
    }
    
    func sortMsg(){
        print("sortMsg")
        self.ary_msg = ary_msg.sorted(by:{
            let msg0 = $0.id_chat
            let msg1 = $1.id_chat
            return (msg0 < msg1)
        })
        print("sortMsg end")
    }
    
    func loadMsg(){
        print("loadMsg")
        for _ in 0..<10 {
            idx_load -= 1
            if idx_load < 0 {break}
            let msg = ary_msg[idx_load]
            self.ary_msg_load.insert(msg,at:0)
        }
        print("loadMsg end")
    }
    
    func setSmplMsg(){
        print("setSmplMsg")
        guard let id = ary_uid.first else {return}
        if let person = Spr.dic_person[id] {
            let rlmMsg = RlmMsg(value: [
                "id_chat":id_chat,
                "id_from":person.id,
                "name":person.name,
                "time":nowDateStr(),
                "type":"text",
                "cnt":"おやすみ"
            ])
            addMsg(rlmMsg)
        }
        print("setSmplMsg end")
    }
    
    func getImg(_ url:String){
        print("getImg")
        if url.hasPrefix("gs://") {
            if let cachedImage = Spr.imageCache.object(forKey: url as AnyObject) as? UIImage {
                print("get img from cashe")
                self.img_chat = cachedImage
            }else{
                getFbImg(url)
                return
            }
        }else{
            if let url = URL(string: url) {
                if let data = try? Data(contentsOf: url)  {
                    self.img_chat = UIImage(data: data)
                }
            }
        }
    }
    
    func getFbImg(_ url:String){
        print("getFbImg")
        print(url)
        let starsRef = storage.reference(forURL:url)
        starsRef.downloadURL { url_dl, error in
            if let error = error {
                print(error)
            } else if let m_url_dl = url_dl {
                print(m_url_dl)
                do{
                    let data = try Data(contentsOf: m_url_dl)
                    print("succsess get image")
                    if let m_uiimg = UIImage(data: data){
                        self.img_chat = m_uiimg
                        Spr.imageCache.setObject(m_uiimg, forKey: url as AnyObject)
                    }else{
                        print("failed get image")
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        print("getImgFb end")
    }
}
