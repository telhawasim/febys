//
//  VerificationCodeViewController.swift
//  febys
//
//  Created by Waseem Nasir on 27/06/2021.
//

import UIKit

class VerificationCodeViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var codeTextField: FebysTextField!
    @IBOutlet var codeLabels: [FebysLabel]!
    //MARK: PROPERTIES
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCodeTextField()
        codeTextField.becomeFirstResponder()
    }
    
    //MARK: IBActions
    
    
    //MARK: API CALLS
    func verify(code: String) {
        let bodyParams = [ParameterKeys.otp: code]
        
        Loader.show()
        UserService.shared.verifyOTP(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(_):
                self.dismiss(animated: true) {
                    self.goToHome()
                }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: NAVIGATION
    func goToHome() {
        let vc = UIStoryboard.getVC(from: .Main, HomeViewController.className)
        AppDelegate.shared.window?.rootViewController = vc
    }
}

//MARK: OneTimeCode Handling
extension VerificationCodeViewController{
    
    func setupCodeTextField() {
        codeTextField.didChangeText = {[weak self] text in
            guard  let self = self, text.count <= self.codeLabels.count else {
                self?.codeTextField.text = String(text.dropLast(1))
                return}
            
            for i in 0..<self.codeLabels.count{
                let currentLabel = self.codeLabels[i]
                
                if i < text.count{
                    let index = text.index(text.startIndex, offsetBy: i)
                    currentLabel.text = String(text[index])
                }else{
                    currentLabel.text?.removeAll()
                }
            }
            
            if text.count == self.codeLabels.count{
                self.verify(code: text)
            }
        }
    }
}
