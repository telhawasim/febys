//
//  ProductTableViewHeader.swift
//  febys
//
//  Created by Faisal Shahzad on 09/09/2021.
//

import UIKit

class ProductTableViewHeader: UITableViewHeaderFooterView {
        
    static let kHeaderViewHeight: CGFloat = 45.0;

    @IBOutlet weak var title: FebysLabel!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var spacer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func changeArrowDirection(_ isOpened: Bool) {
        if isOpened {
            spacer.isHidden = isOpened
            downArrow.image = UIImage(named: "upArrow")
        } else {
            spacer.isHidden = isOpened
            downArrow.image = UIImage(named: "downArrow")
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
