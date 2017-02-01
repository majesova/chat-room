//
//  Post.swift
//  chat-room
//
//  Created by Plenumsoft on 31/01/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit

class Post: NSObject {

    var username :String = ""
    var text :String = ""
    var toId : String = ""
    
    init (username:String, text:String, toId : String){
        self.username = username
        self.text = text
        self.toId = toId
    }
    
}
