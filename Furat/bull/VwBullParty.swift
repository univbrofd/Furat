//
//  VwBullParty.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/02.
//

import SwiftUI

struct VwBullParty :View{
    @EnvironmentObject var spr:Spr
    @ObservedObject var bull : BullParty
    @State var num_rdy_m = 0
    @State var num_rdy_f = 0
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5, alignment: .center), count: 2)
    
    let bg_time = LinearGradient(gradient: Gradient(colors: [
        Color(red: 1, green: 0.5, blue: 0.6),
        Color(red: 1, green: 0.7, blue: 0.8)
    ]), startPoint: .top, endPoint: .bottom)
    let bg_location = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.6, green: 0.9, blue: 0.5),
        Color(red: 0.8, green: 0.9, blue: 0.7)
    ]), startPoint: .top, endPoint: .bottom)
    let bg_pep = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.5, green: 0.8, blue: 1),
        Color(red: 0.7, green: 0.8, blue: 1)
    ]), startPoint: .top, endPoint: .bottom)
    let bg_fee = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.9, green: 0.9, blue: 0.4),
        Color(red: 0.85, green: 0.9, blue: 0.6)
    ]), startPoint: .top, endPoint: .bottom)
        
    init(_ bull :BullParty){
        print("VwBullParty")
        self.bull = bull
        countNum()
        print("VwBullParty end")
    }
    var body: some View{
        VStack(alignment: .leading){
            Text(bull.name)
                .frame(maxWidth:.infinity)
                .padding(0)
                .foregroundColor(.black)
                .font(.system(size: 14, weight: .regular, design: .serif))
            if let img1 = bull.img1{
                Image(uiImage:img1)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
            }
            
            LazyVGrid(columns: columns,spacing: 5){
                if let time = bull.time_party?.string("yyyy.M.d (EEE)"){
                    ZStack(){
                        VStack{HStack{
                                Spacer()
                            markIcon("calendar")
                        }
                            Spacer()}
                        VStack{
                            HStack{
                                Text("Schedule")
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .font(.system(size: 8, weight: .semibold, design: .default))
                                Spacer()
                            }
                            Text(time)
                                .foregroundColor(.white)
                                .font(.system(size: 10, weight: .semibold, design: .default))
                        }
                    }
                    .frame(maxWidth:.infinity)
                    .background(bg_time)
                    .cornerRadius(5)
                }
                if bull.location != "" {
                    ZStack{
                        VStack{HStack{
                            Spacer()
                            markIcon("mappin.and.ellipse")
                        }
                            Spacer()}
                        VStack{
                            HStack{
                                Text("Venue")
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .font(.system(size: 8, weight: .semibold, design: .default))
                                Spacer()
                            }
                            Text(bull.location)
                                .foregroundColor(.white)
                                .font(.system(size: 10, weight: .semibold, design: .default))
                        }
                    }
                    .frame(maxWidth:.infinity)
                    .background(bg_location)
                    .cornerRadius(5)
                }
                ZStack{
                    VStack{HStack{
                        Spacer()
                        markIcon("person.2.fill")
                    }
                        Spacer()}
                    VStack{
                        HStack{
                            Text("Personnel")
                                .padding(5)
                                .foregroundColor(.white)
                                .font(.system(size: 8, weight: .semibold, design: .default))
                            Spacer()
                        }
                        HStack{
                            Spacer().frame(width: 5)
                            if bull.num > 0{
                                numPep(num_t: num_rdy_m + num_rdy_f, num_b: bull.num)
                            }else{
                                numPep(num_t: num_rdy_m, num_b: bull.num_m)
                                numPep(num_t: num_rdy_f, num_b: bull.num_f)
                            }
                        }
                    }
                }
                .frame(maxWidth:.infinity)
                .background(bg_pep)
                .cornerRadius(5)
                ZStack{
                    VStack{HStack{
                        Spacer()
                        markIcon("yensign.square.fill")
                    }
                        Spacer()}
                    VStack{
                        HStack{
                            Text("Fee")
                                .padding(5)
                                .foregroundColor(.white)
                                .font(.system(size: 8, weight: .semibold, design: .default))
                            Spacer()
                        }
                        HStack{
                            Spacer().frame(width:3)
                            if bull.budget > 0 {
                                Text(bull.budget.withComma)
                                    .foregroundColor(.white)
                                    .font(.caption2)
                            }else{
                                Text("M : \(bull.budget_m.withComma)")
                                    .foregroundColor(.white)
                                    .font(.caption2)
                                Spacer()
                                Text("F : \(bull.budget_f.withComma)")
                                    .foregroundColor(.white)
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(maxWidth:.infinity)
                .background(bg_fee)
                .cornerRadius(5)
            }
            Text(bull.text)
                .font(.system(size: 10, weight: .light, design: .default))
        }
        .background(Color.white)
        .shadow(color: .gray, radius: 0.5, x: 0, y: 0)
        .onAppear{
            //bull.getImg(bull.url_img1, emImg: .img1)
        }
    }
    
        
    @ViewBuilder func markIcon(_ sysName:String) -> some View{
        Image(systemName: sysName)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .padding(5)
            .opacity(0.3)
    }
    
    @ViewBuilder func numPep(num_t:Int,num_b:Int) -> some View {
        ZStack{
            Text("／")
                .foregroundColor(.white)
                .font(.caption2)
            HStack{
                VStack{
                    Text(String(num_t))
                        .foregroundColor(.white)
                        .font(.caption2)
                    Spacer().frame(height:3)
                }
                Spacer().frame(width:2)
                VStack{
                    Spacer().frame(height:3)
                    Text(String(num_b))
                        .foregroundColor(.white)
                        .font(.caption2)
                }
            }
        }
    }
    
    func countNum(){
        for person in bull.ary_person{
            if let sex = person.sex{
                if sex == 1 {
                    self.num_rdy_m += 1
                }else{
                    self.num_rdy_f += 1
                }
            }
        }
    }
}

struct VwBullParty_Previews: PreviewProvider {
    static var pre_infoParty = [
        "id": "party1",
        "chara":"party",
        "hight": 100,
        "time":"2022021304203111",
        "party":[
            "name":"同窓会",
            "time":"2022122020360012",
            "num":0,
            "num_m":5,
            "num_f":5,
            "location":"東京 新宿　牛角",
            "budget":5000,
            "budget_m":5000,
            "budget_f":3000,
            "url_img":"gs://furat-97153.appspot.com/test/user_img1/mother-and-child-6601502_640.jpg",
            "ary_tag":["飲み","ゲーム"],
            "text":"三年びりの開催、笑ありがとう涙あり御涙頂戴！！",
            "id_host":"preid001",
            "ary_person":[
                [
                    "id":"preid001",
                    "name":"Ak",
                    "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141168_640.jpg",
                    "url_img1":"gs://furat-97153.appspot.com/test/user_img1/abstract-6047465_640.jpg",
                    "sex":1,
                    "barth":"19971021",
                    "pref":"東京",
                    "profile":""
                ],[
                    "id":"preid002",
                    "name":"る",
                    "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
                    "url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
                    "sex":2,
                    "barth":"19930605",
                    "pref":"東京",
                    "profile":""
                ],[
                    "id":"preid003",
                    "name":"れ",
                    "url_icon":"gs://furat-97153.appspot.com/test/user_icon/animal-6987017_640.jpg",
                    "url_img1":"gs://furat-97153.appspot.com/test/user_img1/bengaluru-4707459_640.jpg",
                    "sex":1,
                    "barth":"19800901",
                    "pref":"東京",
                    "profile":"",
                ]
            ]
        ]
    ] as [String : Any]
    
    static var bull = BullParty(VwBullParty_Previews.pre_infoParty,time: Date())
    
    static var previews: some View {
        GeometryReader{ gmty in
            HStack{
                Spacer().frame(width:(gmty.size.width / 100) * 1)
                VwBullParty(bull)
                Spacer().frame(width:gmty.size.width / 2)
            }
        }
    }
}
