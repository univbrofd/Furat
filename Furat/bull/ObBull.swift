import Foundation
import SwiftUI
import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase
import Collections


enum EmImg{
    case icon
    case img1
}
class EvBull:ObservableObject{
    //@Published var bolTagEdit = false
    var ary_tag_edit = [String]()
    @Published var ary_obBullGrp = [ObBullGrp]()
    static var dic_hdBull = [EmBullChara:HdBull]()
    
    init(){
        print("EvBull init")
        if let rslts = getRlBullGrp(){
            for rlBullGrp in Array(rslts){
                ary_obBullGrp.append(ObBullGrp(rlBullGrp))
            }
        }
        if ary_obBullGrp.isEmpty{
            let dic : [EmBullChara:[String]] = [
                .note:[String](),
                .love:[String]()
            ]
            ary_obBullGrp.append(ObBullGrp(dic_tag: dic,name: "ホーム"))
            ary_obBullGrp.append(ObBullGrp(dic_tag: [.note:[String]()],name: "ノート"))
            ary_obBullGrp.append(ObBullGrp(dic_tag: [.love:[String]()],name:"マッチング"))
            ary_obBullGrp.append(ObBullGrp(dic_tag: [.party:[String]()],name:"デート"))
            ary_obBullGrp.append(ObBullGrp(dic_tag: [.global:[String]()],name :"つぶやき"))
        }
        for chara in EmBullChara.allCases{
            let hdBull:HdBull
            if let rlBullChara = getRlBullHd(chara: chara.rawValue){
                hdBull = HdBull(rlBullChara)
            }else{
                hdBull = HdBull(chara)
            }
            EvBull.dic_hdBull[chara] = hdBull
        }
        print("EvBull init end")
    }
}

class ObBullGrp:ObservableObject{
    let id = UUID()
    @Published var ary_bull = [Bull]()
    @Published var bullPara = BullPara()
    
    @Published var ary_l = [String]()
    @Published var ary_r = [String]()
    @Published var dic_y = [String:CGFloat]()
    @Published var dic_x = [String:CGFloat]()
    @Published var h_l = CGFloat.zero
    @Published var h_r = CGFloat.zero
    @Published var loading = true
    @Published var loading_new = true
    var id_btm_l:String? = nil
    var id_btm_r:String? = nil
    var id_btm : String? = nil
    @Published var name = "チャンネル"
    let num_get = 20
    let time_end :Date
    //var ary_hdBull = [HdBull]()
    var usedBull = [String]()
    @Published var dic_tag = [EmBullChara:[String]]()
    @Published var ary_chara = EmBullChara.allCases
    var time_arc_top :Date? = nil
    var time_arc_btm :Date? = nil
    var bol_get_bull = true
    
    init(dic_tag:[EmBullChara:[String]],name:String?){
        print("ObBull init")
        if let name = name {
            self.name = name
        }
        self.dic_tag = dic_tag
        if !dic_tag.keys.isEmpty{
            ary_chara = Array(dic_tag.keys)
        }
        time_end = "2022042801010101".date("yyyyMMddHHmmssSS") ?? Date()
        print("ObBull init end")
    }
    
    init(_ rlBullGrp:RlBullGrp){
        print("ObBull init2")
        var dic_tag = [EmBullChara:[String]]()
        for rlBullChara in Array(rlBullGrp.ary_rlBullChara){
            guard let chara = EmBullChara.init(rawValue: rlBullChara.chara) else{
                continue
            }
            dic_tag[chara] = Array(rlBullChara.ary_tag)
        }
        self.dic_tag = dic_tag
        if !dic_tag.keys.isEmpty{
            ary_chara = Array(dic_tag.keys)
        }
        time_end = "2022042801010101".date("yyyyMMddHHmmssSS") ?? Date()
        
        print("ObBull init2 end")
    }
    
    func getBull(_ new:Bool){
        print("getBull")
        guard !loading,!loading_new else {
            print("getBull end loading")
            return
        }
        loading = true
        var m_ary_bull = [Bull]()
        var new = new
        var time_top:Date
        var time_btm:Date
        
        if pTst["bull"]! {
            if bol_get_bull {bol_get_bull = false}
            else{return}
            var ary_info = [[String:Any]]()
            //ary_info = predt_call
            ary_info = predt_love
            //ary_info += predt_party
            //ary_info += predt_global
            for info in ary_info{
                if let bull = instBull(info){m_ary_bull.append(bull)}
            }
            time_top = Date()
            time_btm = Date()
            sortBull()
            print("rtGetBull end1")
            return
        }
        print("new : \(new)")
        if new {
            loading_new = true
            time_top = Date()
            time_btm = time_arc_top ?? btmOfDay(date: time_top)
            time_arc_top = time_top
        }else{
            if let m_top = time_arc_btm {
                time_top = m_top
            }else{
                time_top = Date()
                new = true
            }
            let m_btm = btmOfDay(date: time_top)
            if time_top == m_btm{
                time_top = time_top.added(.second, num: -1)!
                time_btm = btmOfDay(date: time_top)
            }else{
                time_btm = m_btm
            }
        }
        print("time_top: \(time_top) , time_btm: \(time_btm)")
        var ary_qeyBull = getAryQeyBull(ary_chara,time_top,time_btm)
        print(ary_qeyBull)
        next()
    //time_top: 2022-05-11 07:10:32 +0000 , time_btm: 2022-05-11 07:03:36 +0000
        
        func next(){
            print("getbull next")
            if ary_qeyBull.isEmpty{
                if new , time_arc_btm != nil{
                    sortBull()
                    print("getbull next end0")
                    return
                }
                
                guard let m_time = time_top.added(.day, num: -1) else{
                    sortBull()
                    print("getbull next end1")
                    return
                }
                time_top = topOfDay(date: m_time)
                guard time_top > time_end else{
                    sortBull()
                    print("getbull next end2")
                    return
                }
                if m_ary_bull.count > self.num_get {
                    sortBull()
                    print("getbull next end3")
                    return
                }
                ary_qeyBull = getAryQeyBull(ary_chara,time_top,btmOfDay(date: time_top))
            }
            guard let qeyBull = ary_qeyBull.first else{
                print("getbull next end4")
                return
            }
            ary_qeyBull.remove(at: 0)
            print(qeyBull)
            if qeyBull.local {
                if let hdBull = EvBull.dic_hdBull[qeyBull.chara],
                   let rslt = hdBull.getBull(qeyBull: qeyBull) {
                    m_ary_bull += rslt
                }
                next()
            }else{rtGetBull(qeyBull)}
            print("getbull next end5")
        }
        
        func rtGetBull(_ qeyBull:QeyBull){
            print("rtGetBull")
            guard let ref = qeyBull.ref else {
                next()
                print("rtGetBull end")
                return
            }
            let chara = qeyBull.chara
            print(ref)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                print("snapshot get sucess snapshot:\(snapshot)")
                if let values = snapshot.value as? [String:Any]{
                    var ary_bull = [Bull]()
                    values.forEach({(key, value) in
                        if let info = value as? [String:Any] {
                            if let id = info["id"] as? String,
                               !self.usedBull.contains(id),
                               let bull = instBull(info){
                                print("bull append")
                                self.usedBull.append(id)
                                ary_bull.append(bull)
                            }
                        }
                    })
                    m_ary_bull += ary_bull
                    EvBull.dic_hdBull[chara]?.setBull(ary_bull,qeyBull:qeyBull)
                }else{
                    EvBull.dic_hdBull[chara]?.updateTime(qeyBull: qeyBull)
                    print("no value")
                }
                
                next()
                return
            }){error in
                print(error.localizedDescription)
                print("rtGetBull end4")
                sortBull()
            }
            print("rtGetBull end2")
        }
        
        func sortBull(){
            print("sortBull")
            
            var n_ary_bull = [Bull]()
            for1 : for bull in m_ary_bull{
                if let selctTags = dic_tag[bull.chara]{
                    if selctTags.isEmpty{
                        n_ary_bull.append(bull)
                        continue for1
                    }
                    for tag in bull.ary_tag{
                        if !selctTags.contains(tag){
                            continue for1
                        }
                    }
                    n_ary_bull.append(bull)
                }
            }
            print(m_ary_bull.count)
            m_ary_bull = n_ary_bull.sorted(by: {$0.time > $1.time})
            print(m_ary_bull.map{$0.time})
            if let bull_last = m_ary_bull.last{
                id_btm = bull_last.id
            }else{
                loading = false
            }
            print(m_ary_bull.count)
            DispatchQueue.main.async {
                insertLoop(0,0)
            }
            print("sortBull end1")
        }
        
        func insertLoop(_ idx:Int,_ idx_in:Int){
            print("insertLoop")
            guard idx < m_ary_bull.count else{
                loading_new = false
                if !new{
                    id_btm_l = ary_l.last
                    id_btm_r = ary_r.last
                }
                if time_arc_btm == nil || time_arc_btm! > time_btm{
                    time_arc_btm = time_btm
                }
                print("insertLoop end1")
                return
            }
            let bull = m_ary_bull[idx]
            
            if let bullLove = bull as? BullLove{
                rtdb.child("love/\(bull.id)").observeSingleEvent(of: .value, with: {snapshot in
                    print("snapshot get sucess snapshot:\(snapshot)")
                    if let info = snapshot.value as? [String:Any]{
                        bullLove.setValue(info: info)
                        if new{
                            self.ary_bull.insert(bullLove, at: idx_in)
                        }else{
                            self.ary_bull.append(bullLove)
                        }
                    }
                    print("insertLoop end2")
                    insertLoop(idx + 1,idx_in + 1)
                    return
                }){error in
                    print(error.localizedDescription)
                    print("insertLoop end3")
                    insertLoop(idx + 1,idx_in)
                    return
                }
            }else{
                print(self.ary_bull.count)
                print(idx)
                if new{
                    self.ary_bull.insert(bull, at: idx_in)
                }else{
                    self.ary_bull.append(bull)
                }
                print("insertLoop end4")
                insertLoop(idx + 1,idx_in)
                return
            }
        }
    }
    
    func set(_ id:String,h:CGFloat){
        print("set")
        if dic_y.keys.contains(id) {
            print("set end1 enough contain")
            return
        }
        else{dic_y[id] = CGFloat.zero}
        var new = true
        if let idx1 = ary_bull.firstIndex(where: {$0.id == id}),
           let idx2 = ary_bull.firstIndex(where: {$0.id == id_btm_l}){
            if idx1 > idx2{
                new = false
            }
        }
        setX(id,h:h,new: new)
    }
    
    func setX(_ id:String,h:CGFloat,new:Bool){
        if h_l <= h_r {
            if new{
                ary_l.insert(id, at: 0)
            }else{
                let idx = ary_l.firstIndex(where: {$0 == id_btm_l}) ?? 0
                ary_l.insert(id, at: idx+1)
                dic_y[id] = h_l
            }
            dic_x[id] = -1
            h_l += h
        }else{
            if new{
                ary_r.insert(id, at: 0)
            }else{
                let idx = ary_r.firstIndex(where: {$0 == id_btm_r}) ?? 0
                ary_r.insert(id, at: idx+1)
                dic_y[id] = h_r
            }
            dic_x[id] = 1
            h_r += h
        }
        if new {setNew(id, h: h)}
        if id == id_btm{
            loading = false
            loading_new = false
        }
        print("setXend h_l:\(h_l) - h_r:\(h_r)")
    }
    func setNew(_ id:String,h:CGFloat){
        let ary_id : [String]
        if dic_x[id] == -1{
            ary_id = ary_l
        }else{
            ary_id = ary_r
        }
        
        if let idx = ary_id.firstIndex(where: {$0 == id}){
            guard (idx + 1) < ary_id.count else{return}
            for i in (idx+1) ..< ary_id.count{
                let id = ary_id[i]
                dic_y[id]! += h
            }
        }
    }
    
    func getAryQeyBull(_ ary_chara:[EmBullChara],_ top:Date,_ btm:Date) -> [QeyBull] {
        print("getAryQeyBull")
        var ary_qeyBull = [QeyBull]()
        for chara in ary_chara{
            let hdBUll = EvBull.dic_hdBull[chara]
            if let m_top = hdBUll?.time_arc_top?.added(.second, num: -1),
               let m_btm = hdBUll?.time_arc_btm?.added(.second, num: -1){
                print("time_top: \(top)")
                print("time_m_top: \(m_top)")
                print("time_btm: \(btm)")
                print("time_m_btm: \(m_btm)")
                //var ary_qeyBull = [QeyBull]()
                
                if top >= m_top {
                    print("getAryQeyBull 1")
                    ary_qeyBull += getAryQeyBull2(chara,top,m_top,false)
                    if m_top > btm {
                        if btm >= m_btm{
                           print("getAryQeyBull 2")
                           ary_qeyBull.append(QeyBull(chara,m_top,btm,true))
                        }else if m_btm > btm {
                            print("getAryQeyBull 3")
                            ary_qeyBull.append(QeyBull(chara,m_top,m_btm,true))
                            ary_qeyBull += getAryQeyBull2(chara,m_btm,btm,false)
                        }
                    }
                }else if m_top > top, top >= m_btm{
                    if btm > m_btm{
                        print("getAryQeyBull 4")
                        ary_qeyBull.append(QeyBull(chara,top,btm,true))
                    }else{
                        print("getAryQeyBull 5")
                        ary_qeyBull.append(QeyBull(chara,top,m_btm,true))
                        ary_qeyBull += getAryQeyBull2(chara,m_btm,btm,false)
                    }
                }else{
                    print("getAryQeyBull 6")
                    ary_qeyBull += getAryQeyBull2(chara,m_btm,btm,false)
                }
            }else{
                print("getAryQeyBull 7")
                ary_qeyBull += getAryQeyBull2(chara,top,btm,false)
            }
        }
        print("getAryQeyBull end count:\(ary_qeyBull.count)")
        return ary_qeyBull
    }
        
    func getAryQeyBull2(_ chara:EmBullChara,_ top:Date,_ btm:Date,_ local:Bool) -> [QeyBull] {
        print("getAryQeyBull2")
        print("time_top: \(top)")
        print("time_btm: \(btm)")
        var ary_qeyBull = [QeyBull]()
        let day_diff = getIntervalDay(time1: top, time2: btm)
        guard day_diff > 0 else {
            ary_qeyBull.append(QeyBull(chara,top,btm,local))
            print("getAryQeyBull2 end1 count:\(ary_qeyBull.count)")
            return ary_qeyBull
        }
        ary_qeyBull.append(QeyBull(chara,top,btmOfDay(date: top),local))
        let top = topOfDay(date: top)
        for i in 1..<(day_diff + 1){
            if let m_top = top.added(.day, num: -i){
                let m_btm :Date
                if i == day_diff{
                    m_btm = btm
                }else{
                    m_btm = btmOfDay(date: top)
                }
                ary_qeyBull.append(QeyBull(chara,m_top,m_btm,local))
            }
        }
        print("getAryQeyBull2 end2 count:\(ary_qeyBull.count)")
        return ary_qeyBull
    }
}
struct QeyBull{
    let top:Date
    let btm:Date
    let local:Bool
    let chara:EmBullChara
    var ref :DatabaseQuery? = nil
    init(_ chara:EmBullChara,_ top:Date,_ btm:Date,_ local:Bool){
        print("QeyBull init")
        self.chara = chara
        self.top = top
        self.btm = btm
        self.local = local
        if local == false {
            self.ref = getRef()
        }
        print("QeyBull init end")
    }
    func getRef() -> DatabaseQuery{
        print("getRef")
        let time_ym = top.string("yyyyMM")
        let time_d = top.string("dd")
        var path = "bull/\(chara)/\(time_ym)/\(time_d)"
        if chara == .love{
            if Spr.sex == 1{
                path += "/\(2)"
            }else if Spr.sex == 2{
                path += "/\(1)"
            }
        }
        var ref : DatabaseQuery = rtdb.child(path).queryOrdered(byChild: "time")
        let str_top = top.string("yyyyMMddHHmmssSS")
        if str_top.suffix(8) != "23595959"{
            ref = ref.queryEnding(atValue: str_top)
        }
        let str_btm = btm.string("yyyyMMddHHmmssSS")
        if str_btm.suffix(8) != "00000000" {
            ref = ref.queryStarting(atValue: str_btm)}
        print("getRef end")
        return ref
    }
}

class HdBull{
    var chara:EmBullChara
    var ary_bull = [Bull]()
    var qey :DatabaseQuery? = nil
    var time_arc_top:Date? = nil
    var time_arc_btm:Date? = nil
    
    init(_ chara:EmBullChara){
        print("Hdbull")
        self.chara = chara
        print("Hdbull end")
    }
    
    init(_ rlBullHd:RlBullHd){
        print("Hdbull init")
        self.chara = EmBullChara.init(rawValue:rlBullHd.chara)!
        self.time_arc_top = rlBullHd.time_arc_top
        self.time_arc_btm = rlBullHd.time_arc_btm
        for rlBull in Array(rlBullHd.ary_bull){
            if let bull = instBull(rlBull){
                ary_bull.append(bull)
            }
        }
        ary_bull.sort(by: {$0.time > $1.time})
        print("Hdbull init end")
    }
    
    func setBull(_ m_ary_bull:[Bull],qeyBull:QeyBull){
        print("HdBull setBull count:\(m_ary_bull.count)")
        let m_ary_bull = m_ary_bull.sorted{$0.time > $1.time}
        let time_qey_top:Date = qeyBull.top
        let time_qey_btm:Date = qeyBull.btm
        
        if let top = time_arc_top,top <= time_qey_top{
            time_arc_top = time_qey_top
            ary_bull.insert(contentsOf: m_ary_bull, at: 0)
        }else if let btm = time_arc_btm,btm >= time_qey_btm{
            time_arc_btm = time_qey_btm
            ary_bull.append(contentsOf: m_ary_bull)
        }
        if ary_bull.isEmpty{ary_bull = m_ary_bull}
        if time_arc_top == nil{time_arc_top = time_qey_top}
        if time_arc_btm == nil{time_arc_btm = time_qey_btm}
        print(ary_bull)
        print("HdBull setBull end")
    }
    
    func getBull(qeyBull:QeyBull) -> [Bull]?{
        print("HdBull getBull")
        print(qeyBull)
        guard let idx_top = ary_bull.firstIndex(where:{$0.time <= qeyBull.top}) else {
            print("HdBull getBull end1")
            return nil
        }
        var idx_btm :Int
        if let idx = ary_bull.firstIndex(where: {$0.time < qeyBull.btm}){
            idx_btm = idx
        }else{idx_btm = ary_bull.count}
        let ary = ary_bull[idx_top..<idx_btm]
        print("HdBull getBull end2")
        print("\(ary.map{$0.time})")
        return Array(ary)
    }
    
    func updateTime(qeyBull:QeyBull){
        print("HdBull updateTime")
        if time_arc_top == nil || time_arc_top! < qeyBull.top{
            time_arc_top = qeyBull.top
        }
        if time_arc_btm == nil || time_arc_btm! > qeyBull.btm  {
            time_arc_btm = qeyBull.btm
        }
        print("HdBull updateTime end")
    }
}
