//
//  SocialLogins.swift
//  Yahuda
//
//  Created by Hira Saleem on 31/05/2021.
//

import Foundation
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

protocol SocialLoginsDelegate {
    func loginError(message: String, isCancel : Bool)
    func facebookLogin(fbUser: FBUserResponse, token: String)
    func gmailLogin(email: String, givenName: String, familyName: String, userid: String, idToken: String)
    func appleLogin(email: String, givenName: String, familyName: String, userid: String, idToken: String)
}

extension SocialLoginsDelegate {
    func gmailLogin(email: String, givenName: String,familyName: String, userid: String, idToken: String){
        // default implementation here
    }
    
    func appleLogin(email: String, givenName: String, userid : String, idToken: String){
        // default implementation here
    }
    
    func facebookLogin(email: String, givenName: String, userid : String){
        // default implementation here
    }
    
}

class SocialLogins: UIViewController, ASAuthorizationControllerDelegate{
    
    static let sharedInstance: SocialLogins = {
        let instance = SocialLogins.init()
        return instance
    }()
    var fbAccessToken  = ""
    var delegate : SocialLoginsDelegate?
    
    // MARK: Apple Login
    @available(iOS 13.0, *)
    func handleAppleIdRequest(_ controller : UIViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email,]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let idToeken = appleIDCredential.identityToken
            let givenName = appleIDCredential.fullName?.givenName ?? ""
            let familyName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email ?? ""
            guard let idTokenString = String(data: idToeken!, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(idToeken.debugDescription)")
                return
            }
            self.delegate?.appleLogin(email: email, givenName: givenName, familyName: familyName, userid: userIdentifier, idToken: idTokenString)
            print("User id is \(userIdentifier) \n Full Name is \(givenName) \(familyName)) \n Email id is \(String(describing: email))" )
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        if let err = error as? ASAuthorizationError {
            switch err.code {
            case .canceled:
                self.delegate?.loginError(message: error.localizedDescription,
                                          isCancel: true)
            default:
                self.delegate?.loginError(message: error.localizedDescription,
                                          isCancel: false)
            }
        }
    }
    
    @available(iOS 13.0, *)
    func checkAppleLoginState(userIdentifier: String) -> Bool  {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        var conditionString  = false
        appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                print("The Apple ID credential is valid.")
                conditionString = true
                
                break
            case .revoked:
                // The Apple ID credential is revoked.
                print(" The Apple ID credential is revoked.")
                conditionString = false
                
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                print("No credential was found, so show the sign-in UI.")
                conditionString =  false
                
            default:
                break
            }
            
        }
        return conditionString
        
        
    }
    
    //MARK: Gmail logins
    func handleGmailLogin(_ controller : UIViewController){
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        let signInConfig = GIDConfiguration.init(clientID: ConfigurationManager.shared.infoForKey(.clientID) ?? "")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: controller){ user, error in
            if let error = error{
                print("\(error.localizedDescription)")
                self.delegate?.loginError(message: error.localizedDescription, isCancel: true)
            }else if let user = user{
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let _ = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                let email = user.profile?.email
                self.delegate?.gmailLogin(email: email ?? "", givenName:  givenName ?? "", familyName: familyName ?? "", userid: userId ?? "", idToken: idToken ?? "")
            }
        }
        
    }
    
    // MARK: FaceBook Login
    func handleFaceBookLogin(_ controller : UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: controller) { result, error in
            if let error = error {
                print("FBSignIn Error: ", error)
                loginManager.logOut()
                self.delegate?.loginError(message: error.localizedDescription,
                                          isCancel: false)
                
            } else if let result = result, result.isCancelled {
                print("FBSignIn Canceled by User")
                loginManager.logOut()
                self.delegate?.loginError(message: "User cancelled login.", isCancel: true)
                
            } else if let tokenString = result?.token?.tokenString {
                self.fbAccessToken = tokenString
                self.returnUserData()
                
            }
        }
    }

    private func returnUserData() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture"], tokenString: fbAccessToken, version: nil, httpMethod: .get)
        
        var fbUser = FBUserResponse()

        graphRequest.start { (connection, result, error) in
            if ((error) != nil) {
                // Process error
                print("\n\n Error: \(String(describing: error))")
                self.delegate?.loginError(message: error?.localizedDescription ?? "", isCancel: false)
            } else {
                let resultDic = result as! NSDictionary
                print("\n\n  fetched user: \(String(describing: result) )")
                
                if (resultDic.value(forKey:"first_name") != nil) {
                    let first = resultDic.value(forKey:"first_name")! as! String
                    fbUser.firstName = first
                }
                
                if (resultDic.value(forKey:"last_name") != nil) {
                    let last = resultDic.value(forKey:"last_name")! as! String
                    fbUser.lastName = last
                }
                
                if (resultDic.value(forKey:"id") != nil) {
                    let id = resultDic.value(forKey:"id")! as! String
                    fbUser.id = id
                }

                if (resultDic.value(forKey:"email") != nil) {
                    let userEmail = resultDic.value(forKey:"email")! as! String
                    fbUser.email = userEmail
                }
                
                if (resultDic.value(forKey:"picture") != nil) {
                    let userPicture = resultDic.value(forKey:"picture") as! NSDictionary
                    let pictureData = userPicture.value(forKey: "data") as! NSDictionary
                    let pictureUrl = pictureData.value(forKey: "url") as! String
                    fbUser.imgUrl = pictureUrl
                }
                
                self.delegate?.facebookLogin(fbUser: fbUser, token: self.fbAccessToken)
            }
        }
    }
    
}

struct FBUserResponse {
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var imgUrl: String?
    
    init() { }
}
