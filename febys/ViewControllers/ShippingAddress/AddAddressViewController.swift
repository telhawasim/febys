//
//  AddShippingAddressViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 28/09/2021.
//

import UIKit
import GoogleMaps
import FlagPhoneNumber

enum PickerType {
    case country
    case state
    case city
}

class AddAddressViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var addressLabelTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var selectAddressButton: FebysButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var setDefaultSwitch: UISwitch!
    @IBOutlet weak var labelPickerButton: FebysButton!
    @IBOutlet weak var saveButton: FebysButton!
    
    @IBOutlet weak var addressCityView: UIView!
    @IBOutlet weak var addressStateView: UIView!
    @IBOutlet weak var addressPostalView: UIView!
    @IBOutlet weak var addressCountryView: UIView!

    
    //MARK: Properties
    var isValidPhoneNumber = false
    var shippingDetails: ShippingDetails?
    var centerCoordinate: CLLocationCoordinate2D?
    var selectedAddress: GMSAddress?
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)


    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareAddress()
        configureToggle()
        configurePhoneNumber()
        setupButtonActions()
        
        if let shippingDetails = shippingDetails?.shippingDetail {
            setFieldsValue(with: shippingDetails)
        }
        
    }
    
    //MARK: IBActions
    func setupButtonActions() {
        saveButton.didTap = { [weak self] in
            guard let self = self else {return}
            if self.validateTextFields() {
                self.saveShippingAddress()
            }
        }
        
        selectAddressButton.didTap = { [weak self] in
            self?.goToChooseLocation()
        }
    }
    
    //MARK: Configure
    private func configureToggle() {
        setDefaultSwitch.thumbTintColor = .white
        setDefaultSwitch.tintColor = .febysLightGray()
        setDefaultSwitch.onTintColor = .febysGray()
        setDefaultSwitch.backgroundColor = .white
        setDefaultSwitch.set(width: 36.08, height: 22)
    }
    
    func configurePhoneNumber() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.hasPhoneNumberExample = false
        phoneNumberTextField.placeholder = " "
        phoneNumberTextField.setBorderColor(width: 2, color: .white)
        phoneNumberTextField.font = .arial(type: .regular, size: 16)
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.flagButtonSize = CGSize(width: 30, height: 30)
        phoneNumberTextField.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)

        listController.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code)
        }
    }
    
    //MARK: HELPERS
    func validateTextFields() -> Bool {
        guard let tag = addressLabelTextField.text?.capitalized.trim(),
              let fName = firstNameTextField.text?.capitalized.trim(),
              let LName = lastNameTextField.text?.capitalized.trim(),
              let address = addressTextField.text?.trim(),
//              let postal = postalCodeTextField.text?.trim(),
              let phoneNumber = phoneNumberTextField.text?.trim()
        else {
            return false
        }
        // CHECK VALIDATY
        var errorMessage : String?
        
        if tag.isEmpty{
            errorMessage = "\(Constants.addressLabel) \(Constants.IsRequired)"
        }else if fName.isEmpty{
            errorMessage = "\(Constants.FirstName) \(Constants.IsRequired)"
        }else if LName.isEmpty{
            errorMessage = "\(Constants.LastName) \(Constants.IsRequired)"
        }else if address.isEmpty{
            errorMessage = "\(Constants.address) \(Constants.IsRequired)"
        }
//        else if postal.isEmpty{
//            errorMessage = "\(Constants.postalCode) \(Constants.IsRequired)"
//        }
        else if phoneNumber.isEmpty{
            errorMessage = "\(Constants.PhoneNumber) \(Constants.IsRequired)"
        }else if !isValidPhoneNumber {
            errorMessage = "\(Constants.PhoneNumber) \(Constants.IsInvalid)"
        }

        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    func setFieldsValue(with details: ShippingDetail) {
        if let coordinates = details.address?.location?.coordinates {
            self.centerCoordinate = CLLocationCoordinate2D(latitude: coordinates.last!, longitude: coordinates.first!)
        }
        
        self.addressLabelTextField.text = details.label?.capitalized
        self.firstNameTextField.text = details.firstName ?? ""
        self.lastNameTextField.text = details.lastName ?? ""
        
        self.addressTextField.text = details.address?.street ?? ""
        
        if let city = details.address?.city {
            didHideCityView(false)
            cityTextField.text = city
        }
        
        if let state = details.address?.state {
            didHideStateView(false)
            stateTextField.text = state
        }
        
        if let postal = details.address?.zipCode {
            postalCodeTextField.text = postal
        }
        
        if let country = details.address?.countryCode {
            didHideCountryView(false)
            countryTextField.text = country
        }
        
        self.setDefaultSwitch.isOn = details.isDefault ?? false
        self.phoneNumberTextField.set(phoneNumber: details.contact?.number ?? "")
    }
    
    func prepareAddress() {
        didHideCityView(true)
        didHideStateView(true)
        didHideCountryView(true)
        
        if let address = selectedAddress {
            if let street = address.thoroughfare {
                addressTextField.text = street.capitalized

            }else if let formatedAddress = address.lines?.joined(separator:", ") {
                let sepratedBy = address.subLocality ?? address.locality ?? address.administrativeArea ?? address.country
                
                if let sprtBy = sepratedBy {
                    let street = formatedAddress.components(separatedBy: sprtBy)
                    addressTextField.text = "\(street.first?.capitalized ?? "")" + "\(address.subLocality ?? "")"
                }
            }
            
            if let city = address.locality {
                didHideCityView(false)
                cityTextField.text = city.capitalized
            }
            
            if let state = address.administrativeArea {
                didHideStateView(false)
                stateTextField.text = state.capitalized
            }
            
            if let postal = address.postalCode {
                postalCodeTextField.text = postal
            }
            
            if let country = address.country {
                didHideCountryView(false)
                countryTextField.text = country.capitalized
            }
        }
    }
    
    func didHideCityView(_ isHidden: Bool) {
        self.addressCityView.isHidden = isHidden
    }
    
    func didHideStateView(_ isHidden: Bool) {
        self.addressStateView.isHidden = isHidden
    }
    
    func didHideCountryView(_ isHidden: Bool) {
        self.addressCountryView.isHidden = isHidden
    }
    
    //MARK: Navigation
    func goToChooseLocation() {
        let vc = UIStoryboard.getVC(from: .ShippingAddress, ChooseLocationViewController.className) as! ChooseLocationViewController
        vc.delegate = self
        vc.centerCoordinate = centerCoordinate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: API Calling
    func saveShippingAddress() {
        if let tag = addressLabelTextField.text?.capitalized.trim(),
           let FName = firstNameTextField.text?.capitalized.trim(),
           let LName = lastNameTextField.text?.capitalized.trim(),
           let phoneCode = phoneNumberTextField.selectedCountry?.code,
           let phoneNumber = phoneNumberTextField.getFormattedPhoneNumber(format: .E164) {
            
            let street = addressTextField.text?.condensingWhitespace().trim()
            let city = cityTextField.text?.capitalized.trim()
            let state = stateTextField.text?.capitalized.trim()
            let zipCode = postalCodeTextField.text?.trim()
            let country = countryTextField.text?.capitalized.trim()
            let coordinate = selectedAddress?.coordinate ?? centerCoordinate
            
            let location = [ParameterKeys.coordinates: [coordinate!.longitude, coordinate!.latitude]]
            
            let addressParam = [ ParameterKeys.country_code: country!,
                                 ParameterKeys.zip_code: zipCode!,
                                 ParameterKeys.state: state!,
                                 ParameterKeys.city: city!,
                                 ParameterKeys.street: street!,
                                 ParameterKeys.location: location] as [String : Any]
            
            let contactParam = [ ParameterKeys.country_code: phoneCode.rawValue,
                                 ParameterKeys.number: phoneNumber ]
            
            let shippingParams = [ ParameterKeys.label: tag,
                                   ParameterKeys.first_name: FName,
                                   ParameterKeys.last_name: LName,
                                   ParameterKeys.address: addressParam,
                                   ParameterKeys.contact: contactParam,
                                   ParameterKeys._default: setDefaultSwitch.isOn ]  as [String : Any]
            
            var bodyParams = [ ParameterKeys.shipping_detail: shippingParams ] as [String : Any]
            
            if let id = shippingDetails?.id {
                bodyParams.updateValue(id, forKey: ParameterKeys.id)
            }
            
            Loader.show()
            AddressService.shared.saveShippingAddress(body: bodyParams) { response in
                Loader.dismiss()
                switch response{
                case .success(_):
                    self.backButtonTapped(self)
                case .failure(let error):
                    self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                }
            }
        }
    }
}

extension AddAddressViewController: ChooseLocationDelegate {
    func didTapChooseLocation(_ address: GMSAddress) {
        self.selectedAddress = address
        self.prepareAddress()
    }
}


extension AddAddressViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.isValidPhoneNumber = isValid
    }
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        listController.title = "Countries"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
}

