//
//  CreateActivityByUserViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/9/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class CreateActivityByUserViewController: UIViewController {

  @IBOutlet weak var navbar: UINavigationBar!
  @IBOutlet weak var startField: UITextField!
  @IBOutlet weak var endField: UITextField!
  @IBOutlet weak var maximumRequiredField: UITextField!
  @IBOutlet weak var createButton: UIButton!
  var latitude: Double?
  var longitude: Double?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    let locManager = CLLocationManager()
    locManager.requestAlwaysAuthorization()
    if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
      let currentLocation = locManager.location
      latitude = currentLocation?.coordinate.latitude
      longitude = currentLocation?.coordinate.longitude
    }
  }

  private func parseIntergerTime(time: Int) -> String {
    var ret: String?
    if (time == 0) {
      return "12:00 AM"
    } else if (time < 12) {
      ret = String(time)
      ret?.append(":00 AM")
      return ret!
    } else {
      ret = String(time - 12)
      ret?.append(":00 PM")
      return ret!
    }
  }

  private func showAlert(with message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  private func setupView() {
    var title = "Create activity from "
    title.append(parseIntergerTime(time: (selectedUserActivity?.startTime)!))
    title.append(contentsOf: " to ")
    title.append(parseIntergerTime(time: (selectedUserActivity?.endTime)!))
    navbar.topItem?.title = title

    createButton.layer.borderWidth = 2.0
    createButton.layer.borderColor = UIColor.black.cgColor
    createButton.layer.cornerRadius = 10
  }

  @IBAction func onTapCreateButton(_ sender: UIButton) {
    guard let startTime = Int(startField.text!) else {
      showAlert(with: "Enter a numerical start time")
      return
    }
    guard let endTime = Int(endField.text!) else {
      showAlert(with: "Enter a numerical end time")
      return
    }
    guard let maximumParticipants = Int(maximumRequiredField.text!) else {
      showAlert(with: "Enter the minimum required participants")
      return
    }
    if startTime < (selectedUserActivity?.startTime)! {
      showAlert(with: "Start time should not be before activity start time")
      return
    }
    if startTime > (selectedUserActivity?.endTime)! {
      showAlert(with: "Start time should not be after activity end time")
      return
    }
    if endTime < (selectedUserActivity?.startTime)! {
      showAlert(with: "End time should not be before activity start time")
      return
    }
    if endTime > (selectedUserActivity?.endTime)! {
      showAlert(with: "End time should not be after activity end time")
      return
    }
    if endTime <= startTime {
      showAlert(with: "End time should be greater than start time")
      return
    }
    if maximumParticipants <= 0 {
      showAlert(with: "Minimum number of participants should be greater than 0")
      return
    }
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("createActivity")
    let params: [String : Any] = ["userEmail": accountEmailId,
                                  "ownerEmail": selectedUserActivity?.owner,
                                  "name": selectedUserActivity?.arena,
                                  "gameid": selectedUserActivity?.gameid,
                                  "latitude": latitude,
                                  "longitude": longitude,
                                  "start": startTime,
                                  "end": endTime,
                                  "totalAllowed": maximumParticipants]
    Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      print(response)
    }
  }
}
