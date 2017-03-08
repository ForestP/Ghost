//
//  myRoomsVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/16/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import Firebase

class myRoomsVC: UIViewController, MyRoomsServiceDelegate {
    
    var currentUser: String?
    
    var roomArr: Array<Room> = []
    
    let mrs = MyRoomsService.instance
    let ds = DataService.instance
    
    let chatRoomSeque = "goToChatVC"
    let createRoomSegue = "goToNewRoom"
    let joinRoomSegue = "goToJoinRoomVC"
    
    var userHasRooms = false
    var tableSize = 0

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, err) in
            if err != nil {
                print("error user could not be created")
                let alert = UIAlertController().createAlertWith(message: "Error Could Not Connect")
                self.present(alert, animated: true, completion: nil)
            } else {
                if let uid = user?.uid {
                    print("uid: \(uid)")
                    self.ds.userRef.child(uid).setValue("true")
                    self.currentUser = uid
                }
            }
        })
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            
            self.currentUser = uid
        }
        

        
        super.viewDidLoad()
        
        self.mrs.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(myRoomsCell.self)
        tableView.register(mainPageCell.self)
        tableView.register(roomActionCell.self)



    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.roomArr = []
        self.mrs.getUsersRooms()

    }
    func noRooms() {
        self.userHasRooms = false
        
        self.headerView.isHidden = true
        self.tableView.allowsSelection = false
        self.tableView.isScrollEnabled = false
        self.tableView.reloadData()
    }
    
    func roomLoaded(roomNum: String?, memberCount: Int?, roomData: Dictionary<String,AnyObject>?) {
        
        guard let num = roomNum else {
            print("could not get room num")
            return
        }
        
        guard let count = memberCount else {
            print("could not get member num")
            return
        }
        
        guard let data = roomData else {
            print("could not get room data")
            return
        }
        
        self.userHasRooms = true
        
        let currentRoom = Room(
            roomId: num,
            roomMembers: count,
            roomData: data
        )
        
        self.roomArr.append(currentRoom)
        
        self.headerView.isHidden = false
        self.tableView.allowsSelection = true
        self.tableView.isScrollEnabled = true
        self.tableView.reloadData()
        
    }
    
    
    func createRoom(roomId: String) {
        self.performSegue(withIdentifier: self.createRoomSegue, sender: roomId)
    }
    
    func joinRoom() {
        self.performSegue(withIdentifier: self.joinRoomSegue, sender: self.currentUser)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.createRoomSegue {
            let roomNameVC = (segue.destination as? roomNameVC)
            roomNameVC?.roomId = sender as! String
        }
        
        if segue.identifier == self.joinRoomSegue {
            let joinRoomVC = (segue.destination as? joinRoomVC)
            joinRoomVC?.uid = sender as? String
        }
        
        if segue.identifier == self.chatRoomSeque {
            let chatRoomVC = (segue.destination as? chatRoomVC)
            chatRoomVC?.roomId = sender as? String
        }
    }

}

extension myRoomsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numRows = 0
        
        if (userHasRooms) {
            numRows = roomArr.count + 1
            print("rooms")
        } else {
            numRows = 2
            print("no rooms")
        }
        
        self.tableSize = numRows
        
        return numRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        let actionCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as roomActionCell
        if let uid = self.currentUser {
            actionCell.configureCell(myRoomsVC: self, currentUser: uid)
        }
        
        
        if (userHasRooms) {
            // set comments
            if (indexPath.row == (self.tableSize - 1)) {
                return actionCell
            
            }else {
                let room = self.roomArr[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as myRoomsCell
                cell.configureCell(room: room)
                
                return cell
            }
            
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as mainPageCell
                return cell
            } else {
                return actionCell
            }
        }
        


        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomNum = self.roomArr[indexPath.row].roomId
        
        self.performSegue(withIdentifier: self.chatRoomSeque , sender: roomNum)
    }
    
}
