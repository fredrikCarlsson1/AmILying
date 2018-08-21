//
//  KickPlayerCell.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-07-23.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit

class KickPlayerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kickButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
