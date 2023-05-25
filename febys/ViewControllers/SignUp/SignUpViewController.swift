//
//  SignUpViewController.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//

import UIKit
import FlagPhoneNumber

class SignUpViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: FebysButton!
    @IBOutlet weak var passwordEyeButton: FebysButton!
    @IBOutlet weak var confirmPasswordEyeButton: FebysButton!
    
    @IBOutlet weak var googleButton: FebysButton!
    @IBOutlet weak var facebookButton: FebysButton!
    @IBOutlet weak var appleButton: FebysButton!
    
    //MARK: PROPERTIES
    var redirectToHome = false
    var selectedCountryCode: String?
    var isValidPhoneNumber = false
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)


    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        configurePhoneNumber()
        SocialLogins.sharedInstance.delegate = self
    }
    
    
    //MARK: Country Code Picker
    func configurePhoneNumber() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.hasPhoneNumberExample = false
        phoneNumberTextField.placeholder = " "
        phoneNumberTextField.setBorderColor(width: 2, color: .white)
        phoneNumberTextField.font = .arial(type: .regular, size: 16)
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.flagButtonSize = CGSize(width: 30, height: 30)
        phoneNumberTextField.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)

        listController.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code)
        }
    }
    
    
    //MARK: HELPERS
    func validateTextFields() -> Bool {
        guard let fName = firstNameTextField.text?.condensingWhitespace(),
              let LName = lastNameTextField.text?.condensingWhitespace(),
              let phoneNumber = phoneNumberTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else{
                  return false
              }
        
        //MARK: CHECK VALIDATY
        var errorMessage : String?
        
        if fName.isEmpty{
            errorMessage = "\(Constants.FirstName) \(Constants.IsRequired)"
        }else if LName.isEmpty{
            errorMessage = "\(Constants.LastName) \(Constants.IsRequired)"
        }else if email.isEmpty{
            errorMessage = "\(Constants.Email) \(Constants.IsRequired)"
        }else if !email.isEmailValid(){
            errorMessage = "\(Constants.Email) \(Constants.IsInvalid)"
        }else if phoneNumber.isEmpty{
            errorMessage = "\(Constants.PhoneNumber) \(Constants.IsRequired)"
        }else if !isValidPhoneNumber{
            errorMessage = "\(Constants.PhoneNumber) \(Constants.IsInvalid)"
        }else if password.count < 8{
            errorMessage = "\(Constants.Password) " + Constants.passwordLimit
        }else if password != confirmPassword{
            errorMessage = Constants.PasswordNotMatch
        }
        
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    //MARK: IBActions
    func setupButtons() {
        signUpButton.didTap = { [weak self] in
            guard let self = self else {return}
            if self.validateTextFields() {
                self.signUpUser()
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
        
        confirmPasswordEyeButton.didTap = { [weak self] in
            guard let self = self else {return}
            self.confirmPasswordEyeButton.isSelected = !self.confirmPasswordEyeButton.isSelected
            self.confirmPasswordTextField.isSecureTextEntry = !self.confirmPasswordTextField.isSecureTextEntry
        }
        
        passwordEyeButton.didTap = { [weak self] in
            guard let self = self else {return}
            self.passwordEyeButton.isSelected = !self.passwordEyeButton.isSelected
            self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        }
    }

    
    //MARK: API CALLS
    private func signUpUser(){
        let bodyParams = [ParameterKeys.first_name: firstNameTextField.text ?? "",
                          ParameterKeys.last_name: lastNameTextField.text ?? "",
                          ParameterKeys.country_code: self.selectedCountryCode ?? "US",
                          ParameterKeys.email: emailTextField.text ?? "",
                          ParameterKeys.phone_number:  phoneNumberTextField.getFormattedPhoneNumber(format: .E164) ?? "",
                          ParameterKeys.password: passwordTextField.text ?? ""]
        
        Loader.show()
        UserService.shared.signUp(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let response):
                _ = response.user?.save()
                UserManager.shared.fetchUserInfo()
                if self.redirectToHome {
                    RedirectionManager.shared.gotoHome()
                } else {
                    self.dismiss(animated: true)
                }
//                self.showVerificationCodeScreen()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func userSocialSignIn(accessToken: String, type: SocialLoginTypes.RawValue, completion: ((SignUpResponse) -> ())? = nil) {
        
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
    
    func profileUpdate(firstName: String, lastName: String, image: String? = nil, completion: (() -> ())? = nil){
        var bodyParams = [ParameterKeys.first_name : firstName,
                          ParameterKeys.last_name: lastName]
        
        if let url = image {
            bodyParams[ParameterKeys.profile_image] = url
        }
    
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
//                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
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
    
    //MARK: Navigation
    func showVerificationCodeScreen() {
        let vc = UIStoryboard.getVC(from: .Auth, VerificationCodeViewController.className)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: FPNTextFieldDelegate
extension SignUpViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        self.selectedCountryCode = code
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.isValidPhoneNumber = isValid
    }
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        listController.title = "Countries"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))
        
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
}

//MARK: SOCIAL LOGINS
extension SignUpViewController: SocialLoginsDelegate{
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
                if let _ = fbUser.id {
                    self.profileUpdate(firstName: fbUser.firstName ?? "", lastName: fbUser.lastName ?? "", image: fbUser.imgUrl ?? "")
                }
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
