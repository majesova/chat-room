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

     let databaseRef = FIRDatabase.database().reference()
    
     var messages = [Message]()
    
    func fillMessages(uid: String, completion: @escaping (_ result : String) -> Void){
    
        self.messages = []
        
        databaseRef.child("messages").queryOrdered(byChild: "uid").observe(.childAdded, with: { (snapshot) in
            print (snapshot)
            if let result = snapshot.value as? NSDictionary{
                var imageUrl = ""
                if result["imageUrl"] != nil {
                    imageUrl = result["imageUrl"] as! String
                }
                
                    let mess = Message(result["from"] as! String,
                                       text: result["text"] as! String,
                                       username: result["username"] as! String,
                                       imageUrl:imageUrl)
                
                self.messages.append(mess)
            }
            completion("")
        })
        
    }
    
     func sendMessage(username:String, text: String, from: String){
        
        let mess = Message(from, text: text, username: username, imageUrl:"")
        
        if(mess.text != ""){
            let messToSend = NSMutableDictionary()
            messToSend.setValue(mess.from, forKey: "from")
            messToSend.setValue(mess.text, forKey: "text")
            messToSend.setValue(mess.username, forKey: "username")
            messToSend.setValue("", forKey: "imageUrl")
            self.databaseRef.child("messages").childByAutoId().setValue(messToSend)
        }
        
    }
    
    func sendMessageWithImage(username:String, text: String, from: String, image:UIImage){
        
        let messImageRef = FIRStorage.storage().reference().child("chatImages").child("\(NSUUID().uuidString).jpg")
        if let imageData = UIImageJPEGRepresentation(image, 0.25) {
            
            messImageRef.put(imageData, metadata: nil, completion: { metadata, error in
                
                if error !=  nil {
                    print(error)
                }else{
                    
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let messToSend = NSMutableDictionary()
                        messToSend.setValue(from, forKey: "from")
                        messToSend.setValue(text, forKey: "text")
                        messToSend.setValue(username, forKey: "username")
                        messToSend.setValue(downloadUrl, forKey: "imageUrl")
                        self.databaseRef.child("messages").childByAutoId().setValue(messToSend)
                    }
                }
                
            })
        
        }
        
        
        
    }
    
    
}
