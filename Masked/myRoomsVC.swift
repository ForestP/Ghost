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
    
    let mrs = MyRoomsService.instance
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mrs.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(myRoomsCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.roomNumArray = []
        self.roomMemberArray = []
        self.mrs.getUsersRooms()

    }
    
    func roomLoaded(roomNum: String?, memberCount: Int?) {

        guard let num = roomNum else {
            print("could not get room num")
            return
        }
        
        guard let count = memberCount else {
            print("could not get member num")
            return
        }
        
        
        self.roomNumArray.append(num)
        self.roomMemberArray.append(count)
        
        self.tableView.reloadData()
        
    }
    

    @IBAction func closeMyRoomsPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}

extension myRoomsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return roomNumArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        
        // set comments
        let roomNum = self.roomNumArray[indexPath.row]
        let roomMemberCount = self.roomMemberArray[indexPath.row]

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as myRoomsCell
        cell.configureCell(roomNum: roomNum, memberCount: roomMemberCount)
        
        return cell
 
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    
}
