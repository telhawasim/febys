//
//  ThankYouViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 31/10/2021.
//

import UIKit

class ThankYouViewController: BaseViewController {

    //MARK: IBOutlet
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var closeButton: FebysButton!
    @IBOutlet weak var myOrderButton: FebysButton!
    @IBOutlet weak var continueShoppingButton: FebysButton!

    //MARK: Properties
    var orderId: String?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        if let id = orderId {
            orderIdLabel.text = id.uppercased()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupButtons() {
        closeButton.didTap = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        myOrderButton.didTap = { [weak self] in
            RedirectionManager.shared.gotoHome(redirection: .account(orderId: self?.orderId ?? ""))
        }
        
        continueShoppingButton.didTap = {
            RedirectionManager.shared.gotoHome()
        }
    }
}
