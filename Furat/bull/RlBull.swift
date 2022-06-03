//
//  RlBull.swift
//  Furat
//
//  Created by 浅香紘 on R 4/03/27.
//

import Foundation
import RealmSwift

class RlBullGrp :Object{
    @objc dynamic var id = ""
    var ary_rlBullChara = List<RlBullChara>()
}

func getRlBullGrp() -> Results<RlBullGrp>?{
    print("getRlmBullBgrp")
    if rlm_delete {return nil}
    do{
        let rl = try Realm()
        print("getRlmBullBgrp end1")
        return rl.objects(RlBullGrp.self)
    }catch{
        print("getRlmBullBgrp end2")
        print(error.localizedDescription)
        return nil
    }
}

class RlBullChara :Object{
    @objc dynamic var chara:String = ""
    var ary_tag = List<String>()
}

class RlBullHd :Object{
    @objc dynamic var chara = ""
    var ary_bull = List<RlBull>()
    @objc dynamic var time_arc_top = Date()
    @objc dynamic var time_arc_btm = Date()
    
    override static func primaryKey() -> String? {
        return "chara"
    }
}

func getRlBullHd(chara:String) -> RlBullHd?{
    print("getRlBullHd")
    if rlm_delete {return nil}
    do{
        let rlm = try Realm()
        print("getRlBullHd end1")
        return rlm.object(ofType: RlBullHd.self, forPrimaryKey: chara)
    }catch{
        print(error.localizedDescription)
        print("getRlBullHd end2")
        return nil
    }
}
 
class RlBull :Object{
    @objc dynamic var id = ""
    @objc dynamic var chara = ""
    @objc dynamic let time = Date()
    var ary_tag = List<String>()
}

class RlBullComment :Object{
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
    @objc dynamic var text = ""
    @objc dynamic var url_icon = ""
    @objc dynamic var time = Date()
}

class RlBullLove :RlBull{
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
    @objc dynamic var profile = ""
    @objc dynamic var pref = ""
    @objc dynamic var barth = ""
    @objc dynamic var sex = 0
    @objc dynamic var url_icon = ""
    @objc dynamic var url_img1 = ""
    @objc dynamic var img_ratioH = 0.0
}

class RlBullParty :RlBull{
    @objc dynamic var name = ""
    @objc dynamic var time_party = Date()
    @objc dynamic var num = 0
    @objc dynamic var num_m = 0
    @objc dynamic var num_f = 0
    @objc dynamic var location = ""
    @objc dynamic var budget = 0
    @objc dynamic var budget_m = 0
    @objc dynamic var budget_f = 0
    @objc dynamic var text = ""
    @objc dynamic var id_host = ""
    var ary_person = List<RlmPerson>()
    @objc dynamic var url_img1 = ""
}

class RlBullCall :RlBull{
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
    @objc dynamic var id_sky = ""
    @objc dynamic var id_dis = ""
    @objc dynamic var text = ""
    @objc dynamic var sex = 0
    @objc dynamic var url_icon = ""
}

class RlBullGlobal :RlBull{
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
    @objc dynamic var text = ""
    @objc dynamic var url_icon = ""
    @objc dynamic var url_img1 = ""
}

class RlBullNote :RlBull{
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
    @objc dynamic var title = ""
    @objc dynamic var color1 = ""
    @objc dynamic var color2 = ""
    var ary_para = List<RlNotePara>()
    var comment = List<RlBullComment>()
}

class RlNotePara :RlBull{
    @objc dynamic var headline = ""
    @objc dynamic var text = ""
}
