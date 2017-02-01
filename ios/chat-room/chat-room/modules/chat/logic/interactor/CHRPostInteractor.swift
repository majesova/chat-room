//
//  CHRPostInteractor.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CHRPostInteractor: NSObject {

    static let databaseRef = FIRDatabase.database().reference()
    static var posts = [Post]()
    
    static func fillPosts(uid:String?, toId:String, completion:@escaping(_ result :String)->Void){
    
        posts = []
        let allPosts = databaseRef.child("posts")
        print(allPosts)
        let post = databaseRef.child("posts").queryOrdered(byChild: "uid")
            .queryEqual(toValue: CHRFirebaseManager.currentUser?.uid).observe(.childAdded, with: { (snapshot) in
                print (snapshot)
            })
        
     
        databaseRef.child("posts").queryOrdered(byChild: "uid")
            .queryEqual(toValue: CHRFirebaseManager.currentUser?.uid).observe(.childAdded, with: { (snapshot) in
                print (snapshot)
                
                if let result = snapshot.value as? [String:AnyObject] {
                    let toIdCloud = result["toId"]! as! String
                    if toIdCloud == toId{
                        print("EQ: IGUAL")
                        let p = Post(username: result["username"] as! String,
                                     text: result["text"] as! String,
                                     toId: "toId")
                        CHRPostInteractor.posts.append(p)
                    }
                }
                completion("")
            })
    }
    
    static func addPost(username:String, text:String, toId:String, fromId: String){
        let p = Post(username: username, text: text, toId: toId)
        if(p.text != ""){
            let uid = FIRAuth.auth()?.currentUser?.uid
            let post = ["uid":uid!,
                        "username":p.username,
                        "text":p.text,
                        "toId":p.toId]
            databaseRef.child("posts").childByAutoId().setValue(post)
        }
    }
    
}


