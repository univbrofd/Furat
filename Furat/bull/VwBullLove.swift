//
//  VwBullLove.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/02.
//

import SwiftUI

struct VwBullLove :View{
    @EnvironmentObject var evMypage:EvMypage
    @ObservedObject var bull : BullLove
    init(_ bull :BullLove){
        self.bull = bull
    }
    var body: some View{
        GeometryReader{ gmty in
            ZStack(alignment: .bottom){
                if let img1 = bull.img1{
                    Image(uiImage:img1)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(maxWidth:.infinity)
                }else{
                    ZStack{
                        Image(systemName: "person.fill.questionmark")
                    }
                    .background(Color.gray)
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
                }
                NavigationLink(destination:VwBullDetail(bull).environmentObject(evMypage)){
                    Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color.gray)
                .cornerRadius(10)
            .onAppear{
                if bull.img1 == nil{
                    bull.getImg(.img1)
                }
            }
        }
    }
    
    @ViewBuilder func vwContext() -> some View{
        VStack(alignment:.leading){
            HStack(alignment:.bottom){
                Text(bull.name)
                    .padding(0)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold, design: .default))
               
                Text(String(getAge(bull.barth)))
                    .padding(0)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .semibold, design:
                                        .default))
                Text(bull.pref)
                    .padding(0)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                Spacer()
                 
            }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            Spacer().frame(height:3)
            
            Text(bull.profile)
                .foregroundColor(.white)
                .lineLimit(3)
                .font(.system(size: 12, weight: .semibold, design: .default))
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

            Spacer().frame(height:3)
        }
    }
    
    @ViewBuilder func vwMake() -> some View{
        VStack{
            Button(action: {
            
            }, label: {
                Text("写真を変更")
            })
            HStack{
                TextField("プロフィール",text: $bull.profile)
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            }
        }
    }
}

struct VwBullLove_Previews: PreviewProvider {
    static var pre_infoLove = [
        "id" : "love2",
        "chara":"love",
        "hight" : 100,
        "time":"2022020913443147",
        //"url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
        "url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
        "love":[
            "uid":"preid002",
            "name":"る",
            "barth":"19870715",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。"
        ]
    ] as [String : Any]
    
    static var bull = BullLove(VwBullLove_Previews.pre_infoLove,time: Date())
    
    static var previews: some View {
        GeometryReader{ gmty in
            HStack{
                Spacer().frame(width:(gmty.size.width / 100) * 1)
                VwBullLove(bull)
                Spacer().frame(width:gmty.size.width / 2)
            }
        }
    }
}
