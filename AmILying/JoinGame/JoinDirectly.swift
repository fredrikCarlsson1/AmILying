//
//  JoinDirectly.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-28.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit
import Firebase

class JoinDirectly: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
        let avatarArray = [("Mexican-Boss-icon", "Sombrero Sam"), ("Angel-icon", " Amy Angel "), ("Devil-icon", "Devil Dennis"), ("Caucasian-Female-Boss-icon", "Boss Bonnie"), ("Knight-icon", "Knight"), ("Police-Officer-icon", "Paul Police"),  ("Queen-icon", "Queen Quinn"), ("Professor-icon", "Professor Pi"), ("Themis-icon", "Themis Tammy"), ("Sheikh-icon", "Sheikh Sheldon"), ("Superman-icon", "Superman"), ("Teacher-icon", "Teacher Tess"), ("Wizard-icon", "Wizz Wizard"), ("Asian-Boss-icon", "Asian Al"), ("Asian-Female-Boss-icon", "Song Sing"), ("Chief-icon", "Office Otto"), ("Head-Physician-icon", "Doctor Derek"), ("Judge-icon", "Judge Jonas"), ("King-icon", "King Karl"), ("Old-Boss-icon", "Grumpy Gert"), ("Security-Guard-icon", "Agent Agon"), ("Uncle-Sam-icon", "Uncle Sammy"), ]
    
    var numberOfRounds: Int?
    var numberOfTeams: Int?
    var selectedAvatarString: String!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var avatarCollectionViewen: UICollectionView!
    @IBOutlet weak var backgroundToSelectedAvatar: UIViewX!
    @IBOutlet weak var selectedAvatar: UIImageView!
    @IBOutlet weak var joinGameButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        randomizeAvatar()
        setUpView()
        self.usernameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
    func setUpView () {

        //Avatar CollectionView
        self.avatarCollectionViewen.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: view.frame.minY + 20 + avatarCollectionViewen.frame.height * 0.5, width: view.frame.size.width, height: 100 )
        
        //Selected Avatar
        self.backgroundToSelectedAvatar.frame.size = CGSize(width: 110, height: 110)
        self.backgroundToSelectedAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionViewen.frame.maxY + self.backgroundToSelectedAvatar.frame.height * 0.5 + 20)
        self.backgroundToSelectedAvatar.layer.cornerRadius = self.backgroundToSelectedAvatar.frame.size.width * 0.1
        self.selectedAvatar.frame.size = CGSize(width: 90, height: 90)
        self.selectedAvatar.center = CGPoint(x: self.backgroundToSelectedAvatar.bounds.midX, y: self.backgroundToSelectedAvatar.bounds.midY)
        
        //Username label
        self.usernameTextField.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 44)
        self.usernameTextField.center = CGPoint(x: view.center.x, y: self.backgroundToSelectedAvatar.frame.maxY + 65)
        self.usernameLabel.frame = CGRect(x: self.usernameTextField.frame.minX + 2, y: self.usernameTextField.frame.minY-26, width: self.view.frame.width * 0.7, height: 21)
        self.usernameTextField.layer.cornerRadius = 3
        
        //Join game button
        self.joinGameButtonOutlet.frame.size = CGSize(width: 140, height: 44)
        self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 80)
        self.joinGameButtonOutlet.layer.cornerRadius = 12
        
        
        
        //IPAD
        if view.frame.width > 450 {

            
            //Selected Avatar
            self.backgroundToSelectedAvatar.frame.size = CGSize(width: 220, height: 220)
            self.backgroundToSelectedAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionViewen.frame.maxY + self.backgroundToSelectedAvatar.frame.height * 0.5 + 20)
            self.backgroundToSelectedAvatar.layer.cornerRadius = self.backgroundToSelectedAvatar.frame.size.width * 0.1
            self.selectedAvatar.frame.size = CGSize(width: 140, height: 140)
            self.selectedAvatar.center = CGPoint(x: self.backgroundToSelectedAvatar.bounds.midX, y: self.backgroundToSelectedAvatar.bounds.midY)
            
            //Username label
            self.usernameTextField.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 60)
            self.usernameTextField.center = CGPoint(x: view.center.x, y: self.view.frame.midY + 40)
            self.usernameLabel.frame = CGRect(x: self.usernameTextField.frame.minX + 5, y: self.usernameTextField.frame.minY-42, width: self.view.frame.width * 0.7, height: 35)
            self.usernameTextField.layer.cornerRadius = 3
            
            //Join game button
            self.joinGameButtonOutlet.frame.size = CGSize(width: 220, height: 54)
            self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 100)
            self.joinGameButtonOutlet.layer.cornerRadius = 14
        }
    }
    
    func randomizeAvatar() {
        let random = arc4random_uniform(UInt32(avatarArray.count)-1)
        self.selectedAvatar.image = UIImage(named: avatarArray[Int(random)].0)
        self.selectedAvatarString = avatarArray[Int(random)].0
        
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
        self.joinNewGame()
    }
    
    func joinNewGame() {
        if AppDelegate.GameID != nil {
            let ref = Database.database().reference().child("games").child(AppDelegate.GameID!)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    let openToPlay = snapshot.childSnapshot(forPath: "game").childSnapshot(forPath: "open").value as! Bool
                    self.numberOfRounds = snapshot.childSnapshot(forPath: "game").childSnapshot(forPath: "nrOfRounds").value as? Int
                    self.numberOfTeams = snapshot.childSnapshot(forPath: "game").childSnapshot(forPath: "numberOfTeams").value as? Int
                    if openToPlay {
                        if self.usernameTextField.text != "" {
                            for child in [snapshot.childSnapshot(forPath: "players")] as [DataSnapshot]{
                                let player = (child.value as! [String: Any])
                                for playern in player.keys {
                                    if playern == self.usernameTextField.text! {
                                        self.alert(title: "Användarnamnet är upptaget", message: "Någon annan har redan tagit ditt önskade användarnamn, försök med ett annat.")
                                    }
                                }
                            }
                            let player = [self.usernameTextField.text!:["points": 0, "answer": "TBA", "avatar": self.selectedAvatarString,"redo": false, "team": 0, "secrets": [String]()]] as [String: Any]
                            let playerRef = ref.child("players")
                            playerRef.updateChildValues(player)
                            self.performSegue(withIdentifier: "joinDirectlySegue", sender: self)
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
        else {
            self.alert(title: "Någonting blev fel", message: "")
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WaitingForUsers {
            if let playerID = usernameTextField.text {
                destination.playerID = playerID
            }
            if let gameID = AppDelegate.GameID {
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
