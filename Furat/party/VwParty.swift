//
//  VwParty.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/16.
//

import SwiftUI

struct VwParty: View {
    @ObservedObject var bull :BullParty
    @State var birthDate = Date()
    @State var height_name :CGFloat = 40
    @State var height_location : CGFloat = 40
    @State var make = false
    let color_bg_form = Color(red: 0.95, green: 0.95, blue: 0.95)
    init(_ bull:BullParty,make:Bool){
        self.bull = bull
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ScrollView{
            VStack{
                Text("name")
            }
            
        }.background(color_bg_form)
        
    }

}

struct VwParty_Previews: PreviewProvider {
    static var pre_infoParty = [
        "id": "party1",
        "chara":"party",
        "hight": 100,
        "time":"2022021304203111",
        "party":[
            "name":"同窓会aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            "time":"2022122020360012",
            "num":0,
            "num_m":5,
            "num_f":5,
            "location":"東京 新宿　牛角aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
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
        VwParty(bull,make: false)
    }
}
