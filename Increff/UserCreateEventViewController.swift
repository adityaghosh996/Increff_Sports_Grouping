//
//  UserCreateEventViewController.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit
import RSSelectionMenu

class UserCreateEventViewController: UIViewController {

  @IBOutlet private weak var radiusField: UITextField!
  @IBOutlet private weak var selectSportButton: UIButton!
  @IBOutlet weak var createButton: UIButton!
  public var selectedSport: String?
  public var hyperLocalRadius: Double?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    selectedSport = nil
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

  @IBAction func onTapCreateEventButton(_ sender: UIButton) {
    guard let sport = selectedSport else {
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
    presentJoinActivityViewController()
  }

  private func presentJoinActivityViewController() {

  }

}
