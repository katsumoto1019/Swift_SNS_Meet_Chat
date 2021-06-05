//
//  NotiModel&Cell.swift
//  emoglass
//
//  Created by Mac on 7/8/20.
//  Copyright © 2020 Mac. All rights reserved.
//


import Foundation
import Kingfisher

class NotiModel{
    
    var id : String?
    var senderInfo: UserModel!
    var time: String?
    var content: String?
    
    init(id: String,senderInfo: UserModel,time: String, content: String) {
        self.id = id
        self.senderInfo = senderInfo
        self.time = time
        self.content = content
    }
}


class NotiCell: UITableViewCell {
    @IBOutlet var imv_photo: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
    var entity:NotiModel!{
        didSet{
            let url = URL(string: entity.senderInfo.user_photo ?? "")
            imv_photo.kf.setImage(with: url,placeholder: UIImage(named: "icon_user"))
            userName.text = entity.senderInfo.user_name
            lbl_time.text = entity.time
            lbl_time.font = lbl_time.font.italic
            if entity.content == "follow"{
                content.text = "があなたにいいねを押しました」。"
            }else{
                content.text = "嫌いな私。"
            }
        }
    }
}

class FavoriteCell: UITableViewCell {
    @IBOutlet var imv_photo: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    
    var entity:NotiModel!{
        didSet{
            let url = URL(string: entity.senderInfo.user_photo ?? "")
            imv_photo.kf.setImage(with: url,placeholder: UIImage(named: "icon_user"))
            userName.text = entity.senderInfo.user_name
            lbl_time.text = entity.time
            lbl_time.font = lbl_time.font.italic
            let spaces = String(repeating: " ", count: 1)
            content.text = entity.senderInfo.user_location! + spaces + "|" + spaces +  getAgeFromString(entity.senderInfo.user_birthday!)
        }
    }
}


