//
//  CancelReasonPickerViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 30/11/2021.
//

import UIKit

protocol PickerViewDelegate {
    func dismissPicker()
}

class ReasonsPickerViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var backgroundButton: FebysButton!
    @IBOutlet weak var crossButton: FebysButton!

    //MARK: Properties
    var isTransclucent = true
    var delegate: PickerViewDelegate?
    var selectedRow = 0
    var pickerTitle = ""
    var pickerData = [String]()
    var didSelectRow: ((String)->())?
    var heightForRow: CGFloat = 0.0
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        titleLabel.text = pickerTitle
        
        if !isTransclucent {
            backgroundButton.alpha = 0.6
            backgroundButton.backgroundColor = .febysBlack()
        }
        
        setupButtonActions()
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
    }
    
    //MARK: IBAction
    func setupButtonActions() {
        backgroundButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.backButtonTapped(self.backgroundButton!)
            self.delegate?.dismissPicker()
        }
        
        crossButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.backButtonTapped(self.crossButton!)
            self.delegate?.dismissPicker()
        }
    }
    
    func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self
        self.pickerView.addGestureRecognizer(tap)
    }
    
    @objc func pickerTapped(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let rowHeight = self.pickerView.rowSize(forComponent: 0).height
            let selectedRowFrame = self.pickerView.bounds.insetBy(dx: 0, dy: (self.pickerView.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.pickerView))
            if userTappedOnSelectedRow {
                let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                pickerView(self.pickerView, didSelectRow: selectedRow, inComponent: 0)
                self.backButtonTapped(self)
            }
        }
    }
    
    //MARK: Helpers
    func numberOfLines(label: UILabel) -> Int {
        // You have to call layoutIfNeeded() if you are using autoLayout
        label.layoutIfNeeded()
        let myText = label.text! as NSString
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font as Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
}

extension ReasonsPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        pickerView.subviews[0].subviews[0].subviews[2].backgroundColor = pickerView.tintColor.withAlphaComponent(0);
        
        didSelectRow?(pickerData[row])
    }
    
    func lines(label: UILabel) -> Int {
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if #available(iOS 14.0, *) {
            let height: CGFloat = 1.0
            let color = UIColor.febysMildGreyColor()
            for subview in pickerView.subviews {
                /* smaller than the row height plus 20 point, such as 40 + 20 = 60*/
                if subview.frame.size.height < 60 {
                    if subview.subviews.isEmpty {
                        let topLineView = UIView()
                        topLineView.frame = CGRect(x: 20.0, y: 0.0, width: subview.frame.size.width - 60, height: height)
                        topLineView.backgroundColor = color
                        subview.addSubview(topLineView)
                        let bottomLineView = UIView()
                        bottomLineView.frame = CGRect(x: 20.0, y: subview.frame.size.height - height, width: subview.frame.size.width - 60, height: height)
                        bottomLineView.backgroundColor = color
                        subview.addSubview(bottomLineView)
                    }
                }
                subview.backgroundColor = .clear
            }
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width - 20, height: 40))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .helvetica(type: .medium, size: 14)
        label.text = pickerData[row]
        let lineHeight = (numberOfLines(label: label)) * 40
        self.heightForRow = CGFloat(lineHeight)
        label.frame = CGRect(x: 0, y: 0, width: pickerView.frame.width - 20, height: CGFloat(lineHeight))
        label.layoutIfNeeded()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension ReasonsPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.pickerView { return true }
        return false
    }
}
