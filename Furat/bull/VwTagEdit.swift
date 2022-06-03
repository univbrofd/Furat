//
//  VwTagEdit.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/04.
//

import SwiftUI

struct VwTagEdit: View {
    @Environment(\.presentationMode) var presentation
    @Binding var ary_tag : [String]
    @State var inp_tag = ""
    let color_bg = LinearGradient(gradient: Gradient(colors: [
        Color(red: 0.7, green: 0.9, blue: 0.5),
        Color(red: 0.7, green: 0.9, blue: 0.7)
    ]), startPoint: .top, endPoint: .bottom)
    
    init(ary_tag:Binding<[String]>){
        self._ary_tag = ary_tag
    }
    
    var body: some View {
        GeometryReader{gmty in
            VStack{
                VStack{
                    Spacer().frame(height:5)
                    ScrollView{
                        generateTags(gmty.size.width,typ:0)
                    }.frame(height: gmty.size.height * 0.45 )
                    Text("タグ候補")
                        .font(.system(size: 20,weight: .heavy))
                        .foregroundColor(Color.white)
                    ScrollView{
                        generateTags(gmty.size.width,typ:1)
                    }
                    HStack{
                        TextField("タグ",text:$inp_tag,onCommit: {
                            if !ary_tag.contains(where: {$0 == inp_tag}){
                                self.ary_tag.append(inp_tag)
                                inp_tag = ""
                            }
                        })
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius:2, x: 0, y: 0)
                    }.padding(20)
                    .frame(height: gmty.size.height * 0.1 )
                }.background(color_bg)
                .cornerRadius(20)
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Text("完了")
                        .foregroundColor(.green)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .padding(10)
                })
            }
        }.padding(10)
    }
    private func generateTags(_ limitWidth:CGFloat,typ:Int) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var ary_tag:[String]
        if typ == 0 {ary_tag = self.ary_tag}
        else{ary_tag = self.getTagCandi()}
        
        return ZStack(alignment: .topLeading) {
            ForEach(ary_tag, id: \.self) { tag in
                item(for: tag,type: typ)
                .padding([.horizontal, .vertical], 4)
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
    func item(for text: String,type:Int) -> some View {
        Button(action: {
            if type == 1, !ary_tag.contains(where: {$0 == text}){
                ary_tag.append(text)
            }else{
                if let idx = ary_tag.firstIndex(where: {$0 == text}){
                    ary_tag.remove(at: idx)
                }
            }
        }, label:{
            if type == 0{
                Text(text)
                    .padding(5)
                    .padding([.horizontal],8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold, design: .default))
            }else{
                if ary_tag.contains(where: {$0 == text}) {
                    Text(text)
                        .padding(5)
                        .padding([.horizontal],8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .bold, design: .default))
                }else{
                    Text(text)
                        .padding(5)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(.white)
                        )
                }
            }
        })
    }
    
    func getTagCandi() -> [String] {
        return ["ゲーム","lol","apex","雑談","野球","ボルタリング","漫画","なると",
        "呪術廻戦","ナルト","サッカー","オセロ","アモンがす","通話","beats","iphone",
        "tv","youtube","netfrix","table","travel"]
    }
}

struct VwTagEdit_Previews: PreviewProvider {
    @State static var tags = [
        "スノボー","スキー","バックカントリー","アルマダ","line","majesty","カートン","タバコ","ラッキーストライク","ブロコリー","サラダ","ベジタリアン","シーフード","釣り","海","サンセット","夕日","絶景","卑怯","登山","クロスカントリー","マラソン","リゾート"
    ]
    
    static var previews: some View {
        VwTagEdit(ary_tag: VwTagEdit_Previews.$tags)
    }
}
