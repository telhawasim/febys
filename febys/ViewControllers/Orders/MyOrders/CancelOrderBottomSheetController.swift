//
//  CancelOrderBottomSheetController.swift
//  febys
//
//  Created by Faisal Shahzad on 08/10/2021.
//

import UIKit

class CancelOrderBottomSheetController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelReasonTextField: UITextField!
    @IBOutlet weak var cancelCommentTextView: UITextView!
    @IBOutlet weak var reasonPickerButton: FebysButton!
    @IBOutlet weak var confirmButton: FebysButton!
    
    //MARK: Properties
    var delegate: PickerViewDelegate?
    var orderId: String?
    var vendorId: String?
    
    var selectedReason: String?
    var cancelReasons: [String]?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmButton.isEnabled = false
        self.setupActionButtons()
        self.fetchCancelReasons()
    }
    
    //MARK: IBActions
    func setupActionButtons() {
        reasonPickerButton.didTap = { [weak self] in
            guard let self = self else { return }
            if let reasons = self.cancelReasons {
                self.hideMainView(true)
                self.presentPicker(with: reasons, title: "Cancellation Reason")
            }
        }
        
        confirmButton.didTap = { [weak self] in
            guard let self = self else { return }
            if self.validateTextFields() {
                self.cancelOrder()
            }
        }
    }
    
    //MARK: Helper
    func hideMainView(_ isHidden: Bool) {
        if isHidden { self.mainView.isHidden = true }
        else { self.mainView.isHidden = false }
    }
    
    //MARK: HELPERS
    func validateTextFields() -> Bool {
        guard let comment = cancelCommentTextView.text?.trim() else {
            return false
        }
        // CHECK VALIDATY
        var errorMessage : String?
        
        if comment.isEmpty{
            errorMessage = "\(Constants.Comment) \(Constants.IsRequired)"
        }
        
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    
    //MARK: Navigation
    func presentPicker(with data: [String], title: String){
        let vc = UIStoryboard.getVC(from: .Orders, ReasonsPickerViewController.className) as! ReasonsPickerViewController
        
        let selectedIndex = cancelReasons?.firstIndex(where:{$0 == (selectedReason ?? "")})
        vc.pickerTitle = title
        vc.selectedRow = selectedIndex ?? 0
        vc.pickerData = data
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.didSelectRow = { [weak self] row in
            self?.cancelReasonTextField.text = row
            self?.selectedReason = row
        }
        
        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    //MARK: API Calling
    func fetchCancelReasons() {
        OrderService.shared.fetchCancelReasons { response in
            switch response {
            case .success(let reasons):
                self.cancelReasons = reasons.consumerReasons?.value?.components(separatedBy: ",")
                self.cancelReasonTextField.text = self.cancelReasons?[0]
                self.selectedReason = self.cancelReasons?[0]
                self.confirmButton.isEnabled = true
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func cancelOrder() {
        if let comment = cancelCommentTextView.text?.trim(),
           let reason = self.selectedReason?.trim() {
            let bodyParams = [ParameterKeys.reason : reason,
                              ParameterKeys.comments : comment ]
            
            Loader.show()
            OrderService.shared.cancelOrderBy(id: self.orderId ?? "", of: self.vendorId ?? "", body: bodyParams) { response in
                Loader.dismiss()
                switch response {
                case .success(_):
                    self.delegate?.dismissPicker()
                    self.backButtonTapped(self)
                case .failure(let error):
                    self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                }
                
            }
        }
    }
    
}

//MARK: PickerViewDelegate
extension CancelOrderBottomSheetController: PickerViewDelegate {
    func dismissPicker() {
        self.hideMainView(false)
    }
}
