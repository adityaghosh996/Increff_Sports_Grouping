//
//  JoinExistingActivityViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/9/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

public struct JoinUserActivity {
  var arena: String
  var sport: String
  var startTime: Int
  var endTime: Int
  var distance: Double
  var owner: String
  var user: String
  var gameid: Int
  var registered: Int
  var total: Int
}

class JoinExistingActivityViewController: UIViewController {

  var latitude: Double?
  var longitude: Double?
  var activities = [JoinUserActivity]()
  @IBOutlet private weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    let locManager = CLLocationManager()
    locManager.requestAlwaysAuthorization()
    if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
      let currentLocation = locManager.location
      latitude = currentLocation?.coordinate.latitude
      longitude = currentLocation?.coordinate.longitude
    }
    getActivitiesToJoin()
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

  private func showAlert(with params: [String : Any], message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] (_) in
      guard let strongSelf = self else { return }
      strongSelf.tableView.reloadData()
    }
    alert.addAction(cancelAction)
    let okAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (_) in
      guard let strongSelf = self else { return }
      var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
      endpoint.append("joinActivity")
      Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
        print(response)
        strongSelf.getActivitiesToJoin()
      })
    }
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }

  private func getSport(with id: Int) -> String {
    return mapIdToSports[id]!
  }

  private func getActivitiesToJoin() {
    let params: [String : Any] = ["email": accountEmailId,
                                  "integerList": selectedSportArray,
                                  "radius": hyperLocalRadius,
                                  "latitude": latitude ?? 0,
                                  "longitude": longitude ?? 0]
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("getActivitiesToJoin")
    print(params)
    Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self] (response) in
      guard let strongSelf = self else { return }
      switch response.result {
      case .success(let JSON):
        guard let JSONArray = JSON as? [Any] else { return }
        strongSelf.activities.removeAll()
        for it in JSONArray {
          guard let JSONDict = it as? [String : Any] else { return }
          let _activity = JoinUserActivity (
            arena: JSONDict["name"] as! String,
            sport: strongSelf.getSport(with: JSONDict["gameId"] as! Int),
            startTime: JSONDict["start"] as! Int,
            endTime: JSONDict["end"] as! Int,
            distance: JSONDict["radius"] as! Double,
            owner: JSONDict["ownerEmail"] as! String,
            user: JSONDict["userEmail"] as! String,
            gameid: JSONDict["gameId"] as! Int,
            registered: JSONDict["totalRegistered"] as! Int,
            total: JSONDict["totalAllowed"] as! Int
          )
          strongSelf.activities.append(_activity)
        }
        strongSelf.tableView.reloadData()
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }

}
extension JoinExistingActivityViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "JoinAvailableActivitiesTableViewCell") as! JoinAvailableActivitiesTableViewCell
    cell.configure (
      arena: activities[indexPath.row].arena,
      sports: activities[indexPath.row].sport,
      distance: activities[indexPath.row].distance,
      start: parseIntergerTime(time: activities[indexPath.row].startTime),
      end: parseIntergerTime(time: activities[indexPath.row].endTime),
      activityOwner: activities[indexPath.row].user,
      arenaOwner: activities[indexPath.row].owner,
      playersRegistered: activities[indexPath.row].registered,
      maxPlayers: activities[indexPath.row].total
    )
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let params: [String : Any] = ["email": accountEmailId,
                  "userEmail": activities[indexPath.row].user,
                  "ownerEmail": activities[indexPath.row].owner,
                  "name": activities[indexPath.row].arena,
                  "gameid": activities[indexPath.row].gameid,
                  "latitude": latitude,
                  "longitude": longitude,
                  "start": activities[indexPath.row].startTime,
                  "end": activities[indexPath.row].endTime]
    showAlert(with: params, message: "Do you want to join this activity ?")
  }


}
