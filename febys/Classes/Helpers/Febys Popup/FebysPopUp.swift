//
//  FebysPopUp.swift
//  febys
//
//  Created by Waseem Nasir on 01/07/2021.
//

import UIKit

enum FebysPopupType:String {
    case network = "network-error"
    case error = "Error"
    case email = "email"
    case location = "locationPin"
    case delete = "deletePopup"
    case pdf = "pdf"
    case upcomming = "upcomming"
    case success = "success"
    case thankYou = "thankYou"
    case follow = "follow"
}

class FebysPopUp: BasePopUp {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: FebysLabel!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dismissButton: UIButton!
    
    var popupTitle: String?
    var detail: String?
    var hideCrossButton = false
    
    private var popupType = FebysPopupType.error
    private var actions = [ActionViewModel]()
    // MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = popupTitle
        
        if titleLabel.isTruncated() {
            titleLabel.font = titleLabel.font.withSize(Constants.notificationTitleMinimumSize)
        }
        
        dismissButton.isHidden = hideCrossButton
        
        detailLabel.text = detail
        
        errorImage.image = UIImage(named: popupType.rawValue)
        
        var idx = 0
        stackView.removeAllArrangedSubviews()
        actions.forEach { (action) in
            self.addButtonForAction(action, tag: idx)
            idx += 1
        }
    }
    
    class func getPopup(with title: String, text: String, popupType: FebysPopupType = FebysPopupType.error) -> FebysPopUp {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FebysPopUp") as! FebysPopUp
        
        vc.popupTitle = title
        vc.detail = text
        vc.popupType = popupType
        
        return vc
    }
    
    // MARK: - setup UI
    fileprivate func addButtonForAction(_ action: ActionViewModel, tag: Int) {
        let isBlack = action.isBlack ?? true
        let button = FebysButton(frame: CGRect.zero)
        button.titleLabel?.numberOfLines = 0
        button.setTitle(action.title, for: .normal)
        button.tag = tag
        button.titleLabel?.font = UIFont.helvetica(type: .regular, size: 15)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(onAction(_:)), for: .touchUpInside)
        
        if action.type == .default{
            button.backgroundColor = isBlack ? .febysBlack() : .white
            button.setTitleColor(isBlack ? .white : .febysBlack(), for: .normal)
            button.borderColor = isBlack ? .clear : .febysBlack()
            button.borderWidth = isBlack ? 0.0 : 1.0
        }
        
        button.cornerRadius = 6
        stackView.addArrangedSubview(button)
        button.sizeToFit()
        if tag == actions.count-1 {
            let constraint = button.widthAnchor.constraint(equalToConstant: 136)
            button.heightAnchor.constraint(equalToConstant: 38).isActive = true
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
        
    }
    
    func addAction(_ action: ActionViewModel) {
        self.actions.append(action)
    }
    // MARK: - IBActions
    @IBAction private func onAction(_ sender: UIButton) {
        if sender.tag >= actions.count {
            return
        }
        let action = actions[sender.tag]
        
        self.hide {
            action.action?()
        }
    }
}
// MARK: - ViewModel
struct ActionViewModel {
    var isBlack: Bool?
    var title: String?
    var type: UIAlertAction.Style? = .default
    var action: (()->Void)?
}

extension UILabel {
    func isTruncated() -> Bool {
        if let string = self.text {
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude)),
                options: NSStringDrawingOptions.usesDeviceMetrics,
                attributes: [NSAttributedString.Key.font: self.font!],
                context: nil).size
            
            if (size.width > self.bounds.size.width - 10) {
                return true
            }
        }
        
        return false
    }
}
