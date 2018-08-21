//
//  GameLobbyHeaderCell.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-30.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit

class GameLobbyHeaderCell: UITableViewCell {
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
