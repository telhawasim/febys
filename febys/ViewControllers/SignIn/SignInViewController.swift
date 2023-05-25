//
//  SignInViewController.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//

import UIKit

class SignInViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var usernameTextField: FebysTextField!
    @IBOutlet weak var passwordTextField: FebysTextField!
    
    @IBOutlet weak var forgotButton: FebysButton!
    @IBOutlet weak var loginButton: FebysButton!
    @IBOutlet weak var googleButton: FebysButton!
    @IBOutlet weak var facebookButton: FebysButton!
    @IBOutlet weak var appleButton: FebysButton!
    @IBOutlet weak var signupButton: FebysButton!
    @IBOutlet weak var eyeButton: FebysButton!
   
    //MARK: PROPERTIES
    var redirectToHome = false
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        SocialLogins.sharedInstance.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate=nil
    }
    
    //MARK: HELPERS
    func validate() -> Bool {
        guard let email = usernameTextField.text?.condensingWhitespace(),
              let password = passwordTextField.text else{
            return false
        }
        // CHECK VALIDATY
        var errorMessage : String?
        
        if email.isEmpty{
            errorMessage = "\(Constants.Email) \(Constants.IsRequired)"
        }else if !email.isEmailValid(){
            errorMessage = "\(Constants.Email) \(Constants.IsInvalid)"
        }else if password.isEmpty {
            errorMessage = "\(Constants.Password) " + Constants.IsRequired
        }
        
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    //MARK: IBActions
    func setupButtons() {
        forgotButton.didTap = { [weak self] in
            self?.goToForgotPassword()
        }
        
        eyeButton.didTap = { [weak self] in
            self?.eyeButton.isSelected = !(self?.eyeButton.isSelected ?? false)
            self?.passwordTextField.isSecureTextEntry = !(self?.passwordTextField.isSecureTextEntry ?? false)
        }
        
        loginButton.didTap = { [weak self] in
            guard let self = self else {return}
            if self.validate() {
                self.userSignIn()
            }
        }
        
        googleButton.didTap = { [weak self] in
            guard let self = self else {return}
            SocialLogins.sharedInstance.handleGmailLogin(self)
        }
        
        facebookButton.didTap = { [weak self] in
            guard let self = self else {return}
            SocialLogins.sharedInstance.handleFaceBookLogin(self)
        }
        
        if #available(iOS 13.0, *) {
            appleButton.isHidden = false
            appleButton.didTap = { [weak self] in
                guard let self = self else {return}
                SocialLogins.sharedInstance.handleAppleIdRequest(self)
            }
        }
        
        signupButton.didTap = { [weak self] in
            self?.goToSignUp()
        }
    }
    
    //MARK: API CALLS
    func userSignIn() {
        
        let bodyParams = [ParameterKeys.email: usernameTextField.text ?? "",
                      ParameterKeys.password: passwordTextField.text ?? ""]
        Loader.show()
        UserService.shared.signIn(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let userResponse):
                _ = userResponse.user?.save()
                UserManager.shared.fetchUserInfo()
                if self.redirectToHome { RedirectionManager.shared.gotoHome() }
                else { self.dismiss(animated: true) }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func userSocialSignIn(accessToken: String, type: SocialLoginTypes.RawValue, completion: ((SignUpResponse) -> ())? = nil ) {
        
        let params = [ParameterKeys.access_token: accessToken,
                      ParameterKeys.client: Constants.ios,
                      ParameterKeys.type: type]
        Loader.show()
        UserService.shared.socialSignIn(params: params) { response in
            Loader.dismiss()
            switch response{
            case .success(let userResponse):
                completion?(userResponse)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func profileUpdate(firstName: String, lastName: String, completion: (() -> ())? = nil){
        let bodyParams = [ParameterKeys.first_name : firstName,
                          ParameterKeys.last_name: lastName]
        
        Loader.show()
        UserService.shared.profileUpdate(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let userResponse):
                var userInfo = UserInfo.fetch()
                userInfo?.consumerInfo = userResponse.user
                let isSaved = userInfo?.save()
                if isSaved ?? false {
                    completion?()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func saveUserInfo(_ user: SignUpResponse, completion: (() -> ())? = nil) {
        let isSaved = user.user?.save()
        if isSaved ?? false {
            UserManager.shared.fetchUserInfo()
            completion?()
        }
    }
    
    //MARK: NAVIGATION
    func goToSignUp() {
        let vc = UIStoryboard.getVC(from: .Auth, SignUpViewController.className) as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToForgotPassword() {
        let vc = UIStoryboard.getVC(from: .Auth, ForgotPasswordViewController.className)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: SOCIAL LOGINS
extension SignInViewController: SocialLoginsDelegate{
    func loginError(message: String,isCancel: Bool) {
        Loader.dismiss()
        if isCancel{
            
        }else {
            self.showMessage("", message, onDismiss: nil)
        }
    }
    
    func gmailLogin(email: String, givenName: String,familyName: String, userid: String, idToken: String) {
        self.userSocialSignIn(accessToken: idToken, type: SocialLoginTypes.google.rawValue) { user in
            self.saveUserInfo(user) {
                if self.redirectToHome { RedirectionManager.shared.gotoHome() }
                else { self.dismiss(animated: true) }
            }
        }
    }
    func facebookLogin(fbUser: FBUserResponse, token: String) {
        self.userSocialSignIn(accessToken: token, type: SocialLoginTypes.facebook.rawValue) { user in
            self.saveUserInfo(user) {
                if self.redirectToHome { RedirectionManager.shared.gotoHome() }
                else { self.dismiss(animated: true) }
            }
        }
    }
    
    func appleLogin(email: String, givenName: String, familyName: String, userid: String, idToken: String) {
        self.userSocialSignIn(accessToken: idToken, type: SocialLoginTypes.apple.rawValue) { user in
            self.saveUserInfo(user) {
                if givenName != "" {
                    self.profileUpdate(firstName: givenName, lastName: familyName)
                }
                if self.redirectToHome { RedirectionManager.shared.gotoHome() }
                else { self.dismiss(animated: true) }
            }
        }
    }
    
}
