//
//  VwBullGrpAdd.swift
//  Furat
//
//  Created by 浅香紘 on R 4/05/11.
//

import SwiftUI

struct VwBullGrpAdd: View {
    @EnvironmentObject var evBull :EvBull
    @EnvironmentObject var evMypage :EvMypage
    @Environment(\.presentationMode) var presentation
    @ObservedObject var obBullGrp:ObBullGrp
    @State var activ_alert = false
    @State var activ_loveEdit = false
    @ObservedObject var bullLove = BullLove(chara: .love)
    init(obBullGrp:ObBullGrp){
        self.obBullGrp = obBullGrp
    }
    
    var body: some View {
        GeometryReader{gmty in
            VStack{
                NavigationLink(destination:VwLoveEdit(bullLove),isActive: $activ_loveEdit){
                    Spacer().frame(width: 0, height: 0)
                }
                ScrollView{
                    VStack(spacing:0){
                        TextField("チャンネル",text: $obBullGrp.name)
                            .padding(10)
                            .cornerRadius(20)
                            .background(Color.white)
                            .padding(30)
                            .shadow(color: .gray, radius: 2, x: 0, y: 0)
                        vwCharaList(gmty.size.width)
                        ForEach(obBullGrp.ary_chara,id:\.self){ chara in
                            VwChara(chara,dic_tag: $obBullGrp.dic_tag,ary_chara: $obBullGrp.ary_chara)
                        }
                    }
                }
                
                    Button(action:{
                        presentation.wrappedValue.dismiss()
                        evBull.ary_obBullGrp.append(obBullGrp)
                    }){
                        VwButton1typ1("保存")
                            .padding([.trailing],10)
                            .padding(5)
                    }
            }
        }.onAppear(){
            //obBullGrp.ary_chara = [.global,.love,.note,.party]
            //obBullGrp.dic_tag[.global] = ["tag1","tag2","tag3"]
        }.alert(isPresented: $activ_alert){
            Alert(
                title: Text("プロフィールの入力が必要です"),
                message: Text("マッチング機能の利用はプロフィール作成が必要です"),
                primaryButton: .default(
                    Text("設定"),
                    action: {
                        activ_loveEdit = true
                    }
                ),
                secondaryButton: .default(Text("キャンセル"))
            )
        }
    }
    
    func vwCharaList(_ width_limit:CGFloat) -> some View{
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment:.topLeading){
            ForEach(EmBullChara.allCases,id: \.self){ chara in
                vwCharaListItem(chara)
                .alignmentGuide(.leading, computeValue: { d in
                    if abs(width - d.width) > width_limit {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if chara == EmBullChara.allCases.last {
                        width = 0
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = height
                    if chara == EmBullChara.allCases.last {
                        height = 0
                    }
                    return result
                })
            }
        }.frame(maxWidth:.infinity)
    }
    
    func vwCharaListItem(_ chara: EmBullChara) -> some View{
        return Button(action:{
            if chara == .love ,!evMypage.bolProfileLove(){
                activ_alert = true
                return
            }
            if obBullGrp.ary_chara.contains(chara){
                obBullGrp.ary_chara.removeAll(where:{$0 == chara})
            }else{
                obBullGrp.ary_chara.append(chara)
            }
        }){
            if obBullGrp.ary_chara.contains(chara){
                Text(chara.rawValue)
                    .padding(8)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .background(dic_para_chara[chara]!["lg"] as! LinearGradient)
                    .cornerRadius(10)
                    .padding(4)
            }else{
                Text(chara.rawValue)
                    .padding(8)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        )
                    .padding(4)
            }
        }
    }
    
    private struct VwChara:View{
        let chara :EmBullChara
        
        @State var width = CGFloat.zero
        @State var height = CGFloat.zero
        @State var ary_tag = [String]()
        @Binding var dic_tag : [EmBullChara:[String]]
        @Binding var ary_chara :[EmBullChara]
        @State var rock = false
        init(_ chara:EmBullChara,dic_tag:Binding<[EmBullChara:[String]]>,ary_chara:Binding<[EmBullChara]>){
            self.chara = chara
            self._dic_tag = dic_tag
            self._ary_chara = ary_chara
            if let m_ary_tag = dic_tag[chara].wrappedValue
            
            {
                ary_tag = m_ary_tag
            }
        }
        var body: some View{
            ZStack(alignment:.topTrailing){
                VStack(alignment:.leading){
                    HStack{
                        Text(dic_para_chara[chara]!["title"] as! String)
                            .foregroundColor(.white)
                            .font(.system(size: 20,weight: .medium))
                        Spacer()
                    }
                    HStack{
                        Text("タグ")
                            .foregroundColor(.white)
                            .font(.system(size: 16,weight: .medium))
                        NavigationLink(
                            destination: VwTagEdit(ary_tag: $ary_tag)
                                .onAppear(){
                                    rock = true
                                }
                                .onDisappear(){
                                    dic_tag[chara] = ary_tag
                                    rock = false
                                }
                        ){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    if ary_tag.isEmpty{
                        HStack{
                            vwTagItem("All")
                            Spacer()
                        }
                    }else{
                        vwTags(300)
                    }
                    
                }
                .padding(10)
                .background(
                    (dic_para_chara[chara]!["lg"] as! LinearGradient)
                    .opacity(0.5)
                )
                .cornerRadius(20)
                .padding([.top],10)
                .padding([.horizontal],10)
                
                Button(action:{
                    ary_chara.removeAll(where:{$0 == chara})
                }){
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.pink)
                        .background(Color.white.cornerRadius(100))
                }
            }
            .padding(10)
            .padding([.horizontal],5)
            .onAppear(){
                if !dic_tag.keys.contains(chara){
                    dic_tag[chara] = [String]()
                }else{
                    if !rock {
                        ary_tag = dic_tag[chara]!
                    }
                }
                print("2")
            }
        }
        func vwTags(_ width_limit:CGFloat) -> some View{
            var width = CGFloat.zero
            var height = CGFloat.zero
            
            return ZStack(alignment:.topLeading){
                ForEach(ary_tag,id: \.self){ tag in
                    vwTagItem(tag)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > 300 {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == ary_tag.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if tag == ary_tag.last {
                            height = 0
                        }
                        return result
                    })
                }
            }
        }
        
        func vwTagItem(_ text:String) -> some View{
            return Text(text)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .padding(5)
                .padding([.horizontal],10)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white))
                .padding(5)
        }
    }
}




struct VwBullGrpAdd_Previews: PreviewProvider {
    @ObservedObject static var obBullGrp = ObBullGrp(dic_tag: [EmBullChara:[String]](), name: "チャンネル")
    
    static var previews: some View {
        VwBullGrpAdd(obBullGrp: obBullGrp)
    }
}
