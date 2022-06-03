//
//  RlMsger.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/12.
//

import Foundation
import RealmSwift
import SwiftUI

class RlmChat: Object{
    @objc dynamic var id_chat: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var img_url: String = ""
    @objc dynamic var chara :String = ""
    var persons = RealmSwift.List<RlmPerson>()
    var msges = RealmSwift.List<RlmMsg>()

    override static func primaryKey() -> String? {
        return "id_chat"
    }
}

func getRlmChat(_ id:String) -> RlmChat?{
    print("getRlmChat")
    if rlm_delete {return nil}
    do{
        let rlm = try Realm()
        print("getRlmChat end")
        return rlm.object(ofType: RlmChat.self, forPrimaryKey: id)
    }catch{
        print("getRlmChat end")
        print(error.localizedDescription)
        return nil
    }
}

func addRlmChatPerson(_ ary_id:[String],id_chat:String){
    print("addRlmChatPerson")
    if rlm_delete {return}
    do{
        let rlm = try Realm()
        guard let rlmChat = rlm.object(ofType: RlmChat.self, forPrimaryKey: id_chat) else {
            print("addRlmChatPerson end1")
            return
        }

        for id in ary_id{
            guard let person = Spr.dic_person[id] else{
                print("addRlmChatPerson end3")
                return
            }
            guard let rlmPerson = getRlmPerson(person) else {
                print("addRlmChatPerson end4")
                return
            }
            try rlm.write{
                rlmChat.persons.append(rlmPerson)
            }
        }
    }catch{
        print(error.localizedDescription)
    }
    print("addRlmChatPerson end2")
}


func getAryRlmChat() -> Results<RlmChat>?{
    print("getAryRlmChat")
    if rlm_delete {return nil}
    do{
        let rlm = try Realm()
        print("getAryRlmChat end1")
        return rlm.objects(RlmChat.self)
    }catch{
        print("getAryRlmChat end2")
        print(error.localizedDescription)
        return nil
    }
    
}

class RlmMsg: Object{
    @objc dynamic var id_chat = ""
    @objc dynamic var id_from = ""
    @objc dynamic var token_from = ""
    @objc dynamic var name_from = ""
    @objc dynamic var time = ""
    @objc dynamic var type = ""
    @objc dynamic var cnt = ""
    @objc dynamic var chara = ""
}

func addRlmMsg(_ rlmMsg:RlmMsg,id_chat:String){
    print("addRlmMsg")
    if rlm_delete {return}
    do{
        let rlm = try Realm()
        let rlmChat = rlm.object(ofType: RlmChat.self, forPrimaryKey: id_chat)
        try rlm.write{
            rlmChat?.msges.append(rlmMsg)
        }
    }catch{
        print(error.localizedDescription)
    }
    print("addRlmMsg end")
}
