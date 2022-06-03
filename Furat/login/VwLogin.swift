import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Firebase

enum EmLoginType{
    case apple
    case demo
}

struct VwLogin:View{
    @EnvironmentObject var spr:Spr
    @State private var email: String = ""
    @State private var password: String = ""
    @State var on_term = false
    @State var on_priva = false

    @State private var signInWithAppleObject = SignInWithAppleObject()
    var body: some View{
        GeometryReader{ gmty in
            ZStack(alignment:.center){
                Image("img_signin_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: gmty.size.width, height: gmty.size.height)
                Color.white.opacity(0.5)
                
                VStack(alignment:.center){
                    Spacer().frame(height:250)
                    Text("Furat").font(.largeTitle)
                    Spacer()
                    Button(action: {
                        print("push login button")
                        if pTst["myself"]! {
                            runSignin(.demo)
                        }else{
                            runSignin(.apple)
                        }
                    }, label: {
                        //SignInWithAppleButton()
                        VwBtnSignApple()
                    })
                    .padding()
                    Spacer().frame(height:10)
                    /*
                    VStack(alignment: .leading){
                        Text("サインインすることで").font(.caption)
                        HStack{
                            Button(action:{
                                on_priva = true
                            }){Text("プライバシーポリシー").font(.caption)}
                            Text("と").font(.caption)
                            Button(action: {
                                on_term = true
                            }){Text("利用規約").font(.caption)}
                        }
                        Text("に同意したことになります。").font(.caption)
                    }.frame(width:200)
                    */
                    Spacer().frame(height:80)
                }
                VStack{
                    Spacer()
                    VwLoginPriva(on_term: $on_term, on_priva: $on_priva)
                        .frame(height: 0)
                }
            }
        }
    }
    
    func runSignin(_ emLoginTyep:EmLoginType){
        print("runSignin")
        spr.loding = true
        
        switch emLoginTyep {
        case .demo:
            spr.fnSignupDemo()
        case .apple:
            signInWithAppleObject.signInWithApple()
        }
        
        DispatchQueue.main.async {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
                print("timer runSignin")
                if Spr.login{
                    spr.getFuser()
                    timer.invalidate()
                    print("timer runSignin invalidate")
                }
            }
        }
        print("runSignin end")
    }
}

struct VwBtnSignApple:View{
    var body: some View{
        HStack{
            Image(systemName: "applelogo")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                
            Spacer().frame(width: 10)
            Text("Sign in with Apple").font(.headline).foregroundColor(.black)
        }
        .padding(14)
        .background(Color(red: 200, green: 200, blue: 200))
        .cornerRadius(5)
        .frame(width:250,height: 50)
    }
}

struct VwLoginPriva:View{
    @Binding var on_term :Bool
    @Binding var on_priva :Bool
    let cnt_term = [[String:String]]()
    let cnt_priva = [[String:String]]()
    @State var cnt = [[String:String]]()
    
    var body: some View{
        ZStack{
            VStack{
                ForEach(cnt_term,id:\.self){sent in
                    if let title = sent["title"]{
                        Text(title)
                    }
                    if let text = sent["text"]{
                        Text(text)
                    }
                    Spacer().frame(height: 10)
                }
            }.onAppear(){
                if on_term {
                    cnt = cnt_term
                }else{
                    cnt = cnt_priva
                }
            }
        }
    }
    
}

/*
struct SignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        //button.addTarget(context.coordinator,
          //                       action: #selector(Coordinator.didTapButton),
            //                     for: .touchUpInside)
        return button
    }
    
    func updateUIView(_: ASAuthorizationAppleIDButton, context _: Context) {print("updateUIView")}
    
    func makeCoordinator() -> Coordinator {
            // NOTE: Coordinatorを作成する処理
            // 初期値にView自身を渡す
            Coordinator(self)
        }
}


final class Coordinator: NSObject {
    var parent: SignInWithAppleButton
    private var currentNonce: String?
    init(_ parent: SignInWithAppleButton) {
        print("cordinator init")
        self.parent = parent
        super.init()
        print("cordinator init end")
    }
    
    // ボタンコンポーネントをタップされたときの処理
    @objc func didTapButton() {
        print("didTaoButtion")
        // NOTE: リクエストの作成
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // NOTE: 認証情報として、「ユーザ名」と「メールアドレス」を受け取る
        request.requestedScopes = [.fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)

        // NOTE: 認証リクエストの実行
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        print("dudTaoButtion end")
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        print("randomNonceString")
            precondition(length > 0)
            let charset: Array<Character> =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length

            while remainingLength > 0 {
                let randoms: [UInt8] = (0 ..< 16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                    }
                    print("randomNonceString end1")
                    return random
                }

                randoms.forEach { random in
                    if remainingLength == 0 {
                        print("randomNonceString end2")
                        return
                    }

                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }
            print("randomNonceString end3")
            return result
        }

        private func sha256(_ input: String) -> String {
            print("sha256")
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()
            print("sha256 end")
            return hashString
        }

}
*/
