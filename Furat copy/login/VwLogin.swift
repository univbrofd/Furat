import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Firebase

struct VwLogin:View{
    @EnvironmentObject var spr:Spr
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var signInWithAppleObject = SignInWithAppleObject()
    var body: some View{
        ZStack{
            
            Button(action: {
                print("push login button")
                if pTst["myself"]! {
                    spr.fnSignupDemo()
                }else{
                    signInWithAppleObject.signInWithApple()
                }
                
            }, label: {
                SignInWithAppleButton()
                    .frame(height: 50)
                    .cornerRadius(16)
            })
            .padding()
        }
    }
}

struct SignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.addTarget(context.coordinator,
                                 action: #selector(Coordinator.didTapButton),
                                 for: .touchUpInside)
        return button
    }
    
    func updateUIView(_: ASAuthorizationAppleIDButton, context _: Context) {}
    
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
    }
   
    // ボタンコンポーネントをタップされたときの処理
    @objc func didTapButton() {
        print("dudTaoButtion")
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
    }
    
    private func randomNonceString(length: Int = 32) -> String {
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
                    return random
                }

                randoms.forEach { random in
                    if remainingLength == 0 {
                        return
                    }

                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }

            return result
        }

        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()

            return hashString
        }
}

extension Coordinator: ASAuthorizationControllerDelegate {
    // 認証処理が完了した時のコールバック
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("authhorizationcontrolloer")
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            let error = NSError(domain: "jp.huiping192.signInWithApple", code: -1000, userInfo: nil)
            print(error)
            return
        }
        if let user = credential.user.data(using:.utf8) {
            print("save user")
            KeychainHelper.standard.save(user, service: "credential_user")
        }
        if let name = credential.fullName?.givenName?.data(using:.utf8){
            print("save name")
            KeychainHelper.standard.save(name, service: "credential_name")
        }
        if let email = credential.email?.data(using:.utf8){
            print("save email")
            KeychainHelper.standard.save(email, service: "credential_email")
        }
        
        //print("#apple \(String(data: appleIDCredential.authorizationCode!, encoding: .utf8))")
        guard let nonce = currentNonce else {
            print("Invalid state: A login callback was received, but no login request was sent.")
            return
        }

        guard let appleIDToken = credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data")
            return
        }

        let m_credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        Auth.auth().signIn(with: m_credential) { result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        print("認証成功", credential)
        
    }
    
    // 認証処理が失敗したときのコールバック
    // NOTE: 認証画面でキャンセルボタンを押下されたときにも呼ばれる
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
            print("認証エラー", error)
    }
}

extension Coordinator: ASAuthorizationControllerPresentationContextProviding {
    // 認証プロセス(認証ダイアログ)を表示するためのUIWindowを返すためのコールバック
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
}
