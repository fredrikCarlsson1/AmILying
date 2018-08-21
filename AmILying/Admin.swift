//
//  Admin.swift
//  AmILying
//
//  Created by Fredrik Carlsson on 2018-05-05.
//  Copyright © 2018 Fredrik Carlsson. All rights reserved.
//

import UIKit
import Firebase

class Admin: UIViewController {
    var arrayOfLiesToApprove = [(key: String, value: String)]()
    
    @IBOutlet weak var textField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLiesToApprove()
    }
    
    //Hämtar alla "LiesWaitingValidation" och lägger till dom i en array av tuples
    func getLiesToApprove(){
        Database.database().reference().child("LiesWaitingValidation").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                for child in snapshot.children.allObjects as! [DataSnapshot]{
                    let key = child.key
                    let lie = child.value as! String
                    let tuple = (key, lie)
                    self.arrayOfLiesToApprove.append(tuple)
                    if self.arrayOfLiesToApprove.count == 1 {
                        self.textField.text = self.arrayOfLiesToApprove[0].value
                    }
                }
            }
            else {
                self.textField.text = "No lies to approve or dismiss"
            }
        }
    }
    
    
    // Tar bort lögn om den inte passar in i spelet
    @IBAction func dismissButton(_ sender: UIButton) {
        if self.arrayOfLiesToApprove.count > 0 {
            Database.database().reference().child("LiesWaitingValidation").child(self.arrayOfLiesToApprove[0].key).removeValue(completionBlock: { (error, _) in
            })
            self.arrayOfLiesToApprove.remove(at: 0)
            if self.arrayOfLiesToApprove.count != 0 {
                self.textField.text = self.arrayOfLiesToApprove[0].value
            }
        }
    }
    
    //Lägger fråga i "Lies" och tar bort den från "LiesWaitingValidation"
    @IBAction func approveButton(_ sender: UIButton) {
        if self.arrayOfLiesToApprove.count > 0 {
            let ref = Database.database().reference().child("Lies").child("index")
            ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if snapshot.exists(){
                    let index = snapshot.value as! Int
                    ref.setValue(index+1)
                }
                else {
                    ref.setValue(1)
                }
                let ref = Database.database().reference().child("Lies")
                ref.childByAutoId().setValue(self.arrayOfLiesToApprove[0].value)
                Database.database().reference().child("LiesWaitingValidation").child(self.arrayOfLiesToApprove[0].key).removeValue(completionBlock: { (error, _) in
                })
                self.arrayOfLiesToApprove.remove(at: 0)
                if self.arrayOfLiesToApprove.count != 0 {
                    self.textField.text = self.arrayOfLiesToApprove[0].value
                }
            }
        }
    }
    
    
    
    
}














