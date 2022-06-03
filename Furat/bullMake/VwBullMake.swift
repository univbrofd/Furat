//
//  VwBullMake.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/13.
//

import SwiftUI

import SwiftUI

struct VwBullMake: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evMypage:EvMypage
    @State var bullGlobal = BullGlobal(chara: EmBullChara.global)
    @State var bullNote = BullNote(chara: EmBullChara.note)
    @State var bullParty = BullParty(chara: EmBullChara.party)
    @State var bullLove = BullLove(chara: EmBullChara.love)
    @State var activ_global = false
    @State var activ_note = false
    @State var activ_party = false
    @State var activ_love = false
    @State var selectChara = EmBullChara.global
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5, alignment: .center), count: 2)

    var body: some View {
        ZStack{
            NavigationLink(
                destination:VwGlobal(bullGlobal, make: true)
                    .environmentObject(evMypage),
                isActive: $activ_global
            ){Color.clear}
            NavigationLink(
                destination:VwNote(bullNote, make: true)
                    .environmentObject(evMypage),
                isActive: $activ_note
            ){Color.clear}
            NavigationLink(
                destination:VwPartyEdit(bullParty)
                    .environmentObject(evMypage),
                isActive: $activ_party
            ){Color.clear}
            NavigationLink(
                destination:VwLove(bullLove, make: true)
                    .environmentObject(evMypage),
                isActive: $activ_love
            ){Color.clear}
            ScrollView{
                VStack(alignment:.leading){
                    Text("何を投稿しますか?")
                        .padding([.vertical],20)
                        .font(.system(size:24,weight: .bold))
                    LazyVGrid(columns: columns,spacing: 5){
                        ForEach(EmBullChara.allCases,id:\.self){ chara in
                            Button(action: {
                                onNav(chara: chara)
                            }){
                                vwLazyItem(chara)
                            }
                        }
                    }
                }.padding([.horizontal],5)
            }
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
    }
    
    func onNav(chara:EmBullChara){
        let bullChara = evMypage.getBull(chara)
        switch chara {
        case .global:
            if let bull = bullChara as? BullGlobal{
                self.bullGlobal = bull
                activ_global = true
            }
        case .love:
            if let bull = bullChara as? BullLove{
                self.bullLove = bull
                activ_love = true
            }
        case .party:
            if let bull = bullChara as? BullParty{
                self.bullParty = bull
                activ_party = true
            }
        case .note:
            if let bull = bullChara as? BullNote{
                self.bullNote = bull
                activ_note = true
            }
        }
    }
        
    func vwLazyItem(_ chara:EmBullChara) -> some View {
        return VStack{
            Image(systemName: dic_para_chara[chara]!["image"] as! String)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text(dic_para_chara[chara]!["title"] as! String)
                .font(.system(size: 16,weight: .black))
                .padding([.top],20)
        }
        .frame(height:200)
        .frame(maxWidth:.infinity)
        .background(
            ZStack{
                Image(dic_para_chara[chara]!["image_bg"] as! String)
                    .resizable()
                    .scaledToFill()
                (dic_para_chara[chara]!["lg"] as! LinearGradient)
                    .opacity(0.5)
            }
        )
        .cornerRadius(30)
        .foregroundColor(.white)
    }
}

struct VwBullMake_Previews: PreviewProvider {
    static var previews: some View {
        VwBullMake()
    }
}
