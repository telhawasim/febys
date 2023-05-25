//
//  AnswersTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 27/09/2021.
//

import UIKit

class AnswersViewCell: UIView {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerByLabel: UILabel!
    @IBOutlet weak var answerDateLabel: UILabel!
    
    @IBOutlet weak var answerDetails: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ answer: ChatModel?) {
        self.answerLabel.text = answer?.message ?? "---"
        self.answerByLabel.text = answer?.sender?.name?.capitalized ?? ""
        if let date = answer?.sentTime {
            answerDateLabel.text = Date.getFormattedDate(string: date, format: Constants.dateFormatDD_MMM_yyyy)
        }

        
//        if answer?.message! != "---"{
//            hideAndShowAnswerDetails(isHidden: false)
//            answerLabel.text = answer?.message ?? "---"
//            answerByLabel.text = answer?.sender?.name?.capitalized ?? ""
//            answerDateLabel.text = Date.getFormattedDate(string: answer?.sentTime ?? "", format: Constants.DateFormat)
//        } else {
//            hideAndShowAnswerDetails(isHidden: true)
//            answerLabel.text = "---"
//        }
    }
    
    func hideAndShowAnswerDetails(isHidden: Bool) {
        if isHidden { answerDetails.isHidden = true }
        else { answerDetails.isHidden = false }
    }
}
