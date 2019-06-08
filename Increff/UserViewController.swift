//
//  UserViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

  @IBOutlet private weak var createButton: UIButton!
  @IBOutlet private weak var joinButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    createButton.layer.borderWidth = 2.0
    createButton.layer.borderColor = UIColor.black.cgColor
    createButton.layer.cornerRadius = 10
    joinButton.layer.borderWidth = 2.0
    joinButton.layer.borderColor = UIColor.black.cgColor
    joinButton.layer.cornerRadius = 10
  }

  @IBAction func onTapCreateButton(_ sender: UIButton) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let userCreateVC = storyBoard.instantiateViewController(withIdentifier: "UserCreateEventViewController")
      as? UserCreateEventViewController else {
        fatalError("Could not instantiate UserCreateEventViewController")
    }
    present(userCreateVC, animated: true, completion: nil)
  }


  @IBAction func onTapJoinButton(_ sender: UIButton) {
  }
}
