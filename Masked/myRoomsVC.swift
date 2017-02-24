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

    var roomNumArray: Array<String> = []
    var roomMemberArray: Array<Int> = []
    var roomDataArray: Array<Dictionary<String,AnyObject>> = []
    
    let mrs = MyRoomsService.instance
    let ds = DataService.instance
    
    let createRoomSegue = "goToNewRoom"
    let joinRoomSegue = "goToJoinRoomVC"
    
    var userHasRooms = true
    var tableSize = 0

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, err) in
            if err != nil {
                print("error user could not be created")
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
        
        
        self.roomNumArray = []
        self.roomMemberArray = []
        self.roomDataArray = []
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
            print("coould not get room date")
            return
        }
        
        self.userHasRooms = true
        
        self.roomNumArray.append(num)
        self.roomMemberArray.append(count)
        self.roomDataArray.append(data)
        
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
            let chatRoomVC = (segue.destination as? chatRoomVC)
            chatRoomVC?.roomId = sender as! String
        }
        
        if segue.identifier == self.joinRoomSegue {
            let joinRoomVC = (segue.destination as? joinRoomVC)
            joinRoomVC?.uid = sender as? String
            
        }
    }

}

extension myRoomsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numRows = 0
        
        if (userHasRooms) {
            numRows = roomNumArray.count + 1
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
                let roomNum = self.roomNumArray[indexPath.row]
                let roomMemberCount = self.roomMemberArray[indexPath.row]
                let data = self.roomDataArray[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as myRoomsCell
                cell.configureCell(roomNum: roomNum, memberCount: roomMemberCount, roomData: data)
                
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
        


        return mainPageCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomNum = self.roomNumArray[indexPath.row]
        
        self.performSegue(withIdentifier: createRoomSegue, sender: roomNum)
    }
    
}
