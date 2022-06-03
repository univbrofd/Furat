//
//  Super.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import FirebaseAuth

class Spr:ObservableObject{
    @Published var fuser : User?
    static var uid = "none"
    static var token = ""
    static var login = false
    let udef :UserDefaults
    @Published var ready = false
    @Published var myself : Person?
    @Published var error : Error = .none
    @Published var loding = false
    static var dic_person = [String:Person]()
    static let imageCache = NSCache<AnyObject, AnyObject>()
    static var sex = 0
    
    init() {
        self.udef = UserDefaults.standard
        self.getMyself()
    }
    
    func start(){
        print("start")
        getFuser()
        guard error != .fuser else{return}
        getMyself()
        print("start end")
    }
    
    func getFuser(){
        print("getFuser")
        if let fuser = Auth.auth().currentUser {
            self.fuser = fuser
            Spr.uid = fuser.uid
            
            let m_token = UserDefaults.standard.string(forKey: "token")
            if Spr.token != m_token {
                UserDefaults.standard.set(Spr.token, forKey: "token")
                rtdb.child("tokne/\(Spr.uid)").setValue(Spr.token)
            }
            print(Spr.uid)
        }else{
            print("fail get fuser")
        }
        print("getFuser end")
    }
    
    func getMyself(){
        print("getMyself")
        if let m_myself = self.udef.object(forKey: "myself") as? Person{
            print("get myself from defo")
            self.myself = m_myself
        }else{
            if let n_myself = Qey.getMyself(Spr.uid){
                self.myself = n_myself
            }
        }
        if let sex = self.udef.object(forKey: "sex") as? Int{
            Spr.sex = sex
        }
        
        print("getMyself end2")
        return
    }
    
    func setMyself(){
        print("setMyself")
        udef.set(myself,forKey:"myself")
        print("setMyself end")
    }
    
    func fnSignupDemo(){
        print("fnSignupDemo")
        Auth.auth().signIn(withEmail: "tyokou927@gmail.com", password: "tyoko927"){ [weak self] authResult, error in
            guard self != nil else {
                print("fnSignupDemo end1")
                return
            }
            print("sucsess login demo user")
            Spr.login = true
            self?.getFuser()
        }
        print("fnSignupDemo end2")
    }
    
    func upMyself(){
        print("upMyself")
        //let info = myself.getInfo()
        //qey.upMyself(info)
        print("upMyself end")
    }
    
}

