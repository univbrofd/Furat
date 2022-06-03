//
//  VwButton1.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/28.
//

import SwiftUI

struct VwButton1: View {
    let text:String
    let col_text: Color
    let col_bg :LinearGradient
   init(text:String,col_text:Color,col_t:Color,col_b:Color){
        self.text = text
        self.col_text = col_text
        col_bg = LinearGradient(gradient: Gradient(colors: [
            col_t,col_b
        ]), startPoint: .leading, endPoint: .trailing)
    }
    var body: some View {
        Text(text)
            .frame(height: 50)
            .frame(maxWidth:.infinity)
            .background(col_bg)
            .foregroundColor(col_text)
            .cornerRadius(20)
            .font(.system(size: 20,weight: .semibold))
            .shadow(color: .red, radius: 2, x: 0, y: 0)
    }
}

struct VwButton1typ1 :View{
    let text:String
    init(_ text:String){
        self.text = text
    }
    var body: some View{
        VwButton1(
            text: text,
            col_text: Color.white,
            col_t: Color(red: 1, green: 0.4, blue: 0.6),
            col_b: Color(red: 1, green: 0.7, blue: 0.65)
        )
    }
}

struct VwButton1typ2 :View{
    let text:String
    init(_ text:String){
        self.text = text
    }
    var body: some View{
        VwButton1(
            text: text,
            col_text: Color(red: 1, green: 0.5, blue: 0.5),
            col_t: Color(red: 1, green: 1, blue: 1),
            col_b: Color(red: 1, green: 1, blue: 1)
        )
    }
}

struct VwButton1_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            VwButton1typ1("公開する")
            VwButton1typ2("非公開にする")
        }
    }
}
