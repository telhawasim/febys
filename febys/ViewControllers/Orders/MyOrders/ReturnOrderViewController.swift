//
//  ReturnOrderViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 11/10/2021.
//

import UIKit
protocol ReturnOrderDelegate {
    func didOrderReturned()
}

class ReturnOrderViewController: BaseViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: IntrinsicTableView!
    @IBOutlet weak var reasonPickerButton: FebysButton!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var returnOrderButton: FebysButton!

    //MARK: Properties
    var delegate: ReturnOrderDelegate?
    var orderId: String?
    var vendor: VendorProducts?
    var returnReasons: [String]?
    var selectedReason: String?

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionButtons()
        configureTableView()
        fetchReturnReasons()
    }
    
    //MARK: IBActions
    func setupActionButtons() {
        reasonPickerButton.didTap = { [weak self] in
            self?.presentPicker(with: self?.returnReasons ?? [], title: "Return Reason")
        }

        returnOrderButton.didTap = { [weak self] in
            if let _ = self?.validateTextFields() {
                self?.returnOrderBy(id: self?.orderId, with: self?.vendor?.products?.first)
            }
        }
    }
    
    //MARK: Helper
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InnerTableViewCell.className)
    }
    
    func validateTextFields() -> Bool {
        guard let comment = commentTextView.text?.trim() else {
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
        
        let selectedIndex = returnReasons?.firstIndex(where:{$0 == (selectedReason ?? "")})
        vc.pickerTitle = title
        vc.selectedRow = selectedIndex ?? 0
        vc.pickerData = data
        vc.isTransclucent = false
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.didSelectRow = { [weak self] row in
            self?.reasonTextField.text = row
            self?.selectedReason = row
        }

        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    //MARK: API Calling
    func fetchReturnReasons() {
        OrderService.shared.fetchReturnReasons { response in
            switch response {
            case .success(let reasons):
                self.returnReasons = reasons.setting?.value?.components(separatedBy:",")
                self.reasonTextField.text = self.returnReasons?.first
                self.selectedReason = self.returnReasons?.first
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func returnOrderBy(id: String?, with product: Products?) {
        let item = [ParameterKeys.sku_id:product?.product?.variants?.first?.skuId ?? "",
                    ParameterKeys.qty:product?.qty ?? 0] as [String : Any]

        let bodyParams = [ParameterKeys.return_items: [item],
                          ParameterKeys.reason: self.selectedReason ?? "",
                          ParameterKeys.comments: self.commentTextView.text ?? "N/A"] as [String:Any]

        OrderService.shared.returnOrderBy(id: id ?? "", body: bodyParams) { response in
            switch response {
            case .success(_):
                self.delegate?.didOrderReturned()
                self.backButtonTapped(self)
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: UITableView
extension ReturnOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vendor?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InnerTableViewCell.className, for: indexPath) as! InnerTableViewCell
        cell.configure(self.vendor, isCancelable: false, isReturnOrder: true, isHeaderEnabled: true, isFooterEnabled: true)
        return cell
    }

}

