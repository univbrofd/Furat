//
//  VwBullTag.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/03.
//

import SwiftUI

struct VwBullTag: View {
    @EnvironmentObject var evBull :EvBull
    @State var ary_tag = [String]()
    let make : Bool
    let size : CGFloat
    var width : CGFloat
    
    init(_ ary_tag:[String],make:Bool,width:CGFloat){
        self.make = make
        self.ary_tag = ary_tag
        self.width = width
        self.size = CGFloat(Float(width / 40))
    }
    var body: some View {
        VStack(spacing:0){
            generateTags(width)
            if make {
                HStack{
                    Spacer()
                    btn_plusTag()
                }
            }
        }.onAppear(){
            if make {
                self.ary_tag = evBull.ary_tag_edit
            }
        }
        
    }
    private func generateTags(_ limitWidth:CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(ary_tag, id: \.self) { tag in
                item(for: tag)
                .padding([.horizontal, .vertical], 2)
                .alignmentGuide(.leading, computeValue: { d in
                    if abs(width - d.width) > limitWidth {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if tag == ary_tag.last {
                        width = 0
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = height
                    if tag == ary_tag.last {
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
            .font(.system(size: self.size, weight: .semibold, design: .default))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    func btn_plusTag() -> some View{
        NavigationLink(
            destination: VwTagEdit(ary_tag: $ary_tag)
        ){
            Text("タグ追加")
                .padding(2)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.system(size: self.size, weight: .semibold, design: .default))
        }
    }
}

struct VwBullTag_Previews: PreviewProvider {
    static var ary_tag = ["lol","apex","雑談","beats","iphone","ワンピース","貝","食べる","旅行"]
    
    static var previews: some View {
        GeometryReader{ gmty in
            HStack{
                Spacer().frame(width:(gmty.size.width / 100) * 1)
                VwBullTag(ary_tag,make: false,width:gmty.size.width)
                Spacer().frame(width:gmty.size.width / 2)
            }
        }
    }
}
