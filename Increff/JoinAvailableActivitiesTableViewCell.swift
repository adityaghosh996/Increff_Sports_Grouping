//
//  JoinAvailableActivitiesTableViewCell.swift
//  Increff
//
//  Created by aditya.gh on 6/9/19.
//  Copyright © 2019 Aditya Ghosh. All rights reserved.
//

import UIKit

class JoinAvailableActivitiesTableViewCell: UITableViewCell {

  @IBOutlet weak var arena: UITextField!
  @IBOutlet weak var sports: UITextField!
  @IBOutlet weak var distance: UITextField!
  @IBOutlet weak var start: UITextField!
  @IBOutlet weak var end: UITextField!
  @IBOutlet weak var activityOwner: UITextField!
  @IBOutlet weak var arenaOwner: UITextField!
  @IBOutlet weak var playersRegistered: UITextField!
  override func awakeFromNib() {
    super.awakeFromNib()
    self.arena.isUserInteractionEnabled = false
    self.sports.isUserInteractionEnabled = false
    self.distance.isUserInteractionEnabled = false
    self.start.isUserInteractionEnabled = false
    self.end.isUserInteractionEnabled = false
    self.activityOwner.isUserInteractionEnabled = false
    self.arenaOwner.isUserInteractionEnabled = false
    self.playersRegistered.isUserInteractionEnabled = false
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func configure (
    arena: String,
    sports: String,
    distance: Double,
    start: String,
    end: String,
    activityOwner: String,
    arenaOwner: String,
    playersRegistered: Int,
    maxPlayers: Int
    ) {
    self.arena.text = arena
    self.sports.text = sports
    self.distance.text = String(distance)
    self.start.text = start
    self.end.text = end
    self.activityOwner.text = activityOwner
    self.arenaOwner.text = arenaOwner
    var players = String(playersRegistered)
    players.append(" / ")
    players.append(String(maxPlayers))
    self.playersRegistered.text = players
  }

}
