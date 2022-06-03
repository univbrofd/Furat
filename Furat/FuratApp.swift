//
//  FuratApp.swift
//  Furat
//
//  Created by 浅香紘 on R 4/02/28.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import UserNotifications
import FirebaseMessaging

@main
struct FuratApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject var spr = Spr()
    @StateObject var evBull = EvBull()
    @StateObject var evMypage = EvMypage()
    @StateObject var obMsger = ObMsger()
    
    var body: some Scene {
        WindowGroup {
            VwMain()
                .edgesIgnoringSafeArea(.all)
                .environmentObject(spr)
                .environmentObject(obMsger)
                .environmentObject(evBull)
                .environmentObject(evMypage)
            
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate,ObservableObject, MessagingDelegate{
    @Published var extme_url = nil as String?
    var window: UIWindow?
    
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if rlm_delete {rlmDeleteAll()}
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        Messaging.messaging().delegate = self
        getToken()
        rtdb = Database.database().reference()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)

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
    
    func getToken(){
        print("getToken")
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                Spr.token = token
            }
        }
    }

}


struct VwMain:View{
    @EnvironmentObject var spr:Spr
    @EnvironmentObject var obMsger:ObMsger
    
    var body: some View{
        ZStack{
            if spr.loding {VwLoding()}
            if spr.fuser != nil {
                VwMainTab()
            }else{
                VwLogin()
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
    @State var para_color = [Color.black,Color.black,Color.black,Color.black,Color.black]
   
    func cngTab(_ m_idx:Int){
        guard m_idx != idx_tab else{return}
        para_color[idx_tab] = color_off
        para_color[m_idx] = color_on
        idx_tab = m_idx
        UITabBar.appearance().barTintColor = UIColor.red
    }
    
    var body: some View{
        TabView{
            NavigationView{
                VwBull()
                    .navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
            }
                    .tabItem{
                        VStack{
                            Image(systemName: "square.grid.2x2.fill").foregroundColor(para_color[0])
                                .rotationEffect(Angle(degrees: 90))
                        }.onTapGesture{cngTab(0)}
                    }
                    
            
            NavigationView{
                VwBullMake()
                    .navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
            }
                    .tabItem {
                        VStack{
                            Image(systemName: "plus.app.fill").foregroundColor(para_color[2])
                            Text("")
                        }.onTapGesture {cngTab(2)}
                    }
            
            NavigationView{
                VwMsger()
                    .navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
            }
                    .tabItem {
                        VStack{
                            Image(systemName: "message.fill").foregroundColor(para_color[3])
                        }.onTapGesture{cngTab(3)}
                    }
                    
            
            NavigationView{
                VwMypage()
                    .navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
            }
                    .tabItem {
                        VStack{
                            Image(systemName: "person.fill").foregroundColor(para_color[4])
                            Text("")
                        }.onTapGesture{cngTab(4)}
                    }
                    
            
        }.onAppear(){
            print("VwMainTab onApper")
            para_color = [color_on,color_off,color_off,color_off,color_off]
            print("VwMainTab onApper end")
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

struct VwLoding:View{
    @EnvironmentObject var spr:Spr
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.6)
            ProgressView("")
        }
    }
}

