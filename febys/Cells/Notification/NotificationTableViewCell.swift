//
//  NotificationTableViewCell.swift
//  febys
//
//  Created by Nouman Akram on 09/02/2022.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var iconBgView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var descriptionLabel: FebysLabel!
    @IBOutlet weak var badgeIcon: UIView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    //MARK: Variables
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configueNotificationIcon(type: NotificationType?, orderStatus: OrderStatus? = nil) {
        switch type {
        case .Order:
            self.iconImage.image = UIImage(named: "order-notification")
            self.iconBgView.backgroundColor = .getOrderStatusColor(status: orderStatus)
        case .Consumer:
            self.iconImage.image = UIImage(named: "febys-notification")
            self.iconBgView.backgroundColor = .febysLightGray()
        case .FebysPlus:
            self.iconImage.image = UIImage(named: "febys-plus-notification")
            self.iconBgView.backgroundColor = .statusLightRed()
        case .QuestionAnswers:
            self.iconImage.image = UIImage(named: "qna-notification")
            self.iconBgView.backgroundColor = .febysSkyBlue()
        default:
            break
        }
    }
    
    //MARK: Configuration
    func configure(_ notification: Notifications?) {
        let orderStatus = OrderStatus(rawValue: notification?.data?.status?.uppercased() ?? "")
        let notificationType = NotificationType(rawValue: notification?.data?.type ?? "")
        let date = Date.getFormattedDate(string: notification?.createdAt ?? "", format: Constants.dateFormatDD_MMM_yyyy)
        let time = Date.getFormattedDate(string: notification?.createdAt ?? "", format: Constants.timeFormatHHmmA)
        
        self.configueNotificationIcon(type: notificationType, orderStatus: orderStatus)
        self.titleLabel.text = notification?.title ?? ""
        self.descriptionLabel.text = notification?.body ?? ""
        self.dateAndTimeLabel.text = "\(date) \(time)"
        
        if let isRead = notification?.read {
            self.badgeIcon.isHidden = isRead ? true : false
            self.contentView.backgroundColor = isRead ? .white : .febysLightGray()
        }
    }
}

enum NotificationType: String {
    case Order = "order"
    case Consumer = "consumer"
    case FebysPlus = "febys-plus"
    case QuestionAnswers = "question-answers"
}
