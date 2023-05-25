//
//  ProductVariantPickerViewController.swift
//  febys
//
//  Created by Waseem Nasir on 02/08/2021.
//

import UIKit

class ProductVariantPickerViewController: BaseViewController {
    //MARK: OUTLETS
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var mainLabel: FebysLabel!
    
    //MARK: PROPERTIES
    var pickerData = [String]()
    var selectedRow = 0
    var titleString = ""
    var didSelectRow: ((String)->())?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        mainLabel.text = titleString
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
    
}

extension ProductVariantPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        //        gradeTextField.text = gradePickerValues[row]
        //        self.view.endEditing(true)
        pickerView.subviews[0].subviews[0].subviews[2].backgroundColor = pickerView.tintColor.withAlphaComponent(0);
        
        didSelectRow?(pickerData[row])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if #available(iOS 14.0, *) {
            let height: CGFloat = 1.0
            let color = UIColor(hexString: "#E1E5E8")
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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 40))
        label.text = pickerData[row]
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension ProductVariantPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.pickerView { return true }
        return false
    }
}
