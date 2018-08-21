//
//  MultiPlayerCollectionViewCell.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-07-24.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit

class MultiPlayerCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var players = [Player]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellInMulltiPlayerCollectionView", for: indexPath) as! InnerCollectionViewCell
        let player = players[indexPath.item]
        cell.avatarImage.image = UIImage(named: player.avatar)
        cell.nameLabel.text = player.name
        
        return cell
    }
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var innerCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.innerCollectionView.delegate = self
        self.innerCollectionView.dataSource = self
    }
    
}
