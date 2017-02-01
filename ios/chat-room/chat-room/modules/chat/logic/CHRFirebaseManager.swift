//
//  CHRFirebaseManager.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CHRFirebaseManager: NSObject {

    static let databaseRef = FIRDatabase.database().reference()
    static var currentUserId:String = ""
    static var currentUser: FIRUser? = nil
    
    static func Login(email:String, password:String, completion: @escaping(_ success:Bool)->Void){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print (error.localizedDescription)
                completion(false)
            }else{
                currentUser = user
                currentUserId = (user?.uid)!
                completion(true)
            }
            
        })
    }
    
    static func CreateAccount(email:String, password:String, username:String, completion: @escaping(_ result:String) -> Void){
        FIRAuth.auth()?.createUser(withEmail:email, password:password, completion:{ (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            AddUser(username: username, email: email)
            Login(email:email, password:password){
                (success:Bool) in
                if(success) {
                    print("Login successful after account creation")
                } else {
                    print("Login unsuccessful after account creation")
                }
            }
            completion("")
        })
    }
    
    static func AddUser(username:String, email:String){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let post = ["uid":uid!,
                    "username":username,
                    "email":email,
                    "profileImageUrl":""]
        databaseRef.child("users").child(uid!).setValue(post)
    }
    
}
