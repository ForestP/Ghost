//
//  ChatRoomService.swift
//  Masked
//
//  Created by Forest Plasencia on 2/15/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import Foundation
import Firebase

protocol ChatRoomServiceDelegate: class {
    func currentUserNumLoaded(userNum: String?)
    func messageLoaded(message: Message?)
}

class ChatRoomService {
    private static let _instance = ChatRoomService()
    
    weak var delegate: ChatRoomServiceDelegate?
    
    static var instance: ChatRoomService {
        return _instance
    }
    
    let ds = DataService.instance
    var handle : UInt = 0
    var currentRoomId = ""
    
    func getCurrentUserNum(roomId: String, uid: String) {

        ds.roomMemberRef.child(roomId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let currentUserNum = snapshot.value as? String
            self.delegate?.currentUserNumLoaded(userNum: currentUserNum)
            
        })
    }
    
    func getChatRoomMessages(roomId: String) {
        print("called")
        self.currentRoomId = roomId
        var count = 0;
        let ref = ds.roomMessageRef.child(roomId).queryOrderedByValue()
        self.handle = ref.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            count += 1
            print(count)
            let msgId = snapshot.key
            self.getMessageData(msgId: msgId)
            
        }
        
    }
    
    func getMessageData(msgId: String){
        
        ds.messageRef.child(msgId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let msg = Message.parseMessage(snapshot: snapshot)
            self.delegate?.messageLoaded(message: msg)
            
        })
    }
    
    func postMessage(roomNum: String, msgText: String, userNum: String) {
        
        let msgRef = self.ds.messageRef.childByAutoId()
        let msgId = msgRef.key
        let createdDate = FIRServerValue.timestamp()
        
        let msgData = [
            "userNum": userNum,
            "msgText": msgText
        ]
        
        // Add message in messageRef
        msgRef.setValue(msgData)
        // Add message ID to roomMessageRef
        self.ds.roomMessageRef.child(roomNum).child(msgId).setValue(createdDate)
    }
    
    func removeObservers() {
        let ref = ds.roomMessageRef.child(self.currentRoomId).queryOrderedByValue()
        ref.removeAllObservers()
    }
}
