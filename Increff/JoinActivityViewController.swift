//
//  JoinActivityViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/9/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

public struct UserActivity {
  var arena: String
  var sport: String
  var startTime: Int
  var endTime: Int
  var distance: Double
  var owner: String
  var gameid: Int
}

var selectedUserActivity: UserActivity?

class JoinActivityViewController: UIViewController {

  var latitude: Double?
  var longitude: Double?
  var activities = [UserActivity]()
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
    getActivitiesToCreate()
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

  private func getSport(with id: Int) -> String {
    return mapIdToSports[id]!
  }

  private func getActivitiesToCreate() {
    var sports = [Int]()
    sports.append(mapSportsToId[selectedSport!]!)
    let params: [String : Any] = ["email" : accountEmailId,
                                  "integerList": sports,
                                  "radius": hyperLocalRadius,
                                  "latitude": latitude ?? 0,
                                  "longitude": longitude ?? 0]
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("getActivitiesToCreate")
    Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self] (response) in
      guard let strongSelf = self else { return }
      switch response.result {
      case .success(let JSON):
        guard let JSONArray = JSON as? [Any] else { return }
        strongSelf.activities.removeAll()
        for it in JSONArray {
          guard let JSONDict = it as? [String : Any] else { return }
          let _activity = UserActivity (arena: JSONDict["name"] as! String,
                                        sport: strongSelf.getSport(with: JSONDict["gameid"] as! Int),
                                        startTime: JSONDict["start"] as! Int,
                                        endTime: JSONDict["end"] as! Int,
                                        distance: JSONDict["distance"] as! Double,
                                        owner: JSONDict["ownerEmail"] as! String,
                                        gameid: JSONDict["gameid"] as! Int)
          strongSelf.activities.append(_activity)
        }
        strongSelf.tableView.reloadData()
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }

}

extension JoinActivityViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CreateActivityTableViewCell") as! CreateActivityTableViewCell
    cell.configure(arena: activities[indexPath.row].arena,
                   distance: activities[indexPath.row].distance,
                   start: parseIntergerTime(time: activities[indexPath.row].startTime),
                   end: parseIntergerTime(time: activities[indexPath.row].endTime),
                   owner: activities[indexPath.row].owner)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let VC = storyBoard.instantiateViewController(withIdentifier: "CreateActivityByUserViewController")
      as? CreateActivityByUserViewController else {
        fatalError("Could not instantiate CreateActivityByUserViewController")
    }
    selectedUserActivity = UserActivity(arena: activities[indexPath.row].arena,
                                        sport: selectedSport!,
                                        startTime: activities[indexPath.row].startTime,
                                        endTime: activities[indexPath.row].endTime,
                                        distance: activities[indexPath.row].distance,
                                        owner: activities[indexPath.row].owner,
                                        gameid: activities[indexPath.row].gameid)
    present(VC, animated: true, completion: nil)
  }


}
