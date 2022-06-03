//
//  Realm.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import Foundation
import RealmSwift

/*
func rlmMigration() {
    print("rlmMigration")
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
 print("rlmMigration end")
}

func rlmrlm(){
 print("rlmrlm")
    let realm = try! Realm()
 print("rlmrlm end")
}
*/

let rlm_delete = false
func rlmDeleteAll(){
    print("rlmDeleteAll")
    do{
        let realm = try Realm()
        let rlmPerson = realm.objects(RlmPerson.self)
        let rlmChat = realm.objects(RlmChat.self)
        let rlmMsg = realm.objects(RlmMsg.self)
        try realm.write {
            realm.delete(rlmPerson)
            realm.delete(rlmChat)
            realm.delete(rlmMsg)
            realm.deleteAll()
            print("realm delete sucsess")
        }
    }catch{
        print("realm delete failed")
        print(error.localizedDescription)
    }
    print("rlmDeleteAll end")
}

class RlmPerson: Object{
    @objc dynamic var id: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url_icon : String = ""
    @objc dynamic var url_img1 : String = ""
    @objc dynamic var profile : String = ""
    @objc dynamic var pref : String = ""
    @objc dynamic var barth : Date? = nil
    @objc dynamic var time_up : Date? = nil
    var sex = RealmOptional<Int>()
    @objc dynamic var chara :String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

func getRlmPerson(_ id:String) -> RlmPerson?{
    print("getRlmPerson1")
    if rlm_delete {return nil}
    do{
        let rlm = try Realm()
        print("getRlmPerson1 end1")
        return rlm.object(ofType: RlmPerson.self, forPrimaryKey: id)
    }catch{
        print("getRlmPerson1 end2")
        print(error.localizedDescription)
        return nil
    }
}

func getRlmPerson(_ person:Person) -> RlmPerson?{
    print("getRlmPerson2")
    if rlm_delete {return nil}
    let info :[String:Any?] = [
        "id" : person.id,
        "token" : person.token,
        "name" : person.name,
        "url_icon" : person.url_icon,
        "url_img1" : person.url_img1,
        "profile" : person.profiel,
        "pref" : person.pref,
        "barth" : person.barth,
        "time_up" : person.time_up,
        "sex" : person.sex ?? RealmOptional<Int>(),
        "chara" : person.chara.rawValue
    ]
    let rlmPerson = RlmPerson(value: info)
    saveRlmPerson(rlmPerson)
    print("getRlmPerson2 end")
    return rlmPerson
}

func saveRlmPerson(_ rlmPerson:RlmPerson){
    print("saveRlmPerson")
    if rlm_delete {return}
    do{
        let rlm = try Realm()
        try rlm.write(){
            rlm.add(rlmPerson,update: .modified)
        }
    }catch{
        print(error.localizedDescription)
    }
    print("saveRlmPerson end")
}

func getRlmChat(info:[String:String]) -> RlmChat? {
    print("getRlmChat")
    if rlm_delete {return nil}
    guard let id = info["id_chat"] else{return nil}
    do{
        let rlm = try Realm()
        if let rlmChat = rlm.object(ofType: RlmChat.self, forPrimaryKey: id){
            print("getRlmChat end1")
            return rlmChat
        }else{
            let rlmChat = RlmChat(value:info)
            try rlm.write{
                rlm.add(rlmChat,update: .modified)
            }
            print("getRlmChat end2")
            return rlmChat
        }
    }catch{
        print("getRlmChat end3")
        print(error.localizedDescription)
        return nil
    }
}


class RlImage :Object{
    @objc dynamic var id: String = ""
    @objc dynamic var image: NSData? = nil
    override static func primaryKey() -> String? {
        return "id"
    }
}

func getRlImage(id:String) -> NSData?{
    print("getRlImage")
    do{
        let rlm = try Realm()
        guard let rlImage = rlm.object(ofType: RlImage.self, forPrimaryKey: id) else{
            return nil
        }
        print("getRlImage end2")
        return rlImage.image
    }catch{
        print("getRlImage end3")
        print(error.localizedDescription)
        return nil
    }
}

func saveRlImage(id:String,image:Data){
    print("saveRlImage")
    if rlm_delete {return}
    let rlImage = RlImage(value: [
        "id":id,
        "image":image
    ])
    do{
        let rlm = try Realm()
        try rlm.write(){
            rlm.add(rlImage,update: .modified)
        }
        print("saveRlImage end1")
    }catch{
        print(error.localizedDescription)
        print("saveRlImage end2")
        return
    }
}
