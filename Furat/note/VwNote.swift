//
//  VwNote.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/16.
//

import SwiftUI

struct VwNote: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var bull :BullNote
    @State var ary_para :[NotePara] = []
    @State var activ_edit = false
    let make:Bool
    let font_title :Font = .system(size: 30,weight: .bold)
    @State var activ_alert = false
    @State var text_alert = ""
    @State var color_border = Color.clear
    @State var color_headline = Color.black
    
    init(_ bull:BullNote,make:Bool){
        UITextView.appearance().backgroundColor = .clear
        self.bull = bull
        self.make = make
    }
    var body: some View {
        ZStack(alignment:.topTrailing){
            ScrollView{
                VStack{
                    VwNoteTitle($bull.title,font: font_title,activ_edit: $activ_edit,color1: $bull.color1,color2: $bull.color2)
                        .multilineTextAlignment(.center)
                    vwPara()
                    if activ_edit{
                        vwAddPara()
                    }
                }
            }
            if make{
                VStack{
                    Spacer()
                    HStack{
                        if activ_edit {
                            vwBtnUploadOff()
                            vwBtnSave()
                        }
                        else{
                            vwBtnUpload()
                            vwBtnEdit()
                        }
                    }
                    .padding([.horizontal],10)
                }
            }
        }.onAppear(){
            ary_para = bull.ary_para.map{NotePara(headline:$0["headline"] ?? "" ,text: $0["text"] ?? "")}
        }.alert(isPresented: $activ_alert){
            Alert(title: Text(text_alert))
        }
    }
    
    let col_bg = LinearGradient(gradient: Gradient(colors: [
        Color(red: 1, green: 0.4, blue: 0.6),
        Color(red: 1, green: 0.7, blue: 0.65)
    ]), startPoint: .leading, endPoint: .trailing)
    
    @ViewBuilder func vwBtnUpload() -> some View{
        Button(action: {
            bull.ary_para = ary_para.map{
                ["headline":$0.headline,"text":$0.text]
            }
            guard
                bull.title.count > 0,
                let para = bull.ary_para.first,
                let headline = para["headline"],
                headline.count > 0 else{
                onAlert("入力が不十分です")
                return
            }
            bull.upload()
            presentation.wrappedValue.dismiss()
        }){
            Text("アップロード")
                .padding([.vertical],10)
                .frame(maxWidth:.infinity)
                .background(col_bg)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.system(size: 20,weight: .semibold))
                .shadow(color: .red, radius: 2, x: 0, y: 0)
        }
    }
    @ViewBuilder func vwBtnUploadOff() -> some View {
        Text("アップロード")
            .padding([.vertical],10)
            .frame(maxWidth:.infinity)
            .background(Color.white)
            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
            .cornerRadius(10)
            .font(.system(size: 20,weight: .semibold))
            .shadow(color: .gray, radius: 2, x: 0, y: 0)
    }
    
    @ViewBuilder func vwPara() -> some View {
        VStack{
            ForEach(ary_para,id: \.uuid){para in
                ZStack(alignment:.topTrailing){
                    VwNotePara(notePara:para, activ_edit: $activ_edit,ary_para: $ary_para,color_headline:$color_headline)
                        .padding([.horizontal],10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(style:StrokeStyle(dash:[10,10,10]))
                                .foregroundColor(color_border)
                            )
                        .padding([.horizontal],10)
                        .padding([.top],10)
                        .onChange(of: activ_edit){bool in
                            if bool{
                                color_border = Color.gray
                            }else{
                                color_border = Color.clear
                            }
                        }
                    if activ_edit{
                        Button(action: {
                            removePara(id: para.uuid)
                        }){
                            Image(systemName: "minus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(100)
                        }
                    }
                }
                
            }
        }.padding([.horizontal],5)
    }
    
    @ViewBuilder func vwAddPara() -> some View{
        Button(action:{
            addPara()
        }){
            HStack{
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
                //Text("追加")
            }
        }
        .padding([.vertical],30)
        .padding([.horizontal],40)
        .frame(maxWidth:.infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(style:StrokeStyle(dash:[10,10,10]))
                .foregroundColor(.blue)
            )
        .padding(15)
    }
    
    @ViewBuilder func vwBtnEdit() -> some View{
        Button(action:{
            color_border = Color.gray
            color_headline = Color.clear
            activ_edit = true
        }){
            Text("編集")
                .padding([.horizontal],20)
                .padding([.vertical],10)
                .font(.system(size: 20,weight: .semibold))
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
        }
    }
    
    @ViewBuilder func vwBtnSave() -> some View{
        Button(action:{
            color_border = Color.clear
            color_headline = Color.black
            activ_edit = false
        }){
            Text("保存")
                .font(.system(size: 20,weight: .semibold))
                .padding([.horizontal],20)
                .padding([.vertical],10)
                .background(col_bg)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    func onAlert(_ text:String){
        text_alert = text
        activ_alert = true
    }
    
    func addPara(){
        ary_para.append(NotePara(headline: "", text: ""))
    }
    func removePara(id:UUID){
        if let idx = ary_para.firstIndex(where: {$0.uuid == id}){
            ary_para.remove(at: idx)
        }
    }
    func copySaveToEdit(){
        for idx in 0..<bull.ary_para.count{
            let para = bull.ary_para[idx]
            if let headline = para["headline"]{
                ary_para[idx].headline = headline
            }
            if let text = para["text"]{
                ary_para[idx].text = text
            }
        }
    }
    func copyEditToSave(){
        for idx in 0..<ary_para.count{
            let para = ary_para[idx]
            bull.ary_para[idx]["headline"] = para.headline
            bull.ary_para[idx]["text"] = para.text
        }
    }
}


class NotePara{
    var headline : String
    var text : String
    var uuid = UUID()
    init(headline:String,text:String){
        self.headline = headline
        self.text = text
    }
}

struct VwNotePara: View{
    let id:UUID
    let NotePara :NotePara
    @State var headline = ""
    @State var text = ""
    @Binding var activ_edit:Bool
    @Binding var ary_para:[NotePara]
    @Binding var color_headline :Color
    @State var height_headline : CGFloat = 20
    @State var height_text : CGFloat = 20
    init(notePara:NotePara,activ_edit:Binding<Bool>,ary_para:Binding<[NotePara]>,color_headline:Binding<Color>){
        self._activ_edit = activ_edit
        self._ary_para = ary_para
        self._color_headline = color_headline
        self.NotePara = notePara
        self.id = notePara.uuid
    }
    
    var body : some View{
        VStack(alignment:.leading){
            Spacer()
                .frame(height:0)
                .frame(maxWidth:.infinity)
            ZStack(alignment:.leading){
                if headline == ""{
                    Text("テキスト")
                        .padding([.top],8)
                        .padding([.horizontal],5)
                        .font(.system(size: 25,weight: .heavy))
                        .foregroundColor(.gray)
                        .opacity(0.7)
                }
                Text(headline)
                    .padding([.top],8)
                    .padding([.horizontal],5)
                    .font(.system(size: 25,weight: .heavy))
                    .foregroundColor(color_headline)
                    .background(GeometryReader {
                        Color.clear.preference(key: VwNoteHeadlineKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                if activ_edit {
                    TextEditor(text: $headline)
                        .padding([.top],0)
                        .padding([.horizontal],0)
                        .font(.system(size: 25,weight: .heavy))
                        .frame(height: max(40,height_headline))
                }
            }
            ZStack(alignment:.leading){
                if text == ""{
                    Text("テキスト")
                        .padding([.top],0)
                        .padding([.horizontal],5)
                        .font(.system(size: 18,weight: .medium))
                        .foregroundColor(.gray)
                        .opacity(0.7)
                }
                Text(text)
                    .padding([.top],0)
                    .padding([.horizontal],5)
                    .font(.system(size: 18,weight: .medium))
                    .foregroundColor(color_headline)
                    .background(GeometryReader {
                        Color.clear.preference(key: VwNoteTextKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                if activ_edit {
                    TextEditor(text: $text)
                        .padding([.top],1)
                        .padding([.horizontal],0)
                        .font(.system(size: 18,weight: .medium))
                        .frame(height: max(40,height_text))
                }
            }
        }.padding([.vertical],14)
        .onPreferenceChange(VwNoteHeadlineKey.self) { height_headline = $0 }
        .onPreferenceChange(VwNoteTextKey.self) { height_text = $0 }
        .onChange(of: activ_edit){bool in
            if let idx = ary_para.firstIndex(where: {$0.uuid == id}){
                ary_para[idx].headline = self.headline
                ary_para[idx].text = self.text
            }
        }
        .onAppear(){
            headline = NotePara.headline
            text = NotePara.text
        }
        
    }
}

struct VwNoteTitle: View {
    @Binding var string: String
    @Binding var activ_edit : Bool
    @Binding var color_title1 :Color
    @Binding var color_title2 :Color
    @State var textEditorHeight : CGFloat = 20
    @State var color = Color.white
    let font : Font
    init(_ text:Binding<String>,font:Font,activ_edit:Binding<Bool>,color1:Binding<Color>,color2:Binding<Color>){
        self._string = text
        self._activ_edit = activ_edit
        self._color_title1 = color1
        self._color_title2 = color2
        self.font = font
    }
    
    var body: some View {
        ZStack {
            if string == ""{
                Text("タイトル")
                    .padding([.vertical],15)
                    .padding([.horizontal],16)
                    .font(font)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            Text(string)
                .padding([.vertical],15)
                .padding([.horizontal],16)
                .font(font)
                .foregroundColor(color)
                .background(GeometryReader {
                    Color.clear.preference(key: VwNoteTitleKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            if activ_edit {
                TextEditor(text: $string)
                    .foregroundColor(.white)
                    .padding([.vertical],8)
                    .padding([.horizontal],12)
                    .font(font)
                    .frame(height: max(40,textEditorHeight))
                VStack{
                    HStack{
                        SquareColorPickerView(colorValue: $color_title1)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        SquareColorPickerView(colorValue: $color_title2)
                    }
                }
            }
                
        }
        .padding(20)
        .frame(maxWidth:.infinity)
        .background(LinearGradient(colors: [color_title1,color_title2], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onPreferenceChange(VwNoteTitleKey.self) { textEditorHeight = $0 }
        .onChange(of: activ_edit){bool in
            if bool{
                color = Color.clear
            }else{
                color = Color.white
            }
        }
    }
}

struct VwNoteTitleKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct VwNoteTextKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct VwNoteHeadlineKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}


struct VwNote_Previews: PreviewProvider {
    static var pre_infoNote = [
        "id":"predt_note1",
        "chara":"note",
        "time":"2022032714452311",
        "ary_tag":["lol","apex","雑談"],
        "note":[
            "uid":"preid015",
            "name":"ペットボルト",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
            "title":"besooooa",
            "color1":"#FBFF6D",
            "color2":"#0E01B4",
            "ary_para":[
                ["headline":"headline1aaaaaaaaaaaaaaaaaaaaaaaaaaaa","text":"text1"],
                ["headline":"headline2","text":"texr2"],
                ["headline":"headline3","text":"text3"]
            ],
            "comment":[
                [
                    "name":"samueru",
                    "uid":"note_com1",
                    "text":"夢がある",
                    "time":"2022032720052311"
                ],[
                    "name":"コップ",
                    "uid":"note_com2",
                    "text":"師匠がいて、師匠を途中で力を抜かす",
                    "time":"2022032802052311"
                ],[
                    "name":"lolwwwW",
                    "uid":"note_com3",
                    "text":"唯一無二の秘めたる力を持っていいて途中で覚醒する",
                    "time":"2022032803452311"
                ]
            ]
        ]
    ] as [String : Any]
    static var bull = BullNote(VwNote_Previews.pre_infoNote,time: Date())
    
    static var previews: some View {
        VwNote(bull,make: true)
    }
}
