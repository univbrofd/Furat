//
//  Person.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseUI

func getPerson(_ id:String, info:[String:Any]) -> Person{
    print("getPerson1")
    if let m_person = Spr.dic_person[id] {
        guard let date = info["time_up"] as? String,
              let time_up = date.date("yyyyMMddHHmmssSS") else{
            print("getPerson1 end2")
            return Person(id,info:info)
        }
        guard let m_time_up = m_person.time_up else{
            print("getPerson1 end3")
            return Person(id,info:info)
        }
        if time_up > m_time_up {
            print("getPerson1 end4")
            return m_person
        }
    }
    print("getPerson1 end5")
    return Person(id,info:info)
}

func getPerson(_ rlmPerson:RlmPerson) -> Person{
    print("getPerson2")
    if let m_person = Spr.dic_person[rlmPerson.id] {
        guard let time_up = rlmPerson.time_up else{
            print("getPerson2 end1")
            return Person(rlmPerson)
        }
        guard let m_time_up = m_person.time_up else{
            print("getPerson2 end2")
            return Person(rlmPerson)
        }
        if time_up > m_time_up {
            print("getPerson2 end3")
            return m_person
        }
    }
    print("getPerson2 end4")
    return Person(rlmPerson)
}

func getPerson(_ bull:Bull) -> Person{
    print("getPerson bull")
    if let m_person = Spr.dic_person[bull.id] {
        print("getPerson bull end1")
        return m_person
    }
    print("getPerson bull end2")
    return Person(bull)
}

class Person:Equatable{
    static func == (lhs: Person, rhs: Person) -> Bool {
        guard lhs.id == rhs.id else {return false}
        guard lhs.name == rhs.name else {return false}
        guard lhs.profiel == rhs.profiel else {return false}
        guard lhs.pref == rhs.pref else {return false}
        guard lhs.barth == rhs.barth else {return false}
        guard lhs.sex == rhs.sex else {return false}
        guard lhs.url_icon == rhs.url_icon else {return false}
        guard lhs.url_img1 == rhs.url_img1 else {return false}
        guard lhs.chara == rhs.chara else {return false}
        return true
    }

    let dpc_queue = DispatchQueue(label:"queue",attributes: .concurrent)
    var id : String
    var token : String = ""
    var name:String = ""
    var profiel:String = ""
    var pref:String = ""
    var barth:Date?
    var sex:Int?
    var time_up: Date?
    var icon:UIImage? = nil
    var img1:UIImage? = nil
    var url_icon:String = ""
    var url_img1:String = ""
    var chara:EmBullChara
  
    init(_ id:String, info:[String:Any]) {
        print("Person init1")
        self.id = id
        self.token = info["token"] as? String ?? ""
        self.name = info["name"] as? String ?? ""
        self.profiel = info["profiel"] as? String ?? ""
        if let barth = info["barth"] as? String,let date = barth.date("yyyyMMdd"){self.barth = date}
        self.sex = info["sex"] as? Int ?? nil
        self.pref = info["pref"] as? String ?? ""
        if let time_up = info["time_up"] as? String,let date = time_up.date("yyyyMMddHHmmssSS"){self.time_up = date}
        self.url_icon = info["icon"] as? String ?? ""
        self.url_img1 = info["img1"] as? String ?? ""
        if let str_chara = info["chara"] as? String,
           let chara = EmBullChara.init(rawValue: str_chara){
            self.chara = chara
        }else{self.chara = .global}
        init_cmn()
        print("Person init1 end")
    }

    init(_ rlmPerson:RlmPerson){
        print("Person init2")
        
        self.id = rlmPerson.id
        self.token = rlmPerson.token
        self.name = rlmPerson.name
        self.profiel = rlmPerson.profile
        self.pref = rlmPerson.pref
        self.barth = rlmPerson.barth
        self.sex = rlmPerson.sex.value
        self.time_up = rlmPerson.time_up
        self.url_icon = rlmPerson.url_icon
        self.url_img1 = rlmPerson.url_img1
        self.chara = EmBullChara.init(rawValue: rlmPerson.chara) ?? .global
        
        init_cmn()
        print("Person init2 end")
    }
    
    init(_ bull:Bull){
        self.id = bull.id
        self.token = bull.token
        self.chara = bull.chara
        if let bullLove = bull as? BullLove{
            self.name = bullLove.name
            self.profiel = bullLove.profile
            self.pref = bullLove.pref
            self.barth = bullLove.barth.date("yyyyMMdd")
            self.sex = bullLove.sex
            self.url_icon = bullLove.url_icon
            self.url_img1 = bullLove.url_img1
        }
        if let bullCall = bull as? BullCall{
            self.name = bullCall.name
            self.url_icon = bullCall.url_icon
        }
    }
    
    func init_cmn(){
        self.addUser()
    }
    
    func update(_ per:Person){
        print("update")
        if self.id != per.id {return}
        if self.name != per.name {self.name = per.name}
        if self.profiel != per.profiel {self.profiel = per.profiel}
        if self.barth != per.barth {self.barth = per.barth}
        if self.sex != per.sex {self.sex = per.sex}
        if self.time_up != per.time_up {self.time_up = per.time_up}
        if self.url_icon != per.url_icon {self.url_icon = per.url_icon}
        if self.url_img1 != per.url_img1 {self.url_img1 = per.url_img1}
        
        print("update end")
    }
    
    func getInfo() -> [String:String]{
        print("getInfo")
        let info = [
            "id":id,
            "naem":name,
            "profil":profiel
        ]
        print("getInfo end")
        return info
    }
    
    func addUser(){
        print("addUser")
        let id = self.id
        if Spr.dic_person.keys.contains(id){
            Spr.dic_person[id]?.update(self)
        }else{
            Spr.dic_person[id] = self
        }
        print("addUser end")
    }
    
    func getImg(_ url:String,emImg:EmImg) {
        print("getImg")
        if url.hasPrefix("gs://") {
            if let cachedImage = Spr.imageCache.object(forKey: url as AnyObject) as? UIImage {
                print("get img from cashe")
                setImg(cachedImage,emImg:emImg)
            }else{
                getFbImg(url,emImg: emImg)
                print("getImg end1")
                return
            }
        }else{
            if let url = URL(string: url) {
                if let data = try? Data(contentsOf: url)  {
                    if let uiimg = UIImage(data: data){
                        setImg(uiimg,emImg: emImg)
                    }
                }
            }
        }
        print("getImg end2")
    }
    
    func getFbImg(_ url:String,emImg:EmImg){
        print("getFbImg")
        print(self)
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
                        Spr.imageCache.setObject(m_uiimg, forKey: url
                                                 as AnyObject)
                        self.setImg(m_uiimg,emImg:emImg)
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
    func setImg(_ uiimg:UIImage,emImg:EmImg){
        switch emImg {
        case .icon:
            self.icon = uiimg
        case .img1:
            self.img1 = uiimg
        }
    }
}
