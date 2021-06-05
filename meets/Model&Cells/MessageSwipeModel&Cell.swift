//
//  MessageSwipeModel.swift
//  meets
//
//  Created by top Dev on 9/23/20.
//

import Foundation
import SwiftyJSON
import SwipeCellKit
import Kingfisher

class MessageSwipeModel{
    var id : String? = nil
    var sender_id = ""
    var msgAvatar = ""
    var msgUserName = ""
    var msgContent = ""
    var unreadMsgNum = ""
    var msgTime = ""
    var readStatus : Bool?
    var sender_photo = ""
    
    init() {
         id = ""
         sender_id = ""
         msgAvatar = ""
         msgUserName = ""
         msgContent = ""
         unreadMsgNum = ""
         msgTime = ""
         readStatus = true
         sender_photo = ""
    }
    init(_ id :String,sender_id : String, msgAvatar:String,msgUserName:String, msgContent:String,unreadMsgNum:String,msgTime:String,sender_photo : String){
        self.id = id
        self.sender_id = sender_id
        self.msgAvatar = msgAvatar
        self.msgUserName = msgUserName
        self.msgContent = msgContent
        self.msgTime = msgTime
        self.unreadMsgNum = unreadMsgNum
        if self.unreadMsgNum.toInt() ?? 0 > 0{
            self.readStatus = true
        }
        else{
            self.readStatus = false
        }
        self.sender_photo = sender_photo
    }
}

class MessageSwipeCell: SwipeCollectionViewCell {
    
    @IBOutlet var msgAvatar: UIImageView!
    @IBOutlet var msgUserName: UILabel!
    @IBOutlet var msgContent: UILabel!
    @IBOutlet var msgTime: UILabel!
    @IBOutlet var msgUnreadNum: UILabel!
    @IBOutlet var msgReadTick: UIImageView!
    @IBOutlet weak var UnreadView: UIView!
     
    var entity:MessageSwipeModel!{
        
        didSet{
            let url = URL(string: entity.sender_photo)
            msgAvatar.kf.setImage(with: url,placeholder: UIImage(named: "avatar"))
            msgUserName.text = entity.msgUserName
            msgContent.text = entity.msgContent
            msgTime.text = getStrDate(entity.msgTime)
        }
    }
}

