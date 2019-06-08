//
//  LoginViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import Alamofire

public var accountEmailId: String!
public var mapIdToSports = [Int : String]()
public var mapSportsToId = [String : Int]()
public var sports = [String]()

class MainViewController: UIViewController {

  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var signupButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    getAllSports()
    setupView()
  }

  private func getAllSports() {
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("getAllSports")
    Alamofire.request(endpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      switch response.result {
      case .success(let JSON):
        guard let JSONArray = JSON as? [Any] else { return }
        for it in JSONArray {
          guard let JSONDict = it as? [String : Any] else { return }
          let id = JSONDict["id"] as! Int
          let sport = JSONDict["name"] as! String
          mapIdToSports[id] = sport
          mapSportsToId[sport] = id
          sports.append(sport)
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }

  private func setupView() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
    view.layer.insertSublayer(gradient, at: 0)

    loginButton.layer.borderWidth = 2
    loginButton.layer.borderColor = UIColor.white.cgColor
    loginButton.layer.cornerRadius = 10
    signupButton.layer.borderWidth = 2
    signupButton.layer.borderColor = UIColor.white.cgColor
    signupButton.layer.cornerRadius = 10
  }

  @IBAction func onTapLoginButton(_ sender: UIButton) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
      as? LoginViewController else {
        fatalError("Could not instantiate LoginViewController")
    }
    present(loginVC, animated: true, completion: nil)
  }

  @IBAction func onTapSignupButton(_ sender: UIButton) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let loginVC = storyBoard.instantiateViewController(withIdentifier: "SignupViewController")
      as? SignupViewController else {
        fatalError("Could not instantiate SignupViewController")
    }
    present(loginVC, animated: true, completion: nil)
  }
}

