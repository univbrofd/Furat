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

class Person{
    let qey = Query()
    let dpc_queue = DispatchQueue(label:"queue",attributes: .concurrent)
    var id : String
    var name:String = ""
    var initial:String = ""
    var url_icon:String = ""
    var url_img1:String = ""
    var profiel:String = ""
    var pref:String = ""
    var barth:Date?
    var age:Int?
    var sex:Int?
    var icon:UIImage? = nil
    var img1:UIImage? = nil
    var msg: String = ""
    var time_msg: Date?
    var height_icon: CGFloat? = nil
    var height_img1: CGFloat? = nil
    enum em_img {
        case icon
        case img1
    }
    
  
    init(_ id:String, m_info:[String:String]) {
        self.id = id
        if let name = m_info["name"]{self.name = name}
        if let initial = m_info["initial"]{self.initial = initial}
        if let url_icon = m_info["url_icon"]{self.url_icon = url_icon}
        if let url_img1 = m_info["url_img1"]{self.url_img1 = url_img1 }
        if let profiel = m_info["profiel"]{self.profiel = profiel }
        if let barth = m_info["barth"]{
            if let date = barth.date("yyyyMMdd"){
                self.barth = date
            }
        }
        if let age = m_info["age"]{self.age = Int(age)}
        if let sex = m_info["sex"]{self.sex = Int(sex)}
        if let pref = m_info["pref"]{self.pref = pref}
        if let url_icon = m_info["icon"]{self.url_icon = url_icon}
        if let url_img1 = m_info["img1"]{self.url_img1 = url_img1}
        if let msg = m_info["msg"]{self.msg = msg}
        if let time_msg = m_info["time_msg"]{
            if let date = time_msg.date("yyyyMMddHHmmssSS"){
                self.time_msg = date
            }
        }
    }

    init(_ rlmPerson:RlmPerson){
        self.id = rlmPerson.id
        self.name = rlmPerson.name
        self.initial = rlmPerson.initial
        self.url_icon = rlmPerson.url_icon
        self.url_img1 = rlmPerson.url_img1
        self.profiel = rlmPerson.profile
        self.pref = rlmPerson.pref
        self.barth = rlmPerson.barth
        self.age = rlmPerson.age.value
        self.sex = rlmPerson.sex.value
    }
    
    func update(_ per:Person){
        if self.id != per.id {return}
        if self.name != per.name {self.name = per.name}
        if self.url_icon != per.url_icon {self.url_icon = per.url_icon}
        if self.url_img1 != per.url_img1 {self.url_img1 = per.url_img1}
        if self.profiel != per.profiel {self.profiel = per.profiel}
        if self.barth != per.barth {self.barth = per.barth}
        if self.age != per.age {self.age = per.age}
        if self.sex != per.sex {self.sex = per.sex}
        if self.icon != per.icon {self.icon = per.icon}
        if self.img1 != per.img1 {self.img1 = per.img1}
        if self.msg != per.msg {self.msg = per.msg}
        if self.time_msg != per.time_msg {self.time_msg = per.time_msg}
        if self.height_icon != per.height_icon {self.height_icon = per.height_icon}
        if self.height_img1 != per.height_img1 {self.height_img1 = per.height_img1}
    }
    
    func getInfo() -> [String:String]{
        let info = [
            "id":id,
            "naem":name,
            "icon":url_icon,
            "img1":url_img1,
            "profil":profiel
        ]
        return info
    }
    
    func getImges(){
        getImg(url_icon,em: .icon)
        getImg(url_img1,em: .img1)
    }
    
    func getImg(_ m_url:String,em:em_img){
        let semaphore = DispatchSemaphore(value: 0)
        if m_url.hasPrefix("gs://") {
            if let uiimg = qey.getImgFb(m_url){
                self.setImg(uiimg, em: em)
            }
        }else{
            var uiimg : UIImage?
            if let url = URL(string: m_url) {
                if let data = try? Data(contentsOf: url){
                    uiimg = UIImage(data: data)
                    semaphore.signal()
                }
            }
            semaphore.wait()
            self.setImg(uiimg, em: em)
        }
        
    }
    /*
    func getImgFb(_ m_url:String,em:em_img){
        let semaphore = DispatchSemaphore(value: 0)
        let starsRef = storage.reference(forURL:m_url)
        var uiimg : UIImage?
        starsRef.downloadURL { url, error in
            if let error = error {
                print(m_url)
                print(error)
            } else if let url = url {
                print("success get url")
                print(url)
                if let data = try? Data(contentsOf: url){
                    print("succsess get image")
                    uiimg = UIImage(data: data)
                    semaphore.signal()
                }
            }
        }
        semaphore.wait()
        self.setImg(uiimg, em: em)
    }
    */
    func setImg(_ uiimg:UIImage?,em:em_img){
        guard let uiimg = uiimg else {
            return
        }
        let height = uiimg.size.height/uiimg.size.width
        
        switch em{
        case .icon:
            self.icon = uiimg
        case .img1:
            self.img1 = uiimg
            self.height_img1 = height
        }
    }
}
