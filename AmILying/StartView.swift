//
//  ViewController.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-24.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit

class StartView: UIViewController {
    @IBOutlet weak var headLineImage: UIImageView!
    @IBOutlet weak var createGameButtonOutlet: UIButtonX!
    @IBOutlet weak var joinGameButtonOutlet: UIButtonX!
    @IBOutlet weak var faqButtonOutlet: UIButtonX!
    @IBOutlet weak var adminButtonOutlet: UIButton!
    
    @IBOutlet weak var adminLoginView: UIView!
    @IBOutlet weak var adminLoginLabel: UILabel!
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.startAnimation()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
       self.navigationController?.navigationBar.tintColor = UIColor.black

    }
    
    
    func setUpViews() {
        self.headLineImage.frame.size = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height*0.2)
        self.headLineImage.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY + self.view.frame.height * 0.2)
        
        if self.view.frame.width > 450 {
            self.createGameButtonOutlet.frame = CGRect(x: self.view.frame.midX - 160, y: self.view.frame.minY + 100, width: 320, height: 66)
            self.joinGameButtonOutlet.frame = CGRect(x: self.view.frame.midX - 160, y: self.view.frame.minY + 20, width: 320, height: 66)
            self.faqButtonOutlet.frame = CGRect(x: self.view.frame.midX - 160, y: self.view.frame.minY + 300, width: 320, height: 66)
        }
        else {
            self.createGameButtonOutlet.frame = CGRect(x: self.view.frame.midX - 70, y: self.view.frame.minY + 100, width: 140, height: 54)
            self.joinGameButtonOutlet.frame = CGRect(x: self.view.frame.midX - 70, y: self.view.frame.minY + 150, width: 140, height: 54)
            self.faqButtonOutlet.frame = CGRect(x: self.view.frame.midX - 70, y: self.view.frame.minY + 200, width: 140, height: 54)
        }
        
        self.adminButtonOutlet.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        
        self.createGameButtonOutlet.alpha = 0
        self.joinGameButtonOutlet.alpha = 0
        self.faqButtonOutlet.alpha = 0
        
        
        self.joinGameButtonOutlet.alpha = 0
        self.faqButtonOutlet.alpha = 0
    }
    
    
    func startAnimation() {

        
        UIView.animate(withDuration: 0.4, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.createGameButtonOutlet.alpha = 1
            if self.view.frame.width > 450 {
                self.createGameButtonOutlet.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 70)
            }
            else {
                self.createGameButtonOutlet.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 50)
            }
            
        }) { (true) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                self.joinGameButtonOutlet.alpha = 1
                if self.view.frame.width > 450 {
                    self.joinGameButtonOutlet.center = CGPoint(x: self.view.frame.midX, y: self.createGameButtonOutlet.frame.maxY + 72)
                }
                else {
                    self.joinGameButtonOutlet.center = CGPoint(x: self.view.frame.midX, y: self.createGameButtonOutlet.frame.maxY + 52)
                }
                
            }) { (true) in
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                    self.faqButtonOutlet.alpha = 1
                    if self.view.frame.width > 450 {
                        self.faqButtonOutlet.center = CGPoint(x: self.view.frame.midX, y: self.joinGameButtonOutlet.frame.maxY + 72)
                    }
                    else {
                        self.faqButtonOutlet.center = CGPoint(x: self.view.frame.midX, y: self.joinGameButtonOutlet.frame.maxY + 52)
                    }
                    
                    
                }) { (true) in
                    UIView.animate(withDuration: 0.8, delay: 0, options: .allowUserInteraction, animations: {
                        self.createGameButtonOutlet.transform = CGAffineTransform(scaleX: 1.3, y: 1.05)
                        
                        self.joinGameButtonOutlet.transform = CGAffineTransform(scaleX: 1.3, y: 1.05)
                        
                        self.faqButtonOutlet.transform = CGAffineTransform(scaleX: 1.3  , y: 1.05)

                    }, completion: nil)

                }
            }
        }
    }
    
    @IBAction func createGameButton(_ sender: UIButton) {
        self.createGameButtonOutlet.shakeView()
        self.performSegue(withIdentifier: "startToCreateSegue", sender: self)
    }
    
    @IBAction func joinGameButton(_ sender: UIButton) {
        self.joinGameButtonOutlet.shakeView()
        self.performSegue(withIdentifier: "startToJoinSegue", sender: self)
    }
    
    
    
    @IBAction func rulesButton(_ sender: UIButton) {
        self.faqButtonOutlet.shakeView()
        self.performSegue(withIdentifier: "startToRules", sender: self)
        
    }
    
    
    @IBAction func adminButton(_ sender: UIButton) {
        self.adminLoginView.alpha = 1
    }
    
    @IBAction func adminLoginButton(_ sender: UIButton) {
        if self.usernameLogin.text! == "Fredrik" && self.passwordLogin.text! == "Micke" {
            self.adminLoginView.alpha = 0
            self.performSegue(withIdentifier: "adminSegue", sender: self)
        }
        else {
            self.adminLoginView.alpha = 0
            self.alert(title: "Fel användarnamn eller lösenord", message: "Är du på rätt plats?")
        }
    }
    
}




