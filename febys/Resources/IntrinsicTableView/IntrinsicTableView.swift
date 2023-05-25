//
//  IntrinsicTableView.swift
//  febys
//
//  Created by Faisal Shahzad on 30/11/2021.
//

import UIKit

class IntrinsicTableView: UITableView {
    
    /// Will assign automatic dimension to the rowHeight variable
    /// Will asign the value of this variable to estimated row height.
    var dynamicRowHeight: CGFloat = UITableView.automaticDimension {
        didSet {
            rowHeight = UITableView.automaticDimension
            estimatedRowHeight = dynamicRowHeight
        }
    }
    
    public override var intrinsicContentSize: CGSize { contentSize }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }
    
}
