//
//  Smpl.swift
//  Furat
//
//  Created by 浅香紘 on R 4/03/05.
//

import Foundation

func getPreData(_ ary_key:[String]) -> [[String:String]]{
    print("getPreData")
    var r_ary_data = [[String:String]]()
    for info in predt_user{
        var r_info = [String:String]()
        for key in ary_key {
            r_info[key] = info[key]
        }
        r_ary_data.append(r_info)
    }
    print("getPreData end")
    return r_ary_data
}

func getPreData2(_ ary_key:[String]) -> [[String]]{
 print("getPreData2")
    var r_ary_data = [[String]]()
    for info in [[String:String]](){
        var r_info = [String]()
        for key in ary_key {
            r_info.append(info[key]!)
        }
        let id = UUID()
        r_info[0] = id.uuidString
        r_ary_data.append(r_info)
    }
    print("getPreData2 end")
    return r_ary_data
}

/*
func getPreDatas(){
    print("getPreDatas")
    predt_lover =  getPreData(["id","url_icon","url_img1","age","pref","profile"])
    //pre_data_msg = getPreData2(["id","initial","url_icon","url_icon","msg","last_msg"])
    print("getPreDatas end")
}
*/
func getMyselfPre() -> Person?{
    guard let id = predt_myself["id"] else{return nil}
    return getPerson(id,info:predt_myself)
}

let res = Bundle.main.resourcePath!

let predt_myself = [
    "id" : "8ocQcgtoAcelowCrkh7XJ4WxIip2",
    "name": "kou",
    "url_icon" : res + "/" + "pre_myself_icon",
    "url_img1" : res + "/" + "pre_myself_img1",
    "img2" : "",
    "img3" : "",
    "barth" : "19960927",
    "profile" : "",
    "pref":"千葉"
]

let predt_user = [
    ["id":"preid001","initial":"Ak","url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141168_640.jpg","url_img1":"gs://furat-97153.appspot.com/test/user_img1/abstract-6047465_640.jpg","age":"23","pref":"東京","profile":"",
     "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"]
]

func getBullPre() -> [Bull]{
    var ary_bull = [Bull]()
    for love in predt_love{
        if let str_time = love["time"] as? String,
           let time = str_time.date("yyyyMMddHHmmssSS"){
            let bull = Bull(love,time: time)
            ary_bull.append(bull)
        }
    }
    print("getLover end1")
    return ary_bull
}

func dupData(data:[String:Any],num:Int) -> [[String:Any]]{
    var ary_data = [[String:Any]]()
    for i in 0..<num{
        guard let m_id = data["id"] else{continue}
        let id = "\(m_id)-\(i)"
        let time:Date
        if let m_time = data["time"] as? String,let n_time = m_time.date("yyyyMMddhhmmssSS"){
            time = n_time.added(.hour, num: -1) ?? Date()
        }else{
            time = Date()
        }
        var new_data = data
        new_data["id"] = id
        new_data["time"] = time
        ary_data.append(new_data)
    }
    return ary_data
}

let predt_love = [
    [
        "id" : "love1",
        "chara":"love",
        "time":"2022020913443147",
        "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141168_640.jpg",
        "url_img1":"gs://furat-97153.appspot.com/test/user_img1/abstract-6047465_640.jpg",
        "love":[
            "uid":"preid001",
            "name":"Ak",
            "barth":"19970315",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。",
            "img_ratioH":1.5
        ]
    ]/*,[
        "id" : "love2",
        "chara":"love",
        "time":"2022020913443147",
        "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
        "url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
        "love":[
            "uid":"preid002",
            "name":"る",
            "barth":"19870715",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。"
        ]
    ],[
        "id" : "love3",
        "chara":"love",
        "time":"2022020913443147",
        "url_icon":"gs://furat-97153.appspot.com/test/user_icon/ad-141170_640.jpg",
        "url_img1":"gs://furat-97153.appspot.com/test/user_img1/beach-6514331_640.jpg",
        "love":[
            "uid":"preid003",
            "name":"cオフ",
            "barth":"19870715",
            "sex" : 1,
            "pref":"東京",
            "profile":"よろしくお願いします。"
        ]
    ],[
        "id" : "love4",
        "chara":"love",
        "hight" : 100,
        "time":"2022020612443147",
        "love":[
            "uid":"preid004",
            "name":"kaika",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/animal-6987017_640.jpg",
            "url_img1":"gs://furat-97153.appspot.com/test/user_img1/bengaluru-4707459_640.jpg",
            "barth":"20000715",
            "sex" : 2,
            "pref":"東京",
            "profile":"雑談、寝おち、愚痴、悩み事なんでもok。動物と読書と博物館・水族館が好きです。声質は落ち着いているとよく言われます。"
        ]
    ],[
        "id" : "love5",
        "chara":"love",
        "hight" : 100,
        "time":"2022020612443147",
        "love":[
            "uid":"preid002",
            "name":"na",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/avocado-6094271_640.jpg",
            "url_img1":"gs://furat-97153.appspot.com/test/user_img1/castle-6708761_640.jpg",
            "barth":"19970615",
            "sex" : 2,
            "pref":"東京",
            "profile":"pcです〜キーマウ移行して間もない下手くそランクブロンズです！！楽しくやれれば嬉しい〜　二十代です"
        ]
    ]*/
]

let predt_party = [
    [
        "id": "party1",
        "chara":"party",
        "hight": 100,
        "time":"2022021304203111",
        "party":[
            "name":"同窓会",
            "time":"2022030520360012",
            "num":0,
            "num_m":5,
            "num_f":5,
            "location":"東京 新宿　牛角",
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
    ]
]

let predt_call = [
    [
        "id":"predt_call1",
        "chara":"call",
        "hight":100,
        "time":"2022021304203111",
        "ary_tag":["lol","apex","雑談"],
        "call":[
            "uid":"preid001",
            "name":"Ak",
            "sex": 1,
            "id_sky" : "hiro.346",
            "id_dis" : "fdfa.dfa",
            "text":"アンレート@4か空いてるとこ入れてください"
        ]
    ],
    [
        "id":"predt_call2",
        "chara":"call",
        "hight":100,
        "time":"2022021304203111",
        "ary_tag":["lol","apex","雑談"],
        "call":[
            "uid":"preid001",
            "name":"天国うまれ(なつみ)",
            "sex": 2,
            "id_sky" : "hfajdjfajsdijfa;dsa",
            "id_dis" : "fdsadfsdfsdvdse",
            "text":"PS4のフレンドと2人でカジュアルしてますが誰か来ませんか？　楽しくやりたいのでエンジョイ勢の方お願いします！　今までSwitchでやってましたが今はPS4で練習してます　まだ慣れてないのですがそれでもいいよって人しましょ！　本当に弱いのでエンジョイでできる人！！　27歳/バツイチ子持ち"
        ]
    ],
    [
        "id":"predt_call3",
        "chara":"call",
        "hight":100,
        "time":"2022021304203111",
        "ary_tag":["lol","apex","雑談"],
        "call":[
            "uid":"preid001",
            "name":"ひ",
            "sex": 1,
            "id_sky" : "hiro",
            "id_dis" : "nvknvdasva2e34v4444444",
            "text":"ひま"
        ]
    ]
]

let predt_global = [
    [
        "id":"predt_global1",
        "chara":"global",
        "hight":100,
        "time":"2022022714452311",
        "ary_tag":["lol","apex","雑談"],
        "global":[
            "uid":"preid015",
            "name":"h",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/kiss-6989996_640.jpg",
            "url_img":"gs://furat-97153.appspot.com/test/user_img1/hyacinths-7013456_640.jpg",
            "text":"ここ同じとこ2回繰り返してるので書き直した方がいいですね"
        ]
    ],
    [
        "id":"predt_global2",
        "chara":"global",
        "hight":100,
        "time":"2022021714452311",
        "ary_tag":["lol","apex","雑談"],
        "global":[
            "uid":"preid015",
            "name":"カタカナ",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/kiss-6989996_640.jpg",
            "url_img":"",
            "text":"続いて、 変換処理 を実装していきます。 今回は 文字列 として処理するのは UTC で表現されたものとしています"
        ]
    ],
    [
        "id":"predt_global2",
        "chara":"global",
        "hight":100,
        "time":"2022032714452311",
        "ary_tag":["lol","apex","雑談"],
        "global":[
            "uid":"preid015",
            "name":"ペットボルト",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
            "url_img":"gs://furat-97153.appspot.com/test/user_img1/hyacinths-7013456_640.jpg",
            "text":"Swift では 現在のタイムゾーン"
        ]
    ]
]

let predt_note = [
    [
        "id":"predt_note1",
        "chara":"note",
        "hight":100,
        "time":"2022032714452311",
        "ary_tag":["lol","apex","雑談"],
        "note":[
            "uid":"preid015",
            "name":"ペットボルト",
            "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
            "text":"なぜ部活動の顧問は部員を｢お前｣と呼ぶのでしょうか？礼節がなっていないと思うのですが。 礼節とは、カースト制度で下の者が上の者におとなしく支配されることではなく、立場関係なく表面上はお互いリスペクトすることだと思うのですが、私の認識が間違っていますか？",
            "best":"note_com1",
            "comment":[
                [
                    "name":"samueru",
                    "uid":"note_com1",
                    "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
                    "text":"顧問が礼節を守るべきか 部活においてスクールカーストを持ち出す必要があるのか 学校の方針や部活指導要領よると思いますが、「お前」と言われるのが不愉快だということでしたら、直接そう顧問に言えば良いと思います。 自分で言えないから、社会を味方につけて礼節とかハラスメントとか言うのかもしれませんが、「お前」だけでは無理ですよ。",
                    "time":"2022032720052311"
                ],[
                    "name":"コップ",
                    "uid":"note_com2",
                    "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
                    "text":"昔の体罰とかが許されていた時代、平成の最初の方とかですね。 あの時に既に先生だった様な人は名残と言うか癖でそうなってると思います。 時代は既に変わっていますが、ついて行けてないんです。",
                    "time":"2022032802052311"
                ],[
                    "name":"lolwwwW",
                    "uid":"note_com3",
                    "url_icon":"gs://furat-97153.appspot.com/test/user_icon/robot-3124412_640.jpg",
                    "text":"60代ぐらいの顧問なら別になんとも思わないけど若い顧問だったら『え？』ってなる",
                    "time":"2022032803452311"
                ]
            ]
        ]
    ]
]
