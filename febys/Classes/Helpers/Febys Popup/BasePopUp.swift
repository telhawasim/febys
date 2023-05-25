//
//  BasePopUp.swift
//  febys
//
//  Created by Waseem Nasir on 01/07/2021.
//

import UIKit

class BasePopUp: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    
    var onDismiss : (()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerView.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        show();
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func btnHidePressed(_ sender: Any) {
        self.onDismiss?()
        self.hide();
    }
    
    func show() {
        
        self.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.containerView.alpha = 1.0

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.containerView.transform = CGAffineTransform.identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        
        self.containerView.alpha = 1.0
        self.containerView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            
            self.containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
            self.containerView.alpha = 0.0
            self.dismiss(animated: true, completion: completion)
        })
    }
}
