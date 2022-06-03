
import SwiftUI
import UIKit

struct VwMypage: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evMypage:EvMypage
    @State var key_text : String? = nil
    @State private var selection = EmBullChara.global
    @State var active_edit = false
    @State var active_edit_love = false
    @ObservedObject var bullLove = BullLove(chara: .love)
    let ary_chara :[EmBullChara] = [.global,.love]
    
    var body: some View {
        ZStack{
            NavigationLink(
                destination: VwMypageEdit(chara: .global)
                    .environmentObject(evMypage),
                isActive: $active_edit){
                    Color.clear
            }
            NavigationLink(
                destination: VwLoveEdit(bullLove)
                    .environmentObject(evMypage),
                isActive: $active_edit_love){
                    Color.clear
            }
            VStack{
                vwHeader()
                TabView(selection: $selection) {
                    ForEach(ary_chara,id:\.self) { emBullChara in
                        vwMyPageChara(emBullChara)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }.onAppear(){
            print("get myself")
            spr.getMyself()
                
            self.bullLove.update(evMypage.getBull(.love) as! BullLove)
        }
    }
    
    @ViewBuilder func vwHeader() -> some View{
        HStack{
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack {
                        ForEach(ary_chara,id:\.self) { emBullChara in
                            vwHederItemChara(emBullChara)
                        }
                    }
                    .onChange(of: selection, perform: { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .center)
                        }
                    })
                }
            }.padding([.trailing],5)
            Button(
                action:{
                    switch selection {
                    case .global:
                        active_edit = true
                    case .love:
                        active_edit_love = true
                    case .party:
                        return
                    case .note:
                        return
                    }
            }){
                Text("編集")
                    .font(.headline)
                    .padding(3)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding(1)
                    
            }
        }.padding([.leading,.trailing],10)
    }
    
    func vwHederItemChara(_ emBullChara:EmBullChara) -> some View{
        let text = emBullChara.rawValue
        
        @ViewBuilder var view : some View {
            Text(text)
            .font(.headline)
            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .decorate(isSelected: emBullChara == selection)
            .onTapGesture(perform: {
                withAnimation {
                    selection = emBullChara
                }
            })
        }
        return view
    }
    
    @ViewBuilder func vwMyPageChara(_ emBullChara:EmBullChara) -> some View {
        switch emBullChara {
        case .love:
            VwMypageLove(bullLove)
        default:
            VwMypageMain()
        }
    }
}

struct VwMypage_pre: PreviewProvider {
    static var previews: some View {
        VwMypage()
    }
}
