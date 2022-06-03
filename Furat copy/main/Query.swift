//
//  Query.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//
import Foundation
import SwiftUI
import UIKit
import Firebase
import FirebaseAuth

class Query {
    let res :String
    
    let smpl_myself:[String:String]
    
    let pre_data_user = [
        ["id":"preid001","initial":"Ak","icon":"gs://secline-ce269.appspot.com/test/user_icon/ad-141168_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/abstract-6047465_640.jpg","age":"23","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"]
        /*,
        ["id":"preid002","initial":"る","icon":"gs://secline-ce269.appspot.com/test/user_icon/ad-141170_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/beach-6514331_640.jpg","age":"25","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid003","initial":"れ","icon":"gs://secline-ce269.appspot.com/test/user_icon/animal-6987017_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/bengaluru-4707459_640.jpg","age":"41","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid004","initial":"な","icon":"gs://secline-ce269.appspot.com/test/user_icon/avocado-6094271_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/castle-6708761_640.jpg","age":"19","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid005","initial":"ロロ","icon":"gs://secline-ce269.appspot.com/test/user_icon/bird-3342446_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/citta-alta-in-bergamo-4839355_640.jpg","age":"34","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid006","initial":"ab","icon":"gs://secline-ce269.appspot.com/test/user_icon/birds-1998382_640.png","img1":"gs://secline-ce269.appspot.com/test/user_img1/dog-4997022_640.jpg","age":"31","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid007","initial":"lT","icon":"gs://secline-ce269.appspot.com/test/user_icon/birds-2037457_640.png","img1":"gs://secline-ce269.appspot.com/test/user_img1/elephant-1598359_640.png","age":"27","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid008","initial":"la","icon":"gs://secline-ce269.appspot.com/test/user_icon/birds-2037459_640.png","img1":"gs://secline-ce269.appspot.com/test/user_img1/felt-tip-pen-drawing-1005134_640.jpg","age":"21","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid089","initial":"あ","icon":"gs://secline-ce269.appspot.com/test/user_icon/cat-5775895_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/frankenstein-monster-983567_640.png","age":"39","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid010","initial":"げ","icon":"gs://secline-ce269.appspot.com/test/user_icon/dog-3385689_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/frog-6607232_640.jpg","age":"22","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid011","initial":"うり","icon":"gs://secline-ce269.appspot.com/test/user_icon/dog-1728494_640.png","img1":"gs://secline-ce269.appspot.com/test/user_img1/girl-2190108_640.jpg","age":"24","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid012","initial":"lあ","icon":"gs://secline-ce269.appspot.com/test/user_icon/kids-4967808_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/golden-4779685_640.jpg","age":"45","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid013","initial":"fh","icon":"gs://secline-ce269.appspot.com/test/user_icon/tiger-160601_640.png","img1":"gs://secline-ce269.appspot.com/test/user_img1/hike-5796976_640.jpg","age":"20","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid014","initial":"ec","icon":"gs://secline-ce269.appspot.com/test/user_icon/robot-3124412_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/hyacinths-7013456_640.jpg","age":"19","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid015","initial":"h","icon":"gs://secline-ce269.appspot.com/test/user_icon/kiss-6989996_640.jpg","img1":"gs://secline-ce269.appspot.com/test/user_img1/mother-6935336_640.jpg","age":"33","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"],
        ["id":"preid016","initial":"B","icon":"gs://secline-ce269.appspot.com/test/user_icon/person-3160324_640.png","img1":"gs://secline-ce269.appspot.com/test/user_img1/mother-and-child-6601502_640.jpg","age":"30","pref":"東京","profile":"",
         "msg":"テキストメッセージ","time_msg":"2021.10.31.18.15.40.11"]
         */
    ]
    func getPreData(_ ary_key:[String]) -> [[String:String]]{
        var r_ary_data = [[String:String]]()
        for info in pre_data_user{
            var r_info = [String:String]()
            for key in ary_key {
                r_info[key] = info[key]
            }
            r_ary_data.append(r_info)
        }
        
        return r_ary_data
    }
    /*
    func getPreData2(_ ary_key:[String]) -> [[String]]{
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
        return r_ary_data
    }
*/
    var pre_data_lover = [[String:String]]()
    var pre_data_msg = [[String:String]]()
    
    init(){
        self.res = Bundle.main.resourcePath!
        
        self.smpl_myself = [
            "id" : "SNihEIBz41MA4heCxJy8c5HUMxN2",
            "name": "kou",
            "icon" : res + "/" + "pre_myself_icon",
            "img1" : res + "/" + "pre_myself_img1",
            "img2" : "",
            "img3" : "",
            "age" : "25",
            "profile" : ""
        ]
        getPreDatas()
    }
    
    func getPreDatas(){
        pre_data_lover = getPreData(["id","initial","icon","img1","age","pref","profile"])
        //pre_data_msg = getPreData2(["id","initial","icon","icon","msg","last_msg"])
    }
    
    
    func getMyself(_ uid:String) -> Person?{
        if pTst["myself"]! {
            if let id = smpl_myself["id"]{
                return Person(id,m_info: smpl_myself)
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func upMyself(_ info:[String:String]){
        return
    }
    
    func getLover() -> [[String:String]]{
        if pTst["match"]! {
            print("data lover : \(pre_data_lover.count)")
            return pre_data_lover
        }else{
            return [[String:String]]()
        }
    }
    
    func getMsg() -> [[String:String]]{
        if pTst["msger"]! {
            return pre_data_msg
        }else{
            return [[String:String]]()
        }
    }
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    func getImgFb(_ m_url:String) -> UIImage?{
        let semaphore = DispatchSemaphore(value: 0)
        let starsRef = storage.reference(forURL:m_url)
        var uiimg : UIImage?
        starsRef.downloadURL { url, error in
            if let error = error {
                print(m_url)
                print(error)
            } else if let url = url {
                print("success get url")
                print(url)
                
                if let cachedImage = Query.imageCache.object(forKey: url as AnyObject) as? UIImage {
                    uiimg = cachedImage
                    semaphore.signal()
                }else{
                 
                    if let data = try? Data(contentsOf: url){
                        print("succsess get image")
                        if let m_uiimg = UIImage(data: data){
                            uiimg = m_uiimg
                            Query.imageCache.setObject(m_uiimg, forKey: url as AnyObject)
                            semaphore.signal()
                        }
                    }
                }
            }
        }
        semaphore.wait()
        return uiimg
    }
}

