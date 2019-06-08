//
//  OwnerActivityTableViewCell.swift
//  Increff
//
//  Created by aditya.gh on 6/8/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit

class OwnerActivityTableViewCell: UITableViewCell {

  @IBOutlet private weak var arenaLabel: UILabel!
  @IBOutlet private weak var sportLabel: UILabel!
  @IBOutlet private weak var startTimeLabel: UILabel!
  @IBOutlet private weak var endTimeLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func configure(arena: String, sport: String, startTime: String, endTime: String) {
    self.arenaLabel.text = arena
    self.sportLabel.text = sport
    self.startTimeLabel.text = startTime
    self.endTimeLabel.text = endTime
  }

}
