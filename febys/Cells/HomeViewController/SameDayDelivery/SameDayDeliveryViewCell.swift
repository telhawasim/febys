//
//  SameDayDeliveryViewCell.swift
//  febys
//
//  Created by Ab Saqib on 15/07/2021.
//

import UIKit

class SameDayDeliveryViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var sameDayLabel: UILabel!
    @IBOutlet weak var sameDayBgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sameDayShoNow(_ sender: UIButton) {
    }
    
    func configure(){
        
    }
}
