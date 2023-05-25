//
//  ForgotPasswordViewController.swift
//  febys
//
//  Created by Waseem Nasir on 27/06/2021.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: FebysButton!
    
    //MARK: PROPERTIES
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    func validate() -> Bool {
        guard let email = emailTextField.text?.condensingWhitespace() else {
            return false
        }
        // CHECK VALIDATY
        var errorMessage : String?
        if email.isEmpty{
            errorMessage = "\(Constants.Email) \(Constants.IsRequired)"
        }else if !email.isEmailValid(){
            errorMessage = "\(Constants.Email) \(Constants.IsInvalid)"
        }
        
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    //MARK: IBActions
    func setupButtons() {
        forgotPasswordButton.didTap = { [weak self] in
            guard let self = self else {return}
            if self.validate() {
                self.forgotPassword()
            }
        }
    }
    
    //MARK: API CALLS
    func forgotPassword() {
        
        let bodyParams = [ParameterKeys.email: emailTextField.text ?? ""]
        
        Loader.show()
        UserService.shared.forgotPassword(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(_):
                self.showMessage("Check Your Email", "We’ve sent an email to the provided address", hideButton: false, messageImage: .email) {
                    self.backButtonTapped(self)
                }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}
