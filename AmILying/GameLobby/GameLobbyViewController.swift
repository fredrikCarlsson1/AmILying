//
//  GameLobby.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-04-30.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation


class GameLobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var GAME_REF: DatabaseReference {
        return Database.database().reference().child("games").child(gameID!).child("game")
    }
    
    var PLAYER_REF: DatabaseReference {
        return Database.database().reference().child("games").child(gameID!).child("players")
    }
    
    
    class AllTeams {
        var teamIndex: Int
        var teamName: String
        var points: Int
        var team: [Player]
        
        init(teamIndex: Int, teamName: String, points: Int = 0, team: [Player]){
            self.teamIndex = teamIndex
            self.teamName = teamName
            self.points = points
            self.team = team
        }
        
        func removeTeam(){
            team.removeAll()
        }
    }
    
    //Firebase game nodes
    var allPlayers = [Player]()
    var playersThatHaventAnswerd = [Player]()
    var allTeamsArray = [AllTeams]()
    var numberOfTeams: Int!
    var currentIndex: Int = 0
    var numberOfAnswers = 0
    var playersTurn: Player?
    var currentReader: String?
    var currentReaderLieOrTruth: Bool?
    var allPlayersDidAnswer = false
    var currentRound: Int = 1
    var numberOfRounds: Int!
    var gameIsOver = false
    var isHost = false
    var roundsPlayed = 1
    //Firebase current AppUser nodes
    var gameID: String!
    var playerID: String!
    var currentUserHasAnswerd = false
    var currentUser: Player!
    var currentUsersAnswer: Bool?
    
    var startingSwipeViewY: CGFloat!
    var swipeViewY: CGFloat!
    var seconds = 3
    var isReading = false
    var audioPlayer: AVAudioPlayer!
    var soundArray: [String] = ["Woosh", "Applause", "Sad"]
    
    @IBOutlet weak var waitingForLabel: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    @IBOutlet weak var readingView: UIView!
    @IBOutlet weak var readingTextView: UITextView!
    @IBOutlet weak var viewWithButtonInSwipeView: UIView!
    @IBOutlet weak var headLineImage: UIImageView!
    @IBOutlet weak var playerAnswerCollectionView: UICollectionView!
    @IBOutlet weak var trueButtonOutlet: UIButton!
    @IBOutlet weak var lieButtonOutlet: UIButton!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var kickPlayerView: UIView!
    @IBOutlet weak var kickPlayerTableView: UITableView!
    
    @IBOutlet weak var roundCountView: UIView!
    @IBOutlet weak var roundCountImageView: UIImageView!
    @IBOutlet weak var labelWithRoundCount: UILabelX!
    
    //Settings om man inte är spelvärd
    @IBOutlet weak var settingsViewForPlayers: UIViewX!
    @IBOutlet weak var settingsViewForPlayersImage: UIImageView!
    
    @IBOutlet weak var leaveGameButtonOutlet: UIButton!
    @IBOutlet weak var resumeGameForPlayersOutlet: UIButton!
    @IBOutlet weak var rulesAndTipsForPlayersOutlet: UIButton!
    
    
    
    @IBOutlet weak var rulesAndTipsOutlet: UIButton!
    
    //FINal Resultat view
    @IBOutlet weak var finalResultView: UIViewX!
    @IBOutlet weak var finalResultButtonOutlet: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    
    @IBOutlet weak var resultViewImage: UIImageView!
    @IBOutlet weak var lastViewInFinalResultView: UIView!
    
    @IBOutlet weak var lastViewImage: UIImageView!
    @IBOutlet weak var quitGameInLastViewOutlet: UIButton!
    @IBOutlet weak var playAgainInLastViewButtonOutlet: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
    //Alla resultat-view kopplingar
    @IBOutlet weak var resultView: UIViewX!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var personThatSpokeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tumbsUpOrDownImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var smallResultView1: UIViewX!
    @IBOutlet weak var smallResultView2: UIView!
    @IBOutlet weak var roundPageIndicator1: UIViewX!
    @IBOutlet weak var roundPageIndicator2: UIViewX!
    
    
    @IBOutlet weak var swipeViewImage: UIImageView!
    
    @IBOutlet weak var readingViewImage: UIImageView!
    
    @IBOutlet weak var swipeBlurView: UIVisualEffectView!
    
    @IBOutlet weak var areYouSureImage: UIImageView!
    @IBOutlet weak var alertViewImage: UIImageView!
    @IBOutlet weak var kickPlayerViewImage: UIImageView!
    @IBOutlet weak var topBlurView: UIVisualEffectView!
    @IBOutlet weak var topBlurViewButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareToPlay()
        self.observeGameIndex()
        self.scoreTableView.rowHeight = 44
        self.resultTableView.rowHeight = 44
        self.kickPlayerTableView.rowHeight = 44
        self.resultTableView.sectionHeaderHeight = 0
        
        if self.numberOfTeams > 0 {
            setUpTableView()
        }
        observePlayers {
            if self.numberOfTeams > 2 {
                self.multiPlayerSetup()
                for player in self.allPlayers {
                    if let _ = player.isHost {
                        self.setGuessingAndReadingTeam(index: player.team-1)
                    }
                }
            }
            self.sortAllPlayersArrayAfterAnswers()
            self.observingPlayers()
            self.setTotalNumberOfRounds()
        }
        observeGame()
        self.positionAllViews()
        resultView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    override func viewDidLayoutSubviews() {
        //Hiarci
        self.view.bringSubview(toFront: self.swipeBlurView)
        self.view.bringSubview(toFront: self.swipeView)
        self.view.bringSubview(toFront: self.blurView)
        self.view.bringSubview(toFront: self.resultView)
        self.view.bringSubview(toFront: self.settingsView)
        self.view.bringSubview(toFront: self.settingsViewForPlayers)
        self.view.bringSubview(toFront: self.topBlurView)
        self.view.bringSubview(toFront: self.kickPlayerView)
        self.view.bringSubview(toFront: self.gameOverView)
        self.view.bringSubview(toFront: self.gameOverLoserView)
        self.view.bringSubview(toFront: self.areYouSureView)
        self.view.bringSubview(toFront: self.alertViewOutlet)
        self.view.bringSubview(toFront: self.finalResultView)
        self.view.bringSubview(toFront: self.lastViewInFinalResultView)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        GAME_REF.child("index").removeObserver(withHandle: indexHandler)
        GAME_REF.removeObserver(withHandle: gameHandler)
        PLAYER_REF.removeObserver(withHandle: playerHandler)
        PLAYER_REF.removeObserver(withHandle: removeHandler)
    }
    
    @IBOutlet weak var gameOverView: UIViewX!
    @IBOutlet weak var gameOverButtonOutlet: UIButton!
    @IBOutlet weak var gameOverLoserView: UIView!
    
    @IBOutlet weak var gameOverLoserButton: UIButton!
    @IBOutlet weak var firstStarRed: UIImageView!
    @IBOutlet weak var secondStarYellow: UIImageView!
    @IBOutlet weak var thirdStarBlue: UIImageView!
    @IBOutlet weak var fourthStarYellow: UIImageView!
    @IBOutlet weak var fifthStarRed: UIImageView!
    @IBOutlet weak var sixthStarBlue: UIImageView!
    @IBOutlet weak var seventhStarYellow: UIImageView!
    @IBOutlet weak var eightStarRed: UIImageView!
    
    func isWinner () -> Bool {
        if self.numberOfTeams > 0 {
            self.allTeamsArray.sort(by: {$1.points < $0.points})
        }
        else {
            self.allPlayers.sort (by: {$1.points < $0.points})
        }
        
        if self.numberOfTeams > 0 {
            //OM man är i lag och vinner:
            if currentUser.team-1 == allTeamsArray[0].teamIndex || allTeamsArray[currentUser.team-1].points == allTeamsArray[0].points {
                return true
            }
                
            else {
                return false
            }
        }
        else {
            //Om man är själv och vinner
            var currentPlayer: Player
            for player in allPlayers {
                if player.index == currentUser.index {
                    currentPlayer = player
                    if currentPlayer.index == allPlayers[0].index || currentPlayer.points == allPlayers[0].points {
                        return true
                    }
                        //Om man är själv och förlorar
                    else {
                        return false
                    }
                }
            }
        }
        return false
    }
    
    func testAnimation(){
        self.blurView.alpha = 1
        
        if self.numberOfTeams > 0 {
            //OM man är i lag och vinner:
            if isWinner() {
                self.winAnimation()
            }
                
            else {
                self.loseAnimation()
            }
        }
        else {
            //Om man är själv och vinner
            if isWinner() {
                self.winAnimation()
            }
                //Om man är själv och förlorar
            else {
                self.loseAnimation()
            }
        }
    }
    
    func winAnimation() {
        playSound(soundString: soundArray[1])
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .allowUserInteraction, animations: {
            self.gameOverView.alpha = 1
            self.gameOverButtonOutlet.pulsateStar()
            
            self.firstStarRed.blink(delay: 6.3)
            self.fourthStarYellow.blink(delay: 3.6)
            self.seventhStarYellow.blink(delay: 1.5)
            self.eightStarRed.blink(delay: 5.5)
            
        }, completion: nil)
    }
    
    func loseAnimation() {
        playSound(soundString: soundArray[2])
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .allowUserInteraction, animations: {
            self.gameOverLoserView.alpha = 1
            self.gameOverLoserButton.shakeViewSlowly()
            
        }, completion: nil)
    }
    
    
    
    @IBAction func winButtonPressed(_ sender: UIButton) {
        self.gameOverButtonOutlet.layer.removeAllAnimations()
        self.firstStarRed.layer.removeAllAnimations()
        self.secondStarYellow.layer.removeAllAnimations()
        self.thirdStarBlue.layer.removeAllAnimations()
        self.fourthStarYellow.layer.removeAllAnimations()
        self.fifthStarRed.layer.removeAllAnimations()
        self.sixthStarBlue.layer.removeAllAnimations()
        self.seventhStarYellow.layer.removeAllAnimations()
        self.eightStarRed.layer.removeAllAnimations()
        
        self.blurViewButtonOutlet.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.resultTableView.reloadWithAnimation()
            self.finalResultView.alpha = 1
        })
    }
    
    @IBAction func loseButtonPressed(_ sender: UIButton) {
        self.gameOverLoserButton.layer.removeAllAnimations()
        self.blurViewButtonOutlet.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.resultTableView.reloadWithAnimation()
            self.finalResultView.alpha = 1
        })
    }
    
    
    
    
    @IBOutlet weak var blurViewButtonOutlet: UIButton!
    
    @IBAction func blurViewButton(_ sender: UIButton) {
        self.blurViewButtonOutlet.isHidden = true
        if isHost {
            UIView.animate(withDuration: 0.5) {
                self.blurView.alpha = 0
                self.settingsView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY - 200)
                if self.settingsVar == 2 {
                    self.kickPlayerView.transform = CGAffineTransform(scaleX: 0, y: 0)
                }
            }
        }
        else {
            UIView.animate(withDuration: 0.5) {
                self.blurView.alpha = 0
                self.settingsViewForPlayers.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY - 200)
            }
        }
    }
    
    
    func positionAllViews(){
        self.swipeBlurView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
        self.swipeBlurView.alpha = 0
        self.topBlurView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
        self.topBlurViewButton.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
        self.topBlurView.alpha = 0
        self.gameOverView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.gameOverButtonOutlet.frame = CGRect(x: self.gameOverView.bounds.midX - self.view.frame.width * 0.35, y: self.gameOverView.bounds.midY - self.view.frame.width * 0.35, width: self.view.frame.width * 0.7, height: self.view.frame.width * 0.7)
        self.gameOverLoserView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.gameOverLoserButton.frame = CGRect(x: self.gameOverLoserView.bounds.midX - self.view.frame.width * 0.35, y: self.gameOverLoserView.bounds.midY - self.view.frame.width * 0.35, width: self.view.frame.width * 0.7, height: self.view.frame.width * 0.7)
        self.gameOverView.alpha = 0
        self.gameOverLoserView.alpha = 0
        
        self.firstStarRed.frame = CGRect(x: 20, y: 40, width: self.view.frame.width * 0.07, height: self.view.frame.width * 0.07)
        self.secondStarYellow.frame = CGRect(x: self.view.frame.width - self.view.frame.width * 0.45, y: self.view.frame.height * 0.1, width: self.view.frame.width * 0.2, height: self.view.frame.width * 0.2)
        self.thirdStarBlue.frame = CGRect(x: 45, y: self.firstStarRed.frame.maxY + 20, width: self.view.frame.width * 0.1, height: self.view.frame.width * 0.1)
        self.fourthStarYellow.frame = CGRect(x: self.view.frame.minX + 30, y: self.gameOverButtonOutlet.frame.minY - self.view.frame.width * 0.2, width: self.view.frame.width * 0.18, height: self.view.frame.width * 0.18)
        self.fifthStarRed.frame = CGRect(x: self.view.frame.minX + 10, y: self.view.frame.midY + 20, width: self.view.frame.width * 0.05, height: self.view.frame.width * 0.05)
        self.sixthStarBlue.frame = CGRect(x: self.view.frame.maxX - self.view.frame.width * 0.3, y: self.gameOverButtonOutlet.frame.maxY + 15, width: self.view.frame.width * 0.12, height: self.view.frame.width * 0.12)
        self.seventhStarYellow.frame = CGRect(x: self.view.frame.maxX - self.view.frame.width * 0.35, y: self.sixthStarBlue.frame.maxY + 30, width: self.view.frame.width * 0.14, height: self.view.frame.width * 0.14)
        self.eightStarRed.frame = CGRect(x: 30, y: self.view.frame.maxY - self.view.frame.width * 0.4, width: self.view.frame.width * 0.15, height: self.view.frame.width * 0.15)
        
        
        self.headLineImage.frame.size = CGSize(width: view.frame.width * 0.7, height: 100)
        self.headLineImage.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY + 90)
        if view.frame.width > 450 {
            self.headLineImage.frame.size = CGSize(width: view.frame.width * 0.7, height: 100)
            self.headLineImage.center = CGPoint(x: self.view.center.x, y: self.view.frame.minY + 100)
        }
        self.playerAnswerCollectionView.frame = CGRect(x: view.center.x - (view.frame.size.width * 0.5), y: headLineImage.center.y + 40, width: view.frame.size.width, height: 90 )
        self.waitingForLabel.frame = CGRect(x: self.playerAnswerCollectionView.center.x-self.playerAnswerCollectionView.frame.width*0.5 + 15, y: self.playerAnswerCollectionView.frame.minY - 23, width: self.view.frame.width*0.8, height: 21)
        
        self.showSettingsButtonOutlet.frame = CGRect(x: self.view.frame.maxX - 43, y: self.view.frame.minY + 40, width: 24, height: 24)
        self.roundCountView.frame = CGRect(x: self.view.bounds.maxX - 43, y: self.playerAnswerCollectionView.frame.maxY + 5, width: 33, height: 33)
        self.roundCountImageView.frame = CGRect(x: 0, y: 0, width: self.roundCountView.frame.width, height: self.roundCountView.frame.height)
        self.labelWithRoundCount.frame = CGRect(x: 0, y: 0, width: self.roundCountView.frame.width, height: self.roundCountView.frame.height)
        
        
        if view.frame.width > 450 {
            self.showSettingsButtonOutlet.frame = CGRect(x: self.view.frame.maxX - 80, y: self.view.frame.minY + 40, width: 66, height: 66)
            self.roundCountView.frame = CGRect(x: self.view.bounds.maxX - 80, y: self.playerAnswerCollectionView.frame.maxY + 5, width: 66, height: 66)
            self.roundCountImageView.frame = CGRect(x: 0, y: 0, width: self.roundCountView.frame.width, height: self.roundCountView.frame.height)
            self.labelWithRoundCount.frame = CGRect(x: 0, y: 0, width: self.roundCountView.frame.width, height: self.roundCountView.frame.height)
        }
        
        self.resultCollectionView.frame = CGRect(x: self.view.frame.minX + 10, y: self.roundCountView.frame.maxY + 5, width: self.view.frame.width - 20, height: self.view.frame.height - self.headLineImage.frame.height - self.playerAnswerCollectionView.frame.height - self.roundCountView.frame.height - 160)
        
        
        //RESULTVIEW CONSTRAINTS
        self.resultView.frame.size = CGSize(width: self.view.frame.width * 0.85, height: self.view.frame.height * 0.5)
        self.resultView.center = self.view.center
        self.resultImageView.frame = CGRect(x: self.resultView.bounds.minX, y: self.resultView.bounds.minY, width: self.resultView.frame.width, height: self.resultView.frame.height)
        self.continueButton.frame.size = CGSize(width: self.resultView.bounds.width * 0.3, height: 44.0)
        self.continueButton.center = CGPoint(x: self.resultView.bounds.midX , y: self.resultView.bounds.maxY - 42)
        
        self.roundPageIndicator1.center = CGPoint(x: self.resultView.bounds.midX - 15, y: self.continueButton.frame.minY - 20)
        self.roundPageIndicator2.center = CGPoint(x: self.resultView.bounds.midX + 15, y: self.continueButton.frame.minY - 20)
        self.smallResultView1.frame.size = CGSize(width: self.resultView.frame.width * 0.8, height: self.resultView.bounds.height -  110)
        self.smallResultView1.center = CGPoint(x: self.resultView.bounds.midX, y: self.resultView.bounds.minY+self.smallResultView1.frame.height*0.5+15)
        self.tumbsUpOrDownImage.frame = CGRect(x: self.smallResultView1.frame.width * 0.2, y: self.smallResultView1.frame.height * 0.2, width: self.smallResultView1.frame.width * 0.6, height: self.smallResultView1.frame.height * 0.6)
        
        self.countDownLabel.center = CGPoint(x: self.smallResultView1.bounds.midX, y: self.smallResultView1.bounds.midY)
        self.personThatSpokeLabel.center = CGPoint(x: self.smallResultView1.bounds.midX, y: self.smallResultView1.bounds.minY + 30)
        self.resultLabel.center = CGPoint(x: self.smallResultView1.bounds.midX, y: self.smallResultView1.bounds.midY)
        
        
        self.smallResultView2.frame.size = CGSize(width: self.resultView.frame.width * 0.8, height: self.resultView.frame.height -  120)
        self.smallResultView2.center = CGPoint(x: self.resultView.bounds.midX, y: self.resultView.bounds.minY+self.smallResultView2.frame.height*0.5+25)
        self.scoreTableView.frame.size = CGSize(width: smallResultView2.bounds.width, height: smallResultView2.bounds.height - 5)
        self.scoreTableView.center = CGPoint(x: self.smallResultView2.bounds.midX, y: self.smallResultView2.bounds.midX + 8)
        
        
        blurView.frame.size = self.view.frame.size
        blurView.center = view.center
        blurViewButtonOutlet.frame.size = blurView.frame.size
        blurViewButtonOutlet.center = self.view.center
        blurView.alpha = 0
        
        
        
        //SWIPE VIEW
        self.swipeView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.45)
        self.swipeView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height-100 + self.swipeView.frame.height * 0.5)
        self.viewWithButtonInSwipeView.frame = CGRect(x: self.swipeView.bounds.minX + 2.5, y: self.swipeView.bounds.minY + 5, width: self.swipeView.bounds.width - 5, height: 50)
        self.swipeViewExclamationMark.frame = CGRect(x: self.viewWithButtonInSwipeView.bounds.maxX - 50, y: 5, width: 40, height: 40)
        self.viewWithButtonInSwipeView.roundCorner(corners: [.topLeft, .topRight], radius: 5)
        self.swipeUpButton.frame = CGRect(x: self.viewWithButtonInSwipeView.bounds.midX-self.swipeUpButton.bounds.width*0.5, y: self.swipeView.bounds.minY+3, width: 44, height: 44)
        self.swipeArrow.frame = CGRect(x: self.viewWithButtonInSwipeView.bounds.midX-self.swipeArrow.bounds.width*0.5, y: self.swipeView.bounds.minY+15, width: 25, height: 20)
        
        self.swipeLabel.frame = CGRect(x: self.swipeView.bounds.minX, y: self.swipeView.bounds.minY+self.viewWithButtonInSwipeView.bounds.height + 8, width: self.swipeView.bounds.width, height: 26)
        self.answerView.frame = CGRect(x: self.swipeView.bounds.minX + 10, y: self.swipeView.bounds.minY+self.viewWithButtonInSwipeView.bounds.height + self.swipeLabel.bounds.height + 20, width: self.swipeView.bounds.width-20, height: self.swipeView.bounds.height-self.viewWithButtonInSwipeView.bounds.height - self.swipeLabel.bounds.height - 30)
        
        self.lieButtonOutlet.frame = CGRect(x: self.answerView.bounds.midX+20, y: self.answerView.bounds.midY - 22, width: self.answerView.bounds.width*0.3, height: self.answerView.bounds.width*0.3)
        self.trueButtonOutlet.frame = CGRect(x: self.answerView.bounds.midX-self.lieButtonOutlet.bounds.width-20, y: self.answerView.bounds.midY - 22, width: self.answerView.bounds.width*0.3, height: self.answerView.bounds.width*0.3)
        
        
        self.readingView.frame = CGRect(x: self.swipeView.bounds.minX + 10, y: self.swipeView.bounds.minX+self.viewWithButtonInSwipeView.bounds.height + self.swipeLabel.bounds.height + 25, width: self.swipeView.bounds.width-20, height: self.swipeView.bounds.height-self.viewWithButtonInSwipeView.bounds.height - self.swipeLabel.bounds.height - 35)
        self.readingTextView.frame = CGRect(x: self.readingView.bounds.minX+5, y: self.readingView.bounds.minY+5, width: self.readingView.frame.width - 10, height: self.readingView.frame.height - 60)
        self.switchLieButtonOutlet.frame = CGRect(x: self.readingView.bounds.midX - 25, y: self.readingView.bounds.maxY - 50 , width: 40, height: 40)
        
        self.startingSwipeViewY = swipeView.center.y
        self.swipeViewY = swipeView.center.y
        
        
        
        //Settings
        self.settingsView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 315)
        self.settingsView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY - 200)
        self.settingsViewImage.frame = CGRect(x: 0, y: 0, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
        self.resumeGameButtonOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 20 , width: self.settingsView.bounds.width * 0.8, height: 50)
        self.rulesAndTipsOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 75 , width: self.settingsView.bounds.width * 0.8, height: 50)
        
        self.restartButtonOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 130 , width: self.settingsView.bounds.width * 0.8, height: 50)
        self.quitGameButtonOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 185 , width: self.settingsView.bounds.width * 0.8, height: 50)
        self.kickPlayersButtonOutlet.frame = CGRect(x: self.settingsView.bounds.minX + self.settingsView.bounds.width * 0.1, y: self.settingsView.bounds.minY + 240 , width: self.settingsView.bounds.width * 0.8, height: 50)
        
        
        //ARE YOU SURE VIEW
        self.areYouSureView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 250)
        self.areYouSureView.center = CGPoint(x: self.view.center.x, y: self.view.frame.midY)
        self.areYouSureImage.frame = CGRect(x: self.areYouSureView.bounds.minX, y: self.areYouSureView.bounds.minY, width: self.areYouSureView.frame.width, height: self.areYouSureView.frame.height)
        
        self.areYouSureTextView.frame = CGRect(x: self.areYouSureView.bounds.minX + 15, y: self.areYouSureView.bounds.minY + 5, width: self.areYouSureView.frame.width - 30, height: 70)
        self.yesImSureButton.frame = CGRect(x: self.areYouSureView.bounds.midX - self.areYouSureView.frame.width * 0.4, y: self.areYouSureView.bounds.midY, width: self.areYouSureView.frame.width * 0.3, height: 44)
        self.noImNotSureButton.frame = CGRect(x: self.areYouSureView.bounds.midX + self.areYouSureView.frame.width * 0.1, y: self.areYouSureView.bounds.midY, width: self.areYouSureView.frame.width * 0.3, height: 44)
        
        self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        
        //AlertView
        self.alertViewOutlet.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 260)
        self.alertViewOutlet.center = CGPoint(x: self.view.center.x, y: self.view.frame.midY)
        self.alertViewImage.frame = CGRect(x: self.alertViewOutlet.bounds.minX, y: self.alertViewOutlet.bounds.minY, width: self.alertViewOutlet.frame.width, height: self.alertViewOutlet.frame.height)
        self.textViewInAlertView.frame = CGRect(x: self.alertViewOutlet.bounds.minX + 15, y: self.alertViewOutlet.bounds.minY + 5, width: self.alertViewOutlet.frame.width - 30, height: 180)
        self.okInAlertViewButtonOutlet.frame = CGRect(x: self.alertViewOutlet.bounds.midX - self.okInAlertViewButtonOutlet.frame.width*0.5, y: self.alertViewOutlet.bounds.maxY - 59, width: self.alertViewOutlet.frame.width * 0.3, height: 44)
        self.alertViewOutlet.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //Kick Player View
        self.kickPlayerView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 250)
        self.kickPlayerView.center = CGPoint(x: self.view.center.x, y: self.view.frame.midY)
        self.kickPlayerViewImage.frame = CGRect(x: self.kickPlayerView.bounds.minX, y: self.kickPlayerView.bounds.minY, width: self.kickPlayerView.frame.width, height: self.kickPlayerView.frame.height)
        self.kickPlayerTableView.frame = CGRect(x: self.kickPlayerView.bounds.minX + self.kickPlayerView.frame.width * 0.1, y: self.kickPlayerView.bounds.minY + self.kickPlayerView.frame.height * 0.1, width: self.kickPlayerView.frame.width - self.kickPlayerView.frame.width * 0.2, height: self.kickPlayerView.frame.height - self.kickPlayerView.frame.height * 0.2)
        self.kickPlayerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //Settings om man inte är spelvärd
        self.settingsViewForPlayers.frame.size = CGSize(width: self.view.frame.width * 0.8, height: 215)
        self.settingsViewForPlayers.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY - 200)
        self.settingsViewForPlayersImage.frame = CGRect(x: self.settingsViewForPlayers.bounds.minX, y: self.settingsViewForPlayers.bounds.minY, width: self.settingsViewForPlayers.bounds.width, height: self.settingsViewForPlayers.bounds.height)
        self.resumeGameForPlayersOutlet.frame = CGRect(x: self.settingsViewForPlayers.bounds.minX + self.settingsViewForPlayers.bounds.width * 0.1, y: self.settingsViewForPlayers.bounds.minY + 20 , width: self.settingsViewForPlayers.bounds.width * 0.8, height: 50)
        self.rulesAndTipsForPlayersOutlet.frame = CGRect(x: self.settingsViewForPlayers.bounds.minX + self.settingsViewForPlayers.bounds.width * 0.1, y: self.resumeGameForPlayersOutlet.frame.maxY + 5 , width: self.settingsViewForPlayers.bounds.width * 0.8, height: 50)
        self.leaveGameButtonOutlet.frame = CGRect(x: self.settingsViewForPlayers.bounds.minX + self.settingsViewForPlayers.bounds.width * 0.1, y: self.rulesAndTipsForPlayersOutlet.frame.maxY + 5 , width: self.settingsViewForPlayers.bounds.width * 0.8, height: 50)
        
        //Final Result view
        self.finalResultView.frame.size = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.6)
        self.finalResultView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        self.finalResultButtonOutlet.frame = CGRect(x: self.finalResultView.bounds.midX - self.finalResultView.frame.width * 0.15, y: self.finalResultView.bounds.maxY - 60, width: self.finalResultView.frame.width * 0.3, height: 44)
        self.resultTableView.frame = CGRect(x: self.finalResultView.frame.width * 0.15, y: self.finalResultView.frame.width * 0.15 , width: self.finalResultView.frame.width * 0.7, height: self.finalResultView.frame.height * 0.7 - 44)
        self.resultViewImage.frame = CGRect(x: 0, y: 0, width: self.finalResultView.frame.width, height: self.finalResultView.frame.height)
        
        self.lastViewInFinalResultView.frame = CGRect(x:self.view.frame.width * 0.15, y: self.view.frame.midY - 100, width: self.view.frame.width * 0.7, height: 200)
        self.lastViewImage.frame = CGRect(x: 0, y: 0, width: self.lastViewInFinalResultView.frame.width, height: self.lastViewInFinalResultView.frame.height)
        self.playAgainInLastViewButtonOutlet.frame = CGRect(x: self.lastViewInFinalResultView.bounds.midX - self.lastViewInFinalResultView.frame.width * 0.35, y: self.lastViewInFinalResultView.bounds.midY - 80, width: self.lastViewInFinalResultView.frame.width * 0.7, height: 60)
        self.quitGameInLastViewOutlet.frame = CGRect(x: self.lastViewInFinalResultView.bounds.midX - self.lastViewInFinalResultView.frame.width * 0.35, y: self.lastViewInFinalResultView.bounds.midY + 20, width: self.lastViewInFinalResultView.frame.width * 0.7, height: 60)
        
        self.labelWithRoundCount.layer.cornerRadius = 3
        
        
        
        self.swipeViewImage.frame.size = CGSize(width: self.swipeView.frame.size.width, height: self.swipeView.frame.size.height)
        self.swipeViewImage.center = CGPoint(x: self.swipeView.bounds.midX, y: swipeView.bounds.midY)
        self.readingViewImage.frame.size = CGSize(width: self.readingView.frame.size.width, height: self.readingView.frame.size.height)
        self.readingViewImage.center = CGPoint(x: self.readingView.bounds.midX, y: readingView.bounds.midY)
        
    }
    
    func prepareToPlay(){
        for sound in soundArray {
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!))
                audioPlayer.prepareToPlay()
                
                
            }
            catch{
                print(error)
            }
        }
    }
    
    
    func playSound(soundString: String){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundString, ofType: "mp3")!))
            
            
        }
        catch{
            print(error)
        }
        DispatchQueue.global().async {
            self.audioPlayer.play()
        }
    }
    
    
    //MARK: COLLECTION VIEWS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.resultCollectionView{
            if self.numberOfTeams > 0 {
                return CGSize(width: self.view.frame.width / 2.3 , height: 250)
                
            }
            else {
                if view.frame.size.width > 450 {
                    return CGSize(width: self.view.frame.width / 3.5 , height: 200)
                }
                
                return CGSize(width: self.view.frame.width / 2.3 , height: 100)
            }
        }
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.resultCollectionView && self.numberOfTeams > 0 {
            return 2
        }
        if collectionView == self.playerAnswerCollectionView {
            return playersThatHaventAnswerd.count
        }
        return allPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.resultCollectionView && self.numberOfTeams == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleGameCell", for: indexPath) as! SingleGameCell
            let player = allPlayers[indexPath.item]
            
            cell.profileImage.image = UIImage(named: player.avatar)
            cell.nameLabel.text = player.name
            cell.pointsLabel.text = String(player.points)
            cell.positionLabel.text = String("#\(indexPath.item + 1)")
            
            return cell
            
        }
        else if collectionView == self.resultCollectionView && self.numberOfTeams > 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "multiPlayerCell", for: indexPath) as! MultiPlayerCollectionViewCell
            cell.players = allTeamsArray[indexPath.item].team
            cell.innerCollectionView.reloadData()
            cell.pointsLabel.text = "\(allTeamsArray[indexPath.item].points) poäng"
            cell.teamLabel.text = allTeamsArray[indexPath.item].teamName
            
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waitingForPlayerCell", for: indexPath) as! AvatarCollectionCell
        let player = playersThatHaventAnswerd[indexPath.item]
        
        
        cell.nameLabel.text = player.name
        cell.imageLabel.image = UIImage(named: player.avatar)
        
        return cell
    }
    
    
    //SORTERAR SPELARNA I ÖVERSTA COLLECTIONVIEWEN EFTER SVAR ELLER EJ
    func sortAllPlayersArrayAfterAnswers() {
        playersThatHaventAnswerd.removeAll()
        
        if numberOfTeams > 0 {
            allTeamsArray.sort(by:{$0.teamIndex < $1.teamIndex})
            if let guessingTeam = self.guessingTeam {
                for player in allTeamsArray[guessingTeam].team {
                    self.playersThatHaventAnswerd.append(player)
                }
                self.playerAnswerCollectionView.reloadData()
            }
        }
        else {
            for player in allPlayers {
                if player.index != currentIndex{
                    self.playersThatHaventAnswerd.append(player)
                }
                self.playerAnswerCollectionView.reloadData()
            }
        }
    }
    
    //Ökar "numberOfAnswers i firebase med 1"
    func increaseNumberOfAnswersByOne() {
        if currentUserHasAnswerd == false {
            self.currentUserHasAnswerd = true
            GAME_REF.child("numberOfAnswers").setValue(self.numberOfAnswers + 1)
        }
    }
    
    //En koll som körs varje gång game Observer körs
    var backUpIsNecessary = false
    
    var multiplayerUpdatingBool = false
    
    func multiplayerAnswerEqually() -> Bool {
        self.allTeamsArray.sort(by:{$0.teamIndex < $1.teamIndex})
        var trueOrFalse = false
        let answerToCompare = allTeamsArray[guessingTeam].team[0].answer
        for (index, player) in allTeamsArray[guessingTeam].team.enumerated() {
            if player.answer != answerToCompare {
                trueOrFalse = false
                break
            }
            if index == self.allTeamsArray[guessingTeam].team.count-1 {
                trueOrFalse = true
            }
        }
        return trueOrFalse
    }
    
    func checkIfAllPlayerHasAnswerd() {
        if numberOfTeams > 0 {
            self.allTeamsArray.sort(by:{$0.teamIndex < $1.teamIndex})
            if numberOfAnswers == allTeamsArray[self.guessingTeam].team.count {
                if multiplayerAnswerEqually() {
                    self.swipeDown()
                    self.backUpIsNecessary = false
                    self.allPlayersDidAnswer = true
                    self.allPlayerHasAnswerd()
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: .allowUserInteraction, animations: {
                        self.blurView.alpha = 1
                        self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 0.1)
                    }) { (true) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        })
                    }
                }
                else {
                    //TODO - Bara de som gissar ska få meddelandet
                    if self.allTeamsArray[guessingTeam].team.contains(where: { $0.name == self.currentUser.name }) {
                        backUpIsNecessary = true
                        self.alert(title: "Svara likadant tack!", message: "!")
                    }
                }
            }
        }
        else {
            if self.numberOfAnswers == allPlayers.count - 1  {
                self.swipeDown()
                self.backUpIsNecessary = false
                self.allPlayersDidAnswer = true
                self.allPlayerHasAnswerd()
                UIView.animate(withDuration: 0.5, delay: 0.1, options: .allowUserInteraction, animations: {
                    self.blurView.alpha = 1
                    self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 0.1)
                }) { (true) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    })
                }
            }
        }
    }
    
    
    func extraCheckIfAllPlayersHasAnswerd() {
        // EN EXTRA KOLL IFALL TVÅ ANVÄNDARE SVARAR EXAKT SAMTIDIGT
        if self.numberOfTeams > 0 {
            if allPlayersDidAnswer == false && backUpIsNecessary == true{
                if  multiplayerAnswerEqually() {
                    self.backUpIsNecessary = false
                    self.swipeDown()
                    self.allPlayersDidAnswer = true
                    self.allPlayerHasAnswerd()
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: .allowUserInteraction, animations: {
                        self.blurView.alpha = 1
                        self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 0.1)
                    }) { (true) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        })
                    }
                    self.swipeViewExclamationMark.isHidden = true
                }
                else {
                    
                    if self.allTeamsArray[guessingTeam].team.contains(where: { $0.name == self.currentUser.name }) {
                        backUpIsNecessary = true
                        self.swipeViewExclamationMark.isHidden = false
                        self.alertViewVarible = AlertViewChoice.other
                        self.textViewInAlertView.text = "Lagets medlemmar har givit olika svar. För att komma vidare behöver ni komma överrens om ett gemensamt svar inom laget"
                        UIView.animate(withDuration: 0.5) {
                            self.alertViewOutlet.transform = .identity
                        }
                    }
                }
            }
        }
        else {
            if allPlayersDidAnswer == false && backUpIsNecessary == true{
                self.backUpIsNecessary = false
                self.swipeDown()
                self.allPlayersDidAnswer = true
                self.allPlayerHasAnswerd()
                UIView.animate(withDuration: 0.5, delay: 0.1, options: .allowUserInteraction, animations: {
                    self.blurView.alpha = 1
                    self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 0.1)
                }) { (true) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.resultView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    })
                }
            }
        }
    }
    
    
    
    func rightOrWrong() -> Bool? {
        if self.currentIndex != self.currentUser.index {
            if let trueOrFalse = currentReaderLieOrTruth {
                if let answer = currentUsersAnswer {
                    if trueOrFalse {
                        if answer == true {
                            return true
                            
                        }
                        else {
                            return false
                        }
                    }
                    else {
                        if answer == true {
                            return false
                        }
                        else {
                            return true
                        }
                    }
                }
                return nil
            }
        }
        return nil
    }
    
    //Körs när alla spelare har svarat
    func allPlayerHasAnswerd() {
        self.checkIfGameIsOver()
        self.startTimer()
        self.swipeLabel.text = "Väntar på spelledaren..."
        
        //LAGSPEL
        //TODO: - När lagen har svarat
        if self.numberOfTeams > 0 {
            self.allTeamsArray.sort(by: {$0.teamIndex < $1.teamIndex})
            let playerAnswer = self.allTeamsArray[self.guessingTeam].team[0].answer
            if let trueOrFalse = currentReaderLieOrTruth {
                if (playerAnswer == "true" && trueOrFalse == true ) || (playerAnswer == "false" && trueOrFalse == false)  {
                    //Laget som gissar, gissade rätt
                    self.allTeamsArray[guessingTeam].points += 1
                    for player in self.allTeamsArray[guessingTeam].team{
                        player.points += 1
                        if isHost{
                            PLAYER_REF.child(player.name).child("points").setValue(player.points)
                        }
                    }
                    
                }
                else {
                    //Laget som gissar, gissade fel
                    self.allTeamsArray[readingTeam].points += 1
                    for player in self.allTeamsArray[readingTeam].team{
                        player.points += 1
                        if isHost{
                            PLAYER_REF.child(player.name).child("points").setValue(player.points)
                        }
                    }
                }
                self.personThatSpokeLabel.text = "\(currentReader!)..."
                if currentReader != self.currentUser!.name {
                    if trueOrFalse {
                        resultLabel.text = "talade sanning!"
                    }
                    else {
                        resultLabel.text = "ljög!"
                    }
                }
                else if currentReader == self.currentUser!.name{
                    self.personThatSpokeLabel.text = "Du..."
                    if trueOrFalse {
                        self.resultLabel.text = "talade sanning!"
                    }
                    else {
                        self.resultLabel.text = "ljög!"
                    }
                }
            }
        }
            //SINGEL-SPEL
        else {
            if let currentReader = currentReader {
                if let trueOrFalse = currentReaderLieOrTruth {
                    self.personThatSpokeLabel.text = "\(currentReader)..."
                    if currentReader != self.currentUser!.name {
                        
                        if let answer = currentUsersAnswer {
                            if trueOrFalse {
                                resultLabel.text = "talade sanning!"
                                if answer == true {
                                    
                                    for player in allPlayers {
                                        if player.name == currentUser.name{
                                            PLAYER_REF.child(currentUser.name).child("points").setValue(player.points + 1)
                                        }
                                    }
                                }
                            }
                                
                            else {
                                resultLabel.text = "ljög!"
                                if answer == true {
                                    
                                }
                                else {
                                    for player in allPlayers {
                                        if player.name == currentUser.name{
                                            PLAYER_REF.child(currentUser.name).child("points").setValue(player.points + 1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                        
                    else if currentReader == self.currentUser!.name{
                        self.personThatSpokeLabel.text = "Du..."
                        if trueOrFalse {
                            self.resultLabel.text = "talade sanning!"
                        }
                        else {
                            self.resultLabel.text = "ljög!"
                        }
                    }
                }
            }
        }
        self.scoreTableView.reloadData()
    }
    
    func checkIfGameIsOver() {
        if roundsPlayed >= self.totalNumberOfRounds {
            self.gameIsOver = true
            if isHost {
                self.restartGame()
            }
        }
    }
    
    //Körs efter att resultatrutan kommit upp
    @objc func countDown() {
        countDownLabel.text = String(seconds)
        seconds = seconds - 1
        if seconds == -1 {
            self.allPlayersDidAnswer = false
            self.continueButton.isEnabled = true
            timer.invalidate()
            UIView.animate(withDuration: 0.2, animations: {
                self.countDownLabel.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.resultLabel.alpha = 1
                }, completion: { (true) in
                    if let rightOrWrongAnswer =
                        self.rightOrWrong()
                    {
                        if rightOrWrongAnswer { self.tumbsUpOrDownImage.image = UIImage(named: "rätt")
                        }
                        else {
                            //Bild för fel
                            self.tumbsUpOrDownImage.image = UIImage(named: "fel")
                        }
                        
                    }
                    else {
                        self.tumbsUpOrDownImage.image = nil
                    }
                    UIView.animate(withDuration: 0.8, animations: {
                        self.tumbsUpOrDownImage.alpha = 1
                        self.tumbsUpOrDownImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.8, delay: 0.2, options: .allowUserInteraction, animations: {
                            self.tumbsUpOrDownImage.transform = .identity
                            self.tumbsUpOrDownImage.alpha = 0
                        })
                    })
                })
            }
        }
    }
    
    
    //Nedräkning tills svaret visas
    var timer = Timer()
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    var resultViewIndex = 0
    //Detta händer efter man trycker på fortsätt knappen.
    @IBAction func afterResultButton(_ sender: UIButton) {
        if resultViewIndex ==  0 {
            self.showTableViewWithResult()
            self.resultViewIndex = 1
        }
        else if resultViewIndex == 1 {
            closeResultButtonAndRestoreFirebaseNodes()
            if self.gameIsOver{
                GAME_REF.child("open").setValue(true)
                self.testAnimation()
            }
            self.resultViewIndex = 0
        }
        
    }
    
    
    
    var totalNumberOfRounds = 0
    
    func setTotalNumberOfRounds() {
        self.totalNumberOfRounds = numberOfRounds * allPlayers.count
        self.updateLabelWithNumberOfRounds()
    }
    
    func reduceTotalNumberOfRoundsIfPlayerLeaveGame(index: Int) {
        if index < self.currentIndex {
            self.totalNumberOfRounds -= (self.numberOfRounds-self.currentRound)
        }
        else {
            self.totalNumberOfRounds -= (self.numberOfRounds-self.currentRound)+1
        }
        self.updateLabelWithNumberOfRounds()
    }
    
    func updateLabelWithNumberOfRounds(){
        
        self.labelWithRoundCount.text = String("\(self.roundsPlayed)/\(self.totalNumberOfRounds)")
    }
    
    
    
    
    func closeResultButtonAndRestoreFirebaseNodes(){
        //Om spelaren är spelledare; utför följande
        if isHost && self.gameIsOver == false {
            for player in allPlayers {
                PLAYER_REF.child(player.key).child("answer").setValue("TBA")
            }
            
            var newIndex = currentIndex + 1
            
            if newIndex >= allPlayers.count{
                newIndex = 0
                if(self.numberOfAnswers != 0) {
                    GAME_REF.child("numberOfAnswers").setValue(0)
                }
                GAME_REF.child("currentRound").setValue(currentRound + 1)
            }
            if(self.numberOfAnswers != 0){ GAME_REF.child("numberOfAnswers").setValue(0)
            }
            GAME_REF.child("index").setValue(newIndex)
            
        }
        //Oavsett om man är spelledare eller ej; utför följande:
        self.roundsPlayed += 1
        self.updateLabelWithNumberOfRounds()
        self.switchLieCount = 0
        self.currentUsersAnswer = nil
        self.lieButtonOutlet.transform = .identity
        self.trueButtonOutlet.transform = .identity
        self.smallResultView1.alpha = 0
        self.smallResultView1.frame.size = CGSize(width: self.resultView.frame.width * 0.8, height: self.resultView.bounds.height -  110)
        self.smallResultView1.center = CGPoint(x: self.resultView.bounds.midX, y: self.resultView.bounds.minY+self.smallResultView1.frame.height*0.5+15)
        UIView.animate(withDuration: 0.3, animations: {
            self.resultView.transform = CGAffineTransform(scaleX: 1.0, y: 0.1)
            self.blurView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0 )
            }, completion: { (true) in
                
                self.seconds = 3
                self.countDownLabel.text = String(3)
                self.currentUserHasAnswerd = false
                self.countDownLabel.alpha = 1
                self.resultLabel.alpha = 0
                self.continueButton.isEnabled = false
            })
        }
        
        self.smallResultView1.alpha = 1
        self.smallResultView2.alpha = 0
        
        self.roundPageIndicator1.backgroundColor = UIColor.yellow
        self.roundPageIndicator1.shadowColor = UIColor.yellow
        self.roundPageIndicator2.backgroundColor = UIColor.lightGray
        self.roundPageIndicator2.shadowColor = UIColor.lightGray
    }
    
    
    //    func setUpTeamScore() {
    //        for team in allTeamsArray {
    //            team.points = 0
    //        }
    //        for player in allTeamsArray[0].team{
    //            allTeamsArray[0].points += player.points
    //        }
    //
    //        for player in allTeamsArray[1].team{
    //            allTeamsArray[1].points += player.points
    //        }
    //        self.resultCollectionView.reloadData()
    //    }
    
    
    
    //TableViewn som visar resultatet i "Result-viewn"
    
    func showTableViewWithResult() {
        self.roundPageIndicator1.backgroundColor = UIColor.lightGray
        self.roundPageIndicator1.shadowColor = UIColor.lightGray
        self.roundPageIndicator2.backgroundColor = UIColor.yellow
        self.roundPageIndicator2.shadowColor = UIColor.yellow
        
        UIView.animate(withDuration: 0.5) {
            self.smallResultView2.alpha = 1
            self.smallResultView1.center = CGPoint(x: self.resultView.bounds.minX - self.smallResultView1.frame.width, y: self.smallResultView1.bounds.midY)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if allTeamsArray.count > 0 {
            return allTeamsArray.count
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == kickPlayerTableView {
            return allPlayers.count
        }
        
        if allTeamsArray.count > 0 {
            return 1
        }
        else {
            return allPlayers.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == scoreTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! GameLobbyHeaderCell
            if self.numberOfTeams > 0 {
                cell.pointsLabel.text = String(allTeamsArray[section].points)
                cell.teamLabel.text = allTeamsArray[section].teamName
            }
            else {
                if self.numberOfTeams > 0 {
                    cell.teamLabel.text = "LAG"
                }
                else {
                    cell.teamLabel.text = "SPELARE"
                }
                cell.pointsLabel.text = "GISSNING"
            }
            
            return cell
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
            
            if self.numberOfTeams > 0 {
                let team = allTeamsArray[indexPath.section]
                cell.nameLabel.text = team.teamName
                cell.resultLabel.text = "\(team.points) poäng"
                
            }
            else {
                let player = allPlayers[indexPath.row]
                cell.nameLabel.text = player.name
                cell.resultLabel.text = "\(player.points) poäng"
                cell.avatarImageView.image = UIImage(named: player.avatar)
            }
            
            return cell
        }
        if tableView == kickPlayerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kickPlayerCell", for: indexPath) as! KickPlayerCell
            let player = allPlayers[indexPath.row]
            cell.nameLabel.text = player.name
            cell.kickButton.tag = player.index
            if player.name == currentUser.name {
                cell.kickButton.isHidden = true
            }
            else {
                cell.kickButton.isHidden = false
            }
            cell.kickButton.addTarget(self, action: #selector(self.kickPlayer(sender:)), for: .touchUpInside)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyCell", for: indexPath) as! GameLobbyTableCell
        
        if self.numberOfTeams > 0 {
            let team = allTeamsArray[indexPath.section]
            cell.nameLabel.text = team.teamName
            if team.team.count != 0 {
                cell.pointsLabel.text = checkIfPlayerIsCorrect(player: team.team[0])
            }
            //cell.avatarImage.image = UIImage(named: player.avatar)
        }
        else {
            let player = allPlayers[indexPath.row]
            cell.nameLabel.text = player.name
            cell.pointsLabel.text = checkIfPlayerIsCorrect(player: player)
            cell.avatarImage.image = UIImage(named: player.avatar)
        }
        return cell
    }
    
    func checkIfPlayerIsCorrect(player: Player) -> String {
        
        if let rightAnswer = currentReaderLieOrTruth{
            if rightAnswer == true {
                if player.answer == "TBA"{
                    return "Talade sanning"
                }
                else if player.answer == "TBA" && player.index != currentIndex{
                    return ""
                }
                else if player.answer == "true"{
                    return "Rätt!"
                }
                else if player.answer == "false" {
                    return "Fel!"
                }
            }
            else if rightAnswer == false {
                if player.answer == "TBA"{
                    return "Ljög!"
                }
                else if player.answer == "TBA" && player.index != currentIndex{
                    return ""
                }
                else if player.answer == "true"{
                    return "Fel!"
                }
                else if player.answer == "false" {
                    return "Rätt!"
                }
            }
        }
        return ""
    }
    
    
    
    
    //Loopar fram antal lag i spelet. Indexeras senare i "observePlayers". Användes främst förut när man kunde ha fler än 2 lag
    func setUpTableView(){
        
        if let number = self.numberOfTeams{
            for i in 0..<number {
                let teamName = "Team \(i+1)"
                let array = [Player]()
                let team = AllTeams(teamIndex: i+1, teamName: teamName, points: 0, team: array)
                self.allTeamsArray.append(team)
            }
        }
    }
    
    var indexHandler: UInt = 0
    var guessingTeam: Int!
    var readingTeam: Int!
    
    
    
    //Observar speländringar i firebase
    func observeGameIndex() {
        self.indexHandler = GAME_REF.child("index").observe(.value) { (snapshot) in
            //-------------------
            self.currentIndex = snapshot.value as! Int
            if self.numberOfTeams > 0 {
                self.multiPlayerSetup()
            }
            else {
                if self.currentIndex == self.currentUser.index {
                    self.swipeLabel.text = "Det är din tur!"
                    self.GAME_REF.child("currentReader").setValue(self.currentUser.name)
                    self.startReading()
                    self.readingView.alpha = 1
                    self.answerView.alpha = 0
                }
                else {
                    self.swipeLabel.text = "Dra uppåt för att svara!"
                    self.readingView.alpha = 0
                    self.answerView.alpha = 1
                }
            }
            self.updateLabelWithNumberOfRounds()
            self.sortAllPlayersArrayAfterAnswers()
        }
        
    }
    
    func multiPlayerSetup() {
        self.allTeamsArray.sort(by: {$0.teamIndex < $1.teamIndex})
        if self.allTeamsArray[0].team.contains(where: { $0.index == self.currentIndex }) {
            if self.currentUser.team == 1 {
                self.swipeLabel.text = "Din lagkamrat läser"
                self.readingTeam = 0
                self.guessingTeam = 1
                self.readingView.alpha = 0
                self.answerView.alpha = 0
            }
            else {
                self.readingTeam = 0
                self.guessingTeam = 1
                self.swipeLabel.text = "Dra uppåt för att svara"
                self.readingView.alpha = 0
                self.answerView.alpha = 1
            }
        } else if self.allTeamsArray[1].team.contains(where: { $0.index == self.currentIndex }) {
            if self.currentUser.team == 2 {
                self.readingTeam = 1
                self.guessingTeam = 0
                self.swipeLabel.text = "Din lagkamrat läser"
                self.readingView.alpha = 0
                self.answerView.alpha = 0
            }
            else {
                self.readingTeam = 1
                self.guessingTeam = 0
                self.swipeLabel.text = "Dra uppåt för att svara"
                self.readingView.alpha = 0
                self.answerView.alpha = 1
            }
        }
        if self.currentIndex == self.currentUser.index {
            self.swipeLabel.text = "Det är din tur!"
            self.GAME_REF.child("currentReader").setValue(self.currentUser.name)
            self.startReading()
            self.readingView.alpha = 1
            self.answerView.alpha = 0
        }
        //self.setUpTeamScore()
    }
    
    var gameHandler: UInt = 1
    
    func observeGame() {
        self.gameHandler = GAME_REF.observe(.value) { (snapshot) in
            //--------------------
            if self.allPlayersDidAnswer == false {
                if snapshot.childSnapshot(forPath: "numberOfAnswers").exists(){
                    self.numberOfAnswers = snapshot.childSnapshot(forPath: "numberOfAnswers").value as! Int
                    if snapshot.childSnapshot(forPath: "numberOfAnswers").value as! Int == 1 {
                        self.backUpIsNecessary = true
                    }
                    if self.numberOfTeams == 0 {
                        self.checkIfAllPlayerHasAnswerd()
                    }
                }
            }
            
            //---------------------
            if snapshot.childSnapshot(forPath: "lieOrTruth").exists(){
                self.currentReaderLieOrTruth = snapshot.childSnapshot(forPath: "lieOrTruth").value as? Bool
            }
            
            //---------------------
            if snapshot.childSnapshot(forPath: "currentReader").exists(){
                self.currentReader = snapshot.childSnapshot(forPath: "currentReader").value as? String
            }
            
            if snapshot.childSnapshot(forPath: "currentRound").exists(){
                self.currentRound = snapshot.childSnapshot(forPath: "currentRound").value as! Int
            }
            if snapshot.childSnapshot(forPath: "gameStatus").exists(){
                let status = snapshot.childSnapshot(forPath: "gameStatus").value as! String
                //RESTART GAME
                if status == "restart" {
                    self.alertViewVarible = AlertViewChoice.restart
                    self.textViewInAlertView.text = "Spelledaren har valt att starta om spelet"
                    UIView.animate(withDuration: 0.5, animations: {
                        self.topBlurView.alpha = 1
                        self.topBlurViewButton.isHidden = true
                        self.alertViewOutlet.transform = .identity
                    })
                    
                }
                    //QUIT GAME
                else if status == "quit"{
                    self.alertViewVarible = AlertViewChoice.quit
                    self.textViewInAlertView.text = "Spelledaren har valt att avsluta spelet"
                    UIView.animate(withDuration: 0.5, animations: {
                        self.topBlurView.alpha = 1
                        self.topBlurViewButton.isHidden = true
                        self.alertViewOutlet.transform = .identity
                    })
                }
            }
        }
    }
    
    
    //Observerar ändringar hos varje spelare
    func observePlayers (_ completion: @escaping () -> ()) {
        PLAYER_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            if self.numberOfTeams > 0 {
                for team in self.allTeamsArray{
                    team.team.removeAll()
                    team.points = 0
                }
            }
            self.allPlayers.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let key = child.key
                let points = child.childSnapshot(forPath: "points").value as! Int
                let team = child.childSnapshot(forPath: "team").value as! Int
                let answer = child.childSnapshot(forPath: "answer").value as! String
                let avatar = child.childSnapshot(forPath: "avatar").value as! String
                let index = child.childSnapshot(forPath: "index").value as! Int
                let player = Player(key: key, name: key, points: points, team: team, answer: answer, avatar: avatar, index: index)
                var secrets = [String]()
                if child.childSnapshot(forPath: "isHost").exists() {
                    player.isHost = true
                }
                for childs in [child.childSnapshot(forPath: "secrets")] as [DataSnapshot]{
                    for child2 in childs.children.allObjects{
                        let tja = child2 as! DataSnapshot
                        secrets.append(tja.value as! String)
                    }
                }
                player.secrets = secrets
                if self.numberOfTeams > 0 {
                    
                    self.allTeamsArray[team-1].points += points
                    self.allTeamsArray[team-1].team.append(player)
                    self.allTeamsArray.sort(by: {$1.points < $0.points})
                }
                
                self.allPlayers.append(player)
                self.resultCollectionView.reloadData()
            }
            completion()
        })
        
    }
    
    func setGuessingAndReadingTeam(index: Int) {
        self.readingTeam = index
        if index == 0 {
            self.guessingTeam = 1
        }
        else {
            self.guessingTeam = 0
        }
    }
    
    var removeHandler: UInt = 3
    var playerHandler: UInt = 2
    
    func observingPlayers() {
        //En spelare har blivit utsparkad eller lämnat själv
        self.removeHandler = self.PLAYER_REF.observe(DataEventType.childRemoved) { (snapshot) in
            if let index = self.allPlayers.index(where: {$0.name == snapshot.key}) {
                self.reduceTotalNumberOfRoundsIfPlayerLeaveGame(index: self.allPlayers[index].index)
                self.allPlayers.remove(at: index)
                self.kickPlayerTableView.reloadData()
            }
            
            if self.numberOfTeams > 0 {
                for teams in self.allTeamsArray{
                    for (index, player) in teams.team.enumerated() {
                        if player.name == snapshot.key {
                            teams.team.remove(at: index)
                        }
                    }
                }
            }
            if snapshot.key == self.currentUser.name {
                self.alertViewVarible = AlertViewChoice.other
                self.textViewInAlertView.text = "Spelledaren har sparkat ut dig ur spelet"
                UIView.animate(withDuration: 0.5, animations: {
                    self.topBlurViewButton.alpha = 1
                    self.topBlurViewButton.isHidden = true
                    self.alertViewOutlet.transform = .identity
                })
            }
            
            self.allPlayers.sort(by: { $0.index < $1.index })
            
            
            if self.gameIsOver == false {
                var newIndex = self.currentIndex
                if newIndex >= self.allPlayers.count{
                    newIndex = 0
                    if self.isHost {
                        self.GAME_REF.child("currentRound").setValue(self.currentRound + 1)
                    }
                }
                
                if snapshot.key != self.currentReader! {
                    for (index, player) in self.allPlayers.enumerated() {
                        if self.isHost {
                            self.PLAYER_REF.child(player.key).child("index").setValue(index)
                        }
                        if self.currentUser.name == player.name {
                            self.currentUser.index = index
                        }
                        player.index = index
                    }
                }
                    
                else if snapshot.key == self.currentReader! {
                    for (index, player) in self.allPlayers.enumerated() {
                        if self.isHost{
                            self.PLAYER_REF.child(player.key).child("answer").setValue("TBA")
                            self.PLAYER_REF.child(player.key).child("index").setValue(index)
                        }
                        if self.currentUser.name == player.name {
                            self.currentUser.index = index
                        }
                        player.index = index
                    }
                    if self.isHost {
                        self.GAME_REF.child("numberOfAnswers").setValue(0)
                    }
                }
                
                
                //                if self.numberOfTeams > 0 {
                //                    self.setUpTeamScore()
                //                }
                if newIndex == self.currentIndex {
                    self.currentReader = self.allPlayers[newIndex].name
                    if newIndex == self.currentUser.index {
                        self.swipeLabel.text = "Det är din tur!"
                        self.GAME_REF.child("currentReader").setValue(self.currentReader!)
                        self.startReading()
                        self.readingView.alpha = 1
                        self.answerView.alpha = 0
                    }
                    else {
                        self.swipeLabel.text = "Dra uppåt för att svara!"
                        self.readingView.alpha = 0
                        self.answerView.alpha = 1
                    }
                    self.sortAllPlayersArrayAfterAnswers()
                    
                }
                else {
                    if self.isHost {
                        self.GAME_REF.child("index").setValue(newIndex)
                    }
                }
                
                if let index = self.playersThatHaventAnswerd.index(where: {$0.name == snapshot.key}) {
                    let indexPath : IndexPath = IndexPath(item: index, section: 0)
                    self.playersThatHaventAnswerd.remove(at: index)
                    self.playerAnswerCollectionView.deleteItems(at: [indexPath])
                    
                }
                self.checkIfGameIsOver()
                self.resultCollectionView.reloadData()
                self.playerAnswerCollectionView.reloadData()
            }
            
        }
        
        
        //OBSERVER ON EVERY PLAYER UPDATE
        
        self.playerHandler = self.PLAYER_REF.observe(DataEventType.value) { (snap) in
            for snapshot in snap.children.allObjects as! [DataSnapshot] {
                if snapshot.exists() {
                    for player in self.allPlayers{
                        if player.name == snapshot.key{
                            
                            player.points = snapshot.childSnapshot(forPath: "points").value as! Int
                            player.answer = snapshot.childSnapshot(forPath: "answer").value as! String
                            
                            if player.answer == "true" || player.answer == "false" {
                                if let index = self.playersThatHaventAnswerd.index(where: {$0.name == player.name}) {
                                    let indexPath : IndexPath = IndexPath(item: index, section: 0)
                                    self.playersThatHaventAnswerd.remove(at: index)
                                    self.playerAnswerCollectionView.deleteItems(at: [indexPath])
                                }
                                if self.playersThatHaventAnswerd.count == 0 {
                                    self.extraCheckIfAllPlayersHasAnswerd()
                                }
                            }
                            if self.numberOfTeams > 0 {
                                self.allTeamsArray.sort(by: {$1.points < $0.points})
                            }
                            self.allPlayers.sort(by: { $1.points < $0.points })
                            self.resultCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    func startReading() {
        self.isReading = true
        randomizeLieOrTruth()
    }
    
    
    func randomizeLieOrTruth(){
        let random = arc4random_uniform(2)
        
        if random == 0 {
            self.switchLieButtonOutlet.isHidden = true
            if currentRound <= numberOfRounds{
                self.readingTextView.text = currentUser.secrets![self.currentRound-1]
            }
            GAME_REF.child("lieOrTruth").setValue(true)
            
        }
        else {
            self.switchLieButtonOutlet.isHidden = false
            GAME_REF.child("lieOrTruth").setValue(false)
            getLie()
        }
    }
    
    func getLie() {
        let lieRef = Database.database().reference().child("Lies")
        
        lieRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let totalNoOfLies = snapshot.childSnapshot(forPath: "index").value as! Int
            
            let randNum = Int(arc4random_uniform(UInt32(totalNoOfLies))) + 1
            
            lieRef.observe(.value, with: {(snap) in
                
                var index = 0
                for child in snap.children.allObjects as! [DataSnapshot]{
                    index += 1
                    if index == randNum{
                        
                        let lie = child.value as! String
                        
                        self.readingTextView.text = lie
                        break
                    }
                }
            })
        })
    }
    
    
    //SWIPE VIEW
    
    @IBOutlet weak var swipeUpButton: UIButton!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var swipeArrow: UIImageView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var swipeViewExclamationMark: UIButton!
    
    
    @IBOutlet weak var switchLieButtonOutlet: UIButton!
    
    var switchLieCount = 0
    @IBAction func switchLieButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            
            
            if self.switchLieButtonOutlet.transform == .identity {
                
                self.switchLieButtonOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            else {
                self.switchLieButtonOutlet.transform = CGAffineTransform(rotationAngle: 0)
                
            }
            
        }
        self.switchLieCount += 1
        if switchLieCount <= 3{
            self.getLie()
        }
        else {
            self.alert(title: "Du har inga byten kvar", message: "Du kan endast byta lögn tre gånger/omgång")
        }
    }
    
    @IBAction func bottomPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: view)
        self.swipeView.center = CGPoint(x: view.center.x, y: self.swipeViewY + point.y)
        
        if sender.state == UIGestureRecognizerState.ended{
            if self.swipeViewY == self.startingSwipeViewY {
                self.swipeUp()
            }
            else {
                swipeDown()
            }
        }
    }
    
    func swipeDown() {
        playSound(soundString: soundArray[0])
        if self.currentReader! == self.currentUser.name {
            self.swipeLabel.text = "Det är din tur!"
        }
        else {
            self.swipeLabel.text = "Dra uppåt för att svara!"
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.swipeBlurView.alpha = 0
            self.swipeView.center.y = self.startingSwipeViewY
        }) { (true) in
            UIView.animate(withDuration: 0.5) {
                self.swipeArrow.transform = CGAffineTransform(rotationAngle: 0)
                self.toggleViewIn()
            }
        }
        
        self.swipeViewY = self.startingSwipeViewY
    }
    
    func swipeUp() {
        playSound(soundString: soundArray[0])
        if self.currentReader! == self.currentUser.name {
            self.swipeLabel.text = "Läs ditt påstående:"
        }
        else {
            self.swipeLabel.text = "Sanning eller lögn?"
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.swipeBlurView.alpha = 1
            self.swipeView.center.y = self.view.center.y
        }) { (true) in
            UIView.animate(withDuration: 0.5) {
                self.toggleViewOut()
                self.swipeArrow.transform = CGAffineTransform(rotationAngle: self.radians(-180))
            }
        }
        
        self.swipeViewY = self.swipeView.center.y
    }
    
    @IBAction func swipeButton(_ sender: UIButton) {
        if self.swipeViewY == self.startingSwipeViewY {
            self.toggleViewOut()
            self.swipeUp()
        }
        else {
            self.toggleViewIn()
            swipeDown()
        }
    }
    
    @IBAction func trueButton(_ sender: UIButton) {
        self.currentUsersAnswer = true
        PLAYER_REF.child(playerID).child("answer").setValue("true")
        self.increaseNumberOfAnswersByOne()
        UIView.animate(withDuration: 0.3) {
            self.trueButtonOutlet.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.lieButtonOutlet.transform = .identity
        }
        
        
    }
    
    @IBAction func lieButton(_ sender: UIButton) {
        self.currentUsersAnswer = false
        PLAYER_REF.child(playerID).child("answer").setValue("false")
        self.increaseNumberOfAnswersByOne()
        UIView.animate(withDuration: 0.3) {
            self.lieButtonOutlet.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.trueButtonOutlet.transform = .identity
        }
    }
    
    func radians (_ degrees: Double)-> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    func toggleViewOut() {
        UIView.animate(withDuration: 0.7, animations: {
            
            self.swipeUpButton.transform = CGAffineTransform(scaleX: 20, y: 3)
        }, completion: nil)
    }
    
    func toggleViewIn() {
        UIView.animate(withDuration: 0.7, animations: {
            self.swipeUpButton.transform = .identity
        }, completion: nil)
    }
    
    
    @IBAction func exclamationMarkButtonInSwipeView(_ sender: UIButton) {
        self.alertViewVarible = AlertViewChoice.other
        self.textViewInAlertView.text = "Lagets medlemmar har givit olika svar. För att komma vidare behöver ni komma överrens om ett gemensamt svar inom laget"
        UIView.animate(withDuration: 0.5) {
            self.alertViewOutlet.transform = .identity
        }
    }
    
    
    
    //Settings
    @IBOutlet weak var settingsView: UIViewX!
    @IBOutlet weak var settingsViewImage: UIImageView!
    
    @IBOutlet weak var restartButtonOutlet: UIButton!
    @IBOutlet weak var quitGameButtonOutlet: UIButton!
    @IBOutlet weak var kickPlayersButtonOutlet: UIButton!
    @IBOutlet weak var resumeGameButtonOutlet: UIButton!
    
    @IBOutlet weak var showSettingsButtonOutlet: UIButtonX!
    
    @IBAction func resumeButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 0
            self.settingsView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY - 200)
        }
    }
    
    
    
    
    @IBAction func restartGameButton(_ sender: UIButton) {
        self.settingsVar = 0
        self.openAreYouSureView()
        
    }
    
    
    @IBAction func quitGameButton(_ sender: UIButton) {
        self.settingsVar = 1
        self.openAreYouSureView()
    }
    
    
    @IBAction func KickPlayersButton(_ sender: UIButton) {
        self.settingsVar = 2
        self.kickPlayerTableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.topBlurView.alpha = 1
            self.topBlurViewButton.isHidden = false
            self.kickPlayerView.transform = .identity
        }
    }
    
    @IBAction func closeTopBlurViewButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.topBlurView.alpha = 0
            self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.kickPlayerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    
    
    @IBAction func showSettingsButton(_ sender: UIButton) {
        self.blurViewButtonOutlet.isHidden = false
        if isHost {
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 1
                self.settingsView.center = self.view.center
            }) { (true) in
                self.settingsView.shakeView()
            }
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 1
                self.settingsViewForPlayers.center = self.view.center
            }) { (true) in
                self.settingsView.shakeView()
            }
        }
    }
    
    var settingsVar = 0
    
    func openAreYouSureView(){
        //Starta om..
        if settingsVar == 0 {
            self.areYouSureTextView.text = "Är du säker på att du vill starta om spelet? All statistik kommer gå förlorad"
        }
            //Avsluta
        else if settingsVar == 1 {
            self.areYouSureTextView.text = "Är du säker på att du vill avsluta? Alla spelare kommer kastas ut ur spelet och ingen statistik kommer sparas!"
        }
        else if settingsVar == 2 {
            
        }
        else if settingsVar == 3 {
            self.areYouSureTextView.text = "Är du säker på att du vill lämna spelet? Du kommer inte kunna återvända till nuvarande runda."
        }
        
        UIView.animate(withDuration: 0.5) {
            self.topBlurView.alpha = 1
            self.areYouSureView.transform = .identity
        }
        
    }
    
    
    
    
    @IBOutlet weak var areYouSureView: UIView!
    @IBOutlet weak var areYouSureTextView: UITextView!
    @IBOutlet weak var yesImSureButton: UIButton!
    @IBOutlet weak var noImNotSureButton: UIButton!
    
    var playerToKick: Player?
    
    @objc func kickPlayer (sender: UIButton) {
        if let index = self.allPlayers.index(where: {$0.index == sender.tag}) {
            let playerName = allPlayers[index]
            self.playerToKick = playerName
            self.areYouSureYouWantToKickPlayerOut(player: playerName)
        }
        
    }
    
    func areYouSureYouWantToKickPlayerOut(player: Player) {
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 1
            self.areYouSureView.transform = .identity
        }
        self.areYouSureTextView.text = "Är du säker på att du vill sparka ut \(player.name) ur spelet?"
        
    }
    
    
    @IBAction func SettingsYesButtonPressed(_ sender: UIButton) {
        
        //RESTART - Move back to wait view
        if settingsVar == 0 {
            GAME_REF.child("gameStatus").setValue("restart")
            GAME_REF.child("open").setValue(true)
            self.restartGame()
            
            self.performSegue(withIdentifier: "backToWait", sender: self)
        }
            
            //QUIT - Move back to startView
        else if settingsVar == 1 {
            GAME_REF.child("gameStatus").setValue("quit")
            self.performSegue(withIdentifier: "quitGameSegue", sender: self)
        }
            
            
        else if settingsVar == 2 {
            if let playerToKick = playerToKick{
                PLAYER_REF.child(playerToKick.name).removeValue()
                
            }
            
        }
            
        else if settingsVar == 3 {
            PLAYER_REF.child(currentUser.name).removeValue()
            self.performSegue(withIdentifier: "quitGameSegue", sender: self)
        }
        UIView.animate(withDuration: 0.3) {
            self.topBlurView.alpha = 0
            self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        
    }
    
    
    
    func restartGame() {
        let values = ["currentReader": "", "numberOfAnswers": 0] as [String : Any]
        GAME_REF.updateChildValues(values)
        
        for players in allPlayers {
            let values = ["redo": false, "answer": "TBA"] as [String : Any]
            PLAYER_REF.child(players.name).updateChildValues(values)
        }
        
    }
    
    
    @IBAction func settingsNoButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.topBlurView.alpha = 0
            self.areYouSureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    
    
    //ALERT VIEW
    var alertViewVarible: AlertViewChoice!
    
    @IBOutlet weak var alertViewOutlet: UIViewX!
    @IBOutlet weak var okInAlertViewButtonOutlet: UIButtonX!
    @IBOutlet weak var textViewInAlertView: UITextView!
    @IBAction func okButtonInAlertViewPressed(_ sender: UIButton) {
        
        switch self.alertViewVarible {
        case .restart:
            self.performSegue(withIdentifier: "backToWait", sender: self)
            return
        case .quit:
            self.performSegue(withIdentifier: "quitGameSegue", sender: self)
            return
        case .other:
            UIView.animate(withDuration: 0.5) {
                self.alertViewOutlet.transform = CGAffineTransform(scaleX: 0, y: 0)
                return
            }
        case .none:
            return
        case .some(let some):
            print(some)
        }
    }
    
    
    //När man startar om
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WaitingForUsers {
            destination.playerID = playerID
            destination.gameID = gameID
            destination.numberOfRounds = numberOfRounds
            destination.numberOfTeams = numberOfTeams
            destination.currentUser = currentUser
            destination.isHost = isHost
            
        }
        
    }
    
    
    //Settings om man inte är
    @IBAction func resumePlayerButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 0
            self.settingsViewForPlayers.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY - 200)
        }
    }
    @IBAction func leaveGameButton(_ sender: UIButton) {
        self.settingsVar = 3
        self.openAreYouSureView()
    }
    
    
    
    //Det här är POP-Upen som visas efter spelet är slut
    @IBAction func finalResultButton(_ sender: UIButton) {
        self.finalResultView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.lastViewInFinalResultView.alpha = 1
        }
    }
    
    
    @IBAction func playAgainInLastView(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "backToWait", sender: self)
    }
    
    @IBAction func quitGameInLastView(_ sender: UIButton) {
        if isHost {
            GAME_REF.child("gameStatus").setValue("quit")
        }
        else {
            PLAYER_REF.child(currentUser.key).removeValue()
        }
        self.performSegue(withIdentifier: "quitGameSegue", sender: self)
    }
    
    
}



enum AlertViewChoice {
    case restart
    case quit
    case other
    
}






















