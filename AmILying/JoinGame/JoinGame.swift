//
//  JoinGame.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-24.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit
import Firebase

class JoinGame: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    let avatarArray = [("Mexican-Boss-icon", "Sombrero Sam"), ("Angel-icon", " Amy Angel "), ("Devil-icon", "Devil Dennis"), ("Caucasian-Female-Boss-icon", "Boss Bonnie"), ("Knight-icon", "Knight"), ("Police-Officer-icon", "Paul Police"),  ("Queen-icon", "Queen Quinn"), ("Professor-icon", "Professor Pi"), ("Themis-icon", "Themis Tammy"), ("Sheikh-icon", "Sheikh Sheldon"), ("Superman-icon", "Superman"), ("Teacher-icon", "Teacher Tess"), ("Wizard-icon", "Wizz Wizard"), ("Asian-Boss-icon", "Asian Al"), ("Asian-Female-Boss-icon", "Song Sing"), ("Chief-icon", "Office Otto"), ("Head-Physician-icon", "Doctor Derek"), ("Judge-icon", "Judge Jonas"), ("King-icon", "King Karl"), ("Old-Boss-icon", "Grumpy Gert"), ("Security-Guard-icon", "Agent Agon"), ("Uncle-Sam-icon", "Uncle Sammy"), ]
    
    var numberOfRounds: Int?
    var numberOfTeams: Int?
    var selectedAvatarString: String!
    
    @IBOutlet weak var inputGameIDTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var inputUsernameTextField: UITextField!
    
    @IBOutlet weak var joinGameButtonOutlet: UIButton!
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    @IBOutlet weak var selectedAvatar: UIImageView!
    @IBOutlet weak var backgroundToSelectedAvatar: UIView!
    @IBOutlet weak var gameIDVIew: UIViewX!
    @IBOutlet weak var gameIDImage: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var continueFromGameIDView: UIButton!
    @IBOutlet weak var gameIDLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        randomizeAvatar()
        setupViews()
        self.inputUsernameTextField.delegate = self
        self.inputGameIDTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupViews () {
        //POP UP VIEW
        self.gameIDVIew.frame.size = CGSize(width: view.frame.width * 0.8, height: 250)
        self.gameIDVIew.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY - 150)
        self.gameIDImage.frame = CGRect(x: 0, y: 0, width: self.gameIDVIew.frame.width, height: self.gameIDVIew.frame.height)
        
        self.inputGameIDTextField.frame.size = CGSize(width: self.gameIDVIew.frame.width * 0.7, height: 40)
        self.inputGameIDTextField.center = CGPoint(x: self.gameIDVIew.bounds.midX, y: self.gameIDVIew.bounds.midY)
        self.inputGameIDTextField.layer.cornerRadius = 3
        
        self.continueFromGameIDView.frame = CGRect(x: self.gameIDVIew.bounds.midX - 50, y: self.gameIDVIew.bounds.maxY - 60, width: 100, height: 44)
        self.gameIDLabel.frame = CGRect(x: self.inputGameIDTextField.frame.minX, y: self.inputGameIDTextField.frame.minY - 24, width: self.gameIDVIew.frame.width * 0.7, height: 21)

        //BlurView
        self.blurView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
   
        //Avatar CollectionView
        self.avatarCollectionView.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: view.frame.minY + (self.navigationController?.navigationBar.frame.size.height)! + avatarCollectionView.frame.height * 0.5, width: view.frame.size.width, height: 100 )
        
        //Selected Avatar
        self.backgroundToSelectedAvatar.frame.size = CGSize(width: 110, height: 110)
        self.backgroundToSelectedAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionView.frame.maxY + self.backgroundToSelectedAvatar.frame.height * 0.5 + 20)
        self.backgroundToSelectedAvatar.layer.cornerRadius = self.backgroundToSelectedAvatar.frame.size.width * 0.1
        self.selectedAvatar.frame.size = CGSize(width: 90, height: 90)
        self.selectedAvatar.center = CGPoint(x: self.backgroundToSelectedAvatar.bounds.midX, y: self.backgroundToSelectedAvatar.bounds.midY)
        
        //Username label
        self.inputUsernameTextField.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 44)
        self.inputUsernameTextField.center = CGPoint(x: view.center.x, y: self.backgroundToSelectedAvatar.frame.maxY + 65)
        self.usernameLabel.frame = CGRect(x: self.inputUsernameTextField.frame.minX + 2, y: self.inputUsernameTextField.frame.minY-26, width: self.view.frame.width * 0.7, height: 21)
        self.inputUsernameTextField.layer.cornerRadius = 3
        
        //Join game button
        self.joinGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 50)
        self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 45)
        self.joinGameButtonOutlet.layer.cornerRadius = 12
        
        
        
        //IPAD
        if view.frame.width > 450 {
            //POP UP VIEW
            self.gameIDVIew.frame.size = CGSize(width: view.frame.width * 0.6, height: 250)
            self.gameIDVIew.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY - 150)
            
            self.inputGameIDTextField.frame.size = CGSize(width: self.gameIDVIew.frame.width * 0.7, height: 50)
            self.inputGameIDTextField.center = CGPoint(x: self.gameIDVIew.bounds.midX, y: self.gameIDVIew.bounds.midY)
            self.inputGameIDTextField.layer.cornerRadius = 3
            
            self.continueFromGameIDView.frame = CGRect(x: self.gameIDVIew.bounds.midX - 40, y: self.gameIDVIew.bounds.maxY - 60, width: 80, height: 44)
            self.gameIDLabel.frame = CGRect(x: self.inputGameIDTextField.frame.minX, y: self.inputGameIDTextField.frame.minY - 34, width: self.gameIDVIew.frame.width * 0.7, height: 30)

            //Selected Avatar
            self.backgroundToSelectedAvatar.frame.size = CGSize(width: 220, height: 220)
            self.backgroundToSelectedAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionView.frame.maxY + self.backgroundToSelectedAvatar.frame.height * 0.5 + 20)
            self.backgroundToSelectedAvatar.layer.cornerRadius = self.backgroundToSelectedAvatar.frame.size.width * 0.1
            self.selectedAvatar.frame.size = CGSize(width: 140, height: 140)
            self.selectedAvatar.center = CGPoint(x: self.backgroundToSelectedAvatar.bounds.midX, y: self.backgroundToSelectedAvatar.bounds.midY)
            
            //Username label
            self.inputUsernameTextField.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 60)
            self.inputUsernameTextField.center = CGPoint(x: view.center.x, y: self.view.frame.midY + 40)
            self.usernameLabel.frame = CGRect(x: self.inputUsernameTextField.frame.minX + 5, y: self.inputUsernameTextField.frame.minY-42, width: self.view.frame.width * 0.7, height: 35)
            self.inputUsernameTextField.layer.cornerRadius = 3
            
            //Join game button
            self.joinGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 70)
            self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 100)

        }
        
        
        //IPHONE SE
        if view.frame.width < 350 {
            self.avatarCollectionView.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: view.frame.minY + 15 + avatarCollectionView.frame.height * 0.5, width: view.frame.size.width, height: 100 )
            
            //Selected Avatar
        self.backgroundToSelectedAvatar.frame.size = CGSize(width: 90, height: 90)
            self.backgroundToSelectedAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionView.frame.maxY + self.backgroundToSelectedAvatar.frame.height * 0.5 + 15)
            self.backgroundToSelectedAvatar.layer.cornerRadius = self.backgroundToSelectedAvatar.frame.size.width * 0.1
            self.selectedAvatar.frame.size = CGSize(width: 60, height: 60)
            self.selectedAvatar.center = CGPoint(x: self.backgroundToSelectedAvatar.bounds.midX, y: self.backgroundToSelectedAvatar.bounds.midY)
            
            
            self.inputUsernameTextField.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 40)
            self.inputUsernameTextField.center = CGPoint(x: view.center.x, y: self.view.frame.midY + 45)
           self.usernameLabel.frame = CGRect(x: self.inputUsernameTextField.frame.minX + 2, y: self.inputUsernameTextField.frame.minY-24, width: self.view.frame.width * 0.7, height: 21)
        self.inputUsernameTextField.layer.cornerRadius = 3
        }
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateGameIDView()
    }
    
    @IBAction func continueFromGameIDViewAction(_ sender: UIButton) {
        if inputGameIDTextField.text! != "" {
            
            let ref = Database.database().reference().child("games").child(inputGameIDTextField.text!)
            
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    UIView.animate(withDuration: 0.2) {
                        self.gameIDVIew.alpha = 0
                        self.blurView.alpha = 0
                    }
                }
                else {
                    self.gameIDVIew.shakeView()
                    self.alert(title: "Felaktigt Spel-ID", message: "Du behöver skriva in ett giltigt Spel-ID för att fortsätta")
                }
            })
        }
        else {
            self.gameIDVIew.shakeView()
            self.alert(title: "Saknar Spel-ID", message: "Skriv in Spel-ID för att gå vidare")
        }
    }
    
    func randomizeAvatar() {
        let random = arc4random_uniform(UInt32(avatarArray.count)-1)
        self.selectedAvatar.image = UIImage(named: avatarArray[Int(random)].0)
        self.selectedAvatarString = avatarArray[Int(random)].0
    }
    
    
    func animateGameIDView () {
        UIView.animate(withDuration: 0.3, animations: {
            self.gameIDVIew.center = self.view.center
        }) { (true) in
            self.gameIDVIew.shakeView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCollectionView", for: indexPath) as! AvatarCollectionCell
        
        cell.imageLabel.image = UIImage(named: avatarArray[indexPath.item].0)
        cell.nameLabel.text = avatarArray[indexPath.item].1
        cell.chooseAvatarButton.tag = indexPath.item
        cell.chooseAvatarButton.addTarget(self, action: #selector(self.selectAvatar), for: .touchUpInside)
        return cell
        
    }
    
    @objc func selectAvatar(_ sender: UIButton) {
        self.selectedAvatar.image = UIImage(named: avatarArray[sender.tag].0)
        
        self.selectedAvatarString = avatarArray[sender.tag].0
        
        self.backgroundToSelectedAvatar.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.backgroundToSelectedAvatar.transform = .identity
        })
        
    }
    
    
    @IBAction func joinGameButton(_ sender: UIButton) {
        joinNewGame()
        
    }
    
    func joinNewGame() {
        let ref = Database.database().reference().child("games").child(inputGameIDTextField.text!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let openToPlay = snapshot.childSnapshot(forPath: "game").childSnapshot(forPath: "open").value as! Bool
                self.numberOfRounds = snapshot.childSnapshot(forPath: "game").childSnapshot(forPath: "nrOfRounds").value as? Int
                self.numberOfTeams = snapshot.childSnapshot(forPath: "game").childSnapshot(forPath: "numberOfTeams").value as? Int
                
                if openToPlay {
                    if self.inputUsernameTextField.text != "" {
                        for child in [snapshot.childSnapshot(forPath: "players")] as [DataSnapshot]{
                            let player = (child.value as! [String: Any])
                            for playern in player.keys {
                                if playern == self.inputUsernameTextField.text! {
                                    self.alert(title: "Användarnamnet är upptaget", message: "Någon annan har redan tagit ditt önskade användarnamn, försök med ett annat.")
                                }
                            }
                        }
                        let player = [self.inputUsernameTextField.text!:["points": 0, "team": 0, "answer": "TBA", "avatar": self.selectedAvatarString, "redo": false, "secrets": ["1": "."]]] as [String: Any]
                        let playerRef = ref.child("players")
                        playerRef.updateChildValues(player)
                        self.performSegue(withIdentifier: "joinGameSegue", sender: self)
                    }
                    else {
                        self.alert(title: "Användarnamn saknas", message: "Du måste skriva in ett användarnamn för att starta spelet")
                    }
                }
                else {
                    self.alert(title: "Spelet är inte öppet för registrering", message: "Spelet har redan startat och är inte öppet för registrering. Vänta tills nästa omgång eller be spelledaren att starta om spelet för att bli insläppt.")
                }
            }
            else {
                self.alert(title: "Felaktigt ID", message: "...")
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WaitingForUsers {
            if let playerID = inputUsernameTextField.text {
                destination.playerID = playerID
            }
            if let gameID = inputGameIDTextField.text {
                destination.gameID = gameID
            }
            if let rounds = numberOfRounds{
                destination.numberOfRounds = rounds
            }
            if let teams = numberOfTeams{
                destination.numberOfTeams = teams
            }
        }
    }
    
    
    
    
    
}
