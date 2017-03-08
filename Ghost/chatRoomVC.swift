//
//  chatRoomVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class chatRoomVC: UIViewController, ChatRoomServiceDelegate {

    var roomId: String!
    var currentUserNum: String?
    var roomMsgArray = [Message]()
    
    var createdDate: Double?
    var currentDate: Double?
    
    let roomInfoSegue = "showRoomInfo"
    
    let lengthOfDay = 86400000.0
    
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let crs = ChatRoomService.instance
    let ds = DataService.instance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("roomID: \(roomId)")
        
        self.updateRoomDate()
        
        self.crs.delegate = self
        
        
        if var currentDate = NSDate().timeIntervalSince1970 as Double? {
            print("current: \(currentDate)")
            currentDate = currentDate * 1000
            self.ds.roomRef.child(roomId).child(FIR_CREATEDDATE_REF).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let created = snapshot.value as? Double {
                    self.createdDate = created
                    print("created: \(created)")
                    let remainingTime = (created + self.lengthOfDay) - currentDate
                    print("time : \(remainingTime)")
                    if remainingTime <= 0 {
                        print("delete room")
                        // segue back to roomVC
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // start timer, update label
                        self.timerLbl.text = self.convertToHrsMins(remainingTime: remainingTime)
                    }
                }
            })
        }
        
        var _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateRoomDate), userInfo: nil, repeats: true);

        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        self.msgTextView.keyboardDistanceFromTextField = 5; //This will modify default distance between textField and keyboard. For exact value, please manually check how far your textField from the bottom of the page. Mine was 8pt.
        
        self.msgTextView.placeholderText = "Start typing a message"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(msgCell.self)
        tableView.register(selfMsgCell.self)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.crs.getCurrentUserNum(roomId: self.roomId, uid: uid)
            self.roomMsgArray = []
            self.crs.getChatRoomMessages(roomId: self.roomId)
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.crs.removeObservers()
        print("Disappear")

    }
    
    
    func currentUserNumLoaded(userNum: String?) {
        self.currentUserNum = userNum
    }
    
    func messageLoaded(message: Message?) {
        if let msg = message {
            self.roomMsgArray.append(msg)
            print("msg count: \(roomMsgArray.count)")
        }
        // Reload Table View
        tableView.reloadData()

    }
    
    func updateRoomDate() {
        
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
    

    @IBAction func homeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func postMsgPressed(_ sender: Any) {
        guard self.msgTextView.text != "" else {
            print("msg text nil")
            return
        }
        
        guard self.currentUserNum != "" else {
            print("user num not loaded")
            let alert = UIAlertController().createAlertWith(message: "Could not send message")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let msgText = self.msgTextView.text
        let userNum = self.currentUserNum
        
        crs.postMessage(roomNum: roomId, msgText: msgText!, userNum: userNum!)
        
        self.msgTextView.text = ""
        
        self.msgTextView.resignFirstResponder()
        
        
    }
    
    func convertToHrsMins(remainingTime: Double) -> String {
        let hours = Int(remainingTime / (60 * 60 * 1000))
        let mins = Int((remainingTime / (60 * 1000)).truncatingRemainder(dividingBy: 60))
        let secs = Int((remainingTime / 1000).truncatingRemainder(dividingBy: 60))
        
        let secString = self.convertToString(num: secs)
        let minString = self.convertToString(num: mins)
        let hourString = self.convertToString(num: hours)

        return "\(hourString):\(minString):\(secString)"
    }
    
    func convertToString(num: Int) -> String {
        var numString = ""
        if num < 10 {
            numString = "0\(num)"
        } else {
            numString = "\(num)"
        }
        
        return numString
    }

}

extension chatRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return roomMsgArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        

            // set comments
        let message = roomMsgArray[indexPath.row]
        if message.postedBy == self.currentUserNum {
            // posted by current user
            // !!! CHANGE ME !!!
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as selfMsgCell
            cell.configureCell(message: message)
            return cell
        } else {
            // posted by other
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as msgCell
            cell.configureCell(message: message)
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    
}
