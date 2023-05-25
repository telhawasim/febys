//
//  CollapsingView.swift
//  febys
//
//  Created by Faisal Shahzad on 01/11/2021.
//

import UIKit

class CollapsingView: UIView {

    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var arrowButton: FebysButton!
    @IBOutlet weak var toggleButton: FebysButton!
    @IBOutlet weak var collapsingView: UIView!
    @IBOutlet weak var stackView: UIStackView!

    var isExpanded: Bool = false {
        didSet {
            toggleCollapsing()
        }
    }
   
    func toggleCollapsing() {
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
            self.arrowButton.isSelected = self.isExpanded
            self.collapsingView.isHidden = !self.isExpanded
            self.stackView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func addChildView(to view: UIView, with subView: UIView) {
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        subView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
    }
    
    func configure(_ data: CollapsingData) {
        self.isExpanded = data.isExpanded ?? false
        self.titleLabel.text = data.title?.capitalized
        self.addChildView(to: collapsingView, with: data.contentView ?? UIView())
        
        self.toggleButton.didTap = {
            self.isExpanded = !self.isExpanded
        }
    }
}
