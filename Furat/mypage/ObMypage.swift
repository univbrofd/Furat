//
//  ObMypage.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/11.
//

import Foundation
import UIKit
import CryptoKit

class MyData:Equatable,Encodable,Decodable{
    static func == (lhs: MyData, rhs: MyData) -> Bool {
        if lhs.main_name != rhs.main_name {return false}
        if lhs.main_url_icon != rhs.main_url_icon {return false}
        if lhs.love_name != rhs.love_name {return false}
        if lhs.love_url_img1 != rhs.love_url_img1 {return false}
        if lhs.love_pref != rhs.love_pref {return false}
        if lhs.love_profile != rhs.love_profile {return false}
        if lhs.call_name != rhs.call_name {return false}
        if lhs.call_url_icon != rhs.call_url_icon {return false}
        if lhs.call_skypeId != rhs.call_skypeId {return false}
        if lhs.call_discordId != rhs.call_discordId {return false}
        return true
    }
    
    var uid :String?
    var barth:String?
    var sex :Int?
    var main_name : String?
    var main_url_icon : String?
    var love_relese : Bool = false
    var love_name : String?
    var love_url_img1 : String?
    var love_pref : String?
    var love_profile : String?
    var call_name : String?
    var call_url_icon : String?
    var call_skypeId : String?
    var call_discordId : String?
    
    init(){}
    init(
        barth:String?,
        sex :Int?,
        main_name : String?,
        main_url_icon : String?,
        love_relese : Bool,
        love_name : String?,
        love_url_img1 : String?,
        love_pref : String?,
        love_profile : String?,
        call_name : String?,
        call_url_icon : String?,
        call_skypeId : String?,
        call_discordId : String?
    ){
        self.barth = barth
        self.sex = sex
        self.main_name = main_name
        self.main_url_icon = main_url_icon
        self.love_relese = love_relese
        self.love_name = love_name
        self.love_url_img1 = love_url_img1
        self.love_pref = love_pref
        self.love_profile = love_profile
        self.call_name = call_name
        self.call_url_icon = call_url_icon
        self.call_skypeId = call_skypeId
        self.call_discordId = call_discordId
    }
}

class EvMypage :ObservableObject{
    let udef :UserDefaults
    var myData = MyData()
    @Published var barth:String? = nil
    @Published var sex :Int? = nil
    @Published var uid : String? = nil
    @Published var main_name : String = ""
    @Published var main_url_icon : String = ""
    @Published var main_icon : UIImage? = nil
    @Published var love_relese : Bool = false
    @Published var love_name :String = ""
    @Published var love_url_img1 :String = ""
    @Published var love_img1 : UIImage? = nil
    @Published var love_pref : String = ""
    @Published var love_profile :String = ""
    @Published var call_name :String = ""
    @Published var call_url_icon :String = ""
    @Published var call_icon : UIImage? = nil
    @Published var call_skypeId :String = ""
    @Published var call_dicordId :String = ""
    @Published var update_main_icon = false
    @Published var update_love_img = false
    @Published var update_call_icon = false
    
    init(){
        self.udef = UserDefaults.standard
        getData()
    }
    
    func bolProfileLove() -> Bool{
        if barth == nil {return false}
        if sex == nil{return false}
        if love_name == "" {return false}
        if love_url_img1 == "" {return false}
        
        return true
    }
    
    func getBull(_ chara:EmBullChara) -> Bull{
        print("getBull")
        switch chara {
        case .love:
            let bullLove = BullLove(chara: .love)
            bullLove.name = love_name
            bullLove.url_img1 = love_url_img1
            bullLove.img1 = love_img1
            bullLove.pref = love_pref
            bullLove.sex = sex ?? 0
            bullLove.barth = barth ?? ""
            bullLove.profile = love_profile
            if let w = love_img1?.size.width, let h = love_img1?.size.height{
                bullLove.img_ratioH = Double(h) / Double(w)
            }
            return bullLove
        case .party:
            let bullParty = BullParty(chara: chara)
            return bullParty
        case .global:
            let bullGlobal = BullGlobal(chara: chara)
            bullGlobal.name = main_name
            bullGlobal.icon = main_icon
            bullGlobal.url_icon = main_url_icon
            return bullGlobal
        case .note:
            let bullNote = BullNote(chara: chara)
            bullNote.name = main_name
            bullNote.icon = main_icon
            bullNote.url_icon = main_url_icon
            return bullNote
        }
        print("getBull end")
    }
    
    func getData(){
        print("getData")
        if let data = udef.data(forKey: "MyData") {
            do {
                let decoder = JSONDecoder()
                let myData = try decoder.decode(MyData.self, from: data)
                self.myData = myData
                self.barth = myData.barth
                self.sex = myData.sex
                self.main_name = myData.main_name ?? ""
                self.main_url_icon = myData.main_url_icon ?? ""
                self.love_relese = myData.love_relese
                self.love_name = myData.love_name ?? ""
                self.love_url_img1 = myData.love_url_img1 ?? ""
                self.love_pref = myData.love_pref ?? ""
                self.love_profile = myData.love_profile ?? ""
                self.call_name = myData.call_name ?? ""
                self.call_url_icon = myData.call_url_icon ?? ""
                self.call_skypeId = myData.call_skypeId ?? ""
                self.call_dicordId = myData.call_discordId ?? ""
                print(main_name)
                print(love_name)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        print(love_url_img1)
        self.main_icon = getImg(id: "main_icon")
        self.love_img1 = getImg(id: "love_img")
        self.call_icon = getImg(id: "call_icon")
        print("getData end")
    }
    
    func getImg(id:String) -> UIImage?{
        print("getImg")
        guard let nsData = getRlImage(id: id) else{
            print("getImg end1")
            return nil
        }
        print("getImg end2")
        return UIImage(data: nsData as Data)
    }
    
    func instMyData() -> MyData{
        print("instMyData")
        return MyData(
            barth: self.barth,
            sex: self.sex,
            main_name: self.main_name,
            main_url_icon: self.main_url_icon,
            love_relese: self.love_relese,
            love_name: self.love_name,
            love_url_img1: self.love_url_img1,
            love_pref: self.love_pref,
            love_profile: love_profile,
            call_name: call_name,
            call_url_icon: call_url_icon,
            call_skypeId: call_skypeId,
            call_discordId: call_dicordId
        )
    }
    
    func saveData(){
        print("saveData")
        if update_main_icon {
            if let main_icon = main_icon {
                let key = "main_icon"
                if let url = saveImg(uiImage: main_icon, key: key){
                    main_url_icon = url
                }
            }
        }
        if update_love_img {
            if let love_img1 = love_img1 {
                let key = "love_img"
                if let url = saveImg(uiImage: love_img1, key: key){
                    love_url_img1 = url
                }
            }
        }
        if update_call_icon {
            if let call_icon = call_icon {
                let key = "call_icon"
                if let url = saveImg(uiImage: call_icon, key: key){
                    call_url_icon = url
                }
            }
        }
        
        let m_myData = instMyData()
        if myData != m_myData{
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(m_myData)
                udef.set(data,forKey: "MyData")
            } catch {
                print("Unable to Encode Note (\(error))")
            }
        }
        
        print("saveData end")
    }
    
    func rtSaveDataLove(){
        print("rtSaveDataLove")
        guard
            let w = love_img1?.size.width,
            let h = love_img1?.size.height,
            let barth = self.barth,
            let sex = self.sex
        else{
            print("rtSaveDataLove end1")
            return
        }
        let img_ratioH = Double(h) / Double(w)
        let info_love = [
            "uid" : Spr.uid,
            "name" : self.love_name,
            "barth" : barth,
            "sex" : sex,
            "pref" : self.love_pref,
            "profile" : self.love_profile,
            "img_ratioH" : img_ratioH,
            "url_img1" : love_url_img1
        ] as [String : Any]
        
        rtdb.child("love/\(Spr.uid)").setValue(info_love)
        
        print("rtSaveDataLove end2")
    }
    
    
    func saveImg(uiImage:UIImage,key:String) -> String?{
        print("saveImg")
        let uiImage = uiImage
        let image_name = Spr.uid + "_" + key + ".jpg"
        let ref = "\(key)/\(image_name)"
        let url = "gs://furat-97153.appspot.com/\(ref)"
    
        uiImage.accessibilityIdentifier = image_name
        guard let imageData = uiImage.jpegData(compressionQuality: 0.1)else{return nil}
        Qey.fbSetImg(image: imageData, ref: ref)
        saveRlImage(id: key, image: imageData)
        print("saveImg end")
        return url
    }
    
    func saveBarth_Sex(barth:Date,sex:Int){
        print("saveBarth_Sex")
        let str_barth = barth.string("yyyyMMdd")
        guard str_barth.count == 8 else{
            print("saveBarth_Sex error barth")
            return
        }
        let udef = UserDefaults.standard
        udef.set(barth, forKey: "barth")
        udef.set(sex, forKey: "sex")
        self.barth = str_barth
        self.sex = sex
        myData.barth = str_barth
        myData.sex = sex
        saveData()
        Spr.sex = sex
        print("saveBarth_Sex end")
    }
}
