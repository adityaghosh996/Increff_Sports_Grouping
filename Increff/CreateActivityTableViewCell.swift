//
//  JoinActivityTableViewCell.swift
//  Increff
//
//  Created by aditya.gh on 6/9/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit

class CreateActivityTableViewCell: UITableViewCell {


  @IBOutlet private weak var arenaLabel: UITextField!
  @IBOutlet private weak var distanceLabel: UITextField!
  @IBOutlet private weak var startLabel: UITextField!
  @IBOutlet private weak var endLabel: UITextField!
  @IBOutlet private weak var ownerLabel: UITextField!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func configure(arena: String, distance: Double, start: String, end: String, owner: String) {
    self.arenaLabel.text = arena
    self.distanceLabel.text = String(distance)
    self.startLabel.text = start
    self.endLabel.text = end
    self.ownerLabel.text = owner
  }

}
