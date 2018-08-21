//
//  CreateNewGame.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-24.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit
import Firebase

class CreateNewGame: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    let avatarArray = [("Mexican-Boss-icon", "Sombrero Sam"), ("Angel-icon", " Amy Angel "), ("Devil-icon", "Devil Dennis"), ("Caucasian-Female-Boss-icon", "Boss Bonnie"), ("Knight-icon", "Knight"), ("Police-Officer-icon", "Paul Police"),  ("Queen-icon", "Queen Quinn"), ("Professor-icon", "Professor Pi"), ("Themis-icon", "Themis Tammy"), ("Sheikh-icon", "Sheikh Sheldon"), ("Superman-icon", "Superman"), ("Teacher-icon", "Teacher Tess"), ("Wizard-icon", "Wizz Wizard"), ("Asian-Boss-icon", "Asian Al"), ("Asian-Female-Boss-icon", "Song Sing"), ("Chief-icon", "Office Otto"), ("Head-Physician-icon", "Doctor Derek"), ("Judge-icon", "Judge Jonas"), ("King-icon", "King Karl"), ("Old-Boss-icon", "Grumpy Gert"), ("Security-Guard-icon", "Agent Agon"), ("Uncle-Sam-icon", "Uncle Sammy"), ]
    
    
    var gameID: String?
    var userName: String?
    var playerID: String?
    var numberOfRounds = 1
    var numberOfTeams = 0
    var selectedAvatarString: String!
    

    @IBOutlet weak var avatarCollectionView: UICollectionView!
    @IBOutlet weak var backgroundBehindAvatar: UIViewX!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var joinGameButtonOutlet: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var teamSettingsView: UIViewX!
    @IBOutlet weak var teamSettingsLabel: UILabel!
    @IBOutlet weak var singelOrTeamSegmentedControl: UISegmentedControl!
    @IBOutlet weak var labelUnderSegmentedControl: UILabel!
    

    @IBOutlet weak var roundsPerPlayerView: UIViewX!
    @IBOutlet weak var roundsPerPlayerLabel: UILabel!
    @IBOutlet weak var roundsPerPlayerStepper: UIStepper!
    @IBOutlet weak var roundsPerPlayerCounter: UILabel!
    @IBOutlet weak var viewThatSplitsScreen: UIView!
    @IBOutlet weak var infoTeamSettings: UIButtonX!
    @IBOutlet weak var infoNumberOfSecrets: UIButtonX!
    
    @IBOutlet weak var infoView: UIViewX!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var blurViewButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeAvatar()
        hideKeyboardWhenTappedAround()
        setUpViews()
        self.userNameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setUpViews() {
        self.blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.blurViewButtonOutlet.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.blurView.alpha = 0
        self.infoView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.3)
        self.infoView.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY - self.view.frame.height * 0.2)
        self.infoTextView.frame = CGRect(x: self.infoView.frame.width * 0.1, y: self.infoTextView.frame.height * 0.1, width: self.infoView.frame.width * 0.8, height: self.infoView.frame.height * 0.8)
        
        if view.frame.width > 450 {
            self.avatarCollectionView.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: view.frame.minY + (self.navigationController?.navigationBar.frame.size.height)! + avatarCollectionView.frame.height * 0.3, width: view.frame.size.width, height: 100 )
            
            
            //TODO:
            self.backgroundBehindAvatar.frame.size = CGSize(width: 260, height: 260)
            self.backgroundBehindAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionView.frame.maxY + self.backgroundBehindAvatar.frame.height * 0.5 + 20)
            self.backgroundBehindAvatar.layer.cornerRadius = self.backgroundBehindAvatar.frame.size.width * 0.1
            self.avatarImageView.frame.size = CGSize(width: 200, height: 200)
            self.avatarImageView.center = CGPoint(x: self.backgroundBehindAvatar.bounds.midX, y: self.backgroundBehindAvatar.bounds.midY)
            
            self.userNameTextField.frame = CGRect(x: self.view.frame.midX - self.view.frame.width * 0.35, y: self.backgroundBehindAvatar.frame.maxY + 30, width: self.view.frame.width * 0.7, height: 66)
            self.userNameTextField.layer.cornerRadius = 3
            
            self.viewThatSplitsScreen.frame = CGRect(x: self.view.frame.width*0.05, y: self.userNameTextField.frame.maxY + 50, width: self.view.frame.width * 0.9, height: 2)
            
            
            //Antal lag
            self.teamSettingsView.frame = CGRect(x: self.view.frame.width*0.03, y: self.viewThatSplitsScreen.frame.maxY + 30, width: self.view.frame.width*0.45, height: self.view.frame.height*0.20)
            self.infoTeamSettings.frame = CGRect(x: self.teamSettingsView.bounds.maxX - 35 , y: self.teamSettingsView.bounds.minY + 4, width: 30, height: 30)
            self.infoTeamSettings.layer.cornerRadius = 15
            self.teamSettingsLabel.frame = CGRect(x: self.teamSettingsView.bounds.minX + 18, y: self.infoTeamSettings.frame.maxY + 4, width: self.teamSettingsView.frame.width - 10, height: 30)
            self.labelUnderSegmentedControl.frame = CGRect(x: self.teamSettingsView.bounds.minX + 5, y: self.teamSettingsView.bounds.midY - 20 , width: self.teamSettingsView.frame.width - 10, height: 30)
            self.singelOrTeamSegmentedControl.frame = CGRect(x: self.teamSettingsView.bounds.minX + 30, y: self.labelUnderSegmentedControl.frame.maxY + 15, width: self.teamSettingsView.frame.width - 60, height: 30)
            
            
            
            //Rundor per spelare
            self.roundsPerPlayerView.frame = CGRect(x: self.view.frame.width*0.52, y: self.viewThatSplitsScreen.frame.maxY + 30, width: self.view.frame.width*0.45, height: self.view.frame.height*0.20)
            self.infoNumberOfSecrets.frame = CGRect(x: self.roundsPerPlayerView.bounds.maxX - 35 , y: self.roundsPerPlayerView.bounds.minY + 4, width: 30, height: 30)
            self.infoNumberOfSecrets.layer.cornerRadius = 15
            self.roundsPerPlayerLabel.frame = CGRect(x: self.roundsPerPlayerView.bounds.minX + 18, y: self.infoNumberOfSecrets.frame.maxY + 4, width: self.roundsPerPlayerView.frame.width - 10, height: 40)
 
            
            self.roundsPerPlayerCounter.frame = CGRect(x: self.roundsPerPlayerView.bounds.minX + 5, y: self.roundsPerPlayerView.bounds.midY - 20 , width: self.roundsPerPlayerView.frame.width - 10, height: 30)
            self.roundsPerPlayerStepper.frame = CGRect(x: self.roundsPerPlayerView.bounds.midX - self.roundsPerPlayerStepper.frame.width * 0.5, y: self.roundsPerPlayerCounter.frame.maxY + 15 , width: self.roundsPerPlayerView.frame.width - 10, height: 40)
            
            
            
            self.joinGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 78)
            self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 86)
            
            
        }
        else if view.frame.width < 350 {
            self.avatarCollectionView.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: view.frame.minY + (self.navigationController?.navigationBar.frame.size.height)! + avatarCollectionView.frame.height * 0.35, width: view.frame.size.width, height: 100 )
            
            self.backgroundBehindAvatar.frame.size = CGSize(width: 80, height: 80)
            self.backgroundBehindAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionView.frame.maxY + self.backgroundBehindAvatar.frame.height * 0.5 + 20)
            self.backgroundBehindAvatar.layer.cornerRadius = self.backgroundBehindAvatar.frame.size.width * 0.1
            self.avatarImageView.frame.size = CGSize(width: 60, height: 60)
            self.avatarImageView.center = CGPoint(x: self.backgroundBehindAvatar.bounds.midX, y: self.backgroundBehindAvatar.bounds.midY)
            
            self.userNameTextField.frame = CGRect(x: self.view.frame.midX - self.view.frame.width * 0.4, y: self.backgroundBehindAvatar.frame.maxY + 10, width: self.view.frame.width * 0.8, height: 34)
            self.userNameTextField.layer.cornerRadius = 3
            
            self.viewThatSplitsScreen.frame = CGRect(x: self.view.frame.width*0.1, y: self.userNameTextField.frame.maxY + 20, width: self.view.frame.width * 0.8, height: 2)
            
            
            //Antal lag
            self.teamSettingsView.frame = CGRect(x: self.view.frame.width*0.03, y: self.viewThatSplitsScreen.frame.maxY + 12, width: self.view.frame.width*0.45, height: self.view.frame.height*0.20)
            self.infoTeamSettings.frame = CGRect(x: self.teamSettingsView.bounds.maxX - 22 , y: self.teamSettingsView.bounds.minY + 2, width: 18, height: 18)
            self.teamSettingsLabel.frame = CGRect(x: self.teamSettingsView.bounds.minX + 8, y: self.infoTeamSettings.frame.maxY, width: self.teamSettingsView.frame.width - 10, height: 21)
            self.labelUnderSegmentedControl.frame = CGRect(x: self.teamSettingsView.bounds.minX + 5, y: self.teamSettingsView.bounds.midY - 20 , width: self.teamSettingsView.frame.width - 10, height: 21)
            self.singelOrTeamSegmentedControl.frame = CGRect(x: self.teamSettingsView.bounds.minX + 30, y: self.labelUnderSegmentedControl.frame.maxY + 10, width: self.teamSettingsView.frame.width - 60, height: 25)
            
            
            
            //Rundor/spelare
            self.roundsPerPlayerView.frame = CGRect(x: self.view.frame.width*0.52, y: self.viewThatSplitsScreen.frame.maxY + 12, width: self.view.frame.width*0.45, height: self.view.frame.height*0.20)
            self.infoNumberOfSecrets.frame = CGRect(x: self.roundsPerPlayerView.bounds.maxX - 22 , y: self.roundsPerPlayerView.bounds.minY + 2, width: 18, height: 18)
            self.roundsPerPlayerLabel.frame = CGRect(x: self.roundsPerPlayerView.bounds.minX + 8, y: self.infoNumberOfSecrets.frame.maxY, width: self.roundsPerPlayerView.frame.width - 10, height: 21)
            self.roundsPerPlayerLabel.text = "Rundor/spelare"
            self.roundsPerPlayerCounter.frame = CGRect(x: self.roundsPerPlayerView.bounds.minX + 5, y: self.roundsPerPlayerView.bounds.midY - 20 , width: self.roundsPerPlayerView.frame.width - 10, height: 25)
            self.roundsPerPlayerStepper.frame = CGRect(x: self.roundsPerPlayerView.bounds.midX - self.roundsPerPlayerStepper.frame.width * 0.5, y: self.roundsPerPlayerCounter.frame.maxY + 10 , width: self.roundsPerPlayerView.frame.width - 10, height: 40)
            

            self.joinGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 54)
            self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 48)
        }
        
        else {
        self.avatarCollectionView.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: view.frame.minY + (self.navigationController?.navigationBar.frame.size.height)! + avatarCollectionView.frame.height * 0.41, width: view.frame.size.width, height: 100 )
            
        self.backgroundBehindAvatar.frame.size = CGSize(width: 110, height: 110)
        self.backgroundBehindAvatar.center = CGPoint(x: self.view.center.x, y: self.avatarCollectionView.frame.maxY + self.backgroundBehindAvatar.frame.height * 0.5 + self.view.frame.height*0.025)
        self.backgroundBehindAvatar.layer.cornerRadius = self.backgroundBehindAvatar.frame.size.width * 0.1
        self.avatarImageView.frame.size = CGSize(width: 90, height: 90)
        self.avatarImageView.center = CGPoint(x: self.backgroundBehindAvatar.bounds.midX, y: self.backgroundBehindAvatar.bounds.midY)
            
            
        self.userNameTextField.frame = CGRect(x: self.view.frame.midX - self.view.frame.width * 0.4, y: self.backgroundBehindAvatar.frame.maxY + self.view.frame.height*0.025, width: self.view.frame.width * 0.8, height: 44)
            self.userNameTextField.layer.cornerRadius = 3
            
            self.viewThatSplitsScreen.frame = CGRect(x: self.view.frame.width*0.05, y: self.userNameTextField.frame.maxY + self.view.frame.height*0.05, width: self.view.frame.width * 0.9, height: 2)
            
            
            self.teamSettingsView.frame = CGRect(x: self.view.frame.width*0.03, y: self.viewThatSplitsScreen.frame.maxY + self.view.frame.height*0.05, width: self.view.frame.width*0.45, height: self.view.frame.height*0.20)
            self.infoTeamSettings.frame = CGRect(x: self.teamSettingsView.bounds.maxX - 25 , y: self.teamSettingsView.bounds.minY + 4, width: 20, height: 20)
            self.teamSettingsLabel.frame = CGRect(x: self.teamSettingsView.bounds.minX + 8, y: self.infoTeamSettings.frame.maxY + 1, width: self.teamSettingsView.frame.width - 10, height: 21)
            self.labelUnderSegmentedControl.frame = CGRect(x: self.teamSettingsView.bounds.minX + 5, y: self.teamSettingsView.bounds.midY - 30 , width: self.teamSettingsView.frame.width - 10, height: 25)
            self.singelOrTeamSegmentedControl.frame = CGRect(x: self.teamSettingsView.bounds.minX + 30, y: self.labelUnderSegmentedControl.frame.maxY + 10, width: self.teamSettingsView.frame.width - 60, height: 30)
            
            
            
            //RUndor/spelare
            self.roundsPerPlayerView.frame = CGRect(x: self.view.frame.width*0.52, y: self.viewThatSplitsScreen.frame.maxY + self.view.frame.height*0.05, width: self.view.frame.width*0.45, height: self.view.frame.height*0.20)
            self.infoNumberOfSecrets.frame = CGRect(x: self.roundsPerPlayerView.bounds.maxX - 25 , y: self.roundsPerPlayerView.bounds.minY + 4, width: 20, height: 20)
            self.roundsPerPlayerLabel.frame = CGRect(x: self.roundsPerPlayerView.bounds.minX + 8, y: self.infoNumberOfSecrets.frame.maxY + 1, width: self.roundsPerPlayerView.frame.width - 10, height: 21)
            self.roundsPerPlayerLabel.text = "Rundor/spelare"
            self.roundsPerPlayerCounter.frame = CGRect(x: self.roundsPerPlayerView.bounds.minX + 5, y: self.roundsPerPlayerView.bounds.midY - 30 , width: self.roundsPerPlayerView.frame.width - 10, height: 25)
            self.roundsPerPlayerStepper.frame = CGRect(x: self.roundsPerPlayerView.bounds.midX - self.roundsPerPlayerStepper.frame.width * 0.5, y: self.roundsPerPlayerCounter.frame.maxY + 10 , width: self.roundsPerPlayerView.frame.width - 10, height: 40)
            
            
            
            self.joinGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 54)
            self.joinGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 58)
        }

    }
    
    
    func randomizeAvatar() {
        let random = arc4random_uniform(UInt32(avatarArray.count)-1)
        self.avatarImageView.image = UIImage(named: avatarArray[Int(random)].0)
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
        self.avatarImageView.image = UIImage(named: avatarArray[sender.tag].0)
        
        self.selectedAvatarString = avatarArray[sender.tag].0
        
        self.backgroundBehindAvatar.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.backgroundBehindAvatar.transform = .identity
        })
        
    }
    

    
    
    @IBAction func launchGameButton(_ sender: UIButton) {
        launchNewGame()
    }
    
    func launchNewGame() {
        
        
        let ref = Database.database().reference().child("games")
        userName = self.getUserName()
        if userName != "" && userName != "no" {
            createRandomGameID(gameName: userName!)
            if let game = gameID {
                
                let values = ["open": true, "nrOfRounds": numberOfRounds, "playWithPictures": false, "numberOfTeams": numberOfTeams] as [String: Any]
                let childvalues = [game: ["game": values]] as [String : Any]
                let playerRef = ref.child(game).child("players").child(userName!)
                let player = ["points": 0, "team": 0,"redo": false, "secrets": [String](), "answer": "TBA", "avatar": self.selectedAvatarString, "isHost": true] as [String: Any]
                
                ref.updateChildValues(childvalues)
                playerRef.updateChildValues(player)
                performSegue(withIdentifier: "launchGameSegue", sender: self)
            }
            else {
                
            }
        }
        else {
            if userName == "no" {
                self.alert(title: "Felaktigt användarnamn", message: "Användarnamnet ska vara ett sammansatt ord och kan inte innehålla följande tecken: . # $ [ ]")
            }
            else {
                self.alert(title: "Skriv in ditt användarnamn", message: "Användarnamnet kommer vara synligt för dina medspelare")
            }
        }
        
    }
    
    @IBAction func infoTeamSettingsButton(_ sender: UIButton) {
        self.infoTextView.text = "Välj om ni vill spela lag mot lag eller enskilt. Om ni väljer att spela som lag delar spelledaren upp lagen i nästa fönster. I så fall gäller det för alla deltagare i det gissande laget att komma överrens om 'läsaren' ljuger eller talar sanning. Om ni istället spelar enskilt behöver man inte ta hänsyn till någonting förutom sin egen magkänsa."
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 1
            self.infoView.center = self.view.center
        }
    }
    
    @IBAction func infoNumberOfSecretsButton(_ sender: UIButton) {
        self.infoTextView.text = "Välj antal hemligheter varje spelare måste skriva ner innan spelets start. Om ni exempelvis väljer två hemligheter kommer vardera spelare läsa ett påstående (sant eller falskt) för resterande spelare två gånger under spelets gång."
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 1
            self.infoView.center = self.view.center
        }
    }
    @IBAction func closeBlurViewButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 0
            self.infoView.center.y = self.view.frame.minY - self.view.frame.height * 0.2
        }
    }
    
    
    func createRandomGameID(gameName: String) {
        let random = arc4random_uniform(100000)
        gameID = ("\(gameName)\(random)")
    }
    
    //    func createRandomPlayerID(playerName: String) {
    //        let random = arc4random_uniform(1000)
    //        playerID = ("\(playerName)-\(random)")
    //    }
    
    
    func getUserName () -> String {
        let trimmedString = userNameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let ok : Bool = trimmedString.contains {".#$[] ".contains($0)}
        if ok == true {
            return "no"
        }

        return trimmedString
    }
    
    @IBAction func nrOfRoundsStepper(_ sender: UIStepper) {
        sender.minimumValue = 1
        sender.maximumValue = 4
        self.numberOfRounds = Int(sender.value)
        self.roundsPerPlayerCounter.text = String(self.numberOfRounds)
    }
    

    @IBAction func setNumberOfTeamsSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.numberOfTeams = 0
            self.labelUnderSegmentedControl.text = "Alla mot alla"
        }
        else if sender.selectedSegmentIndex == 1 {
            self.numberOfTeams = 2
            self.labelUnderSegmentedControl.text = "Lagspel"
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WaitingForUsers {
            if let playerID = userName {
                destination.playerID = playerID
            }
            
            if let gameID = gameID {
                
                destination.gameID = gameID
            }
            destination.isHost = true
            destination.numberOfRounds = numberOfRounds
            destination.numberOfTeams = numberOfTeams
        }
        
    }
    
    
    
    
}
