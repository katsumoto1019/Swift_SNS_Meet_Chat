//
//  StatusModel.swift
//  meets
//
//  Created by top Dev on 9/23/20.
//

import Foundation
class StatusModel {
    
    var online : String
    var sender_id : String
    var timesVal : String
    
    
    init(online : String,sender_id : String, timesVal : String) {
        
        self.online = online
        self.sender_id = sender_id
        self.timesVal = timesVal
        
    }
    
    init() {
        self.online = ""
        self.sender_id = ""
        self.timesVal = ""
    }
}
