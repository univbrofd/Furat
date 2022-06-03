//
//  VwMypageLove.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/07.
//

import SwiftUI

struct VwMypageLove: View {
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evMypage:EvMypage
    @State var preview = false
    @ObservedObject var bullLove : BullLove
    let bg_promote = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.4, green: 0.8, blue: 0.2),
        Color(red: 0.4, green: 0.8, blue: 0.5)
    ]), startPoint: .leading, endPoint: .trailing)
    
    init(_ bullLove:BullLove){
        self.bullLove = bullLove
    }
    
    var body: some View {
        GeometryReader{gmty in
            ZStack{
                HStack{
                    Spacer()
                    if preview {
                        VwBullLove(bullLove)
                            .frame(width:gmty.size.width * 0.5)
                    }else{
                        VwLove(bullLove,make: false)
                    }
                    Spacer()
                }
                if evMypage.sex == nil || evMypage.barth == nil{
                    vwPromote()
                }
            }
        }
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
}

/*
struct VwMypageLove_Previews: PreviewProvider {
    static var pre_infoLove = [
        "id" : "love2",
        "chara":"love",
        "hight" : 100,
        "time":"2022020913443147",
        "love":[
            "uid":"preid002",
            "name":"る",
            //"url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
            //"url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
            "barth":"19870715",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。"
        ]
    ] as [String : Any]
    
    static var previews: some View {
        VwMypageLove()
    }
}
 */
