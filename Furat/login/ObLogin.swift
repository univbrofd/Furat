import AuthenticationServices
import CryptoKit
import FirebaseAuth

public class SignInWithAppleObject: NSObject {
    private var currentNonce: String?

    public func signInWithApple() {
        print("signInWithApple")
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        print("signInWithApple end")
    }

    //  https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
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

extension SignInWithAppleObject: ASAuthorizationControllerDelegate {

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("authorizationController")
        // Sign in With Firebase app
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                print("authorizationController end1")
                print("Invalid state: A login callback was received, but no login request was sent.")
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("authorizationController end2")
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("authorizationController end3")
                print("Unable to serialize token string from data")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    print("authorizationController end4")
                    print(error!.localizedDescription)
                    return
                }
                Spr.login = true
                print("sign in with apple success")
            }
        }
    }
}
