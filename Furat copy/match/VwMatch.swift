import SwiftUI

struct VwMatch: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMatch :ObMatch
    @EnvironmentObject var obMsger:ObMsger
    
    var body: some View {
        VwImgList().onAppear(){
            
        }
    }
}

struct VwImgList: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMatch :ObMatch
    @EnvironmentObject var obMsger:ObMsger
    //@State var idx = 0
    @State var idx2 = 0
    var idx_size = 2
    //@State var ary2_lover = [[Person]]()
    @State var ary_high :[CGFloat] = []
    
    var body: some View{
        GeometryReader{ gmty in
            ScrollView{
                HStack(alignment: .top){
                    ForEach(0..<idx_size,id:\.self){ i in
                        if( i == 0 ){Spacer().frame(width: gmty.size.width*1/100)
                        }else{Spacer().frame(width: gmty.size.width*2/100)}
                        VwImgListClm(idx:i,gmty: gmty)
                        /*
                        VStack{
                            if self.ary2_lover.count > 0{
                                ForEach(self.ary2_lover[i],id: \.id){lover in
                                    NavigationLink(destination: VwChat(lover: lover).environmentObject(spr)
                                                    .environmentObject(obMsger)){
                                        VwLover(lover)
                                    }
                                }
                            }
                            Spacer()
                        }.frame(width: gmty.size.width*48/100)
                        */
                    }
                    Spacer().frame(width: gmty.size.width*1/100)
                }
                .frame(width: gmty.size.width)
                .onChange(of: obMatch.ary_lover_rea){newValue in
                    self.sortlover()
                }
            }.onAppear(){
                obMatch.vw = gmty.size.width
            }
        }
        .onAppear(){
            print("on apeer")
            for _ in 0..<idx_size{
                let m_ary_lover = [Person]()
                obMatch.ary2_lover.append(m_ary_lover)
                self.ary_high.append(0)
            }
        }
    }
    
    func sortlover(){
        print(obMatch.ary_lover_rea.count)
        
        while !obMatch.ary_lover_rea.isEmpty {
            let m_idx2 = self.getMinHigh()
            self.apendLover(m_idx2)
        }
    }
    func getMinHigh() -> Int{
        var m_idx = 0
        for i in 1..<ary_high.count{ //idx_size{
            if ary_high[m_idx] > ary_high[i]{
                m_idx = i
            }
        }

        return m_idx
    }
    func apendLover(_ idx2:Int){
        guard let id = obMatch.ary_lover_rea.first else {return}
        if let lover = dic_person[id]{
            if let hight_img = lover.height_img1{
                obMatch.ary2_lover[idx2].append(lover)
                self.ary_high[idx2] += hight_img
                obMatch.ary_lover_rea.remove(at: 0)
                obMatch.ary_lover.append(id)
            }
        }
    }
}

struct VwImgListClm : View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMatch :ObMatch
    @EnvironmentObject var obMsger:ObMsger
    let idx : Int
    let gmty : GeometryProxy
    init(idx:Int,gmty:GeometryProxy){
        self.idx = idx
        self.gmty = gmty
    }
    var body : some View{
        VStack{
            if obMatch.ary2_lover.count > 0{
                ForEach(obMatch.ary2_lover[idx],id: \.id){lover in
                    NavigationLink(destination: VwChat(person: lover).environmentObject(spr)
                                    .environmentObject(obMsger)){
                        VwLover(lover)
                    }
                }
            }
            Spacer()
        }.frame(width: gmty.size.width*48/100)
    }
}

struct VwLover :View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMatch :ObMatch
    @State var lover: Person
    init(_ lover:Person){
        self.lover = lover
    }
    var body: some View{
        ZStack(alignment: .bottom){
            VStack{
                if let img1 = lover.img1{
                    Image(uiImage:img1)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                }
                Spacer()
                    .frame(height: 2)
                HStack{
                    if let icon = lover.icon{
                        Image(uiImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 78, height: 78)
                            .shadow(radius: 20)
                            .cornerRadius(10)
                    }
                    VStack(alignment: .leading){
                        Text(lover.initial)
                            .padding(0)
                            .foregroundColor(.pink)
                            .font(.footnote)
                            
                        if let age = lover.age{
                            Text(String(age))
                                .padding(0)
                                .foregroundColor(.pink)
                                .font(.footnote)
                        }
                        Text(lover.pref)
                            .padding(0)
                            .foregroundColor(.pink)
                            .font(.footnote)
                    }
                    Image(systemName: "suit.heart.fill")
                        .resizable()
                        .padding(10)
                        .frame(width: 48, height: 48)
                        .imageScale(.large)
                        .foregroundColor(.pink)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
        
    }
}

//高さを算出してから並び替えるため、uiiumageを取得したら表示するようにする
