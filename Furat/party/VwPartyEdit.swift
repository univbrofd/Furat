//
//  VwPartyEdit.swift
//  Furat
//
//  Created by 浅香紘 on R 4/05/06.
//

import SwiftUI

struct VwPartyEdit: View {
    @ObservedObject var bull :BullParty
    @State var time = Date()
    @State var height_name :CGFloat = 40
    @State var height_text :CGFloat = 40
    @State var height_location : CGFloat = 40
    @State var activ_alert = false
    @State var text_alert = ""
    init(_ bull:BullParty){
        self.bull = bull
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ScrollView{
            VStack(spacing:40){
                vwName()
                    .padding([.horizontal],20)
                vwImg()
                VStack(spacing:40){
                    vwText()
                    vwLocation()
                    vwDate()
                    vwNum()
                    vwBudget()
                }.padding([.horizontal],20)
            }
        }
        .navigationBarItems(trailing:
            Button(action:{
                upload()
            }){
                Text("投稿")
            }
        )
        .alert(isPresented: $activ_alert){
            Alert(title: Text(text_alert))
        }
    }
    @ViewBuilder func vwName() -> some View{
        ZStack(alignment:.topLeading){
            Text(bull.name)
                .foregroundColor(.red)
                .font(.system(size: 30,weight: .medium))
                .padding([.horizontal],5)
                .padding([.vertical],8)
                .background(GeometryReader {
                    Color.clear.preference(key: PkeyPartyName.self, value: $0.frame(in: .local).size.height)
                })
            TextEditor(text: $bull.name)
                .frame(height: height_name)
                .font(.system(size: 30,weight: .medium))
            if bull.name == "" {
                Text("")
            }
        }
        .partyForm()
    }
    @ViewBuilder func vwImg() -> some View{
        if let img = bull.img1{
            Image(uiImage: img)
        }else{
            Button(action: {
                
            }){
                ZStack{
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    ZStack(alignment: .topTrailing){
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(10)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
            .frame(width: 300, height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style:StrokeStyle(dash:[10,10,10]))
                    .foregroundColor(.blue)
                )
            .background(Color.white)
            .cornerRadius(10)
        }
    }
    @ViewBuilder func vwText() -> some View{
        VStack(alignment:.leading){
            Text("説明")
                .padding([.leading],10)
                .foregroundColor(.gray)
            ZStack(alignment:.topLeading){
                Text(bull.text)
                    .foregroundColor(.red)
                    .padding([.horizontal],5)
                    .padding([.vertical],8)
                    .background(GeometryReader {
                        Color.clear.preference(key: PKeyPartyText.self, value: $0.frame(in: .local).size.height)
                    })
                TextEditor(text: $bull.text)
                    .frame(height: height_text)
            }.partyForm()
        }
    }
    @ViewBuilder func vwLocation() -> some View{
        VStack(alignment:.leading){
            Text("場所")
                .padding([.leading],10)
                .foregroundColor(.gray)
            ZStack(alignment:.topLeading){
                Text(bull.location)
                    .foregroundColor(.red)
                    .padding([.horizontal],5)
                    .padding([.vertical],8)
                    .background(GeometryReader {
                        Color.clear.preference(key: PKeyPartyLocation.self, value: $0.frame(in: .local).size.height)
                    })
                TextEditor(text: $bull.location)
                    .frame(height: height_location)
            }.partyForm()
        }
    }
    @ViewBuilder func vwDate() -> some View{
        VStack(alignment:.leading){
            Text("日時")
                .padding([.leading],10)
                .foregroundColor(.gray)
            DatePicker("",selection: $time,
                       displayedComponents: [.date])
            .partyForm()
        }
    }
    @State var activ_num_sex = false
    @State var str_num = ""
    @State var str_num_m = ""
    @State var str_num_f = ""
    @ViewBuilder func vwNum() -> some View{
        VStack{
            HStack{
                Text("人数")
                    .padding([.leading],10)
                    .foregroundColor(.gray)
                Spacer()
                Toggle("性別で分ける", isOn : $activ_num_sex)
                    .frame(width: 180)
                    .foregroundColor(.gray)
            }
            if !activ_num_sex {
                HStack{
                    TextField("0",text:$str_num)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        //.frame(width:20)
                    Text("人")
                        .padding([.leading],10)
                        .font(.system(size: 12))
                }.partyForm()
            }else{
                HStack{
                    HStack{
                        Text("男性")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("0",text:$str_num_f)
                            .keyboardType(.numberPad)
                            .frame(width:20)
                        Text("人")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth:.infinity)
                    .partyForm()
        
                    HStack{
                        Text("女性")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("0",text:$str_num_f)
                            .keyboardType(.numberPad)
                            .frame(width:20)
                        Text("人")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth:.infinity)
                    .partyForm()
                }
            }
        }
    }
    
    @State var activ_budget_sex = false
    @State var str_budget = ""
    @State var str_budget_m = ""
    @State var str_budget_f = ""
    @ViewBuilder func vwBudget() -> some View{
        VStack{
            HStack{
                Text("予算")
                    .padding([.leading],10)
                    .foregroundColor(.gray)
                Spacer()
                Toggle("性別で分ける", isOn : $activ_budget_sex)
                    .frame(width: 180)
                    .foregroundColor(.gray)
            }
            if !activ_budget_sex {
                HStack{
                    TextField("0",text:$str_budget)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        //.frame(width:20)
                    Text("円")
                        .padding([.leading],10)
                        .font(.system(size: 12))
                }.partyForm()
            }else{
                HStack{
                    HStack{
                        Text("男性")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("0",text:$str_budget_f)
                            .keyboardType(.numberPad)
                            .frame(width:20)
                        Text("円")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth:.infinity)
                    .partyForm()
        
                    HStack{
                        Text("女性")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("0",text:$str_budget_f)
                            .keyboardType(.numberPad)
                            .frame(width:20)
                        Text("円")
                            .font(.system(size: 12))
                    }
                    .frame(maxWidth:.infinity)
                    .partyForm()
                }
            }
        }
    }
    func onAlert(_ text:String){
        text_alert = text
        activ_alert = true
    }
    func upload(){
        if activ_num_sex{
            let num_m = Int(str_num_m) ?? 0
            let num_f = Int(str_num_f) ?? 0
            if num_m == 0,num_f == 0 {
                onAlert("人数が無効です")
                return
            }
            bull.num_m = num_m
            bull.num_f = num_f
            bull.num = 0
        }else{
            let num = Int(str_num) ?? 0
            if num == 0 {
                onAlert("人数が無効です")
                return
            }
            bull.num_m = 0
            bull.num_f = 0
            bull.num = Int(str_num) ?? 0
        }
        if activ_budget_sex{
            let num_m = Int(str_budget_m) ?? 0
            let num_f = Int(str_budget_f) ?? 0
            if num_m == 0,num_f == 0 {
                onAlert("予算が無効です")
                return
            }
            bull.budget_m = num_m
            bull.budget_f = num_f
            bull.budget = 0
        }else{
            let num = Int(str_budget) ?? 0
            if num == 0 {
                onAlert("予算が無効です")
                return
            }
            bull.budget_m = 0
            bull.budget_f = 0
            bull.budget = Int(str_budget) ?? 0
        }
        bull.time_party = time
        if bull.name == "" {
            onAlert("タイトルを入力してください")
            return
        }
        if bull.location == ""{
            onAlert("場所を入力してください")
            return
        }
        bull.upload()
    }
}

extension View{
    func partyForm() -> some View{
        self
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
    }
}

struct PkeyPartyName: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct PKeyPartyText: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct PKeyPartyLocation: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct VwPartyEdit_Previews: PreviewProvider {
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
    
    static var bull = BullParty(VwPartyEdit_Previews.pre_infoParty,time: Date())
    static var previews: some View {
        VwPartyEdit(bull)
    }
}
