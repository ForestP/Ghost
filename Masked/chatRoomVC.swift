//
//  chatRoomVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class chatRoomVC: UIViewController {

    var roomId: String!
    
    var createdDate: Double?
    var currentDate: Double?
    
    let roomInfoSegue = "showRoomInfo"
    
    let lengthOfDay = 86400000.0
    
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var timerLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("roomID: \(roomId)")
        
        self.updateRoomDate()
        
        let ds = DataService.instance
        
        if var currentDate = NSDate().timeIntervalSince1970 as Double? {
            print("current: \(currentDate)")
            currentDate = currentDate * 1000
            ds.roomRef.child(roomId).child(FIR_CREATEDDATE_REF).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let created = snapshot.value as? Double {
                    self.createdDate = created
                    print("created: \(created)")
                    let remainingTime = (created + self.lengthOfDay) - currentDate
                    print("time : \(remainingTime)")
                    if remainingTime <= 0 {
                        print("delete room")
                        ds.roomRef.child(self.roomId).removeValue()
                        // segue back to roomVC
                    } else {
                        // start timer, update label
                        
                        self.timerLbl.text = self.convertToHrsMins(remainingTime: remainingTime)
                    }
                }
            })
        }
        
        var _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateRoomDate), userInfo: nil, repeats: true);

        self.msgTextView.keyboardDistanceFromTextField = 5; //This will modify default distance between textField and keyboard. For exact value, please manually check how far your textField from the bottom of the page. Mine was 8pt.

    }
    
    func updateRoomDate() {
        let ds = DataService.instance
        
        if var currentDate = NSDate().timeIntervalSince1970 as Double? {
            currentDate = currentDate * 1000
            if let created = self.createdDate {
                let remainingTime = (created + self.lengthOfDay) - currentDate
                if remainingTime <= 0 {
                    print("delete room")
                    
                    // Add delete room func
                    ds.roomRef.child(self.roomId).removeValue()
                    // segue back to roomVC
                } else {
                    // Update label
                    self.timerLbl.text = self.convertToHrsMins(remainingTime: remainingTime)
                }
                
            }
            
            
        }
    }
    
    func convertToHrsMins(remainingTime: Double) -> String {
        let hours = Int(remainingTime / (60 * 60 * 1000))
        print("hours : \(hours)")
        let mins = Int((remainingTime / (60 * 1000)).truncatingRemainder(dividingBy: 60))
        print("mins: \(mins)")
        let secs = Int((remainingTime / 1000).truncatingRemainder(dividingBy: 60))
        print("secs: \(secs)")
        
        var secString = ""
        var minString = ""
        var hourString = ""
        
        if secs < 10 {
            secString = "0\(secs)"
        } else {
            secString = "\(secs)"
        }
        if mins < 10 {
            minString = "0\(mins)"
        } else {
            minString = "\(mins)"
        }
        if hours < 10 {
            hourString = "0\(hours)"
        } else {
            hourString = "\(hours)"
        }
        return "\(hourString):\(minString):\(secString)"
    }

    @IBAction func infoBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: roomInfoSegue, sender: roomId)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.roomInfoSegue {
            let roomInfoVC = (segue.destination as? roomInfoVC)
            roomInfoVC?.roomId = sender as? String
        }
    }
    

}
