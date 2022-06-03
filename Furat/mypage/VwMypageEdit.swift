import SwiftUI


struct VwMypageEdit: View {
    @EnvironmentObject var evMypage:EvMypage
    @Environment(\.dismiss) var dismiss
    @State var chara:EmBullChara
    let ary_chara :[EmBullChara] = [.global,.love]
    let bg_finish = LinearGradient(gradient: Gradient(colors: [
        Color(red: 1, green: 0.4, blue: 0.6),
        Color(red: 1, green: 0.7, blue: 0.65)
    ]), startPoint: .leading, endPoint: .trailing)
    
    @State var name = ""
    @State var update_icon = false
    @State var activ_edit = false
    @State var activ_gallery = false
    @State var icon :UIImage? = nil
    @State var rawUIImage : UIImage? = nil
    @State var rawImage : Image? = nil
    @State var iniSize : CGSize? = nil
    
    init(chara:EmBullChara){
        self._chara = State(initialValue: chara)
    }
    var body: some View{
        ZStack{
            NavigationLink(
                destination:
                    VwIconEdit(
                        icon:$icon,
                        update:$update_icon,
                        activImageEdit:$activ_edit,
                        rawUIImage:$rawUIImage,
                        rawImage:$rawImage,
                        iniSize:$iniSize
                    ),
                isActive: $activ_edit
            ){
                Color.clear
            }.isDetailLink(false)
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        HStack{
                            Image(systemName: "chevron.backward")
                            Text("キャンセル")
                        }.padding(5)
                    }
                    Spacer()
                }
                ScrollView{
                    VStack{
                        vwMyMainEdit()
                        //vwMyCallEdit()
                    }.padding([.bottom],50)
                }
                
                Button(action: {
                    evMypage.main_name = name
                    if update_icon{
                        evMypage.main_icon = icon
                        evMypage.update_main_icon = update_icon
                    }
                    evMypage.saveData()
                    dismiss()
                }, label: {
                    Text("完了")
                        .padding([.top,.bottom],10)
                        .frame(maxWidth:.infinity)
                        .background(bg_finish)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 20,weight: .semibold))
                        .shadow(color: .red, radius: 2, x: 0, y: 0)
                        .padding([.top,.bottom],10)
                        .padding([.trailing,.leading],40)
                })
            }
            if activ_gallery{
                GetIconView(
                    activ_gallery: $activ_gallery,
                    activ_edit: $activ_edit,
                    rawImage: $rawImage,
                    rawUIImage: $rawUIImage,
                    iniSize: $iniSize
                )
            }
        }.navigationBarHidden(true)
    }
    
    @ViewBuilder func vwMyMainEdit() -> some View{
        VStack(spacing:20){
            vwMyEditIcon()
            VwMyEditText(title: "Name", text: $name)
        }.padding([.leading,.trailing],50)
            .padding([.top],30)
    }
    
    @ViewBuilder func vwMyCallEdit() -> some View{
        VStack(spacing:10){
            Text("Call")
                .font(.system(size: 20,weight: .semibold))
                .padding([.bottom,.top],20)
            vwMyEditIcon()
            VwMyEditText(title: "Name", text: $evMypage.call_name)
            VwMyEditText(title: "Skype ID", text: $evMypage.call_skypeId)
            VwMyEditText(title: "Discrd ID", text: $evMypage.call_dicordId)
            
        }.padding([.leading,.trailing],50)
            .padding([.top],50)
    }
    
    @ViewBuilder func vwMyEditIcon() -> some View{
        Button(action:{
            self.activ_gallery = true
        }){
            ZStack(alignment:.bottomTrailing){
                ZStack{
                    if let icon = icon{
                        Image(uiImage: icon)
                            .resizable()
                            .scaledToFit()
                    }else{
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFill()
                            .padding(30)
                            .foregroundColor(.white)
                            .background(Color.gray)
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .cornerRadius(100)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct VwMyEditText :View{
    let title:String
    @Binding var text:String
    var body :some View{
        VStack{
            HStack{
                Text(title)
                    .font(.system(size: 14))
                Spacer()
            }
            .padding([.top],10)
            TextField("name",text: $text)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                .multilineTextAlignment(.center)
        }
    }
}

struct VwMypageEdit_pre: PreviewProvider {
    static var previews: some View {
        VwMypageEdit(chara: .global)
    }
}
