//
//  VwInputBarth.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/24.
//

import SwiftUI

struct VwInputBarth: View {
    @EnvironmentObject var evMypage:EvMypage
    @Environment(\.presentationMode) var presentation
    
    @State var selected = 0
    @State var birthDate : Date
    @State var sex = 0
    @State var str_sex = "不明"
    @State var activ_vwEditSex = false
    @State var activ_vwConfirm = false
    @State var activ_vwError = true
    @State var color_man = Color.white
    @State var color_woman = Color.white
    @State var text_error = ""
    let bg_finish = LinearGradient(gradient: Gradient(colors: [
        Color(red: 1, green: 0.4, blue: 0.6),
        Color(red: 1, green: 0.7, blue: 0.65)
    ]), startPoint: .leading, endPoint: .trailing)
    init(){
        _birthDate = State<Date>(
            initialValue: Calendar.current.date(
                byAdding:DateComponents(year: -18),
                to: Date()) ?? Date()
            )
    }
    var body: some View {
        ZStack{
            NavigationView {
                Form {
                    DatePicker("正年月日",selection: $birthDate,
                               displayedComponents: [.date])
                    Button(action:{
                        activ_vwEditSex = true
                    }){
                        HStack{
                            Text("性別")
                            Spacer()
                            Text(str_sex)
                        }.foregroundColor(.black)
                    }
                }
                .navigationBarTitle("入力画面")
            }
            
            if activ_vwError{
                Text(text_error)
                    .foregroundColor(.red)
            }
            
            if activ_vwEditSex{
                Button(action: {
                    activ_vwEditSex = false
                }){
                    Spacer()
                        .frame(maxWidth:.infinity,maxHeight: .infinity)
                        .background(Color.clear).opacity(0.25)
                }
                vwEditSex()
            }
            if !activ_vwConfirm{
                VStack{
                    Spacer()
                    Button(action: {
                        guard getAge(birthDate) >= 18 else{
                            onError("18歳未満は登録できません")
                            return
                        }
                        guard sex == 1 || sex == 2 else{
                            onError("性別が設定されていません")
                            return
                        }
                        activ_vwConfirm = true
                    }, label: {
                        Text("完了")
                            .padding([.top,.bottom],10)
                            .frame(maxWidth:.infinity)
                            .frame(width:340,height: 50)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius:20)
                                        .stroke(Color.gray))
                            .padding([.bottom],20)
                    })
                }
            }
            if activ_vwConfirm{
                vwConfirm()
            }
        }
    }
    
    func onError(_ text:String){
        activ_vwError = true
        text_error = text
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            DispatchQueue.main.sync {
                activ_vwError = false
            }
        }
    }
    
    func vwEditSex() -> some View{
        HStack{
            VStack{
                Button(action:{
                    selectSex(1)
                }){
                    Text("男")
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1)
                        )
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            Spacer().frame(width:20)
            VStack{
                Button(action:{
                    selectSex(2)
                }){
                    Text("女")
                        .foregroundColor(.red)
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 1)
                        )
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(30)
        .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color(.init(gray: 0.5, alpha: 0.5)), radius: 20, x: 0, y: 0)
    }
    
    func selectSex(_ sex:Int){
        if sex == 1{
            self.sex = sex
            str_sex = "男"
            color_man = Color.blue
            color_woman = Color.white
        }
        if sex == 2{
            self.sex = sex
            str_sex = "女"
            color_man = Color.white
            color_woman = Color.red
        }
        activ_vwEditSex = false
    }
    
    func vwConfirm() -> some View{
        ZStack{
            Spacer()
                .frame(maxWidth:.infinity,maxHeight: .infinity)
                .background(Color.gray).opacity(0.7)
            VStack{
                VStack{
                    Text("以下の内容で保存しますか？")
                    Text("生年月日")
                        .padding([.top],20)
                        .foregroundColor(.gray)
                    Text(birthDate.string("yyyy年 M月 d日"))
                        .font(.system(size: 24))
                        .padding([.top],2)
                    
                    Text("性別")
                        .padding([.top],20)
                        .foregroundColor(.gray)
                    
                    Text(str_sex)
                        .font(.system(size: 24))
                        .padding([.top],2)
                    
                    Text("あとで変更はできません")
                        .foregroundColor(.red)
                        .padding([.top],30)
                }
                .padding([.vertical],40)
                .frame(width: 340)
                .background(Color.white)
                .cornerRadius(20)
                
                .shadow(color: Color(.init(gray: 0.5, alpha: 0.5)), radius: 20, x: 0, y: 0)
                
                Button(action: {
                    self.evMypage.saveBarth_Sex(barth: birthDate, sex: sex)
                    self.presentation.wrappedValue.dismiss()
                }){
                    Text("はい")
                        .frame(width:340,height: 50)
                        .background(bg_finish)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.system(size: 20,weight: .semibold))
                        .shadow(color: .red, radius: 2, x: 0, y: 0)
                        .padding([.top,.bottom],10)
                        .padding([.trailing,.leading],40)
                }
                Button(action: {
                    activ_vwConfirm = false
                }){
                    Text("いいえ")
                        .frame(width:340,height: 50)
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius:20)
                                    .stroke(Color.gray))
                }
            }
        }
    }
}

struct VwInputBarth_Previews: PreviewProvider {
    static var previews: some View {
        VwInputBarth()
    }
}
