//
//  CHRMessageInteractor.swift
//  chat-room
//
//  Created by Plenumsoft on 01/02/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CHRMessageInteractor: NSObject {

    static let databaseRef = FIRDatabase.database().reference()
    
    static var messages = [Message]()
    
    static func fillMessages(uid: String, completion: @escaping (_ result : String) -> Void){
    
        self.messages = []
        
        databaseRef.child("messages").queryOrdered(byChild: "uid").observe(.childAdded, with: { (snapshot) in
            print (snapshot)
            if let result = snapshot.value as? NSDictionary{
                    let mess = Message(result["from"] as! String,
                                       text: result["text"] as! String,
                                       username: result["username"] as! String)
                
                self.messages.append(mess)
            }
            completion("")
        })
        
    }
    
    
    static func sendMessage(username:String, text: String, from: String){
        
        let mess = Message(from, text: text, username: username)
        
        if(mess.text != ""){
            let messToSend = NSMutableDictionary()
            messToSend.setValue(mess.from, forKey: "from")
            messToSend.setValue(mess.text, forKey: "text")
            messToSend.setValue(mess.username, forKey: "username")
            
            databaseRef.child("messages").childByAutoId().setValue(messToSend)
        }
        
    }
    
    
}
