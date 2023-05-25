//
//  ProfileSettingViewController.swift
//  febys
//
//  Created by Nouman Akram on 06/01/2022.
//

import UIKit
import FlagPhoneNumber

class ProfileSettingViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectImageButton: FebysButton!
    @IBOutlet weak var nameLabel: FebysLabel!
    @IBOutlet weak var firstNameTextField: FebysTextField!
    @IBOutlet weak var lastNameTextfield: FebysTextField!
    @IBOutlet weak var emailTextfield: FebysTextField!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var editAndSaveButton: FebysButton!
    @IBOutlet weak var chooseImageButton: FebysButton!
    @IBOutlet weak var deleteUserButton: FebysButton!
    
    //MARK: Variables
    var selectedCountryCode: String?
    var isProfileEditing = false
    var imgURL: String?
    var isValidPhoneNumber = false
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setButtons()
        self.configurePhoneNumber()
        if let user = UserInfo.fetch()?.consumerInfo {  self.setUserData(user) }
        self.setFieldsUserIntraction(isEditable: self.isProfileEditing)
    }
    
    //MARK: HELPERS
    func validateTextFields() -> Bool {
        guard let fName = firstNameTextField.text?.condensingWhitespace(),
              let LName = lastNameTextfield.text?.condensingWhitespace(),
              let phoneNumber = phoneNumberTextField.text,
              let email = emailTextfield.text else {
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
        }
        
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    func userSignOut() {
        if let userId = UserInfo.fetch()?.consumerInfo?.id {
            FirebaseManager.shared.unSubscribeToTopic(userId)
        }
        
        DispatchQueue.main.async {
            CartEntity.clearAllFromCoreData()
            User.remove()
            UserInfo.remove()
            ShippingDetails.remove()
            WishlistManager.shared.clearWishList()
            RedirectionManager.shared.gotoHome()
            ZendeskManager.shared.resetVisitorIdentity()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    //MARK: Enable/Disable Field
    func setFieldsUserIntraction(isEditable: Bool) {
        self.editAndSaveButton.isSelected = isEditable
        self.firstNameTextField.isUserInteractionEnabled = isEditable
        self.lastNameTextfield.isUserInteractionEnabled = isEditable
        self.emailTextfield.isUserInteractionEnabled = false
        self.emailTextfield.tintColor = UIColor.gray
        self.phoneNumberTextField.isUserInteractionEnabled = isEditable
        self.chooseImageButton.isHidden = !isEditable
    }
    
    //MARK: Country Code Picker
    func configurePhoneNumber() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.hasPhoneNumberExample = false
        phoneNumberTextField.placeholder = " "
        phoneNumberTextField.setBorderColor(width: 2, color: .white)
        phoneNumberTextField.font = .arial(type: .regular, size: 16)
        phoneNumberTextField.displayMode = .list
//        phoneNumberTextField.setFlag(countryCode: FPNCountryCode)
        phoneNumberTextField.flagButtonSize = CGSize(width: 30, height: 30)
        phoneNumberTextField.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        
        listController.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code)
        }
    }
    
    //MARK: Configure Data
    func setUserData(_ user: User) {
        let countryCode = FPNCountryCode(rawValue: user.phone_number?.countryCode ?? "")
        self.firstNameTextField.text = user.first_name ?? ""
        self.lastNameTextfield.text = user.last_name ?? ""
        self.emailTextfield.text = user.email ?? ""
        self.phoneNumberTextField.setFlag(countryCode: countryCode ?? .US)
        self.phoneNumberTextField.set(phoneNumber: user.phone_number?.number ?? "")
        self.nameLabel.text = "\(user.first_name ?? "") \(user.last_name ?? "")"
        
        if let imageurl = user.profile_image {
            self.profileImage.setImage(url: imageurl )
        } else {
            self.profileImage.image = UIImage(named: "user.png")
        }
    }
    
    func setButtons(){
        selectImageButton.didTap = { [weak self] in
            guard let self = self else { return }
            ImagePickerController().pickImage(self){ image in
                self.uploadProfileImage(image: image) { imgURL in
                    self.imgURL = imgURL ?? ""
                    if let url = imgURL { self.profileImage.setImage(url: url) }
                    else { self.profileImage.image = UIImage(named: "user.png") }
                }
            }
        }
        
        editAndSaveButton.didTap = { [weak self] in
            guard let self = self else {return}
            if !(self.isProfileEditing) {
                self.isProfileEditing = !(self.isProfileEditing)
                self.setFieldsUserIntraction(isEditable: self.isProfileEditing)
                self.emailTextfield.textColor = UIColor.gray
            } else {
                if self.validateTextFields() { self.profileUpdate() }
            }
        }
        
        deleteUserButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.showMessage(Constants.areYouSure, Constants.youWantToDeleteUser, messageImage: .delete, isQuestioning: true, onSuccess: {
                if let _ = UserInfo.fetch()?.consumerInfo?.id {
                    self.deleteUserAPI()
                }
            }, onDismiss: nil)
            
        }
        
    }
    
    //MARK: API Calling
    func profileUpdate(){
        var bodyParams = [ParameterKeys.first_name : firstNameTextField.text ?? "",
                          ParameterKeys.last_name: lastNameTextfield.text ?? "",
                          ParameterKeys.country_code: self.selectedCountryCode ?? "US",
                          ParameterKeys.email: emailTextfield.text ?? "",
                          ParameterKeys.phone_number: phoneNumberTextField.getFormattedPhoneNumber(format: .E164) ?? ""] as [String : Any]
        
        
        if let url = self.imgURL {
            bodyParams[ParameterKeys.profile_image] = url
        }
        
        Loader.show()
        UserService.shared.profileUpdate(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let userResponse):
                var userInfo = UserInfo.fetch()
                userInfo?.consumerInfo = userResponse.user
                _ = userInfo?.save()
                if let user = userInfo?.consumerInfo { self.setUserData(user) }
                self.isProfileEditing = !(self.isProfileEditing)
                self.setFieldsUserIntraction(isEditable: self.isProfileEditing)
                self.showMessage(Constants.thankYou,
                                 Constants.profileUpdatedSuccessfully,
                                 messageImage: .success, onDismiss: nil)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func uploadProfileImage(image: UIImage, onComplete: @escaping (String?) -> ()){
        UserService.shared.uploadProfileImage(with: image) { response in
            switch response {
            case .success(let url):
                onComplete(url.first)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func deleteUserAPI() {
        Loader.show()
        UserService.shared.deleteUser() { response in
            Loader.dismiss()
            switch response {
            case .success(_):
                self.userSignOut()
            case .failure(let error):
                 self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}


extension ProfileSettingViewController: FPNTextFieldDelegate {
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
