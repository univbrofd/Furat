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
import FirebaseMessaging

class Qey {
    static func getMyself(_ uid:String) -> Person?{
        print("getMyself")
        guard !pTst["myself"]! else{return getMyselfPre()}
            
        if let rlm_person = getRlmPerson(uid) {
            return getPerson(rlm_person)
        }else{
            return nil
        }
    }
    
    static func logoutFb(){
        print("logoutFb")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("logoutFb end1")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
            print("logoutFb end2")
        }
    }
    
    static func fbSetImg(image:Data,ref:String){
        print("fbSetImg")
        let ref = storage.reference().child(ref)
        let uploadTask = ref.putData(image, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
            // Uh-oh, an error occurred!
                print("fbSetImg end1")
                return
            }
          // Met    adata contains file metadata such as size, content-type.
            let size = metadata.size
          // You can also access to download URL after upload.
            print("fdSetImg sucsess")
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
              // Uh-oh, an error occurred!
                    print("fbSetImg end2")
                    return
                }
            }
        }
    }
        
    static func sendMsg(msg:[String:String],uid:String){
        print("Query sendMsg")
        rtdb.child("msg/\(uid)").childByAutoId()
            .setValue(msg)
        rtdb.child("token/\(uid)").observeSingleEvent(of: .value, with: { snapshot in
            if let token = snapshot.value as? String{
                print("snapshot get sucess snapshot:\(token)")
            }
        }){error in
            print(error.localizedDescription)
        }
        print("Query sendMsg end")
    }
    
    static let FCM_serverKey = "AAAAGLcR5NU:APA91bE6AI7EPk1Z8h9NPSbdHuQK6HqE-p-R0RUdlW-KRjlmQ9YFDdrqpBGBVFQ158eCe8HUFC0SrNZBeH05q-sjJSANrgKU-3KJG3fSyGsxsLITfrCOHZGFSO8vBHhulvqmn1oowPZA"
    static private let endpoint = "https://fcm.googleapis.com/fcm/send"
   
    static func sendPushNotification(info:[String:Any], completion: @escaping () -> Void) {
        print("sendPushNotification")
        let serverKey = Qey.FCM_serverKey
        guard let url = URL(string: Qey.endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: info, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            do {
                if let jsonData = data {
                    if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        print("Received data: \(jsonDataDict)")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
        completion()
        print("sendPushNotification end")
    }
    
    static func fdUploadBull(chara:EmBullChara,info:[String:Any]){
        print("fdUploadBull")
        let time = Date()
        let str_time = time.string("yyyyMMddHHmmssSS")
        let time_ym = time.string("yyyyMM")
        let time_d = time.string("dd")
        var info = info
        info["chara"] = chara.rawValue
        info["time"] = str_time
        
        var ref = rtdb.child("bull/\(chara.rawValue)/\(time_ym)/\(time_d)")
        if chara == .love{
            ref = ref.child("/\(Spr.sex)/\(Spr.uid)")
            let path = "bull/\(chara.rawValue)/\(time_ym)/\(time_d)/\(Spr.sex)/\(Spr.uid)"
            UserDefaults.standard.set(path,forKey: "path_love")
        }else{
            ref = ref.childByAutoId()
        }
        ref.setValue(info)
        
        print("fdUploadBull end1")
    }
    
}
