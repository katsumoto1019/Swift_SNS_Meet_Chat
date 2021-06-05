//
//  SettingModel.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/18/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import Foundation
import UIKit

class SettingModel {
    
    var settingCaption:String = ""
    var image: String = ""
    var state : Bool = false
    
    init (_ settingCaption:String, image: String, state: Bool)
    {
        self.settingCaption = settingCaption
        self.image = image
        self.state = state
    }
}


class SettingCell: UITableViewCell {
    
    
    @IBOutlet weak var setting_lbl: UILabel!
    @IBOutlet weak var imv_icon: UIImageView!
    
    @IBOutlet weak var switch_btn: UISwitch!
    
    var entity : SettingModel!{
        
        didSet{
            imv_icon.image = UIImage.init(named: entity.image)
            setting_lbl.text = entity.settingCaption
            switch_btn.set(width: 35, height: 20)
            switch_btn.isOn = entity.state
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            contentView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
        else{
            contentView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }
}
