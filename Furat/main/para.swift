//
//  para.swift
//  Furat
//
//  Created by 浅香紘 on R 4/03/07.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

let fsdb = Firestore.firestore()
let storage = Storage.storage()
let storageRef = storage.reference()
var rtdb : DatabaseReference!
let pTst = [
    "myself" : false,
    "bull" : false,
    "msger" : false
]
var functions = Functions.functions()
