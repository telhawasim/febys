//
//  AddVoucherViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 15/02/2022.
//

import UIKit

protocol AddVoucherDelegate {
    func voucherAddedSuccessfully()
}

class AddVoucherViewController: BaseViewController {

    //MARK: IBOutlets
    @IBOutlet weak var voucherTextField: FebysTextField!
    @IBOutlet weak var addVoucherButton: FebysButton!

    //MARK: Properties
    var delegate: AddVoucherDelegate?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    //MARK: IBActions
    func setupButtons() {
        addVoucherButton.didTap = { [weak self] in
            guard let self = self else {return}
            if self.validate() {
                self.collectVoucher(code: self.voucherTextField.text ?? "")
            }
        }
    }
    
    //MARK: Helpers
    func validate() -> Bool {
        guard let voucherCode = voucherTextField.text else {
            return false
        }
        // CHECK VALIDATY
        var errorMessage : String?
        if voucherCode.isEmpty {
            errorMessage = "\(Constants.VoucherCode) \(Constants.IsRequired)"
        }
        
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    
    //MARK: API Calling
    func collectVoucher(code: String) {
        Loader.show()
        VoucherService.shared.collectVoucher(code: code) { response in
            Loader.dismiss()
            switch response {
            case .success(_):
                self.delegate?.voucherAddedSuccessfully()
                self.backButtonTapped(self)
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
}
