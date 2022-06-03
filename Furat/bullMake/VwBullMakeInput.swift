//
//  VwBullMakeInput.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/13.
//

import SwiftUI

struct VwBullMakeInput: View {
    @EnvironmentObject var evMypage:EvMypage
    var chara : EmBullChara
    
    init(chara:EmBullChara){
        self.chara = chara
    }
    var body: some View {
        ZStack{
            getVwBull(self.chara)
        }
    }
    
    func getVwBull(_ chara:EmBullChara) -> AnyView {
        let bull = evMypage.getBull(chara)
        switch chara {
        case .love: return AnyView(VwLove(bull as! BullLove,make: true))
        case .party: return AnyView(VwParty(bull as! BullParty ,make: true))
        case .global: return AnyView(VwGlobal(bull as! BullGlobal,make: true))
        case .note: return AnyView(Text("none"))
        }
    }
}

struct VwBullMakeInput_Previews: PreviewProvider {
    static var previews: some View {
        VwBullMakeInput(chara:.global)
    }
}
