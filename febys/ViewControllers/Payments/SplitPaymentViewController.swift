//
//  SplitPaymentViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 19/01/2022.
//

import UIKit

protocol SpitPaymentDelegate {
    func didTapSplit()
    func didTapCancel()
}

class SplitPaymentViewController: BaseViewController {

    @IBOutlet weak var splitPayButton: FebysButton!
    @IBOutlet weak var cancelButton: FebysButton!
    @IBOutlet weak var backButton: FebysButton!

    var delegate: SpitPaymentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitPayButton.didTap = { [weak self] in
            guard let self = self else {return}
            self.delegate?.didTapSplit()
            self.backButtonTapped(self)
        }
        
        cancelButton.didTap = { [weak self] in
            guard let self = self else {return}
            self.delegate?.didTapCancel()
            self.backButtonTapped(self)
        }
        
        backButton.didTap = { [weak self] in
            guard let self = self else {return}
            self.delegate?.didTapCancel()
            self.backButtonTapped(self)
        }
    }
}
