//
//  SignupViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {

  @IBOutlet private weak var emailField: UITextField!
  @IBOutlet private weak var passwordField: UITextField!
  @IBOutlet private weak var reTypedPasswordField: UITextField!
  @IBOutlet private weak var signupButton: UIButton!
  @IBOutlet private weak var userButton: UIButton!
  @IBOutlet private weak var ownerButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
    view.layer.insertSublayer(gradient, at: 0)

    signupButton.layer.borderWidth = 2
    signupButton.layer.borderColor = UIColor.white.cgColor
    signupButton.layer.cornerRadius = 10
    userButton.layer.borderWidth = 2
    userButton.layer.borderColor = UIColor.white.cgColor
    userButton.layer.cornerRadius = 10
    ownerButton.layer.borderWidth = 2
    ownerButton.layer.borderColor = UIColor.white.cgColor
    ownerButton.layer.cornerRadius = 10
    disable(button: userButton)
    disable(button: ownerButton)
  }

  private func disable(button: UIButton) {
    button.alpha = 0.5
  }

  private func enable(button: UIButton) {
    button.alpha = 1.0
  }

  private func showAlert(with message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func onTapSignupButton(_ sender: UIButton) {
    if userButton.alpha == 0.5, ownerButton.alpha == 0.5 {
      showAlert(with: "Please select user / owner")
    }
    let email = emailField.text!
    let password = passwordField.text!
    let reTypedPassword = reTypedPasswordField.text!
    if email.isEmpty {
      showAlert(with: "Please enter an email-id")
      return
    }
    if password.count <= 8 {
      showAlert(with: "Password length must be greater than 8")
      return
    }
    if password != reTypedPassword {
      showAlert(with: "Password mismatch")
      return
    }
    var endpoint: String = Bundle.main.object(forInfoDictionaryKey: "baseURL") as! String
    endpoint.append("signUp")
    let type = (userButton.alpha == 1.0) ? 0 : 1
    let parameters: [String: Any] = ["email": email, "type": type, "password": password, "age": 20, "gender": "Male"]
    let headers = ["Content-Type": "application/json"]
    Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] (response) in
      guard let strongSelf = self else { return }
      let statusCode = response.response?.statusCode
      if statusCode == 200 {
        strongSelf.dismiss(animated: true, completion: nil)
      } else if statusCode == 402 {
        strongSelf.showAlert(with: "Email alredy registered")
      }
    }
  }
  @IBAction private func onTapCancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction private func onTapUserButton(_ sender: UIButton) {
    enable(button: userButton)
    disable(button: ownerButton)
  }
  @IBAction private func onTapOwnerButton(_ sender: UIButton) {
    enable(button: ownerButton)
    disable(button: userButton)
  }
}
