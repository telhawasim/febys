//
//  SearchListCell.swift
//  febys
//
//  Created by Waseem Nasir on 11/07/2021.
//

import UIKit

class SearchListCell: UITableViewCell {

    @IBOutlet weak var mainLabel: FebysLabel!
    @IBOutlet weak var subLabel: FebysLabel!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var radioButton: FebysButton!
    @IBOutlet weak var tickImageView: UIImageView!

    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureToggle()
        configureRadioButton()
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                radioButton.isSelected = isSelected
                tickImageView.image = UIImage(named: "tick")
            } else {
                radioButton.isSelected = isSelected
                tickImageView.image = nil
            }
        }
    }
    
    
    //MARK: Helpers
    private func didHideToggle(_ isHidden: Bool) {
        isHidden
        ? (toggleSwitch.isHidden = true)
        : (toggleSwitch.isHidden = false)
    }
    
    func didHideArrow(_ isHidden: Bool) {
        isHidden
        ? (arrowImage.isHidden = true)
        : (arrowImage.isHidden = false)
    }
    
    private func didHideSubTitle(_ isHidden: Bool) {
        isHidden
        ? (subLabel.isHidden = true)
        : (subLabel.isHidden = false)
    }
    
    private func didHideTickImage(_ isHidden: Bool) {
        isHidden
        ? (tickImageView.isHidden = true)
        : (tickImageView.isHidden = false)
    }
    
    private func didHideRadioButton(_ isHidden: Bool) {
        isHidden
        ? (radioButton.isHidden = true)
        : (radioButton.isHidden = false)
    }
    
    private func didHideFlagImage(_ isHidden: Bool) {
        isHidden
        ? (flagImageView.isHidden = true)
        : (flagImageView.isHidden = false)
    }
    
    private func didHideLoaction(_ isHidden: Bool) {
        isHidden
        ? (locationStackView.isHidden = true)
        : (locationStackView.isHidden = false)
    }
    
    //MARK: Configutations
    private func configureRadioButton(){
        radioButton.setImage(UIImage(named: "radioUnfilled"), for: .normal)
        radioButton.setImage(UIImage(named: "radioFilled"), for: .selected)
    }
    
    private func configureToggle() {
        toggleSwitch.thumbTintColor = .white
        toggleSwitch.tintColor = .febysLightGray()
        toggleSwitch.onTintColor = .febysGray()
        toggleSwitch.backgroundColor = .white
        toggleSwitch.set(width: 36.08, height: 22)
    }
    
    func configure(category: Categories?){
        self.didHideArrow(false)
        self.didHideToggle(true)
        self.didHideTickImage(true)
        self.didHideSubTitle(true)
        self.didHideRadioButton(true)
        self.didHideFlagImage(true)
        self.didHideLoaction(true)

        self.mainLabel.text = category?.name ?? ""
    }
    
    func configure(settings: Setting?){
        self.didHideArrow(settings?.isToggle ?? false)
        self.didHideToggle(!(settings?.isToggle ?? false))
        self.didHideTickImage(true)
        self.didHideSubTitle(true)
        self.didHideRadioButton(true)
        self.didHideFlagImage((settings?.image == nil) ? true : false)
        self.didHideLoaction((settings?.image == nil) ? true : false)

        self.mainLabel.text = settings?.title ?? ""
    }
    
    func configure(store: NavigationMenu?){
        self.didHideArrow(false)
        self.didHideToggle(true)
        self.didHideTickImage(true)
        self.didHideSubTitle(true)
        self.didHideRadioButton(true)
        self.didHideFlagImage(true)
        self.didHideLoaction(true)
        
        self.mainLabel.text = store?.name ?? ""
    }
    
    func configure(filters: String?, withRadioButton: Bool, isSelected: Bool){
        self.isSelected = isSelected
        self.didHideTickImage(withRadioButton ? true : false)
        self.didHideRadioButton(withRadioButton ? false : true)
        self.didHideArrow(true)
        self.didHideToggle(true)
        self.didHideSubTitle(true)
        self.didHideFlagImage(true)
        self.didHideLoaction(true)
        
        self.mainLabel.text = filters ?? ""
    }
    
    func configure(title: String?, subTitle: String?, withArrow: Bool){
        self.didHideArrow(!withArrow)
        self.didHideToggle(true)
        self.didHideTickImage(true)
        self.didHideRadioButton(true)
        self.didHideFlagImage(true)
        self.didHideLoaction(true)
        
        if subTitle != nil { self.didHideSubTitle(false) }
        else { self.didHideSubTitle(true) }
        
        self.mainLabel.text = title ?? ""
        self.subLabel.text = "(\(subTitle ?? ""))"
    }
    
}


extension UISwitch {
    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
