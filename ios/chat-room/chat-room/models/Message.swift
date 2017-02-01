//
//  Message.swift
//  chat-room
//
//  Created by Plenumsoft on 01/02/17.
//  Copyright © 2017 com.majesova. All rights reserved.
//

import UIKit

class Message: NSObject {

    var from : String?
    var text : String?
    var username : String?
    
    init (_ from:String, text:String, username:String){
    
        self.from = from
        self.text = text
        self.username = username
        
    }
}
