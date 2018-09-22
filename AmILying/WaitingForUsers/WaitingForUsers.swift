//
//  WaitingForUsers.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-24.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit
import Firebase


class WaitingForUsers: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kickPlayerCell", for: indexPath) as! KickPlayerCell
        let player = playerArray[indexPath.row]
        cell.nameLabel.text = player.name
        cell.kickButton.tag = player.index
        if player.name == currentUser.name {
            cell.kickButton.isHidden = true
        }
        cell.kickButton.addTarget(self, action: #selector(self.kickPlayer(sender:)), for: .touchUpInside)
        return cell
    }
    
    var settingsVar = 0
    var playerToKick: Player!
    
    @objc func kickPlayer (sender: UIButton) {
        self.settingsVar = 2
        if let index = self.playerArray.index(where: {$0.index == sender.tag}) {
            let playerName = playerArray[index]
            self.playerToKick = playerName
        self.areYouSureYouWantToKickPlayerOut(player: playerName)

        }
    }
    
    
    
    func areYouSureYouWantToKickPlayerOut(player: Player) {
        UIView.animate(withDuration: 0.5) {
            self.areYouSureView.transform = .identity
        }
        self.areYouSureTextView.text = "Är du säker på att du vill sparka ut \(player.name) ur spelet?"
        
    }
    
    @IBAction func openKickPlayerView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.kickPlayerView.transform = .identity
        }
        self.kickPlayerTableView.reloadData()
    }
    
    
    @IBOutlet weak var areYouSureView: UIViewX!
    @IBOutlet weak var areYouSureTextView: UITextView!
    @IBOutlet weak var areYouSureImageView: UIImageView!
    
    @IBOutlet weak var yesImSureButton: UIButtonX!
    @IBOutlet weak var noImNotSureButton: UIButtonX!
    
    
    //Knappar inne i are you sure view
    @IBAction func yesImSureButton(_ sender: UIButton) {
        //QUIT
        if settingsVar == 0 {
            GAME_REF.child("gameStatus").setValue("quit")
            performSegue(withIdentifier: "waitingBackToStart", sender: self)
        }
            //LÄMNA SPEL
        else if settingsVar == 1 {
            playerRef.child(playerID).removeValue()
            performSegue(withIdentifier: "waitingBackToStart", sender: self)
        }
            
            //TODO: Kick players
        else if settingsVar == 2 {
            if let playerToKick = playerToKick{
                //self.playerArray.remove(at: playerToKick.index)
                playerRef.child(playerToKick.name).removeValue()
                //self.kickPlayerTableView.reloadData()
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    
    @IBAction func abortButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    
    var GAME_REF: DatabaseReference {
        return Database.database().reference().child("games").child(gameID!).child("game")
    }
    
    
    
    
    
    var playerID: String!
    var numberOfRounds: Int?
    var numberOfTeams: Int?
    var gameID: String!
    var isHost: Bool = false
    var playerArray = [Player]()
    var secretNumber = 1
    var inviteLink: String?
    var currentUser: Player!
    var host: String?
    var labelArray = [UILabel]()
    let gameOrange = UIColor(hexString: "D9765A")
    let darkGreen = UIColor(hexString: "176C33")

    var childAddedHandler: UInt = 0
    var childChangedHandler: UInt = 1
    var childRemovedHandler: UInt = 2
    var gameIsOpenHandler: UInt = 3
    var gameHandler: UInt = 4
    
    @IBOutlet weak var secretTextView: UIViewX!
    @IBOutlet weak var secretTextField: UITextView!
    @IBOutlet weak var shareGameView: UIView!
    @IBOutlet weak var shareGameImageView: UIImageView!
    
    @IBOutlet weak var shareBlurView: UIVisualEffectView!
    
    @IBOutlet weak var shareBlurViewButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var secretPupupButtonOutlet: UIButton!
    
    @IBOutlet weak var secretPopupHeadline: UILabel!
    @IBOutlet weak var secretPopupNrOfSecretsLabel: UILabel!
    @IBOutlet weak var startGameButtonOutlet: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var inviteButtonOutlet: UIButton!
    @IBOutlet weak var shareGameButtonOutlet: UIButtonX!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var waitingForLabel: UILabel!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var settingsView: UIViewX!
    @IBOutlet weak var settingsViewImage: UIImageView!
    @IBOutlet weak var rulesAndTipsOutlet: UIButton!
    
    @IBOutlet weak var quitOrLeaveButtonOutlet: UIButtonX!
    @IBOutlet weak var alertView: UIViewX!
    @IBOutlet weak var alertViewImage: UIImageView!
    
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var okButtonInAlertViewOutlet: UIButtonX!
    @IBOutlet weak var copyIDButtonOutlet: UIButtonX!
    @IBOutlet weak var blurViewButton: UIButton!
    @IBOutlet weak var gameIDOutlet: UILabel!
    
    @IBOutlet weak var kickPlayerView: UIViewX!
    @IBOutlet weak var kickPlayerImageView: UIImageView!
    
    @IBOutlet weak var kickPlayerTableView: UITableView!
    
    @IBOutlet weak var kickPlayerButtonOutlet: UIButton!
    
    @IBOutlet weak var secretViewImage: UIImageView!
    
    @IBOutlet weak var closeShareViewButtonOutlet: UIButton!
    
    @objc func startObservingAgain() {
        print("OBSERVE AGAIN")
        self.observeGame()
        self.observeIfGameIsOpen()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.kickPlayerTableView.rowHeight = 44
        
        createViews()
        hideKeyboardWhenTappedAround()
        secretTextField.delegate = self
        
        if let gameID = gameID {
            observeGame()
            observeIfGameIsOpen()
            createDeepLinkURL {
                self.shareGameButtonOutlet.isHidden = false
            }
            linkTextField.text = gameID
            if isHost == true {
                self.observeGameStatus()
                startGameButtonOutlet.isHidden = false
                self.waitingForLabel.isHidden = true
            }
            observePlayers()
        
            if let numberOfRounds = numberOfRounds {
                secretPopupNrOfSecretsLabel.text = "\(secretNumber)/\(numberOfRounds)"
                
                if numberOfRounds > 1 {
                    secretPupupButtonOutlet.setTitle("Nästa", for: .normal)
                }
                else {
                    secretPupupButtonOutlet.setTitle("Klar", for: .normal)
                }
            }
        }
        
        
        self.secretTextField.delegate = self
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.secretPopupHeadline.isHidden = true
    }

    
    let centerView = UIScrollView()
    
    
    func createViews() {
        self.shareBlurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.shareBlurView.alpha = 0
        self.shareBlurViewButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.settingsButtonOutlet.frame = CGRect(x: self.view.frame.maxX - 43, y: self.view.frame.minY + 40, width: 24, height: 24)
        self.inviteButtonOutlet.frame = CGRect(x: 19, y: self.view.frame.minY + 40, width: 24, height: 24)
        
        if view.frame.width > 450 {
            self.settingsButtonOutlet.frame = CGRect(x: self.view.frame.maxX - 63, y: self.view.frame.minY + 45, width: 44, height: 44)
            self.inviteButtonOutlet.frame = CGRect(x: 19, y: self.view.frame.minY + 45, width: 44, height: 44)
        }
        
        
        // ALLA STORLEKAR
        self.blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.blurViewButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.headlineLabel.frame = CGRect(x: self.view.frame.width * 0.2, y: self.view.frame.minY + 30, width: self.view.frame.width * 0.6, height: 100)
        self.startGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 50)
        self.startGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 64)
        self.waitingForLabel.frame.size = CGSize(width: self.view.frame.width, height: 44)
        self.waitingForLabel.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 64)
        self.centerScrollView.frame = CGRect(x: self.view.frame.minX, y: self.headlineLabel.frame.maxY + 20, width: self.view.frame.width, height: self.startGameButtonOutlet.frame.minY - self.headlineLabel.frame.maxY - 40)
        
        if self.view.frame.width > 450 {
            self.startGameButtonOutlet.frame.size = CGSize(width: self.view.frame.width * 0.4, height: 70)
            self.startGameButtonOutlet.center = CGPoint(x: view.frame.midX, y: self.view.frame.maxY - 64)
        }
        //DE SENASTE UPPDATERINGARNA
        
        //Settings view
        self.settingsView.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 145)
        self.settingsView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)

        if isHost{
            self.quitOrLeaveButtonOutlet.setTitle("Avsluta spelet", for: .normal)
            self.settingsView.frame.size = CGSize(width: self.view.frame.width * 0.7, height: 200)
            self.settingsView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            self.kickPlayerButtonOutlet.frame =  CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 130 , width: self.settingsView.bounds.width * 0.8, height: 50)
        }
        else {
            self.quitOrLeaveButtonOutlet.setTitle("Lämna spelet", for: .normal)
            self.kickPlayerButtonOutlet.isHidden = true
        }
        self.settingsViewImage.frame = CGRect(x: 0, y: 0, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
        
        self.rulesAndTipsOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 20 , width: self.settingsView.bounds.width * 0.8, height: 50)
        self.quitOrLeaveButtonOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 75 , width: self.settingsView.bounds.width * 0.8, height: 50)
        self.settingsView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //AlertView
        self.alertView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 180)
        self.alertView.center = CGPoint(x: self.view.center.x, y: self.view.frame.midY)
        self.alertViewImage.frame = CGRect(x: 0, y: 0, width: self.alertView.frame.width, height: self.alertView.frame.height)
        self.alertTextView.frame = CGRect(x: self.alertView.bounds.minX + 15, y: self.alertView.bounds.minY + 5, width: self.alertView.frame.width - 30, height: 70)
        self.okButtonInAlertViewOutlet.frame = CGRect(x: self.alertView.bounds.midX - self.okButtonInAlertViewOutlet.frame.width*0.5, y: self.alertView.bounds.midY, width: self.alertView.frame.width * 0.3, height: 44)
        
        self.alertView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //DE SENASTE UPPDATERINGARNA SLUTAR HÄR
        
        //OM det är singel-spel
        if numberOfTeams == 0 {

        }
        
        
        
        //OM DET ÄR LAG-SPEL
        
        //Om det är flera lag
        if self.numberOfTeams! > 0 {
            centerScrollView.addSubview(centerView)
            centerView.frame = CGRect(x: self.centerScrollView.bounds.midX-self.view.bounds.width*0.2, y: self.centerScrollView.bounds.minY, width: view.frame.width*0.4, height: self.centerScrollView.frame.height*0.9)
            centerView.layer.cornerRadius = 5
            centerView.layer.borderColor = UIColor.black.cgColor
            centerView.layer.borderWidth = 3

            
            let centerLabel = UILabel(frame: CGRect(x: centerView.bounds.midX - 60, y: centerView.bounds.minY + 8, width: 120, height: 34))
            centerLabel.text = "Spelare"
            if view.frame.width > 450 {
                centerLabel.font = UIFont (name: "Charter", size: 40)
            }
            centerLabel.font = UIFont (name: "Charter", size: 28)
            centerLabel.textAlignment = .center
            centerView.addSubview(centerLabel)
            
            
            //IPAD
            if view.frame.width > 450 {
                leftTeamView.frame = CGRect(x: centerScrollView.bounds.minX + self.centerScrollView.bounds.width*0.025, y: centerScrollView.bounds.minY + 25, width: self.centerScrollView.frame.width*0.25, height: self.centerScrollView.frame.height*0.9)
                leftTeamView.layer.cornerRadius = 20
                
                let leftTeamLabel = UILabel(frame: CGRect(x: self.centerScrollView.bounds.width*0.025, y: centerScrollView.bounds.minY, width: self.centerScrollView.frame.width*0.25, height: 34))
                leftTeamLabel.textAlignment = .center
                leftTeamLabel.text = "Lag 1"
                if view.frame.width > 450 {
                   leftTeamLabel.font = UIFont (name: "Charter", size: 40)
                }
                leftTeamLabel.font = UIFont (name: "Charter", size: 28)
                
                centerScrollView.addSubview(leftTeamView)
                centerScrollView.addSubview(leftTeamLabel)
                
                rightTeamView.frame = CGRect(x: centerScrollView.bounds.maxX - self.centerScrollView.bounds.width*0.275, y: centerScrollView.bounds.minY + 25, width: self.centerScrollView.frame.width*0.25, height: 1000)
                rightTeamView.layer.cornerRadius = 20
                
                
                let rightTeamLabel = UILabel(frame: CGRect(x: self.centerScrollView.bounds.width*0.725, y: centerScrollView.bounds.minY, width: self.centerScrollView.frame.width*0.25, height: 34))
                rightTeamLabel.textAlignment = .center
                rightTeamLabel.text = "Lag 2"
                if view.frame.width > 450 {
                    rightTeamLabel.font = UIFont (name: "Charter", size: 40)
                }
                rightTeamLabel.font = UIFont (name: "Charter", size: 28)
                
                centerScrollView.addSubview(rightTeamView)
                centerScrollView.addSubview(rightTeamLabel)
            }
                
                //SE
            else if view.frame.width < 350 {
                
            }
                //ÖVRIGA
            else {
                
                leftTeamView.frame = CGRect(x: centerScrollView.bounds.minX + self.centerScrollView.bounds.width*0.025, y: centerScrollView.bounds.minY + 25, width: self.centerScrollView.frame.width*0.25, height: self.centerScrollView.frame.height*0.9)
                leftTeamView.layer.cornerRadius = 20
                
                let leftTeamLabel = UILabel(frame: CGRect(x: self.centerScrollView.bounds.width*0.025, y: centerScrollView.bounds.minY, width: self.centerScrollView.frame.width*0.25, height: 21))
                leftTeamLabel.textAlignment = .center
                leftTeamLabel.text = "Lag 1"
                centerScrollView.addSubview(leftTeamView)
                centerScrollView.addSubview(leftTeamLabel)
                
                rightTeamView.frame = CGRect(x: centerScrollView.bounds.maxX - self.centerScrollView.bounds.width*0.275, y: centerScrollView.bounds.minY + 25, width: self.centerScrollView.frame.width*0.25, height: 1000)
                rightTeamView.layer.cornerRadius = 20
                
                
                let rightTeamLabel = UILabel(frame: CGRect(x: self.centerScrollView.bounds.width*0.725, y: centerScrollView.bounds.minY, width: self.centerScrollView.frame.width*0.25, height: 21))
                rightTeamLabel.textAlignment = .center
                rightTeamLabel.text = "Lag 2"
                
                centerScrollView.addSubview(rightTeamView)
                centerScrollView.addSubview(rightTeamLabel)
            }
        }

        //SECRET VIEW
        self.secretTextView.frame.size =  CGSize(width: view.frame.width * 0.8, height: 250)
        self.secretTextView.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY - 150)
        self.secretPopupHeadline.frame = CGRect(x: self.secretTextView.bounds.midX - self.secretTextView
            .frame.width * 0.4, y: self.secretTextField.bounds.midY - 8, width: self.secretTextView.frame.width * 0.8, height: 21)
        self.secretPopupNrOfSecretsLabel.frame = CGRect(x: self.secretTextView.bounds.maxX - self.secretTextView.frame.width * 0.2, y: self.secretTextView.bounds.minY + 8, width: self.secretTextView.frame.width * 0.15, height: 21)
        
        self.secretPupupButtonOutlet.frame = CGRect(x: self.secretTextView.bounds.midX - self.secretTextView.frame.width
            * 0.15, y: self.secretTextView.bounds.maxY - 54, width: self.secretTextView.frame.width
                * 0.3, height: 44)
        
        self.secretTextField.frame = CGRect(x: self.secretTextView.bounds.minX + 2 , y: self.secretTextView.bounds.minY + 25, width: self.secretTextView.frame.width - 4, height: self.secretTextView.frame.height -  self.secretPupupButtonOutlet.frame.height - 40)
        self.secretTextField.layer.cornerRadius = 5
        self.secretViewImage.frame.size = CGSize(width: self.secretTextView.frame.width, height: self.secretTextView.frame.height)
        self.secretViewImage.center = CGPoint(x: self.secretTextView.bounds.midX, y: self.secretTextView.bounds.midY)
        
        
        
        
        //SHARE GAME VIEW
        self.shareGameView.frame.size =  CGSize(width: view.frame.width * 0.8, height: 330)
        self.shareGameView.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY - 300)
        self.shareGameImageView.frame = CGRect(x: 0, y: 0, width: self.shareGameView.frame.width, height: self.shareGameView.frame.height)
       

        self.linkTextField.frame = CGRect(x: self.shareGameView.frame.width * 0.2, y: self.shareGameView.bounds.midY-25, width: self.shareGameView.frame.width * 0.6, height: 44)
        
        self.copyIDButtonOutlet.frame = CGRect(x: self.shareGameView.bounds.midX - self.shareGameView.frame.width * 0.3 - 10, y: self.linkTextField.frame.maxY+10, width: self.shareGameView.frame.width * 0.3, height: 44)
         self.shareGameButtonOutlet.frame = CGRect(x: self.shareGameView.bounds.midX + 10, y: self.linkTextField.frame.maxY+10, width: self.shareGameView.frame.width * 0.3, height: 44)
        self.closeShareViewButtonOutlet.frame = CGRect(x: self.shareGameView.bounds.midX - self.shareGameView.frame.width * 0.25, y: self.shareGameView.bounds.maxY - 64, width: self.shareGameView.frame.width * 0.5, height: 44)

        self.linkTextField.isEnabled = false
        
        self.gameIDOutlet.frame = CGRect(x: self.shareGameView.bounds.minX + 20, y: self.linkTextField.frame.minY - 25, width: 200, height: 21)



        //ARE YOU SURE VIEW
        self.areYouSureView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 250)
        self.areYouSureView.center = CGPoint(x: self.view.center.x, y: self.view.frame.midY)
        self.areYouSureImageView.frame = CGRect(x: 0, y: 0, width: self.areYouSureView.frame.width, height: self.areYouSureView.frame.height)
        self.areYouSureTextView.frame = CGRect(x: self.areYouSureView.bounds.minX + 15, y: self.areYouSureView.bounds.minY + 5, width: self.areYouSureView.frame.width - 30, height: 70)
        self.yesImSureButton.frame = CGRect(x: self.areYouSureView.bounds.midX - self.areYouSureView.frame.width * 0.4, y: self.areYouSureView.bounds.midY, width: self.areYouSureView.frame.width * 0.3, height: 44)
        self.noImNotSureButton.frame = CGRect(x: self.areYouSureView.bounds.midX + self.areYouSureView.frame.width * 0.1, y: self.areYouSureView.bounds.midY, width: self.areYouSureView.frame.width * 0.3, height: 44)
        
        self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //Kick Player View
        self.kickPlayerView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 250)
        self.kickPlayerView.center = CGPoint(x: self.view.center.x, y: self.view.frame.midY)
        self.kickPlayerImageView.frame = CGRect(x: 0, y: 0, width: self.kickPlayerView.frame.width, height: self.kickPlayerView.frame.height)
        self.kickPlayerTableView.frame = CGRect(x: self.kickPlayerView.bounds.minX + self.kickPlayerView.frame.width * 0.1, y: self.kickPlayerView.bounds.minY + self.kickPlayerView.frame.height * 0.1, width: self.kickPlayerView.frame.width - self.kickPlayerView.frame.width * 0.2, height: self.kickPlayerView.frame.height - self.kickPlayerView.frame.height * 0.2)
        self.kickPlayerView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    
    
    
    func createPlayerIcon(player: Player) {
        //VID LAGSPEL
        if numberOfTeams! > 0 {
            let newView = UIView(frame: CGRect(x: centerScrollView.bounds.midX-50, y: 50 + self.centerScrollView.bounds.minY+105*(CGFloat(checkIfPositionIsAvailable(leftCenterRight: 1))), width: 100, height: 100))
            let newViewImage = UIImageView(image: UIImage(named: "lagpoäng"))
            newViewImage.frame = CGRect(x: newView.bounds.minX, y: newView.bounds.minY, width: newView.frame.width, height: newView.frame.height)

            
            let labelView = UIView(frame: CGRect(x: newView.bounds.minX, y: newView.bounds.maxY - 45, width: newView.frame.width, height: 42))
            labelView.layer.cornerRadius = 10
          
            let label = UILabel(frame: CGRect(x: labelView.bounds.minX, y: labelView.bounds.minY, width: labelView.frame.width, height: 21))
            label.text = player.name
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            
            let statusLabel = UILabel(frame: CGRect(x: newView.bounds.minX, y: label.bounds.maxY + 2, width: newView.frame.width, height: 21))
            statusLabel.text = "Skriver..."
            statusLabel.textColor = UIColor.yellow
            statusLabel.textAlignment = .center
            statusLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
            labelArray.append(statusLabel)
            
            let backgroundView = UIView(frame: CGRect(x: newView.bounds.midX-25, y: newView.bounds.minY + 2, width: 50, height: 50))

            let avatarImage = UIImageView(image: UIImage(named: player.avatar))
            avatarImage.frame.size = CGSize(width: 40, height: 40)
            avatarImage.center = CGPoint(x: backgroundView.bounds.midX, y: backgroundView.bounds.midY)
            
            
            newView.tag = player.index
            
            
            let panRec = UIPanGestureRecognizer()
            
            centerScrollView.addSubview(newView)
            newView.addSubview(newViewImage)
            backgroundView.addSubview(avatarImage)
            newView.addSubview(backgroundView)
            labelView.addSubview(label)
            labelView.addSubview(statusLabel)
            newView.addSubview(labelView)
            
            if isHost && numberOfTeams! > 0 {
                newView.addGestureRecognizer(panRec)
                panRec.addTarget(self, action:#selector(draggedView(_:)))
            }
            
            arrayOfViews.append(newView)
            
            

        }
            
            
            
            //VID SINGELSPEL
        else {
            let newView = UIView(frame: CGRect(x: centerScrollView.bounds.midX - self.view.frame.width * 0.3, y: 10 + self.centerScrollView.bounds.minY+105*(CGFloat(checkIfPositionIsAvailable(leftCenterRight: 1))), width: self.view.frame.width*0.6, height: 100))
            
            let newViewImage = UIImageView(image: UIImage(named: "lagpoäng"))
            newViewImage.frame = CGRect(x: newView.bounds.minX, y: newView.bounds.minY, width: newView.frame.width, height: newView.frame.height)
            
            let backgroundView = UIView(frame: CGRect(x: newView.bounds.minX+15, y: newView.bounds.minY+10, width: 70, height: 70))
            
            backgroundView.backgroundColor = UIColor.white
            backgroundView.layer.cornerRadius = 35
            backgroundView.dropShadow(color: UIColor.darkGray, offSet: CGSize(width: -1, height: 1), cornerRadius: 35)
            
            
            let avatarImage = UIImageView(image: UIImage(named: player.avatar))
            avatarImage.frame.size = CGSize(width: 50, height: 50)
            avatarImage.center = CGPoint(x: backgroundView.frame.midX, y: backgroundView.frame.midY)
            
            let label = UILabel(frame: CGRect(x: backgroundView.bounds.maxX + 25, y: newView.bounds.minY + 20, width: newView.frame.width - backgroundView.frame.width - 50, height: 21))
            label.text = player.name
            label.textColor = UIColor.black
            label.textAlignment = .left
            
            let statusLabel = UILabel(frame: CGRect(x: backgroundView.bounds.maxX + 25, y: label.frame.maxY + 10, width: newView.frame.width - backgroundView.frame.width - 50, height: 21))
            statusLabel.text = "Skriver..."
            statusLabel.textColor = UIColor.yellow
            statusLabel.textAlignment = .left
            
            labelArray.append(statusLabel)
            
            centerScrollView.addSubview(newView)
            newView.addSubview(newViewImage)
            newView.addSubview(backgroundView)
            newView.addSubview(label)
            newView.addSubview(statusLabel)
            newView.addSubview(avatarImage)
            
            arrayOfViews.append(newView)
        }
  
    }
    
    var arrayOfViews = [UIView]()

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bringSubview(toFront: self.blurView)
        self.view.bringSubview(toFront: self.blurViewButton)
        self.view.bringSubview(toFront: self.settingsView)
        self.view.bringSubview(toFront: self.alertView)
        self.view.bringSubview(toFront: self.secretTextView)
        self.view.bringSubview(toFront: self.shareBlurView)
        self.view.bringSubview(toFront: self.shareGameView)
        self.view.bringSubview(toFront: self.kickPlayerView)
        self.view.bringSubview(toFront: self.areYouSureView)
       
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isHost {
            UIView.animate(withDuration: 0.9, animations: {
                self.shareGameView.center = self.view.center
            }) { (true) in
                self.shareGameView.shakeView()
                
            }
            
        }
        else {
            self.animateSecretView()
        }
        

    }
    
    func animateSecretView () {
        UIView.animate(withDuration: 0.9, animations: {
            self.secretTextView.center = self.view.center
        }) { (true) in
            self.secretTextView.shakeView()
            
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    
    @objc func handleStepper (_ sender: UIStepper) {
  playerRef.child(playerArray[sender.tag].key).updateChildValues(["team" : sender.value])
    }
    
    var handle: UInt = 0
    var playerRef: DatabaseReference {
        return    Database.database().reference().child("games").child(gameID!).child("players")
    }
    
    
    
    func observeIfGameIsOpen() {
        self.gameIsOpenHandler =  Database.database().reference().child("games").child(gameID!).child("game").child("open").observe(DataEventType.value) { (snapshot) in
            print("OBSERVE GAME IS OPEN")
            let open = snapshot.value as! Bool
            if open == false {
                Database.database().reference().child("games").child(self.gameID!).child("players").child(self.playerID!).child("index").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    self.currentUser.index = snapshot.value as! Int
                })
                self.performSegue(withIdentifier: "startGameSegue", sender: self)
            }
        }
    }
    
    
    
    func observeGame() {
        self.gameHandler = Database.database().reference().child("games").child(gameID!).child("game").observe(DataEventType.value) { (snapshot) in
            print("OBSERVE GAME IN WAIT")
            if snapshot.childSnapshot(forPath: "gameStatus").exists(){
                let status = snapshot.childSnapshot(forPath: "gameStatus").value as! String
                
                if status == "quit"{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.blurView.alpha = 1
                        self.alertTextView.text = "Spelledaren har valt att avsluta spelet"
                        self.alertView.transform = .identity
                    })
                }
            }
        }
    }

    
    
    func observeGameStatus() {
        Database.database().reference().child("games").child(gameID!).child("game").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childSnapshot(forPath: "gameStatus").exists(){
                Database.database().reference().child("games").child(self.gameID!).child("game").child("gameStatus").removeValue()
            }
        }
    }

    
    
    
    func observePlayers () {
        self.childAddedHandler = playerRef.observe(.childAdded, with: { (snapshot) -> Void in
            print("CHILD ADDED IN WAIT")
            let key = snapshot.key
            let points = snapshot.childSnapshot(forPath: "points").value as! Int
            let team = snapshot.childSnapshot(forPath: "team").value as! Int
            let answer = snapshot.childSnapshot(forPath: "answer").value as! String
            let avatar = snapshot.childSnapshot(forPath: "avatar").value as! String
            let player = Player(key: key, name: key, points: points, team: team, answer: answer, avatar: avatar, index: self.playerArray.count)
            var secrets = [String]()
            for child in [snapshot.childSnapshot(forPath: "secrets")] as [DataSnapshot]{
                for child2 in child.children.allObjects{
                    let tja = child2 as! DataSnapshot
                    secrets.append(tja.value as! String)
                }
            }

            let redo = snapshot.childSnapshot(forPath: "redo").value as! Bool

            
            if snapshot.childSnapshot(forPath: "isHost").exists() {
                self.host = player.name
            }

            player.secrets = secrets
            if key == self.playerID {
                self.currentUser = player

            }
            

            self.playerArray.append(player)
            self.centerScrollView.contentSize = CGSize(width: self.view.bounds.width, height: CGFloat(150*self.playerArray.count))
            self.centerView.frame.size.height = self.centerScrollView.contentSize.height + self.centerScrollView.frame.height
            self.createPlayerIcon(player: player)
            
            if redo == true {
                self.labelArray[player.index].font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
                self.labelArray[player.index].text = "Redo!"
                self.labelArray[player.index].textColor = self.darkGreen
            }
            

        })
        // Listen for deleted players in the Firebase database
        self.childRemovedHandler = playerRef.observe(.childRemoved, with: { (snapshot) -> Void in
            print("CHILD REMOVED IN WAIT")
            let index = self.indexOfPlayer(snapshot: snapshot)
            
            if snapshot.key == self.currentUser.name {

                self.alertTextView.text = "Spelledaren har sparkat ut dig ur spelet"
                UIView.animate(withDuration: 0.5, animations: {
                    self.blurView.alpha = 1
                    self.blurViewButton.isHidden = true
                    self.alertView.transform = .identity
                })
            }
            self.labelArray.remove(at: index)
            self.playerArray.remove(at: index)
            self.removePosition(viewToCheck: self.arrayOfViews[index])
            self.arrayOfViews[index].removeFromSuperview()
            self.kickPlayerTableView.reloadData()
        })
        
        self.childChangedHandler = playerRef.observe(.childChanged, with: { (snapshot) -> Void in
            print("CHILD CHANGED IN WAIT")
            let index = self.indexOfPlayer(snapshot: snapshot)
            let points = snapshot.childSnapshot(forPath: "points").value as! Int
            let team = snapshot.childSnapshot(forPath: "team").value as! Int
            var secrets = [String]()
            for child in [snapshot.childSnapshot(forPath: "secrets")] as [DataSnapshot]{
                for child2 in child.children.allObjects{
                    let tja = child2 as! DataSnapshot
                    secrets.append(tja.value as! String)
                }
            }
            
            let redo = snapshot.childSnapshot(forPath: "redo").value as! Bool
            if redo == true {
                self.labelArray[index].font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
                self.labelArray[index].text = "Redo!"
                self.labelArray[index].textColor = self.darkGreen
            }
            
            
            self.playerArray[index].points = points
            
            //TODO: Animate view to right position if team is changed
            if self.playerArray[index].team != team {
                
            }
            
            self.playerArray[index].team = team
            self.playerArray[index].secrets = secrets

   
        })
    }
    
    func indexOfPlayer(snapshot: DataSnapshot) -> Int {
        var index = 0
        for  player in self.playerArray {
            if (snapshot.key == player.key) {
                return index
            }
            index += 1
        }
        return -1
    }
    
    func setIndexOfPlayer() {
        for (index, player) in playerArray.enumerated() {
            if(currentUser.name == player.name){
                currentUser.index = index
            }
            let values = ["index": index, "points": 0] as [String : Any]
            playerRef.child(player.key).updateChildValues(values)
            
        }
    }
    func setTeamForPlayers() {
        for player in playerArray {
            playerRef.child(player.key).child("team").setValue(player.team)
        }
    }
    
    //Lets the player write a secret of 120 characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 120
    }
    
    @IBAction func shareGameButton(_ sender: UIButton) {
        // createDeepLinkURL()

            let activityVC = UIActivityViewController(activityItems: [inviteLink!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
    
    }
    
    //Skapar en delbar länk och förkortar den
    func createDeepLinkURL(completion: @escaping ()->()) {
        guard let deepLink = URL(string: "https://qmb7n.app.goo.gl/page?param=\(gameID!)") else { return }
        let domain = "qmb7n.app.goo.gl"
        
        let components = DynamicLinkComponents(link: deepLink, domain: domain)

        let options = DynamicLinkComponentsOptions()
        options.pathLength = .short
        components.options = options
        
        components.shorten { (shortURL, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
                // Build the dynamic link
                let link = components.url
                self.inviteLink = (link?.absoluteString ?? "")
                return
            }
            self.inviteLink = shortURL?.absoluteString
            completion()
        }
    }
    
    
    @IBAction func secretPopupButton(_ sender: UIButton) {
        
        if let playerID = playerID, let gameID = gameID {
            let ref = Database.database().reference().child("games").child(gameID).child("players").child(playerID)
            let lieListRef = Database.database().reference().child("LiesWaitingValidation")
            if secretTextField.text != "" {
                let values = [String(secretNumber): secretTextField.text!]
                ref.child("secrets").updateChildValues(values)
                lieListRef.childByAutoId().setValue(secretTextField.text!)
                secretNumber += 1
                self.secretPopupNrOfSecretsLabel.text = "\(secretNumber)/\(numberOfRounds!)"
                if (secretNumber == numberOfRounds){
                    secretPupupButtonOutlet.setTitle("Klar", for: .normal)
                }
                else if secretNumber > numberOfRounds! {
                    playerRef.child(playerID).child("redo").setValue(true)
                    secretTextView.isHidden = true
                    self.blurView.alpha = 0
                }
            }
            else {
                self.alert(title: "Skriv in din hemlighet för fortsätta", message: "...")
            }
        }
        secretTextField.text = ""
    }
    
    @IBAction func startGameButton(_ sender: UIButton) {
        setIndexOfPlayer()
        let values = ["open": false, "index": 0, "currentRound": 1] as [String : Any]
        
        var ready = true
        for status in self.labelArray{
            if status.text == "Skriver..." {
                ready = false
                break
            }
        }
        if ready == false {
            alert(title: "Alla spelare har inte skrivit sin hemlighet ännu", message: "Låt alla spelare skriva in deras hemligheter eller sparka ut de som ännu inte skrivit sin hemlighet ur spelet")
            
        }
        else {
            if numberOfTeams! > 0 {
                if leftTeam.count + rightTeam.count == playerArray.count  {
                    self.setTeamForPlayers()
                Database.database().reference().child("games").child(gameID!).child("game").updateChildValues(values)
                    performSegue(withIdentifier: "startGameSegue", sender: self)
                }
                else {
                    alert(title: "Du måste dela upp lagen innan du kan fortsätta", message: "Swipa alla deltagare till önskat lag för att start spelet")
                }
            }
                
            else {
            Database.database().reference().child("games").child(gameID!).child("game").updateChildValues(values)
                performSegue(withIdentifier: "startGameSegue", sender: self)
            }
        }
    }
    
    @IBAction func closeSharePopup(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1) {
            self.shareGameView.alpha = 0
            self.shareGameView.center = CGPoint(x: self.view.center.x, y: -300)
        }
        
        self.animateSecretView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 Database.database().reference().child("games").child(gameID!).child("game").child("open").removeObserver(withHandle: gameIsOpenHandler)
        Database.database().reference().child("games").child(gameID!).child("game").removeObserver(withHandle: gameHandler)
        playerRef.removeObserver(withHandle: childChangedHandler)
        playerRef.removeObserver(withHandle: childRemovedHandler)
        playerRef.removeObserver(withHandle: childAddedHandler)
        
        if let destination = segue.destination as? GameLobbyViewController{
            destination.gameID = gameID
            destination.numberOfTeams = numberOfTeams
            destination.playerID = playerID
            destination.currentUser = currentUser
            destination.numberOfRounds = numberOfRounds
            destination.currentReader = host
            destination.isHost = isHost
        }
        
    }
    
    @IBOutlet weak var centerScrollView: UIScrollView!
    
    var leftTeamView = UIView()
    var rightTeamView = UIView()
    
    
    
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){

        let theView = sender.view!
        let point = sender.translation(in: view)
        let tmp=sender.view?.center.x  //x translation
        let tmp1=sender.view?.center.y //y translation
        
        if sender.state == UIGestureRecognizerState.began{

            removePosition(viewToCheck: theView)
        }
        if sender.state == UIGestureRecognizerState.changed{
            if theView.center.x < view.center.x - theView.frame.width*0.5 {
                UIView.animate(withDuration: 0.3) {
                    self.leftTeamView.transform = CGAffineTransform(scaleX: 1.1, y: 1.0)
                    theView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    self.rightTeamView.transform = .identity
                }
            }
            else if theView.center.x > view.center.x + theView.frame.width*0.5 {
                UIView.animate(withDuration: 0.3) {
                    self.rightTeamView.transform = CGAffineTransform(scaleX: 1.1, y: 1.0)
                    theView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    self.leftTeamView.transform = .identity
                }
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    theView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.leftTeamView.transform = .identity
                    self.rightTeamView.transform = .identity
                }
            }
            
        }
        
        theView.center=CGPoint(x:tmp!+point.x, y:tmp1!+point.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        self.view.bringSubview(toFront: sender.view!)
        
    
        if sender.state == UIGestureRecognizerState.ended{
            if theView.center.x < view.center.x - theView.frame.width*0.5 {
                animateToLeftTeam(newView: theView)
            }
            else if theView.center.x > view.center.x + theView.frame.width*0.5 {
                animateToRightTeam(newView: theView)
            }
            else {
                self.addPlayerToCorrectTeam(theView: theView, leftMiddleRight: 1)
                UIView.animate(withDuration: 0.3) {
                    
                    theView.center = CGPoint(x: self.view.center.x, y: 40 + self.centerScrollView.bounds.minY + 50 + CGFloat(105*self.checkIfPositionIsAvailable(leftCenterRight: 1)))
                    if theView.transform != .identity{
                        theView.transform = .identity
                    }
                }
            }
        }
    }
    
    
    
    func animateToLeftTeam(newView: UIView) {
        self.addPlayerToCorrectTeam(theView: newView, leftMiddleRight: 0)
        UIView.animate(withDuration: 0.3) {
            newView.center = CGPoint(x: self.view.frame.width * 0.15, y: self.centerScrollView.bounds.minY + 70 + (newView.frame.height + 5)*CGFloat(self.checkIfPositionIsAvailable(leftCenterRight: 0)))
            if newView.transform == .identity{
                newView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            self.leftTeamView.transform = .identity
        }
    }
    func animateToRightTeam(newView: UIView) {
        self.addPlayerToCorrectTeam(theView: newView, leftMiddleRight: 2)
        UIView.animate(withDuration: 0.3) {
            newView.center = CGPoint(x: self.view.frame.width * 0.85, y: self.centerScrollView.bounds.minY + 70 + (newView.frame.height + 5)*CGFloat(self.checkIfPositionIsAvailable(leftCenterRight: 2)))
            if newView.transform == .identity{
                newView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            
            self.rightTeamView.transform = .identity
        }
    }
    
    var leftTeam = [Player]()
    var rightTeam = [Player]()
    var leftPositionArray = [Int]()
    var rightPositionArray = [Int]()
    var centerPositionArray = [Int]()
    
    func checkIfPositionIsAvailable(leftCenterRight: Int) -> Int {
        if leftCenterRight == 0 {
            for i in 0...10{
                if !self.leftPositionArray.contains(i){
                    self.leftPositionArray.append(i)
                    return i
                }
            }
        }
            
        else if leftCenterRight == 1 {
            for i in 0...20{
                if !self.centerPositionArray.contains(i){
                    self.centerPositionArray.append(i)
                    return i
                }
            }
        }
            
        else if leftCenterRight == 2 {
            for i in 0...10{
                if !self.rightPositionArray.contains(i){
                    self.rightPositionArray.append(i)
                    return i
                }
            }
        }
        return 10
    }
    
    func removePosition(viewToCheck: UIView) {
        playerArray[viewToCheck.tag].team = 0
        let yValue = viewToCheck.frame.midY
        //Kolla om spelaren är i vänstra laget
        if view.frame.width < 450{
            if viewToCheck.frame.minX < 50 {
                let indexToRemove:Int = Int((yValue-70)/75)
   
                
                if let index = leftPositionArray.index(of: indexToRemove) {
                    leftPositionArray.remove(at: index)
                }
            }
            else if viewToCheck.frame.maxX > view.frame.width*0.9{
                let indexToRemove:Int = Int((yValue-70)/75)
                
                if let index = rightPositionArray.index(of: indexToRemove) {
                    rightPositionArray.remove(at: index)
                }
            }
            else if viewToCheck.frame.midX > view.bounds.midX-50 && viewToCheck.frame.midX < view.bounds.midX+50 {
                let indexToRemove:Int = Int((yValue-40)/100)

                if let index = centerPositionArray.index(of: indexToRemove) {
                    centerPositionArray.remove(at: index)
                }
            }
        }
        else {
            if viewToCheck.frame.minX < 150 {
                let indexToRemove:Int = Int((yValue-70)/75)

                
                if let index = leftPositionArray.index(of: indexToRemove) {
                    leftPositionArray.remove(at: index)
                }
            }
            else if viewToCheck.frame.maxX > view.frame.width*0.8{
                let indexToRemove:Int = Int((yValue-70)/75)

                
                if let index = rightPositionArray.index(of: indexToRemove) {
                    rightPositionArray.remove(at: index)
                }
            }
            else if viewToCheck.frame.midX > view.bounds.midX-100 && viewToCheck.frame.midX < view.bounds.midX+100 {
                let indexToRemove:Int = Int((yValue-40)/100)
                
                if let index = centerPositionArray.index(of: indexToRemove) {
                    centerPositionArray.remove(at: index)
                }
            }
        }
    }
    
    
    //Lägger till spelaren i rätt lag. Tar bort den från tidigare lista
    func addPlayerToCorrectTeam(theView: UIView, leftMiddleRight: Int) {
        //Om spelaren dras till vänstra laget
        
        if leftMiddleRight == 0 {
            playerArray[theView.tag].team = 1
            if !self.leftTeam.contains(where: { $0.index == theView.tag }) {
                self.leftTeam.append(playerArray[theView.tag])
                
            }
            if self.rightTeam.contains(where: { $0.index == theView.tag }) {
                for (index,player) in rightTeam.enumerated() {
                    if player.index == theView.tag {
                        self.rightTeam.remove(at: index)
                    }
                }
            }
        }
            
            //Om spelaren dras till mitten
            
        else if leftMiddleRight == 1 {
            playerArray[theView.tag].team = 0
            if self.leftTeam.contains(where: { $0.index == theView.tag }) {
                for (index,player) in leftTeam.enumerated() {
                    if player.index == theView.tag {
                        self.leftTeam.remove(at: index)
                    }
                }
            }
            if self.rightTeam.contains(where: { $0.index == theView.tag }) {
                for (index,player) in rightTeam.enumerated() {
                    if player.index == theView.tag {
                        self.rightTeam.remove(at: index)
                    }
                }
            }
        }
        
        //Om spelaren dras till högra laget
        if leftMiddleRight == 2 {
            playerArray[theView.tag].team = 2
            if !self.rightTeam.contains(where: { $0.index == theView.tag }) {
                self.rightTeam.append(playerArray[theView.tag])
            }
            
            
            if self.leftTeam.contains(where: { $0.index == theView.tag }) {
                for (index,player) in leftTeam.enumerated() {
                    if player.index == theView.tag {
                        self.leftTeam.remove(at: index)
                    }
                }
            }
        }
    }
    
    
    @IBAction func copyIDButton(_ sender: UIButton) {
        UIPasteboard.general.string = self.linkTextField.text!
        
    }
    
    
    
    @IBAction func inviteButton(_ sender: UIButton) {
        self.shareGameView.alpha = 1
        UIView.animate(withDuration: 0.9, animations: {
            self.shareBlurView.alpha = 1
            self.shareGameView.center = self.view.center
        }) { (true) in
            self.shareGameView.shakeView()
            
        }
    }
    
    @IBAction func closeShareViewBlurButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.shareBlurView.alpha = 0
            self.shareGameView.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY - 300)
        }
    }
    
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 1
            self.blurViewButton.isHidden = false
            self.settingsView.transform = .identity
        }
    }
    

    @IBAction func quitOrLeaveButton(_ sender: UIButton) {
        
        if isHost{
            self.areYouSureTextView.text = "Är du säker på att du vill avsluta spelet?"
            self.settingsVar = 0
        }
        else {
            self.areYouSureTextView.text = "Är du säker på att du vill lämna spelet?"
            self.settingsVar = 1
        }
        
        UIView.animate(withDuration: 0.5) {
            self.areYouSureView.transform = .identity
        }
    }
    
    
    @IBAction func buttonInAlertView(_ sender: UIButton) {
        performSegue(withIdentifier: "waitingBackToStart", sender: self)
    }
    
    
    @IBAction func blurViewButtonPressed(_ sender: UIButton) {
        self.blurViewButton.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 0
            self.settingsView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.kickPlayerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    
    
    
    
    
}













