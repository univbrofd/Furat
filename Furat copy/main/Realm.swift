//
//  Realm.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import Foundation
import Foundation
import RealmSwift

/*
func rlmMigration() {
  // 次のバージョン（現バージョンが０なので、１をセット）
    let nextSchemaVersion = 1

  // マイグレーション設定
    let config = Realm.Configuration(
        schemaVersion: UInt64(nextSchemaVersion),
        migrationBlock: { migration, oldSchemaVersion in
            print("ready migration")
            print(oldSchemaVersion)
            if (oldSchemaVersion < nextSchemaVersion) {
                print("rlm migration")
            }
        })
    Realm.Configuration.defaultConfiguration = config
    
}

func rlmrlm(){
    let realm = try! Realm()
}

func rlmDeleteAll(){
    
    do{
        let realm = try Realm()
        //let rlmPerson = realm.objects(RlmPerson.self)
        //let rlmChat = realm.objects(RlmChat.self)
        //let rlmMsg = realm.objects(RlmMsg.self)
        try realm.write {
            //realm.delete(rlmPerson)
            //realm.delete(rlmChat)
            //realm.delete(rlmMsg)
            realm.deleteAll()
            print("realm delete sucsess")
        }
    }catch{
        print("realm delete failed")
        print(error.localizedDescription)
    }
}
*/
class RlmPerson: Object{
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var initial: String = ""
    @objc dynamic var url_icon : String = ""
    @objc dynamic var url_img1 : String = ""
    @objc dynamic var profile : String = ""
    @objc dynamic var pref : String = ""
    @objc dynamic var barth : Date? = nil
    var age = RealmOptional<Int>()
    var sex = RealmOptional<Int>()
    override static func primaryKey() -> String? {
        return "id"
    }
}

func getRlmPerson(_ person:Person) -> RlmPerson{
    let info :[String:Any?] = [
        "id" : person.id,
        "name" : person.name,
        "initial" : person.initial,
        "url_icon" : person.url_icon,
        "url_img1" : person.url_img1,
        "profile" : person.profiel,
        "pref" : person.pref,
        "barth" : person.barth,
        "age" : person.age ?? RealmOptional<Int>(),
        "sex" : person.sex ?? RealmOptional<Int>()
    ]
    let rlmPerson = RlmPerson(value: info)
    saveRlmPerson(rlmPerson)
    return RlmPerson(value: info)
}

func saveRlmPerson(_ rlmPerson:RlmPerson){
    do{
        let rlm = try Realm()
        try rlm.write(){
            rlm.add(rlmPerson,update: .modified)
        }
    }catch{
        print(error.localizedDescription)
    }
}

class RlmChat: Object{
    @objc dynamic var id_chat: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var img_url: String = ""
    var persons = List<RlmPerson>()
    var msges = List<RlmMsg>()

    override static func primaryKey() -> String? {
        return "id_chat"
    }
}

func addRlmChatPerson(_ ary_person:[Person],id_chat:String){
    do{
        let rlm = try Realm()
        let rlmChat = rlm.object(ofType: RlmChat.self, forPrimaryKey: id_chat)
        for person in ary_person{
            let rlmPerson = getRlmPerson(person)
            try rlm.write{
                rlmChat?.persons.append(rlmPerson)
            }
        }
    }catch{
        print(error.localizedDescription)
    }
}

func getAryRlmChat() -> Results<RlmChat>?{
    do{
        let rlm = try Realm()
        return rlm.objects(RlmChat.self)
    }catch{
        print(error.localizedDescription)
        return nil
    }
}

func getRlmChat(info:[String:String]) -> RlmChat? {// id_chat:String,name:String) -> RlmChat?{
    do{
        let rlm = try Realm()
        if let rlmChat = rlm.object(ofType: RlmChat.self, forPrimaryKey: info["id_chat"]){
            return rlmChat
        }else{
            let rlmChat = RlmChat(value:info)/*[
                "id_chat":id_chat,
                "name":name,
                "img_ulr":
            ])*/
            try rlm.write{
                rlm.add(rlmChat)
            }
            return rlmChat
        }
    }catch{
        print(error.localizedDescription)
        return nil
    }
}

class RlmMsg: Object{
    @objc dynamic var id_chat = ""
    @objc dynamic var id_from = ""
    @objc dynamic var name = ""
    @objc dynamic var time = ""
    @objc dynamic var type = ""
    @objc dynamic var cnt = ""
}

func addRlmMsg(_ rlmMsg:RlmMsg,id_chat:String){
    do{
        let rlm = try Realm()
        let rlmChat = rlm.object(ofType: RlmChat.self, forPrimaryKey: id_chat)
        try rlm.write{
            rlmChat?.msges.append(rlmMsg)
        }
    }catch{
        print(error.localizedDescription)
    }
}
