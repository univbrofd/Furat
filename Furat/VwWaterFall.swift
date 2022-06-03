//
//  VwWoterFall.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/19.
//

import SwiftUI
import RealmSwift

class ObWaterFall:ObservableObject{
    @Published var ary_item = [WaterFallitem]()
    @Published var ary_l = [UUID]()
    @Published var ary_r = [UUID]()
    @Published var dic_y = [UUID:CGFloat]()
    @Published var dic_x = [UUID:CGFloat]()
    @Published var h_l = CGFloat.zero
    @Published var h_r = CGFloat.zero
    var id_btm_l:UUID? = nil
    var id_btm_r:UUID? = nil
    
    func addItem(newItem:[WaterFallitem],new:Bool){
        if new{
            ary_item.insert(contentsOf:newItem,at:0)
        }else{
            ary_item.append(contentsOf:newItem)
            id_btm_l = ary_l.last
            id_btm_r = ary_r.last
        }
    }
    
    func set(_ id:UUID,h:CGFloat){
        var new = true
        if let idx1 = ary_item.firstIndex(where: {$0.id == id}),
           let idx2 = ary_item.firstIndex(where: {$0.id == id_btm_l}){
            if idx1 > idx2{
                new = false
            }
        }
        
        dic_y[id] = CGFloat.zero
        setX(id,h:h,new: new)
    }
    
    func setX(_ id:UUID,h:CGFloat,new:Bool){
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
    }
    func setNew(_ id:UUID,h:CGFloat){
        let ary_id : [UUID]
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
}

struct VwWaterFall: View {
    @ObservedObject var ob = ObWaterFall()
    @State var height_l = CGFloat.zero
    @State var height_r = CGFloat.zero
    
    var body: some View {
        GeometryReader{ gmty in
            ScrollView{
                ZStack(alignment:.top){
                    Spacer().frame(height:ob.h_l)
                    Spacer().frame(height:ob.h_r)
                    ForEach(ob.ary_item,id:\.id){ item in
                        VwWaterFallitem(ob:ob,item:item,gmty: gmty)
                            
                    }
                    Button(action: {
                        var ary_item = [WaterFallitem]()
                        for i in 3..<6 {
                            let item = WaterFallitem(i)
                            ary_item.append(item)
                        }
                        ob.addItem(newItem: ary_item, new: true)
                    }){
                        Text("add")
                    }
                }
            }
        }.onAppear(){
            var ary_item = [WaterFallitem]()
            for i in 0..<3 {
                let item = WaterFallitem(i)
                ary_item.append(item)
            }
            ob.addItem(newItem: ary_item, new: true)
        }
    }
}

class WaterFallitem{
    let id : UUID
    let idx :Int
    let color :Color
    let height :CGFloat
    init(_ idx:Int){
        self.id = UUID()
        self.idx = idx
        let red = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        color = Color(red: red, green: green, blue: blue)
        height = CGFloat(Double.random(in: 100...300))
    }
}

struct VwWaterFallitem : View{
    @ObservedObject var ob : ObWaterFall
    let item:WaterFallitem
    let id :UUID
    @State var h = CGFloat.zero
    let gmty:GeometryProxy
    init(ob:ObWaterFall,item:WaterFallitem,gmty:GeometryProxy){
        self.ob = ob
        self.item = item
        self.id = item.id
        self.gmty = gmty
    }
    
    var body : some View{
        ZStack{
            item.color
            Text(String(item.idx))
        }
        .frame(width:gmty.size.width * 0.5,height: item.height)
            .offset(
                x: (ob.dic_x[id] ?? 0) * (gmty.size.width * 0.25), y: ob.dic_y[id] ?? 0)
            .opacity(0.5)
            .background(
                GeometryReader{gmty_b in
                    Spacer()
                        .onAppear{
                            h = gmty_b.size.height
                            ob.set(id,h:h)
                        }
                }
            )
    }
}

struct VwWaterFall_Previews: PreviewProvider {
    static var previews: some View {
        VwWaterFall()
    }
}
