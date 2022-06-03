//
//  VwTest.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/24.
//

import SwiftUI

struct VwTest: View {
    @State var on = false
    @State var color_bg : LinearGradient
    let color_bg_on :LinearGradient
    let color_bg_off : LinearGradient
    
    init(){
        let color_bg_on_t = Color(red: 0.3, green: 0.3, blue: 0.3)
        let color_bg_on_b = Color(red: 0.5, green: 0.5, blue: 0.5)
        let color_bg_off_t = Color(red: 0.3, green: 0.3, blue: 0.3)
        let color_bg_off_b = Color(red: 0.5, green: 0.5, blue: 0.5)
        
        color_bg_on = LinearGradient(gradient: Gradient(colors: [color_bg_on_t,color_bg_on_b]), startPoint: .top, endPoint: .bottom)
        color_bg_off = LinearGradient(gradient: Gradient(colors: [color_bg_off_t,color_bg_off_t]), startPoint: .top, endPoint: .bottom)
        self.color_bg = color_bg_on
    }
    
    var body: some View {
        HStack(alignment: .top){
            Spacer().frame(width: 10)
            
            Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(10)
            .frame(width: 50, height: 50)
            .background(Color.gray)
            .clipShape(Circle())

            Spacer().frame(width: 10)
            VStack(alignment: .leading){
                Spacer().frame(height: 5)
                Text("name")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("こんにちわ")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            Spacer()
            /*
            VStack{
                Text(elapsedTime)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
             */
            Spacer().frame(width: 10)
        }
    }
}

struct VwTest_Previews: PreviewProvider {
    static var previews: some View {
        VwTest()
    }
}
