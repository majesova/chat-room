//
//  User.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit
import FirebaseStorage

class User: NSObject {
    var username:String
    var email:String
    var uid:String
    var profileImageUrl:String
    
    init(uid:String, username:String, email:String, profileImageUrl:String){
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
    
    func getProfileImage() -> UIImage {
        if let url = NSURL(string: profileImageUrl){
            if let data = NSData(contentsOf: url as URL){
                return UIImage(data: data as Data)!
            }
        }
        return UIImage()
    }
    
    func uploadProfilePhoto(profileImage:UIImage, callback:@escaping (()->Void)){
        let profileImageRef = FIRStorage.storage().reference().child("profileImages").child("\(NSUUID().uuidString).jpg")
        if let imageData = UIImageJPEGRepresentation(profileImage, 0.25){
            profileImageRef.put(imageData, metadata:nil){
                metadata, error in
                print("finish upload")
                if error != nil {
                    //print(error)
                    return
                } else {
                    //print(metadata)
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString{
                       
                            self.profileImageUrl = downloadUrl
                            CHRFirebaseManager.databaseRef.child("users").child(self.uid)
                                .updateChildValues(["profileImageUrl": downloadUrl])
                        callback()
                    }
                }
            }
        }
    }
    
    
    
}
