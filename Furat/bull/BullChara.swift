import Foundation
import SwiftUI
import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

func instBull(_ info:[String:Any]) -> Bull?{
    print("instBull1")
    guard let chara = info["chara"] as? String,
          let time = (info["time"] as? String)?.date("yyyyMMddHHmmssSS")
    else {return nil}
    guard let emBullChara = EmBullChara(rawValue: chara) else {return nil}
    switch emBullChara {
    case .love:return BullLove(info,time: time)
    case .party:return BullParty(info,time:time)
    case .global:return BullGlobal(info,time:time)
    case .note:return BullNote(info,time: time)
    }
}

func instBull(_ rlBull:RlBull) -> Bull?{
    print("instBull2")
    guard let emBullChara = EmBullChara(rawValue: rlBull.chara) else {return nil}
    switch emBullChara {
    case .love: return BullLove(rlBull)
    case .party:return BullParty(rlBull)
    case .global: return BullGlobal(rlBull)
    case .note: return BullNote(rlBull)
    }
}

enum EmBullChara :String,CaseIterable {
    case global = "global"
    case love = "love"
    case party = "party"
    case note = "note"
}

let dic_para_chara:[EmBullChara:[String:Any]] = [
    .global : [
        "title":"つぶやき","image":"globe","image_bg":"bullGlobal_bg",
        "lg":LinearGradient(colors: [
            Color(red: 0, green: 0, blue: 1),
            Color(red: 0, green: 1, blue: 1)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
    ],.love : [
        "title":"マッチング","image":"heart.fill","image_bg":"bullLove_bg",
        "lg":LinearGradient(colors: [
            Color(red: 1, green: 1, blue: 0),
            Color(red: 1, green: 0, blue: 0)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
    ],.note : [
        "title":"ノート","image":"note.text","image_bg":"bullNote_bg",
        "lg":LinearGradient(colors: [
            Color(red: 0, green: 1, blue: 0),
            Color(red: 0, green: 0.5, blue: 1)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
    ],.party : [
        "title":"デート","image":"circle.hexagonpath.fill","image_bg":"bullParty_bg",
        "lg":LinearGradient(colors: [
            Color(red: 0, green: 0.3, blue: 1),
            Color(red: 1, green: 0, blue: 0.5)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
    ]
]

class BullPara{
    var love = true
    var party = true
    var call = true
    var global = true
    var note = true
}

class Bull:ObservableObject{
    var id:String
    var token :String = ""
    let chara:EmBullChara
    var time:Date
    //var sign_load = true
    @Published var ary_tag = [String]()
    @Published var icon:UIImage? = nil
    @Published var img1:UIImage? = nil
    @Published var url_icon = ""
    @Published var url_img1 = ""
    
    init(){
        self.id = ""
        self.time = Date()
        self.chara = .global
    }
    
    init(chara:EmBullChara){
        self.id = UUID().uuidString
        self.chara = chara
        self.time = Date()
    }
    
    init(_ info:[String:Any],time:Date){
        print("Bull init")
        self.time = time
        self.id = info["id"] as? String ?? UUID().uuidString
        self.token = info["token"] as? String ?? ""
        self.ary_tag = info["ary_tag"] as? [String] ?? [String]()
        self.url_icon = info["url_icon"] as? String ?? ""
        self.url_img1 = info["url_img1"] as? String ?? ""
        if let str_chara = info["chara"] as? String,
           let chara = EmBullChara.init(rawValue: str_chara){
            self.chara = chara
        }else{self.chara = .global}
        print("Bull init end")
    }
    
    init(_ rlBull:RlBull){
        self.time = rlBull.time
        self.id = rlBull.id
        if let emBullChara = EmBullChara.init(rawValue: rlBull.chara){
            self.chara = emBullChara
        }else{self.chara = .global}
        self.ary_tag = Array(rlBull.ary_tag)
    }
    
    func getImg(_ emImg:EmImg) {
        print("getImg")
        let url :String
        switch emImg {
        case .icon:
            url = url_icon
        case .img1:
            url = url_img1
        }
        guard url.count > 0 else{return}
        
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
    
    func upload(){}
    func remove(){}
}

extension Bull:Hashable{
    static func == (lhs: Bull, rhs: Bull) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class BullComment{
    var name = ""
    var uid = ""
    var text = ""
    var time = Date()
    var url_icon = ""
    var icon :UIImage? = nil
    init(_ info:[String:Any]){
        self.name = info["name"] as? String ?? ""
        self.uid = info["uid"] as? String ?? ""
        self.text = info["text"] as? String ?? ""
        self.url_icon = info["url_icon"] as? String ?? ""
        if let str_time = info["time"] as? String,
           let time = str_time.date("yyyyMMddHHmmssSS"){
            self.time = time
        }
    }
    init(_ rlBullComment:RlBullComment){
        self.uid = rlBullComment.uid
        self.name = rlBullComment.name
        self.text = rlBullComment.text
        self.url_icon = rlBullComment.url_icon
        self.time = rlBullComment.time
    }
}

class BullChara{
    init(_ info:[String:Any]){}
}

class BullGlobal:Bull{
    @Published var uid = ""
    @Published var name = ""
    @Published var text = ""
    
    override init(_ info:[String:Any],time:Date){
        print("BullGlobal init")
        if let info_c = info["global"] as? [String:Any]{
            self.uid = info_c["uid"] as? String ?? ""
            self.name = info_c["name"] as? String ?? ""
            self.text = info_c["text"] as? String ?? ""
        }
        super.init(info,time: time)
        
        print("BullGlobal init end")
    }
    override init(_ rlBull:RlBull){
        print("BullGlobal init2")
        if let rlBullGlobal = rlBull as? RlBullGlobal{
            self.uid = rlBullGlobal.uid
            self.name = rlBullGlobal.name
            self.text = rlBullGlobal.text
        }
        super.init(rlBull)
        print("BullGlobal init2 end")
    }
    
    override init(chara:EmBullChara){
        print("Bull init3")
        super.init(chara: chara)
        print("Bull init3 end")
    }
    
    override func upload() {
        let info : [String:Any] = [
            "id" : id,
            "ary_tag" :ary_tag,
            "url_icon":self.url_icon,
            "url_img":self.url_img1,
            "global":[
                "uid":Spr.uid,
                "name":self.name,
                "text":self.text
            ]
        ]
        Qey.fdUploadBull(chara: .global, info: info)
    }
}

class BullLove:Bull{
    @Published var uid = ""
    @Published var name = ""
    @Published var profile = ""
    @Published var pref = ""
    @Published var barth = ""
    @Published var sex = 0
    @Published var img_ratioH = 0.0
    
    override init(_ info:[String:Any],time:Date){
        print("BullLove init")
        super.init(info,time: time)
        print("BullLove init end")
    }
    
    override init(_ rlBull:RlBull){
        print("BullLove init2")
        if let rlBullLove = rlBull as? RlBullLove{
            self.uid = rlBullLove.uid
            self.name = rlBullLove.name
            self.profile = rlBullLove.profile
            self.pref = rlBullLove.pref
            self.barth = rlBullLove.barth
            self.sex = rlBullLove.sex
             self.img_ratioH = rlBullLove.img_ratioH
        }
        super.init(rlBull)
        print("BullLove init2")
    }
    override init(chara:EmBullChara){
        print("Bull init3")
        super.init(chara: chara)
        print("Bull init3 end")
    }
    
    override func upload() {
        print("upload")
        guard self.id.count > 0 else{
            print("upload end id")
            return}
        guard self.url_img1.count > 0 else{
            print("upload end url_img1")
            return}
        guard Spr.uid.count > 0 else{
            print("upload end uid")
            return}
        guard self.name.count > 0 else{
            print("upload end name")
            return}
        guard self.barth.count > 0 else{
            print("upload end barth")
            return}
        guard self.sex > 0 else{
            print("upload end sex")
            return}
        guard self.pref.count > 0 else{
            print("upload end pref")
            return}
        guard self.profile.count > 0 else{
            print("upload end profile")
            return}
        guard self.img_ratioH > 0 else{
            print("upload end img_ratioH")
            return}
        
        let info : [String:Any] = [
            "id" : Spr.uid,
            "ary_tag" :ary_tag
        ]
        remove()
        Qey.fdUploadBull(chara: .love, info: info)
        print("upload")
    }
    
    override func remove() {
        print("remove")
        guard let path = UserDefaults.standard.object(forKey: "path_love") as? String else{
            print("remove end1")
            return
        }
        rtdb.child(path).removeValue()
        print("remove end2 \(path)")
    }
    
    func setValue(info:[String:Any]){
        self.uid = info["uid"] as? String ?? ""
        self.name = info["name"] as? String ?? ""
        self.barth = info["barth"] as? String ?? ""
        self.sex = info["sex"] as? Int ?? 0
        self.pref = info["pref"] as? String ?? ""
        self.profile = info["profile"] as? String ?? ""
        self.img_ratioH = info["img_ratioH"] as? Double ?? 0.0
        self.url_img1 = info["url_img1"] as? String ?? ""
    }
    
    func update(_ bull:Bull){
        print("update")
        guard let bull = bull as? BullLove else{
            print("update end1")
            return
        }
        
        self.id = bull.id
        self.token = bull.token
        self.time = bull.time
        self.ary_tag = bull.ary_tag
        self.icon = bull.icon
        self.img1 = bull.img1
        self.url_icon = bull.url_icon
        self.url_img1 = bull.url_img1
        self.uid = bull.uid
        self.name = bull.name
        self.profile = bull.profile
        self.pref = bull.pref
        self.barth = bull.barth
        self.sex = bull.sex
        self.img_ratioH = bull.img_ratioH
        print("update end2")
    }
}

class BullParty:Bull{
    @Published var name = ""
    @Published var time_party :Date? = nil
    @Published var num = 0
    @Published var num_m = 0
    @Published var num_f = 0
    @Published var location = ""
    @Published var budget = 0
    @Published var budget_m = 0
    @Published var budget_f = 0
    @Published var text = ""
    @Published var id_host = ""
    var ary_person = [Person]()
    override init(_ info:[String:Any],time:Date){
        print("BullParty init")
        if let info_c = info["party"] as? [String:Any]{
            self.name = info_c["name"] as? String ?? ""
            if let time_party = info_c["time"] as? String {
                self.time_party = time_party.date("yyyyMMddHHmmssSS")}
            self.num = info_c["num"] as? Int ?? 0
            self.num_m = info_c["num_m"] as? Int ?? 0
            self.num_f = info_c["num_f"] as? Int ?? 0
            self.location = info_c["location"] as? String ?? ""
            self.budget = info_c["budget"] as? Int ?? 0
            self.budget_m = info_c["budget_m"] as? Int ?? 0
            self.budget_f = info_c["budget_f"] as? Int ?? 0
            self.text = info_c["text"] as? String ?? ""
            self.id_host = info_c["id_host"] as? String ?? ""
            if let ary_info_person = info_c["ary_person"] as? [[String:Any]] {
                for info_person in ary_info_person {
                    guard let id_p = info_person["id"] as? String else{continue}
                    let person = getPerson(id_p, info: info_person)
                    self.ary_person.append(person)
                }
            }
        }
        super.init(info,time:time)
        print("BullParty init end")
    }
    
    override init(_ rlBull:RlBull){
        print("BullParty init2")
        if let rlBullParty = rlBull as? RlBullParty{
            self.name = rlBullParty.name
            self.time_party = rlBullParty.time_party
            self.num = rlBullParty.num
            self.num_m = rlBullParty.num_m
            self.num_f = rlBullParty.num_f
            self.location = rlBullParty.location
            self.budget = rlBullParty.budget
            self.budget_m = rlBullParty.budget_m
            self.budget_f = rlBullParty.budget_f
            self.text = rlBullParty.text
            self.id_host = rlBullParty.id_host
            for rlPerson in Array(rlBullParty.ary_person){
                self.ary_person.append(getPerson(rlPerson))
            }
        }
        super.init(rlBull)
        print("BullParty init2 end")
    }
    override init(chara:EmBullChara){
        print("Bull init3")
        super.init(chara: chara)
        print("Bull init3 end")
    }
    override func upload() {
        let info : [String:Any] = [
            "id" : id,
            "img1" : self.url_img1,
            "party" : [
                "name":self.name,
                "time":self.time_party?.string("yyyyMMddHHmmddssSS"),
                "num":self.num,
                "num_m":self.num_m,
                "num_f":self.num_f,
                "location":self.location,
                "budget":self.budget,
                "budget_m":self.budget_m,
                "budget_f":self.budget_f,
                "ary_tag":self.ary_tag,
                "text":self.text,
                "id_host":Spr.uid,
                "ary_person":[]
            ]
        ]
        Qey.fdUploadBull(chara: .party, info: info)
        print("upload")
    }
}

class BullCall:Bull{
    @Published var uid = ""
    @Published var name = ""
    @Published var id_sky = ""
    @Published var id_dis = ""
    @Published var text = ""
    @Published var sex = 0

    override init(_ info:[String:Any],time:Date){
        print("BullCall init1")
        if let info_c = info["call"] as? [String:Any]{
            self.uid = info_c["uid"] as? String ?? ""
            self.name = info_c["name"] as? String ?? ""
            self.sex = info_c["sex"] as? Int ?? 0
            self.id_sky = info_c["id_sky"] as? String ?? ""
            self.id_dis = info_c["id_dis"] as? String ?? ""
            self.text = info_c["text"] as? String ?? ""

        }
        super.init(info,time: time)
        print("BullCall init1 end")
    }
    override init(_ rlBull:RlBull){
        print("BullCall init2")
        if let rlBullCall = rlBull as? RlBullCall{
            self.uid = rlBullCall.uid
            self.name = rlBullCall.name
            self.id_sky = rlBullCall.id_sky
            self.id_dis = rlBullCall.id_dis
            self.text = rlBullCall.text
            self.sex = rlBullCall.sex
        }
        super.init(rlBull)
        print("BullCall init2 end")
    }
    override init(chara:EmBullChara){
        print("Bull init3")
        super.init(chara: chara)
        print("Bull init3 end")
    }
    
    func getInfo() -> [String:Any] {
        return [
            "id":UUID().uuidString,
            "chara":"call",
            "hight":100,
            "time":"2022021304203111",
            "ary_tag":["lol","apex","雑談"],
            "call":[
                "uid":"preid001",
                "name":"Ak",
                "sex": 1,
                "id_sky" : "hiro.346",
                "id_dis" : "fdfa.dfa",
                "text":"アンレート@4か空いてるとこ入れてください"
            ]
        ]
    }
}

class BullNote:Bull{
    @Published var uid = ""
    @Published var name = ""
    @Published var title = ""
    @Published var ary_para = [[String:String]]()
    @Published var color1 = Color.gray
    @Published var color2 = Color.gray
    
    var comment = [BullComment]()
    override init(_ info:[String:Any],time:Date){
        print("BullNote init")
        if let info_c = info["note"] as? [String:Any]{
            self.uid = info_c["uid"] as? String ?? ""
            self.name = info_c["name"] as? String ?? ""
            self.title = info_c["title"] as? String ?? ""
            if let hex1 = info_c["color1"] as? String{
                self.color1 = Color(hex: hex1)
            }
            if let hex2 = info_c["color2"] as? String{
                self.color2 = Color(hex: hex2)
            }
             self.ary_para = info_c["ary_para"] as? [[String:String]] ?? [[String:String]]()
            if let ary_comment = info_c["comment"] as? [[String:String]]{
                for info_comment in ary_comment{
                    comment.append(BullComment(info_comment))
                }
            }
        }
        super.init(info,time: time)
        print("BullGlobal init end")
    }
    override init(_ rlBull:RlBull){
        print("BullGlobal init2")
        var m_ary_para = [[String:String]]()
        if let rlBullNote = rlBull as? RlBullNote{
            self.uid = rlBullNote.uid
            self.name = rlBullNote.name
            self.title = rlBullNote.title
            if let uiColor = UIColor(hex: rlBullNote.color1){
                self.color1 = Color(uiColor: uiColor)
            }
            if let uiColor = UIColor(hex: rlBullNote.color2){
                self.color2 = Color(uiColor: uiColor)
            }
            for rlPara in Array(rlBullNote.ary_para){
                let para = ["headline":rlPara.headline,"text":rlPara.text]
                m_ary_para.append(para)
            }
            for rlComment in Array(rlBullNote.comment){
                self.comment.append(BullComment(rlComment))
            }
        }
        super.init(rlBull)
        self.ary_para = m_ary_para
        print("BullGlobal init2 end")
    }
    override init(chara:EmBullChara){
        print("Bull init3")
        super.init(chara: chara)
        print("Bull init3 end")
    }
    override func upload() {
        let info : [String:Any] = [
            "id" : id,
            "note" : [
                "uid" : Spr.uid,
                "name" : self.name,
                "title" : self.title,
                "ary_para":self.ary_para,
                "color1" : self.color1.toHex() ?? "",
                "color2" : self.color2.toHex() ?? ""
            ]
        ]
        Qey.fdUploadBull(chara: .note, info: info)
        print("upload")
    }
}
