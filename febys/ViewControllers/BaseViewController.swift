//
//  ViewController.swift
//  febys
//
//  Created by Waseem Nasir on 23/06/2021.
//

import UIKit
import SwiftUI

class BaseViewController: UIViewController {
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if self.isBeingPresented || self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("##### Dying \(self) #####")
    }
    
    func showMessage(_ title: String, _ message: String, hideButton: Bool = false, messageImage: FebysPopupType = .error, isQuestioning: Bool = false, onSuccess:(()->Void)? = nil, onDismiss:(()->Void)?){
        DispatchQueue.main.async {
            
            let dialog = FebysPopUp.getPopup(with: title, text: message, popupType: messageImage)
            if !hideButton{
                if isQuestioning {
                    dialog.addAction(ActionViewModel(isBlack: true, title: "Yes", action: {
                        onSuccess?()
                    }))
                    
                    dialog.addAction(ActionViewModel(isBlack: false, title: "No", action: {
                        onDismiss?()
                    }))
                } else {
                    dialog.addAction(ActionViewModel(title: "Okay", action: {
                        onDismiss?()
                    }))
                }
            }
            self.present(dialog, animated: true, completion: nil)
        }
    }
}
