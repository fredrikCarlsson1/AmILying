//
//  RulesAndTips.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-08-07.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit

class RulesAndTips: UIViewController {
    
    @IBOutlet weak var rulesView: UIView!
    @IBOutlet weak var rulesImageView: UIImageView!
    
    @IBOutlet weak var rulesTextView: UITextView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var blurViewButtonOutlet: UIButton!
    
    @IBOutlet weak var rulesAndTipsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
    }
    
    override func viewDidLayoutSubviews() {
        rulesTextView.setContentOffset(.zero, animated: false)
    }

    func setUpViews() {
        self.blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.blurViewButtonOutlet.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.rulesView.frame = CGRect(x: self.view.frame.width * 0.1, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.6 )
        self.rulesImageView.frame = CGRect(x: 0, y: 0, width: self.rulesView.frame.width, height: self.rulesView.frame.height)
        self.rulesAndTipsLabel.frame = CGRect(x: 0, y: self.rulesView.frame.height * 0.08, width: self.rulesView.frame.width, height: 40)
        self.rulesTextView.frame = CGRect(x: self.rulesView.frame.width * 0.1, y: self.rulesAndTipsLabel.frame.maxY + 5, width: self.rulesView.frame.width * 0.8, height: self.rulesView.frame.height * 0.7)
    }
    
    @IBAction func blurViewButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}











