//
//  AttachModel&Cell.swift
//  DatingKinky
//
//  Created by top Dev on 9/16/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class AttachModel: NSObject{
    
    var str_image: String?
    var backColor: UIColor?
    
    override init() {
        
        self.str_image = ""
        self.backColor = .clear
    }
    
    init(str_image: String, color_back: UIColor ) {
        
        self.str_image = str_image
        self.backColor = color_back
    }
}

class AttachCell: UICollectionViewCell {
    
    @IBOutlet var imv_attach: UIImageView!
    @IBOutlet var uiv_back: UIView!
    @IBOutlet weak var lbl_plus: UILabel!
    
    var entity: AttachModel!{
        
        didSet{
            if let str_image = entity.str_image {
                self.imv_attach.image = UIImage.init(named: str_image)
            }
            self.uiv_back.backgroundColor = entity.backColor
        }
    }
}
