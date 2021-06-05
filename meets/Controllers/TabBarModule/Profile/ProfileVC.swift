//
//  ProfileVC.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import Kingfisher

class ProfileVC: BaseVC {

    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_usercontent: UILabel!
    @IBOutlet weak var txv_aboutme: UITextView!
    @IBOutlet weak var lbl_likenumber: UILabel!
    @IBOutlet weak var uiv_like: UIView!
    @IBOutlet weak var imv_favorite: UIImageView!
    @IBOutlet weak var imv_profile: UIImageView!
    var islike: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Messages.MY_PAGE
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.islike = false
    }
    
    func setUI()  {
        if let userphoto = thisuser?.user_photo{
            let url = URL(string: userphoto )
            imv_profile.kf.setImage(with: url,placeholder: UIImage.init(named: "logo"))
        }
        self.lbl_username.text = thisuser?.user_name
        self.txv_aboutme.text = thisuser?.aboutme
        if thisuser!.isValid{
            self.lbl_usercontent.text = thisuser!.user_location! + " " + "|" + " " + getAgeFromString(thisuser!.user_birthday!)
        }
        
        if let likenum = thisuser?.likeNumber{
            self.lbl_likenumber.text = "\(likenum)"
        }
        
        self.uiv_like.backgroundColor = UIColor.init(named: "color_Primary")
        self.imv_favorite.image = UIImage.init(named: "like_filled")
    }
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func gotoEditProfile(_ sender: Any) {
        if thisuser!.isValid{
            self.gotoVC(VCs.EDITPROFILENAV)
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
}
