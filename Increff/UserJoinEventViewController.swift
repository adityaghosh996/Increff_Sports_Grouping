//
//  UserJoinEventViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/9/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import RSSelectionMenu

public var selectedSportArray = [Int]()

class UserJoinEventViewController: UIViewController {

  @IBOutlet private weak var radiusField: UITextField!
  @IBOutlet private weak var selectSportButton: UIButton!
  @IBOutlet weak var createButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    hyperLocalRadius = nil
  }

  private func setupView() {
    createButton.layer.borderWidth = 2.0
    createButton.layer.borderColor = UIColor.black.cgColor
    createButton.layer.cornerRadius = 10
  }

  private func showAlert(with message: String) {
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func onTapSelectSportButton(_ sender: UIButton) {
    let selectedNames = [String]()
    selectedSportArray = [Int]()
    let menu = RSSelectionMenu(selectionStyle: .multiple, dataSource: sports) { (cell, name, indexPath) in
      cell.textLabel?.text = name
    }
    menu.cellSelectionStyle = .tickmark
    menu.setSelectedItems(items: selectedNames, maxSelected: UInt(sports.count)) { (name, _, _, _) in
      selectedSportArray.append(mapSportsToId[name!]!)
    }
    menu.show(from: self)
  }

  @IBAction func onTapCreateEventButton(_ sender: UIButton) {
    if selectedSportArray.count == 0 {
      showAlert(with: "Please select a sport")
      return
    }
    if (radiusField.text?.isEmpty)! {
      showAlert(with: "Please enter the hyper locality radius")
      return
    }
    guard let radius = Double(radiusField.text!) else {
      showAlert(with: "Please enter a numerical radius")
      return
    }
    if radius <= 0 {
      showAlert(with: "Please enter a radius greater than 0")
      return
    }
    hyperLocalRadius = radius
    presentJoinExistingActivityViewController()
  }

  private func presentJoinExistingActivityViewController() {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let joinExistingActivityVC = storyBoard.instantiateViewController(withIdentifier: "JoinExistingActivityViewController")
      as? JoinExistingActivityViewController else {
        fatalError("Could not instantiate JoinExistingActivityViewController")
    }
    present(joinExistingActivityVC, animated: true, completion: nil)
  }

}
