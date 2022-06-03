//
//  FuratApp.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseAuth

//var obUser = ObUser()
let fdb = Firestore.firestore()
let storage = Storage.storage()
let storageRef = storage.reference()
let pTst = [
    "myself" : true,
    "match" : true,
    "msger" : true
]

@main
struct FuratApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    @StateObject var spr = Spr()
    @StateObject var obMatch = ObMatch()
    @StateObject var obMsger = ObMsger()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                VwMain()
                    .edgesIgnoringSafeArea(.all)
                    .environmentObject(spr)
                    .environmentObject(obMatch)
                    .environmentObject(obMsger)
                 
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate,ObservableObject, MessagingDelegate, UNUserNotificationCenterDelegate{
    @Published var extme_url = nil as String?
    var window: UIWindow?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        return true
    }
    
}


struct VwMain:View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMatch:ObMatch
    @EnvironmentObject var obMsger:ObMsger
    
    var body: some View{
        ZStack{
            if spr.fuser != nil {//Auth.auth().currentUser != nil {
                VwMainTab()
            }else{
                VwVist()
            }
            /*
            if spr.error != .none{
                VwError()
            }
             */
        }.onAppear(){
            spr.start()
        }
    }
}

struct VwMainTab:View{
    @EnvironmentObject var spr:Spr
    @State var idx_tab = 0
    let color_on = Color.black
    let color_off = Color.gray
    @State var para_color = [Color.black,Color.black,Color.black]
   
    func cngTab(_ m_idx:Int){
        guard m_idx != idx_tab else{return}
        para_color[idx_tab] = color_off
        para_color[m_idx] = color_on
        idx_tab = m_idx
    }
    
    var body: some View{
        TabView{
            VwMatch()
                .tabItem{
                    VStack{
                        Image(systemName: "heart.fill").foregroundColor(para_color[0])
                        Text("まとめ")
                    }.onTapGesture{cngTab(0)}
                }
                .navigationBarTitle("",displayMode: .inline)
                .navigationBarHidden(true)
            
            VwMsger()
                .tabItem {
                    VStack{
                        Image(systemName: "message.fill").foregroundColor(para_color[1])
                        Text("チャット")
                    }.onTapGesture{cngTab(1)}
                }
                .navigationBarTitle("",displayMode: .inline)
                .navigationBarHidden(true)
    
            VwMypage()
                .tabItem {
                    VStack{
                        Image(systemName: "person.fill").foregroundColor(para_color[2])
                        Text("")
                    }.onTapGesture{cngTab(2)}
                }
                .navigationBarTitle("",displayMode: .inline)
                .navigationBarHidden(true)
            /*
            VwAdres()
                .tabItem {
                    VStack{
                        Image(systemName: "doc.plaintext").foregroundColor(para_color[1])
                        Text("フレンズ")
                    }.onTapGesture{cngTab(1)}
                }.navigationBarTitle("",displayMode: .inline)
                .navigationBarHidden(true)
 */
        }.onAppear(){
            para_color = [color_on,color_off,color_off]
        }
    }
}

struct VwVist :View{
    @State var bol_open = true
    var body:some View{
        ZStack{
            VwMatch()
            
            if bol_open {
                ZStack{
                    Rectangle().frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        .opacity(0.5)
                    VStack{
                        Spacer()
                        Button(action:{
                            bol_open = false
                        }){
                            Text("キャンセル").foregroundColor(.white)
                        }.padding(100)
                    }
                    VwLogin()
                }
            }
        }
    }
}

struct VwError:View {
    @EnvironmentObject var spr:Spr
    
    var body: some View{
        switch spr.error {
        case .uid:
            Text("no uid")
        case .myself:
            Text("no myself")
        case .fuser:
            Text("no fuser")
        default:
            Text("no error")
        }
    }
}
