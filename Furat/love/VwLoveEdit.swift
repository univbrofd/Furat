//
//  VwLoveEdit.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/26.
//

import SwiftUI

struct VwLoveEdit: View {
    @EnvironmentObject var evMypage:EvMypage
    @Environment(\.presentationMode) var presentation
    let bg_finish = LinearGradient(gradient: Gradient(colors: [
        Color(red: 1, green: 0.4, blue: 0.6),
        Color(red: 1, green: 0.7, blue: 0.65)
    ]), startPoint: .leading, endPoint: .trailing)
    @State var name = ""
    @State var img1 : UIImage? = nil
    @State var pref = "-"
    @State var profile = ""
    @State var activ_gallery = false
    @State var update_img1 = false
    @ObservedObject var bullLove :BullLove
    
    init(_ bullLove:BullLove){
        self.bullLove = bullLove
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }){
                        HStack{
                            Image(systemName: "chevron.backward")
                            Text("キャンセル")
                        }
                    }
                    Spacer()
                }
                ScrollView{
                    VStack{
                        vwMyLoveEdit()
                    }.padding([.bottom],50)
                }.onAppear{
                    name = evMypage.love_name
                    profile = evMypage.love_profile
                    pref = evMypage.love_pref
                }
            }
            VStack{
                Spacer()
                Button(action: {
                    save()
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
                GetImageView(
                    activ: $activ_gallery,
                    uiimage: $img1,
                    update: $update_img1
                )
            }
        }
        .navigationBarHidden(true)
    }
    @ViewBuilder func vwMyLoveEdit() -> some View{
        VStack(spacing:10){
            vwEditImage()
            VwMyEditText(title: "名前", text: $name)
                .padding([.top],10)
            HStack{
                Text("所在地")
                    .font(.system(size: 14))
                Spacer()
            }.padding([.top],10)
            
            Picker("地域",selection: $pref){
                ForEach(ary_pref,id:\.self){pref in
                    Text(pref)
                }
            }
                .foregroundColor(.white)
                .padding(5)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                .multilineTextAlignment(.center)
            
            HStack{
                Text("プロフィール")
                    .font(.system(size: 14))
                Spacer()
            }.padding([.top],10)
            TextEditorView($profile,font: .system(.body))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
        }.padding([.horizontal],50)
            .padding([.vertical],30)
            .padding([.bottom],30)
    }
    
    @ViewBuilder func vwEditImage() -> some View{
        Button(action:{
            activ_gallery = true
        }){
            ZStack(alignment:.bottomTrailing){
                ZStack{
                    if  let uiimage = img1,
                        let data = uiimage.jpegData(compressionQuality: 0.1),
                        let uiImage = UIImage(data: data) {
                        Image(uiImage:uiImage)
                            .resizable()
                            .scaledToFit()
                    }else if let img1 = evMypage.love_img1{
                        Image(uiImage: img1)
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
                .frame(width: 300)
                .frame(maxHeight:.infinity)
                
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .cornerRadius(100)
                    .frame(width: 30, height: 30)
            }
        }
    }
    func save(){
        var update = false
        if evMypage.love_name != name {
            evMypage.love_name = name
            update = true
        }
        if evMypage.love_name != name {
            evMypage.love_name = name
            update = true
        }
        if evMypage.love_profile != profile{
            evMypage.love_profile = profile
            update = true
        }
        if evMypage.love_pref != pref{
            evMypage.love_pref = pref
            update = true
        }
        if update_img1 {
            evMypage.love_img1 = img1
            evMypage.update_love_img = update_img1
            update = true
        }
        if update{
            evMypage.saveData()
            evMypage.rtSaveDataLove()
        }
        bullLove.update(evMypage.getBull(.love) as! BullLove)
        self.presentation.wrappedValue.dismiss()
    }
}

/*
struct VwLoveEdit_Previews: PreviewProvider {
    //@State var bullLove = BullLove(chara: .love)
    
    static var previews: some View {
        VwLoveEdit()
    }
}
*/
