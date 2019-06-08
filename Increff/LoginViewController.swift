
//
//  LoginViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

  @IBOutlet private weak var emailField: UITextField!
  @IBOutlet private weak var passwordField: UITextField!
  @IBOutlet private weak var loginButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
    view.layer.insertSublayer(gradient, at: 0)

    loginButton.layer.borderWidth = 2
    loginButton.layer.borderColor = UIColor.white.cgColor
    loginButton.layer.cornerRadius = 10
  }

  private func showAlert(with message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func onTapLoginButton(_ sender: UIButton) {
    let email = emailField.text!
    let password = passwordField.text!
    if email.isEmpty {
      showAlert(with: "Enter email id")
    }
    if password.isEmpty {
      showAlert(with: "Enter password")
    }
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("login")
    let parameters: [String: Any] = ["email": email, "password": password]
    let headers = ["Content-Type": "application/json"]
    Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] (response) in
      guard let strongSelf = self else { return }
      let status = response.response?.statusCode
      if status == 400 {
        strongSelf.showAlert(with: "Invalid Password")
        return
      } else if status == 401 {
        strongSelf.showAlert(with: "Email doesn't exist")
        return
      }
      switch response.result {
      case .success(let val):

        accountEmailId = email
        if (val as! Int) == 1 {
          strongSelf.presentOwnerViewController()
        } else {
          strongSelf.presentUserViewController()
        }

      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
  @IBAction func onTapCancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  private func presentOwnerViewController() {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let ownerVC = storyBoard.instantiateViewController(withIdentifier: "OwnerViewController")
      as? OwnerViewController else {
        fatalError("Could not instantiate OwnerViewController")
    }
    present(ownerVC, animated: true, completion: nil)
  }

  private func presentUserViewController() {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let userVC = storyBoard.instantiateViewController(withIdentifier: "UserViewController")
      as? UserViewController else {
        fatalError("Could not instantiate UserViewController")
    }
    present(userVC, animated: true, completion: nil)
  }
}

