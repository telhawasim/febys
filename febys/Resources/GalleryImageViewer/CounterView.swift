//
//  CounterView.swift
//  febys
//
//  Created by Faisal Shahzad on 23/02/2022.
//

import UIKit

class CounterView: UIView {

    var count: Int
    let countLabel = UILabel()
    var currentIndex: Int {
        didSet {
            updateLabel()
        }
    }

    init(frame: CGRect, currentIndex: Int, count: Int) {

        self.currentIndex = currentIndex
        self.count = count

        super.init(frame: frame)

        configureLabel()
        updateLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLabel() {

        countLabel.textAlignment = .center
        self.addSubview(countLabel)
    }

    func updateLabel() {

        let stringTemplate = "%d of %d"
        let countString = String(format: stringTemplate, arguments: [currentIndex + 1, count])

        countLabel.attributedText = NSAttributedString(string: countString, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        countLabel.frame = self.bounds
    }
}
