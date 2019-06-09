//
//  OwnerViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import Alamofire

struct Activity {
  var arena: String
  var sport: String
  var startTime: String
  var endTime: String
}

class OwnerViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  private var activities = [Activity]()
  override func viewDidLoad() {
    super.viewDidLoad()
    getAllActivities()
  }

  override func viewWillAppear(_ animated: Bool) {
    getAllActivities()
  }

  private func getSport(with id: Int) -> String {
    return mapIdToSports[id]!
  }

  private func getAllActivities() {
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("getAllActivities")
    let parameters = ["email": accountEmailId!]
    let headers = ["Content-Type": "application/json"]
    Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] (response) in
      guard let strongSelf = self else { return }
      switch response.result {
      case .success(let JSON):
        guard let JSONArray = JSON as? [Any] else { return }
        strongSelf.activities.removeAll()
        for it in JSONArray {
          guard let JSONDict = it as? [String : Any] else { return }
          let _activity = Activity (
            arena: JSONDict["name"] as! String,
            sport: strongSelf.getSport(with: JSONDict["gameid"] as! Int),
            startTime: JSONDict["startString"] as! String,
            endTime: JSONDict["endString"] as! String
          )
          strongSelf.activities.append(_activity)
        }
        strongSelf.tableView.reloadData()
      case .failure(let err):
        print(err.localizedDescription)
        fatalError()
      }
    }
  }

  @IBAction func addActivity(_ sender: UIBarButtonItem) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let ownerVC = storyBoard.instantiateViewController(withIdentifier: "AddAcitivityViewController")
      as? AddAcitivityViewController else {
        fatalError("Could not instantiate AddAcitivityViewController")
    }
    present(ownerVC, animated: true, completion: nil)
  }
}

extension OwnerViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerActivityTableViewCell") as! OwnerActivityTableViewCell
    cell.configure(
      arena: activities[indexPath.row].arena,
      sport: activities[indexPath.row].sport,
      startTime: activities[indexPath.row].startTime,
      endTime: activities[indexPath.row].endTime
    )
    return cell
  }


}
