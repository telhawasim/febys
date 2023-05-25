//
//  MessageFooter.swift
//  febys
//
//  Created by Faisal Shahzad on 15/11/2021.
//

import UIKit

protocol MessageDelegate {
    func messageDidChange(_ message: String, forVendor id: String)
}

class MessageFooter: UITableViewHeaderFooterView {

    //MARK: IBOutlets
    @IBOutlet weak var messageField: UITextView!
    
    //MARK: Properties
    var delegate: MessageDelegate?
    var vendorId: String?
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        messageField.delegate = self
    }
    
    //MARK: Helpers
    func configure(_ vendorId: String?) {
        self.vendorId = vendorId ?? ""
    }
}

extension MessageFooter: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let message = self.messageField.text, let id = self.vendorId {
            self.delegate?.messageDidChange(message, forVendor: id)
        }
    }
}
