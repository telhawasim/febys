//
//  ChooseLocationViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 17/08/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import CoreMIDI

protocol ChooseLocationDelegate {
    func didTapChooseLocation(_ address: GMSAddress)
}

class ChooseLocationViewController: BaseViewController {

    //MARK: OUTLETS
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchClearButton: FebysButton!
    @IBOutlet weak var userLocationButton: FebysButton!
    @IBOutlet weak var chooseLocationButton: FebysButton!
    @IBOutlet weak var searchLocationTextField: FebysTextField!
    @IBOutlet weak var predictionsView: UIView!
    @IBOutlet weak var predictionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: PROPERTIES
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var preciseLocationZoomLevel: Float = 18.0
    var approximateLocationZoomLevel: Float = 18.0
    var delegate: ChooseLocationDelegate?
    
    var marker: GMSMarker?
    var centerCoordinate: CLLocationCoordinate2D?
    var selectedAddress: GMSAddress?

    var placesClient: GMSPlacesClient!
    let token = GMSAutocompleteSessionToken.init()
    let filter = GMSAutocompleteFilter()
    var predictions: [GMSAutocompletePrediction]?

    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtonActions()
        self.configLocation()
        self.configureTableView()
        
        if let centerCoordinate = centerCoordinate {
            animate(mapView, to: centerCoordinate, zoom: approximateLocationZoomLevel)
        }
        
        hidePredictionsView(true)
        hideClearButton(searchLocationTextField.text?.isEmpty ?? true)
        searchLocationTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

    }

    //MARK: IBACTIONS
    func setupButtonActions() {
        
        self.userLocationButton.didTap = { [weak self] in
            guard let self = self, let location = self.currentLocation
            else { return }
            
            self.animate(self.mapView, to: location.coordinate, zoom: self.approximateLocationZoomLevel)
        }
        
        self.searchClearButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.searchLocationTextField.text = nil
            self.hideClearButton(self.searchLocationTextField.text?.isEmpty ?? true)
            self.hidePredictionsView(true)
            if !self.searchLocationTextField.isFirstResponder {
                self.searchLocationTextField.becomeFirstResponder()
            }
        }
        
        self.chooseLocationButton.didTap = { [weak self] in
            if let address = self?.selectedAddress {
                self?.delegate?.didTapChooseLocation(address)
                self?.backButtonTapped(self!)
            }
        }
    }
    
    
    //MARK: - CONFIGURE
    func configLocation(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
//        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        placesClient = GMSPlacesClient.shared()
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseLocationTableViewCell.className)
    }
    
    //MARK: - METHODS
    func hidePredictionsView(_ isHidden: Bool){
        predictionsView.isHidden = isHidden ? true : false
    }
    
    func hideClearButton(_ isHidden: Bool){
        searchClearButton.isHidden = isHidden ? true : false
    }
    
    func updateDropDownUI() {
        if let predictions = predictions {
            if predictions.count > 3 {
                self.predictionHeightConstraint.constant = 180
            } else {
                self.predictionHeightConstraint.constant = CGFloat(predictions.count * 45)
            }
        }
    }
    
    func animate(_ mapView: GMSMapView, to coordinate: CLLocationCoordinate2D, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoom)
        
        mapView.camera = camera
        mapView.animate(to: camera)
    }
}

extension ChooseLocationViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        hideClearButton(textField.text?.isEmpty ?? true)
        
        if !(textField.text?.isEmpty ?? true) {
            getAutocompletePredictions(fromQuery: textField.text!)
        } else {
            self.hidePredictionsView(true)
        }
    }
}

//MARK: UITableView
extension ChooseLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseLocationTableViewCell.className, for: indexPath) as! ChooseLocationTableViewCell
                
        if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
            cell.dividerView.isHidden = true
        } else {
            cell.dividerView.isHidden = false
        }
        
        let addressString = predictions?[indexPath.row].attributedFullText
        cell.configure(icon: UIImage(named: "ic_location_pin_24x24") ?? UIImage(),
                       title: addressString?.string ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let placeId = predictions?[indexPath.row].placeID else { return }
        self.getPlaceDetail(of: placeId) { [weak self] place in
            guard let self = self else {return}
            self.hidePredictionsView(true)
            self.animate(self.mapView, to: place.coordinate, zoom: self.preciseLocationZoomLevel)
        }
    }
    
}

// MARK: - LocationManger Delegate
extension ChooseLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location
        if centerCoordinate == nil {
            animate(mapView, to: location.coordinate, zoom: approximateLocationZoomLevel)
        }
    }
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        if #available(iOS 14.0, *) {
            let accuracy = manager.accuracyAuthorization
            switch accuracy {
            case .fullAccuracy:
                print("Location accuracy is precise.")
            case .reducedAccuracy:
                print("Location accuracy is not precise.")
            @unknown default:
                fatalError()
            }
        } else {
            // Fallback on earlier versions
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
            locationManager.stopUpdatingLocation()

        case .denied:
            print("User denied access to location.")
            locationManager.stopUpdatingLocation()

        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

//MARK: GMSMapViewDelegate
extension ChooseLocationViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.searchLocationTextField.resignFirstResponder()
        self.hidePredictionsView(true)
        self.hideClearButton(self.searchLocationTextField.text?.isEmpty ?? true)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude,
                                                      longitude: longitude)

        self.convertLatLongToAddress(coordinate: centerCoordinate) { address in
            self.selectedAddress = address
            let addressString = address.lines?.joined(separator: ", ")
            self.searchLocationTextField.text = addressString
            self.hideClearButton(self.searchLocationTextField.text?.isEmpty ?? true)
        }
    }
}

// MARK: - GMSAutocomplete
extension ChooseLocationViewController {
    
    func convertLatLongToAddress(coordinate: CLLocationCoordinate2D,  _ completion: @escaping ((GMSAddress) -> Void)) {

        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let error = error {
                print("ReverseGeocoder error: \(error)")
                return
            }
            
            guard let address = response?.firstResult() else { return }
            completion(address)
            
        }
    }
    
    func getAutocompletePredictions(fromQuery: String) {
        
        placesClient.findAutocompletePredictions(fromQuery: fromQuery, filter: filter, sessionToken: token, callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            
            if let results = results,
                results.count > 0 {
                self.predictions = results
                self.updateDropDownUI()
                self.tableView.reloadData()
                self.hidePredictionsView(false)
            }
        })
    }
    
    func getPlaceDetail(of placeId: String, completion: @escaping (GMSPlace)->()) {
        // Specify the place data types to return.
        let fields = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue)
                                   | UInt(GMSPlaceField.placeID.rawValue)
                                   | UInt(GMSPlaceField.addressComponents.rawValue)
                                   | UInt(GMSPlaceField.formattedAddress.rawValue)
                                   | UInt(GMSPlaceField.coordinate.rawValue))

        placesClient?.fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: token, callback: { (place, error) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
            
          if let place = place {
              completion(place)
          }
        })
    }
}

