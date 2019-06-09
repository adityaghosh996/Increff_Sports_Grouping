//
//  AddAcitivityViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import RSSelectionMenu
import CoreLocation
import Alamofire

public var latitude: Double = 0
public var longitude: Double = 0

class AddActivityViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet private weak var eventField: UITextField!
  @IBOutlet private weak var startTimeField: UITextField!
  @IBOutlet private weak var endTimeField: UITextField!
  @IBOutlet private weak var addButton: UIButton!
  @IBOutlet private weak var selectSportButton: UIButton!
  var selectedSport: String?
  public let locationManager = CLLocationManager()
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.requestAlwaysAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
      locationManager.startUpdatingLocation()
    }
    setupView()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      latitude = location.coordinate.latitude
      longitude = location.coordinate.longitude
    }
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if(status == CLAuthorizationStatus.denied) {
      showLocationDisabledPopUp()
    }
  }

  func showLocationDisabledPopUp() {
    let alertController = UIAlertController(title: "Background Location Access Disabled",
                                            message: "In order to deliver pizza we need your location",
                                            preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)

    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    alertController.addAction(openAction)

    self.present(alertController, animated: true, completion: nil)
  }

  private func setupView() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
    view.layer.insertSublayer(gradient, at: 0)

    addButton.layer.borderWidth = 2
    addButton.layer.borderColor = UIColor.black.cgColor
    addButton.layer.cornerRadius = 10

    selectSportButton.layer.borderWidth = 2
    selectSportButton.layer.borderColor = UIColor.black.cgColor
    selectSportButton.layer.cornerRadius = 10
  }
  @IBAction func onTapSelectSportButton(_ sender: UIButton) {
    let selectedNames = [String]()
    let menu = RSSelectionMenu(dataSource: sports) { (cell, name, indexPath) in
      cell.textLabel?.text = name
    }
    menu.cellSelectionStyle = .tickmark
    menu.setSelectedItems(items: selectedNames) { [weak self] (name, _, _, _) in
      guard let strongSelf = self else { return }
      var title = "Selected Sport: "
      title.append(name!)
      strongSelf.selectSportButton.setTitle(title, for: .normal)
      strongSelf.selectedSport = name
    }
    menu.show(from: self)
  }

  private func showAlert(with message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func onTapAddButton(_ sender: UIButton) {
    guard let selectedSport = selectedSport else {
      showAlert(with: "Please select a sport")
      return
    }
    guard let start = Int(startTimeField.text!) else {
      showAlert(with: "Please enter hour in integer format")
      return
    }
    guard let end = Int(endTimeField.text!) else {
      showAlert(with: "Please enter hour in integer format")
      return
    }
    if start < 0 {
      showAlert(with: "Start time should be greater than or equal to 0")
      return
    }
    if end < 0 {
      showAlert(with: "End time should be greater than or equal to 0")
      return
    }
    if start >= 24 {
      showAlert(with: "Start time should be lesser than or equal to 23")
      return
    }
    if end >= 24 {
      showAlert(with: "Start time should be lesser than or equal to 23")
      return
    }
    if start >= end {
      showAlert(with: "Start time should be lesser than end time")
      return
    }
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("register")
    let email = accountEmailId
    let name = eventField.text!
    let gameId = mapSportsToId[selectedSport]
    let parameters: [String : Any] = ["email": email, "name": name, "gameid": gameId, "latitude": latitude, "longitude": longitude, "start": start, "end": end]
    Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self] (response) in
      guard let strongSelf = self else { return }
      let status = response.response?.statusCode
      if status == 200 {
        strongSelf.dismiss(animated: true, completion: nil)
      } else if status == 403 {
        strongSelf.showAlert(with: "Activity already exists")
      }
    }
  }
}
