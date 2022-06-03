//
//  VwBullCall.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/01.
//

import SwiftUI

struct VwBullCall :View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var evBull:EvBull
    @ObservedObject var bull : BullCall
    let color_bg :LinearGradient
    @State var make_text = ""
    init(_ bull :BullCall){
        print("VwBullCall")
        self.bull = bull
        let color_t:Color
        let color_b:Color
        if bull.sex == 1{
            color_t = Color(red: 1.0, green: 0.5, blue: 0.5)
            color_b = Color(red: 1.0, green: 0.9, blue: 0.9)
        }else if bull.sex == 2{
            color_t = Color(red: 0.3, green: 0.3, blue: 1)
            color_b = Color(red: 0.5, green: 0.5, blue: 1)
        }else{
            color_t = Color(red: 0.3, green: 0.3, blue: 0.3)
            color_b = Color(red: 0.5, green: 0.5, blue: 0.5)
        }
        color_bg = LinearGradient(gradient: Gradient(colors: [color_t,color_b]), startPoint: .top, endPoint: .bottom)
        print("VwBullCall end")
    }
    var body: some View{
        VStack(alignment:.leading){
            Text(bull.name)
                .padding(EdgeInsets(top: 4, leading: 11, bottom: 4, trailing: 0))
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold, design: .default))
            Spacer().frame(height: 0)
            if bull.id_sky != ""{bodySky(bull.id_sky,"skype")}
            if bull.id_dis != ""{bodySky(bull.id_dis,"discord")}
           
            Text(bull.text)
                .foregroundColor(.gray)
                .font(.system(size: 10, weight: .semibold, design: .default))
                .frame(maxWidth:.infinity)
                .padding(6)
                .background(Color.white)
                .cornerRadius(6)
            
        }
        .background(color_bg)
        .onAppear{
            bull.getImg(.icon)
        }
        .cornerRadius(10)
        .shadow(color: .gray, radius: 0.4, x: 0, y: 0)
    }
    
    private func bodySky(_ id:String,_ icon:String) -> some View{
        var view : some View{
            Button(action: {
                
            }, label: {
                HStack{
                    Spacer().frame(width:1)
                    Image(icon).resizable().scaledToFit().frame(width: 18, height: 18).cornerRadius(100)
                    Spacer().frame(width: 5)
                    Text(id)
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Spacer()
                    
                    Spacer().frame(width:1)
                }
                .padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 0))
                .background(Color.white)
                .cornerRadius(100, corners: [.bottomLeft, .topLeft])
                .cornerRadius(100, corners: [.bottomRight, .topRight])
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 5))
            })
            
                
        }
        return view
    }
    
    private func generateTags(_ limitWidth:CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(bull.ary_tag, id: \.self) { tag in
                item(for: tag)
                .padding([.horizontal, .vertical], 2)
                .alignmentGuide(.leading, computeValue: { d in
                    if abs(width - d.width) > limitWidth {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if tag == bull.ary_tag.last {
                        width = 0
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = height
                    if tag == bull.ary_tag.last {
                        height = 0
                    }
                    return result
                })
            }
        }
    }
    func item(for text: String) -> some View {
        Text(text)
            .padding(2)
            .cornerRadius(10)
            .foregroundColor(.gray)
            .font(.system(size: 8, weight: .semibold, design: .default))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
}

struct VwBullCall_Previews: PreviewProvider {
    static var pre_infoCall = [
        "id":"predt_call1",
        "chara":"call",
        "hight":100,
        "ary_tag":["lol","apex","雑談"],
        "time":"2022021304203111",
        "call":[
            "uid":"preid001",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
            "name":"Ak",
            "sex": 1,
            "id_sky" : "hiro.346fdfhkfhjcudkgkfycfjcfjfkfyjfyjffcjhvj",
            "id_dis" : "fdfa.dfa",
            "text":"アンレート@4か空いてるとこ入れてください"
        ]
    ] as [String : Any]
    
    static var bull = BullCall(VwBullCall_Previews.pre_infoCall,time: Date())
    
    static var previews: some View {
        GeometryReader{ gmty in
            HStack{
                Spacer().frame(width:(gmty.size.width / 100) * 1)
                VStack(alignment:.leading
                ){
                    VwBullCall(VwBullCall_Previews.bull)
                    VwBullTag(VwBullCall_Previews.bull.ary_tag,make: false, width: gmty.size.width)
                }
                Spacer().frame(width:gmty.size.width / 2)
            }
        }.environmentObject(Spr())
            .environmentObject(EvBull())
    }
}
