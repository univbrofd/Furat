//
//  VwLove.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/08.
//

import SwiftUI

struct VwLove: View {
    @EnvironmentObject var evMypage:EvMypage
    
    @ObservedObject var bullLove : BullLove
    @State var inp_profile = ""
    @State var release = false
    @State var activ_alert = false
    @State var text_alert = ""
    var make:Bool
    let bg_finish = LinearGradient(gradient: Gradient(colors: [
        Color(red: 1, green: 0.4, blue: 0.6),
        Color(red: 1, green: 0.7, blue: 0.65)
    ]), startPoint: .leading, endPoint: .trailing)
    let bg_promote = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.4, green: 0.8, blue: 0.2),
        Color(red: 0.4, green: 0.8, blue: 0.5)
    ]), startPoint: .leading, endPoint: .trailing)
    init(_ bullLove:BullLove,make:Bool){
        self.bullLove = bullLove
        self.make = make
    }
    
    var body: some View {
        ZStack{
            vwMain()
            VStack{
                Spacer()
                if make{
                    vwButtonRelese()
                        .padding([.bottom],10)
                        .padding([.horizontal],30)
                }
            }
            if make{
                if evMypage.sex == nil || evMypage.barth == nil{
                    vwPromote()
                }
            }
            //frame(maxHeight:.infinity)
        }.alert(isPresented: $activ_alert){
            Alert(title: Text(text_alert))
        }.navigationTitle("マッチング")
        .navigationBarItems(trailing: HStack{
            if make {
                NavigationLink(
                    destination: VwLoveEdit(bullLove)
                        .environmentObject(evMypage)
                ){
                    Text("編集")
                }
            }else{
                Spacer()
            }
        })
    }
    
    func vwPromote() -> some View{
        ZStack(){
            Color.black
                .frame(maxWidth:.infinity,maxHeight: .infinity)
                .opacity(0.5)
            ZStack(alignment: .top){
                VStack{
                    Spacer().frame(height:30)
                    VStack(spacing:0){
                        Text("生年月日と性別を設定してください")
                            .padding([.top],80)
                        Spacer()
                        HStack{
                            NavigationLink(destination: VwInputBarth()
                                            .environmentObject(evMypage)){
                                Text("設定する")
                                    .font(.system(size: 18,weight: .medium))
                                    .frame(width:300,height: 50)
                                    .foregroundColor(.white)
                                    .background(bg_promote)
                                    .cornerRadius(20).environmentObject(evMypage)
                            }
                        }
                        .padding([.bottom],20)
                    }
                    .frame(width: 340, height: 240)
                    .background(Color.white)
                    .cornerRadius(30)
                }
                VStack{
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(Color.white.cornerRadius(100))
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    func vwMain() -> some View{
        ScrollView{
            VStack(alignment:.leading,spacing: 0){
                if let img1 = bullLove.img1{
                    Image(uiImage: img1)
                        .resizable()
                        .frame(maxWidth:.infinity)
                        .scaledToFill()
                }else{
                    ZStack{
                        Image(systemName: "person.fill.questionmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width:100,height:100)
                            .foregroundColor(.white)
                    }
                    .frame(height: 400)
                    .frame(maxWidth:.infinity)
                    .background(Color.gray)
                }
                HStack(alignment:.bottom){
                    Text(bullLove.name).font(.system(size: 30,weight: .heavy))
                    Text(String(getAge(bullLove.barth)))
                        .font(.system(size: 20,weight: .bold))
                    Text(bullLove.pref).font(.system(size: 20,weight: .bold))
                    Spacer()
                }.padding(20)

                Text("自己紹介")
                    .font(.system(size: 14,weight: .light))
                    .padding([.top,.leading,.trailing],10)
                
                Text(bullLove.profile)
                    .font(.system(size: 16))
                    .padding([.top,.leading,.trailing],10)
                Spacer()
                    .frame(height: 100)
            }
            .frame(maxWidth:.infinity)
            .onAppear{
                if bullLove.img1 == nil{
                    bullLove.getImg(.img1)
                }
            }
        }
    }
    
    @ViewBuilder func vwButtonRelese() -> some View{
        if evMypage.love_relese{
            Button(action:{
                evMypage.love_relese = false
                bullLove.remove()
            }){
                VwButton1typ2("非公開にする")
            }
        }else{
            Button(action:{
                evMypage.love_relese = onRelese()
            }){
                VwButton1typ1("公開する")
            }
        }
    }
    
    func onRelese() -> Bool{
        print("onRelese")
        guard bullLove.url_img1.count > 0 else{
            onAlert("写真を設定してください")
            return false}
        guard Spr.uid.count > 0 else{
            onAlert("ユーザーIDが設定されていません")
            return false}
        guard bullLove.name.count > 0 else{
            onAlert("なまえを設定してください")
            return false}
        guard bullLove.barth.count > 0 else{
            onAlert("生年月日を設定してください")
             return false}
        guard bullLove.sex > 0,Spr.sex > 0 else{
            onAlert("性別を設定してください")
            return false}
        guard bullLove.pref.count > 0 else{
            onAlert("所在地を設定してください")
            return false}
        guard bullLove.profile.count > 0 else{
            onAlert("プロフィールを入力してください")
            return false}
        guard bullLove.img_ratioH > 0 else{
            onAlert("写真が読み込めません")
            return false}
        
        bullLove.upload()
        print("onRelese end")
        return true
    }
    func onAlert(_ text:String){
        text_alert = text
        activ_alert = true
    }
}

struct VwLove_Previews: PreviewProvider {
    static var pre_infoLove = [
        "id" : "love2",
        "chara":"love",
        "time":"2022020913443147",
        "url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
        "img_ratioH" : 1.5,
        "ary_tag":["ゲーム","スノボー","野球","apex","カフェ","音楽","なると","lol","サマーランド","散歩","絵","アクロバット","コップ作り"],
        "love":[
            "uid":"preid002",
            "name":"る",
            //"url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
            
            "barth":"19870715",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。"
        ]
    ] as [String : Any]
    
    static var bull = BullLove(VwLove_Previews.pre_infoLove,time: Date())
    
    static var previews: some View {
        VwLove(bull,make:true)
    }
}
