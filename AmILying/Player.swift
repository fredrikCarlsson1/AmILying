//
//  Player.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-25.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import Foundation
import Firebase

class Player {
    var key: String
    var name: String
    var points: Int
    var team: Int
    var index: Int
    var secrets: [String]?
    var answer: String
    var avatar: String
    var isHost: Bool?
    
    init (key: String, name: String, points: Int, team: Int, answer: String, avatar: String, index: Int){
        self.key = key
        self.name = name
        self.points = points
        self.team = team
        self.answer = answer
        self.avatar = avatar
        self.index = index

        
        
    }
    
    
}
