import SwiftUI

struct VwBull:View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evBull :EvBull
    @EnvironmentObject var obMsger:ObMsger
    @State var bolMakeBullRdy = false
    @State var bolMakeBull = false
    @State var idx = 0
    @State var selection_init = false
    @State private var selection = UUID()
    @State var activ_grpEdit = false
    
    var body: some View{
        GeometryReader{ gmty in
            ZStack{
                VStack{
                    HStack(alignment:.center){
                        ScrollView(.horizontal, showsIndicators: false) {
                            ScrollViewReader { proxy in
                                HStack {
                                    ForEach(evBull.ary_obBullGrp,id:\.id) { obBullGrp in
                                        Text(obBullGrp.name)
                                            .font(.headline)
                                            .decorate(isSelected: obBullGrp.id == selection)
                                            .onTapGesture(perform: {
                                                withAnimation {
                                                    selection = obBullGrp.id
                                                }
                                            })
                                    }
                                }
                                .onChange(of: selection, perform: { id in
                                    withAnimation {
                                        proxy.scrollTo(id, anchor: .center)
                                    }
                                })
                            }
                        }
                        Button(action:{
                            activ_grpEdit = true
                        }){
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(5)
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(5)
                        }
                    }
                    .padding([.horizontal],5)
                    TabView(selection: $selection) {
                        ForEach(evBull.ary_obBullGrp,id: \.id) { obBullGrp in
                            VwBullList(obBullGrp).frame(width: gmty.size.width)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }.sheet(isPresented: $activ_grpEdit){
            VwBullGrpEdit().environmentObject(evBull)
        }.onAppear(){
            if !selection_init,let id = evBull.ary_obBullGrp.first?.id{
                selection_init = true
                selection = id
            }
            
        }
    }
}

struct VwBullList: View {
    @EnvironmentObject var spr:Spr
    @ObservedObject var obBullGrp : ObBullGrp
    @EnvironmentObject var obMsger:ObMsger
    @State var height = CGFloat.zero
    @State var loading = false
    init(_ obBullGrp:ObBullGrp){
        self.obBullGrp = obBullGrp
    }
    
    var body: some View{
        GeometryReader{ gmty in
            ScrollView{
                VStack{
                    if obBullGrp.loading_new{
                        ProgressView()
                    }
                    ZStack(alignment: .top){
                        GeometryReader{gmty_in in
                            Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: [
                                calculateContentOffset(fromOutsideProxy: gmty, insideProxy: gmty_in),
                            ])
                        }
                        Color.clear.frame(height: max(obBullGrp.h_r,obBullGrp.h_l))
                        ForEach(obBullGrp.ary_bull,id: \.id){bull in
                            VwBullListCell(bull,width: gmty.size.width,ob:obBullGrp)
                                .frame(width: gmty.size.width * 0.5)
                        }
                    }
                    .frame(width: gmty.size.width)
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                print(value[0])
                if value[0] < 0{
                    obBullGrp.getBull(true)
                }
                let h_vw = max(obBullGrp.h_l,obBullGrp.h_r)
                let h_screen = gmty.size.height
                if h_vw - h_screen - value[0] < 200{
                    self.obBullGrp.getBull(false)
                }
            }
        }.padding([.horizontal],2)
            .onAppear(){
                if obBullGrp.ary_bull.count == 0{
                    obBullGrp.loading = false
                    obBullGrp.loading_new = false
                    obBullGrp.getBull(true)
                }
            }
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
    }
}

struct VwBullListCell :View{
    @ObservedObject var obBullGrp : ObBullGrp
    @ObservedObject var bull : Bull
    let id:String
    let width :CGFloat
    @State var h = CGFloat.zero
    init(_ bull:Bull,width:CGFloat,ob:ObBullGrp){
        self.bull = bull
        self.id = bull.id
        self.width = width
        self.obBullGrp = ob
    }
    var body: some View{
        VStack(alignment:.leading){
            if let bullLove = bull as? BullLove{
                NavigationLink(destination: VwLove(bullLove,make: false)){
                    VwBullLove(bullLove)
                        .frame(height: (Double(width * 0.5) - 4) * bullLove.img_ratioH )
                }
            }else if let bullParty = bull as? BullParty{
                NavigationLink(destination: VwParty(bullParty,make: false)){
                    VwBullParty(bullParty)
                }
            }else if let bullCall = bull as? BullCall{
                
                VwBullCall(bullCall)
            }else if let bullGlobal = bull as? BullGlobal{
                NavigationLink(destination: VwGlobal(bullGlobal,make: false)){
                    VwBullGlobal(bullGlobal)
                }
            }else if let bullNote = bull as? BullNote{
                NavigationLink(destination: VwNote(bullNote,make: false)){
                    VwBullNote(bullNote)
                }
            }else{
                Spacer().frame(width: 0, height: 0)
            }
            VwBullTag(bull.ary_tag,make: false,width: width)
        }
        .padding(2)
        //.onChange(of: h){newValue in//obBullGrp.set(id,h:h)}
        .offset(
            x: (obBullGrp.dic_x[id] ?? 0) * (width * 0.25), y: obBullGrp.dic_y[id] ?? 0)
        .background(
            GeometryReader{gmty_b in
                Spacer()
                    .onAppear{
                        h = gmty_b.size.height
                        obBullGrp.set(id,h:h)
                        if bull.id == obBullGrp.ary_bull.last?.id{
                            obBullGrp.loading = false
                        }
                    }
            }
        )
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

//高さを算出してから並び替えるため、uiiumageを取得したら表示するようにする
