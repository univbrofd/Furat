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

var dic_person = [String:Person]()

class Spr:ObservableObject{
    @Published var fuser : User?
    var uid : String?
    let udef :UserDefaults
    @Published var login = false
    @Published var ready = false
    @Published var myself : Person? = nil
    @Published var error : Error = .none
    
    let qey = Query()
    
    init() {
        self.udef = UserDefaults.standard
    }
    
    func start(){
        getFuser()
        guard error != .fuser else{return}
        getMyself()
    }
    
    func getFuser(){
        if let fuser = Auth.auth().currentUser {
            self.fuser = fuser
            self.uid = fuser.uid
            print(self.uid ?? "no uid")
        }else{
            print("fail get fuser")
        }
    }
    
    func getMyself(){
        if let m_myself = self.udef.object(forKey: "myself") as? Person{
            print("get myself from defo")
            self.myself = m_myself
        }else{
            guard let uid = self.uid else {
                error = .uid
                return
            }
            if let n_myself = qey.getMyself(uid){
                self.myself = n_myself
            }
        }
        return
    }
    
    func setMyself(){
        if let myself = self.myself {
            udef.set(myself,forKey:"myself")
        }
    }
    
    func fnSignupDemo(){
        Auth.auth().signIn(withEmail: "tyokou927@gmail.com", password: "tyoko927"){ [weak self] authResult, error in
            guard self != nil else {return}
            print("sucsess login demo user")
            self?.getFuser()
        }
    }
    
    func fnLogin(){
        login = true
        upMyself()
    }
    
    func upMyself(){
        if let myself = self.myself {
            let info = myself.getInfo()
            qey.upMyself(info)
        }
    }
    
    
}
