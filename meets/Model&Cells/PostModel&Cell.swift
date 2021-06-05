//
//  PostModel&Cell.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import Foundation
import SwiftyUserDefaults
import Kingfisher
import GoogleMobileAds
import SwiftyJSON

class PostModel {

    var id : String
    var userid: Int
    var userName : String
    var userPhoto: String
    var userLocation : String
    var user_birthday : String
    var userAbout : String
    var postTime : String
    var postContent : String?
    var toSend: String?
    var likeNumber: Int
    var isLike: Int
    var adId: Bool
    var adVal: String?

    
    init(_ one: JSON){
        self.id = one["id"].stringValue
        self.userid = one["id"].intValue
        self.userName = one["username"].stringValue
        self.userPhoto = one["picture"].stringValue
        self.userLocation = one["user_location"].stringValue
        self.user_birthday = one["user_birthday"].stringValue
        self.postTime = one["created_at"].stringValue
        self.postContent = nil
        self.likeNumber = one["follower"].intValue
        self.isLike = one["like"].intValue
        self.adId = false
        self.userAbout = one["about_me"].stringValue
        self.toSend = nil
        self.adVal = nil
    }
    
    
    init(id : String, userid: Int, userName : String, userPhoto : String, userLocation: String, user_birthday : String,userAbout: String,  postTime: String , postContent : String, likeNumber: Int, isLike: Int = 0, adId: Bool, toSend: String?, adVal: String?){

        self.id = id
        self.userid = userid
        self.userName = userName
        self.userPhoto = userPhoto
        self.userLocation = userLocation
        self.user_birthday = user_birthday
        self.postTime = postTime
        self.postContent = postContent
        self.likeNumber = likeNumber
        self.isLike = isLike
        self.adId = adId
        self.userAbout = userAbout
        self.toSend = toSend
        self.adVal = adVal
    }

    init() {
        self.id = ""
        self.userid = 0
        self.userName = ""
        self.userPhoto = ""
        self.userLocation = ""
        self.userAbout = ""
        self.user_birthday = ""
        self.postTime = ""
        self.postContent = ""
        self.likeNumber = 0
        self.isLike = 0
        self.adId = false
        self.toSend = nil
        self.adVal = nil
    }
}


class PostCell: UICollectionViewCell {

    @IBOutlet weak var imv_userProfile: UIImageView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_userlocation_age: UILabel!
    @IBOutlet weak var lbl_postTime: UILabel!
    @IBOutlet weak var lbl_postContent: UILabel!
    @IBOutlet weak var btn_reply: UIButton!
    @IBOutlet weak var btn_chat: UIButton!
    @IBOutlet weak var btn_report: UIButton!
    @IBOutlet weak var uiv_total: dropShadowView!
    @IBOutlet weak var uiv_reply: UIView!
    @IBOutlet weak var uiv_message: UIView!
    @IBOutlet weak var btn_profile: UIButton!
    
    var entity : PostModel!{
        didSet {
            let url = URL(string: entity.userPhoto)
            imv_userProfile.kf.setImage(with: url,placeholder: UIImage.init(named: "icon_user"))
            let spaces = String(repeating: " ", count: 1)
            lbl_username.text = entity.userName
            lbl_userlocation_age.text = entity.userLocation + spaces + "|" + spaces + getAgeFromString(entity.user_birthday)
            lbl_postTime.text = entity.postTime
            lbl_postContent.text = entity.postContent
        }
    }
}

class ReplyCell: UICollectionViewCell {

    @IBOutlet weak var imv_userProfile: UIImageView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_userlocation_age: UILabel!
    @IBOutlet weak var lbl_postTime: UILabel!
    @IBOutlet weak var lbl_postContent: UILabel!
    @IBOutlet weak var btn_reply: UIButton!
    @IBOutlet weak var btn_chat: UIButton!
    @IBOutlet weak var btn_report: UIButton!
    @IBOutlet weak var uiv_total: dropShadowView!
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var uiv_toView: UIView!
    @IBOutlet weak var lbl_to: UILabel!
    
    var entity : PostModel!{
        didSet {
            let url = URL(string: entity.userPhoto)
            imv_userProfile.kf.setImage(with: url,placeholder: UIImage.init(named: "icon_user"))
            let spaces = String(repeating: " ", count: 1)
            lbl_username.text = entity.userName
            
            lbl_userlocation_age.text = entity.userLocation + spaces + "|" + spaces +  getAgeFromString(entity.user_birthday)
            lbl_postTime.text = entity.postTime
            lbl_postContent.text = entity.postContent
            lbl_to.text = entity.toSend
        }
    }
}

class AdCell: UICollectionViewCell {
    @IBOutlet weak var uiv_total: dropShadowView!
    var delegate: UIViewController?
    var adDelegate: GADBannerViewDelegate?
    var cellAdView: GADBannerView = GADBannerView()
    
    /*func setAd()  {
        cellAdView = GADBannerView()
        cellAdView.adSize = GADAdSizeFromCGSize(CGSize.init(width: Constants.SCREEN_WIDTH, height: 250))
        cellAdView.adUnitID = Constants.admob_id
        cellAdView.delegate = adDelegate
        cellAdView.rootViewController = delegate
        cellAdView.load(GADRequest())
        uiv_total.addSubview(cellAdView)
    }*/
    
    class func cellBannerView(rootVC: UIViewController, frame: CGRect) -> GADBannerView {
        let bannerView = GADBannerView()
        bannerView.frame = frame
        bannerView.rootViewController = rootVC
        bannerView.adUnitID = Constants.admob_id
        bannerView.adSize = kGADAdSizeBanner
        return bannerView
    }
}


class titleViewCell: UICollectionViewCell {
    
    @IBOutlet var imv_profile: UIImageView!
    @IBOutlet weak var btn_more: UIButton!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_userlocation_age: UILabel!
    @IBOutlet weak var uiv_total: UIView!
    
    var entity: PostModel!{
        
        didSet{
            let url = URL(string: entity.userPhoto )
            imv_profile.kf.setImage(with: url,placeholder: UIImage.init(named: "logo"))
            imv_profile.cornerRadius = (Constants.SCREEN_WIDTH - 20 - 16) / 4.1
            lbl_userName.text = entity.userName
            let spaces = String(repeating: " ", count: 1)
            lbl_userlocation_age.text = entity.userLocation + spaces + "|" + spaces +  getAgeFromString(entity.user_birthday)
        }
    }
}

class ThumbViewCell: UICollectionViewCell {
    
    @IBOutlet weak var uiv_like: UIView!
    @IBOutlet var imv_prfile: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_userlocation_age: UILabel!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var imv_favorite: UIImageView!
    @IBOutlet weak var lbl_likeNum: UILabel!
    @IBOutlet weak var uiv_likeEffect: UIView!
    
    var entity: PostModel!{
        didSet{
            let url = URL(string: entity.userPhoto)
            imv_prfile.kf.setImage(with: url,placeholder: UIImage.init(named: "logo"))
            lbl_userName.text = entity.userName
            let spaces = String(repeating: " ", count: 1)
            lbl_userlocation_age.text = entity.userLocation + spaces + "|" + spaces +  getAgeFromString(entity.user_birthday)
            lbl_content.text = entity.postContent
            lbl_likeNum.text = "\(entity.likeNumber)"
            if entity.isLike == 1{
                imv_favorite.image = UIImage.init(named:"like_filled")
                uiv_like.backgroundColor = UIColor.init(named: "color_Primary")
            }else{
                imv_favorite.image = UIImage.init(named:"like")
                uiv_like.backgroundColor = .lightGray
            }
        }
    }
}
