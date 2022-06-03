
import SwiftUI
import UIKit

enum EditMyThema  {
    case name
    case pref
}

class ObMyPage :ObservableObject{
    @Published var edit_thema:EditMyThema? = nil
    @Published var bol_edit = false
}

struct VwMypage: View {
    @EnvironmentObject var spr:Spr
    @ObservedObject var ob = ObMyPage()
    @State var key_text : String? = nil
    var body: some View {
        ZStack{
            VStack{
                if let img1 = spr.myself?.img1{
                    Image(uiImage: img1)
                }
                Button(action: {
                    
                }){
                    Text("メイン写真を変更")
                }
                if let icon = spr.myself?.icon{
                    Image(uiImage: icon)
                }
                Button(action:{
                
                }){
                    Text("アイコンを変更")
                }
                Text("")
                Text(spr.myself?.name ?? "未設定")
                Text(String(spr.myself?.age ?? 0))
                Text(spr.myself?.pref ?? "未設定")
            }
            if ob.bol_edit {
                VwMyEdit(ob)
            }
            
        }.onAppear(){
            print("get myself")
            spr.getMyself()
            
            if let myself = spr.myself{
                print(myself.name)
            }
        }
    }
}



struct VwMyEdit:View{
    @ObservedObject var ob : ObMyPage
    init(_ ob : ObMyPage){
        self.ob = ob
    }
    var body: some View {
        switch self.ob.edit_thema{
        case .name:
            VwEditMyInput(ob)
        case .pref:
            VwEditMyPicker(ob)
        default:
            Text("error")
        }
    }
}

struct VwEditMyInput:View{
    @EnvironmentObject var spr:Spr
    @ObservedObject var ob : ObMyPage
    @State var name :String = "未設定"
    init(_ ob : ObMyPage){
        self.ob = ob
        if let m_name = spr.myself?.name{
            self.name = m_name
        }
    }
    var body: some View{
        VStack{
            Text("名前")
            TextField("",text: $name)
            Button(action: {
                
            }){
                Text("変更")
            }
        }
    }
}

struct VwEditMyPicker : View{
    @EnvironmentObject var spr:Spr
    @ObservedObject var ob : ObMyPage
    @State var emPref : EmPref = .pref0
    init(_ ob : ObMyPage){
        self.ob = ob
    }
    var body: some View{
        VStack{
            Picker("地域",selection: $emPref){
                ForEach(EmPref.allCases ,id:\.id){pref in
                    Text(ary_pref[pref.rawValue]).tag(pref)
                }
            }
            Spacer()
            HStack{
                Button(action:{
                    ob.bol_edit = false
                }){
                    Text("戻る")
                }
                Button(action:{
                    spr.myself?.pref = ary_pref[emPref.rawValue]
                    spr.setMyself()
                    
                }){
                    Text("保存")
                }
            }
        }
    }
}

