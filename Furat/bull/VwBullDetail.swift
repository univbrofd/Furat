//
//  VwBullDetail.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/21.
//

import SwiftUI

struct VwBullDetail: View {
    @EnvironmentObject var evMypage : EvMypage
    let bull:Bull
    let person:Person
    let name_my:String = "test"
    @State var comment = ""
    @State var h_chat :CGFloat = 164
    let h_chat_min = 164.0
    let h_chat_max = 600.0
    init(_ bull:Bull){
        self.bull = bull
        self.person = Person(bull)
    }
    var body: some View {
        ZStack{
            ScrollView{
                vwChara()
            }
            VStack{
                Spacer()
                VStack{
                    Rectangle()
                        .fill(Color.gray)
                        .cornerRadius(20)
                        .frame(width:100,height:6)
                        .padding([.top],10)
                        .gesture(
                            DragGesture().onChanged{ value in
                                print(value)
                                let h_new = h_chat + -(value.translation.height)
                                if h_new < h_chat_min{
                                    h_chat = h_chat_min
                                }else if h_new > h_chat_max{
                                    h_chat = h_chat_max
                                }else{
                                    h_chat = h_new
                                }
                            }.onEnded{ value in
                                print("onended ")
                            }
                        )
                    if bull.chara == .love{
                        VwChat(person: getPerson(bull)).frame(minHeight:0,maxHeight: h_chat)
                    }
                }
                .background(Color.white)
                .cornerRadius(40, corners: [.topLeft,.topRight])
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
            }
        }
    }
    
    @ViewBuilder func vwChara() -> some View{
        if let bullLove = self.bull as? BullLove{
            VwLove(bullLove,make: false)
        }else if let bullParty = self.bull as? BullParty{
            VwParty(bullParty,make: false)
        }else if let bullCall = self.bull as? BullCall{
            VwCall(bullCall,make: false)
        }else if let bullGlobal = self.bull as? BullGlobal{
            VwGlobal(bullGlobal,make: false)
        }else if let bullNote = self.bull as? BullNote{
            VwNote(bullNote,make: false)
        }else{
            Spacer().frame(width: 0, height: 0)
        }
    }
    
    @ViewBuilder func vwComment() -> some View{
        HStack{
            TextField("コメント",text: $comment)
                .background(Color.gray)
                .foregroundColor(.black)
                .padding(10)
            Button(action: {
                if name_my != "",
                   bull.token != "",
                   comment.count > 0{
                    let info = [
                        "to" : bull.token,
                        "notification" : ["title":name_my, "body":comment],
                        "data":[
                            "id_chat": bull.id,
                            "id_from" : Spr.uid,
                            "token_from" : Spr.token,
                            "name":name_my,
                            "time":bull.time,
                            "type":"text",
                            "cnt":comment
                        ]
                    ] as [String : Any]
                    Qey.sendPushNotification(info: info){
                        print("done")
                    }
                }
            }){
                Image(systemName: "paperplane.fill")
            }
        }
    }
}

struct VwBullDetail_Previews: PreviewProvider {
    static var pre_infoLove = [
        "id" : "love2",
        "chara":"love",
        "hight" : 100,
        "time":"2022020913443147",
        "url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
        "ary_tag":["ゲーム","スノボー","野球","apex","カフェ","音楽","なると","lol","サマーランド","散歩","絵","アクロバット","コップ作り"],
        "love":[
            "uid":"preid002",
            "name":"る",
            //"url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
            
            "barth":"19870715",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。"
        ]
    ] as [String : Any]
    
    static var bull = BullLove(VwLove_Previews.pre_infoLove,time: Date())
    
    static var previews: some View {
        VwBullDetail(VwBullDetail_Previews.bull)
    }
}

