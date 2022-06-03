//
//  VwBullGrpEdit.swift
//  Furat
//
//  Created by 浅香紘 on R 4/05/13.
//

import SwiftUI

struct VwBullGrpEdit: View {
    @EnvironmentObject var evBull :EvBull
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Spacer()
                    Button(action: {dismiss()}){
                        Text("閉じる")
                            .padding(20)
                    }
                }
                ScrollView{
                    VStack{
                        ForEach(evBull.ary_obBullGrp,id:\.id){ bullGrp in
                            vwBullGrp(bullGrp: bullGrp)
                        }
                        vwBtnAdd()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder func vwBullGrp(bullGrp:ObBullGrp) -> some View{
        ZStack(alignment:.topLeading){
            VStack(alignment:.leading){
                Text(bullGrp.name)
                    .font(.system(size:20))
                VStack(alignment:.leading){
                    ForEach(bullGrp.ary_chara,id:\.self){chara in
                        if let ary_tag = bullGrp.dic_tag[chara]{
                            HStack{
                                Text(chara.rawValue)
                                ScrollView(.horizontal){
                                    HStack{
                                        ForEach(ary_tag,id: \.self){tag in
                                            Text(tag)
                                                .font(.system(size:10))
                                                .padding(1)
                                                .padding([.horizontal],5)
                                                .overlay(RoundedRectangle(cornerRadius: 3)
                                                    .stroke())
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding([.vertical],10)
            .padding([.horizontal],10)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
            .padding([.vertical],10)
            .padding([.horizontal],20)
            
            Button(action:{
                if evBull.ary_obBullGrp.count > 1{
                    evBull.ary_obBullGrp.removeAll(where: {$0.id == bullGrp.id})
                }
            }){
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
                    .background(Color.white)
            }
            .padding([.horizontal],10)
        }
    }
    
    @ViewBuilder func vwBtnAdd() -> some View{
        NavigationLink(destination: VwBullGrpAdd(obBullGrp: ObBullGrp(dic_tag: [:], name: "チャンネル\(evBull.ary_obBullGrp.count + 1)")).environmentObject(evBull)){
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
                .padding([.vertical],10)
                .frame(maxWidth:.infinity)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue))
                .padding([.horizontal],20)
        }
    }
}

struct VwBullGrpEdit_Previews: PreviewProvider {

    static var previews: some View {
        VwBullGrpEdit().environmentObject(EvBull())
    }
}
