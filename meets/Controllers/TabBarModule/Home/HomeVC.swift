//
//  HomeVC.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import GoogleMobileAds
import SwiftyJSON
import Kingfisher

class HomeVC: BaseVC {
    
    @IBOutlet weak var col_home: UICollectionView!
    @IBOutlet weak var txv_post: UITextView!
    @IBOutlet weak var uiv_postView: UIView!
    @IBOutlet weak var uiv_reply: UIView!
    @IBOutlet weak var lbl_sendto: UILabel!
    @IBOutlet weak var txv_reply: UITextView!
    var ds_blockusers = [NotiModel]()
    var ds_posts = [PostModel]()
    // for advertisment part
    var cellAdView: GADBannerView = GADBannerView()
    var isPostViewShow: Bool = false
    var isReplyViewShow: Bool = false
    var isRequesting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Messages.TWEET
        self.addBackButtonNavBar()
        self.addProfileImage()
        self.setPostView(false)
        self.setReplyView(false, str_sendto: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getDataSource()
        self.isPostViewShow = false
        self.isRequesting = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getDataSource()  {
        self.showLoadingView(vc: self)
        ApiManager.getBlockUsers { (isSuccess, data) in
            if isSuccess{
                self.ds_blockusers.removeAll()
                let dict = JSON(data as Any)
                let notification_info = dict["follower_info"].arrayObject
                var num = 0
                if let notificationinfo = notification_info{
                    if notificationinfo.count != 0{
                        for one in notificationinfo{
                            num += 1
                            let jsonone = JSON(one as Any)
                                 
                            let user = UserModel(id: jsonone["block_user_id"].intValue, username: jsonone["username"].stringValue, userphoto: jsonone["picture"].stringValue, likeNumber: jsonone["follower"].intValue, aboutme: jsonone["about_me"].stringValue, user_location: jsonone["user_location"].stringValue, user_birthday: jsonone["user_birthday"].stringValue, password: jsonone["password"].stringValue)
                            
                            let notimodel = NotiModel(id: jsonone["id"].stringValue, senderInfo: user, time: jsonone["created_at"].stringValue, content: jsonone["type"].stringValue)
                            self.ds_blockusers.append(notimodel)
                            if num == notificationinfo.count{
                                self.getDataSource4Posts()
                            }
                        }
                    }else{
                        self.getDataSource4Posts()
                    }
                }
            }else{
                self.showToast(Messages.NETISSUE)
                self.hideLoadingView()
            }
        }
    }
    
    
    func setPostView(_ isShow: Bool) {
        if isShow{
            UIView.animate(withDuration: 0.5) {
                self.uiv_postView.isHidden = false
                self.txv_post.delegate = self
                self.txv_post.text = Messages.WHATS_ON_YOUR_MIND
                self.txv_post.textColor = .lightGray
                self.txv_post.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.uiv_postView.isHidden = true
                self.txv_post.delegate = nil
                self.txv_post.text = ""
            }
        }
    }
    
    func setReplyView(_ isShow: Bool, str_sendto: String?) {
        if isShow{
            UIView.animate(withDuration: 0.5) {
                self.uiv_reply.isHidden = false
                self.txv_reply.delegate = self
                if let sendto = str_sendto{
                    self.lbl_sendto.text = "To: " + sendto
                }
                self.txv_reply.text = Messages.WHATS_ON_YOUR_MIND
                self.txv_reply.textColor = .lightGray
                self.txv_reply.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.uiv_reply.isHidden = true
                self.txv_reply.delegate = nil
                self.txv_reply.text = ""
            }
        }
    }
    
    func getDataSource4Posts()  {
        var ds_posts_temp = [PostModel]()
        ApiManager.getTotalPost { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                self.ds_posts.removeAll()
                ds_posts_temp.removeAll()
                let dict = JSON(data as Any)
                let post_info = dict["post_info"].arrayObject
                var num = 0
                if let postinfo = post_info{
                    for one in postinfo{
                        num += 1
                        let jsonone = JSON(one as Any)
                        let postmodel = PostModel(id: jsonone["id"].stringValue, userid: jsonone["user_id"].intValue, userName: jsonone["user_name"].stringValue, userPhoto: jsonone["user_photo"].stringValue, userLocation: jsonone["user_location"].stringValue, user_birthday: jsonone["user_birthday"].stringValue, userAbout: jsonone["about_me"].stringValue, postTime: jsonone["created_at"].stringValue, postContent: jsonone["post_content"].stringValue, likeNumber: jsonone["follower_number"].intValue, isLike: jsonone["like"].intValue, adId: (num % 5 == 0 ? true : false), toSend:jsonone["to_send"].stringValue , adVal: Constants.admob_id)
                        ds_posts_temp.append(postmodel)
                        if num == postinfo.count{
                            if ds_posts_temp.count == 0{
                                self.showToast(Messages.NO_ARTICLE_PREVIOUS_POST)
                            }else{
                                //print(ds_posts_temp.count)
                                //print(self.ds_blockusers.count)
                                var post_temp_num = 0
                                if self.ds_blockusers.count != 0{
                                    for all in ds_posts_temp{
                                        post_temp_num += 1
                                        var isblocked = true
                                        for blocked  in self.ds_blockusers{
                                            if all.userid == blocked.senderInfo.id{
                                                isblocked = false
                                                break
                                            }
                                        }
                                        if isblocked{
                                            self.ds_posts.append(all)
                                        }
                                        if post_temp_num == ds_posts_temp.count{
                                            self.col_home.reloadData()
                                        }
                                    }
                                }else{
                                    self.ds_posts = ds_posts_temp
                                    self.col_home.reloadData()
                                }
                            }
                        }
                    }
                }
            }else{
                self.showToast(Messages.NETISSUE)
            }
        }
    }
    
    func addBackButtonNavBar() {
        // if needed i will add
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "edit")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(postBtnTapped), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItemBack
//        self.navigationItem.rightBarButtonItems = [barButtonItemLogout/*, barButtonItem2*/]
    }
    
    @objc func postBtnTapped() {
        if !thisuser!.isValid{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }else{
            self.setInitState4PostandReplyView()
        }
    }
    
    func addProfileImage() {
        
        let imv_left = UIImageView()
        if let url = URL(string: thisuser!.user_photo ?? ""){
            imv_left.kf.setImage(with: url,placeholder: UIImage.init(named: "logo"))
            imv_left.cornerRadius = 17
            let barButtonItemBack = UIBarButtonItem(customView: imv_left)
            barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 34).isActive = true
            barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 34).isActive = true
            self.navigationItem.leftBarButtonItem = barButtonItemBack
        }
    }
    
    @objc func imageBtnTapped() {
        
    }
    
    func setInitState4PostandReplyView()  {
        self.isReplyViewShow = false
        self.setReplyView(false, str_sendto: nil)
        self.isPostViewShow = !isPostViewShow
        self.setPostView(self.isPostViewShow)
    }
    
    private func action(title: String, index: Int) -> UIAlertAction? {
    
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if title != "Cancel"{
                print("clicked===>\(index)")
                self.showLoadingView(vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideLoadingView()
                    self.showToast(Messages.REPORT_SUCCESS)
                }
            }
        }
    }

    public func presentAlert(from sourceView: UIView, index: Int) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let action = self.action(title: Messages.REPORT_THIS_POST, index: index) {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: Messages.CANCEL, style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    
    @IBAction func replyBtnClicked(_ sender: Any) {
        if thisuser!.isValid{
            let button = sender as! UIButton
            let index = button.tag
            self.isReplyViewShow = !isReplyViewShow
            self.setReplyView(self.isReplyViewShow, str_sendto: self.ds_posts[index].userName)
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    
    @IBAction func chatBtnClicked(_ sender: Any) {
        if thisuser!.isValid{
            chattingOptionVC = .fromHome
            let button = sender as! UIButton
            let index = button.tag
            let user = UserModel(id: ds_posts[index].userid, username: ds_posts[index].userName, userphoto: ds_posts[index].userPhoto)
            self.gotoMessageSendVC(user)
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    
    @IBAction func reportBtnClicked(_ sender: Any) {
        if thisuser!.isValid{
            let button = sender as! UIButton
            let index = button.tag
            self.presentAlert(from: view, index: index)
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.isPostViewShow = false
        self.setPostView(self.isPostViewShow)
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        if thisuser!.isValid{
            if txv_post.text != nil && txv_post.text != Messages.WHATS_ON_YOUR_MIND && txv_post.text != "" {
                self.showLoadingView(vc: self)
                ApiManager.uploadPost(post_content: self.txv_post.text!, to_send: nil) { (isSuccess, data) in
                    self.hideLoadingView()
                    self.setInitState4PostandReplyView()
                    if isSuccess{
                        self.getDataSource4Posts()
                    }else{
                        self.showToast(Messages.NETISSUE)
                    }
                }
                
            }else{
                self.showToast(Messages.POST_TEXT_REQUIRE)
            }
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    @IBAction func replyCloseBtnClicked(_ sender: Any) {
        
        self.isReplyViewShow = false
        self.setReplyView(self.isReplyViewShow, str_sendto: nil)
    }
    
    @IBAction func replySendBtnClicked(_ sender: Any) {
        if thisuser!.isValid{
            if txv_reply.text != nil && txv_reply.text != Messages.WHATS_ON_YOUR_MIND && txv_reply.text != "" {
                self.showLoadingView(vc: self)
                ApiManager.uploadPost(post_content: self.txv_reply.text!, to_send: self.lbl_sendto.text) { (isSuccess, data) in
                    self.hideLoadingView()
                    self.isReplyViewShow = false
                    self.setReplyView(self.isReplyViewShow, str_sendto: nil)
                    if isSuccess{
                        self.getDataSource4Posts()
                    }else{
                        self.showToast(Messages.NETISSUE)
                    }
                }
            }else{
                self.showToast(Messages.REPLY_TEXT_REQUIRE)
            }
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    
    @IBAction func profileBtnClicked(_ sender: Any) {
        if thisuser!.isValid{
            let profiel_count = UserDefault.getInt(key: PARAMS.PROFILE_LIMIT, defaultValue: 0)
            let message_count = UserDefault.getInt(key: PARAMS.MESSAGE_LIMIT, defaultValue: 0)
            print("\(profiel_count), \(message_count)")
            
            if profiel_count > Constants.profile_limit{
                self.gotoVCModal(VCs.ADSHOWVC)
            }else{
                let new_profile_count = profiel_count + 1
                UserDefault.setInt(key: PARAMS.PROFILE_LIMIT, value: new_profile_count)
                UserDefault.Sync()
                if !self.isRequesting{
                    self.isRequesting = true
                    let button = sender as! UIButton
                    let index = button.tag
                    let one = self.ds_posts[index]
                    //self.showLoadingView(vc: self)
                    ApiManager.getOtherUserProfile(owner_id: "\(one.userid)") { (isSuccess, data) in
                        //self.hideLoadingView()
                        self.isRequesting = false
                        if isSuccess{
                            let one = JSON(data as Any)
                            let user = UserModel(id: one["id"].intValue, username: one["username"].stringValue, userphoto: one["picture"].stringValue, likeNumber: one["follower"].intValue, aboutme: one["aboutme"].stringValue, user_location: one["user_location"].stringValue, user_birthday: one["user_birthday"].stringValue, password: "")
                            self.gotoGeneralProfileVC(user, isLikeUser: (one["like"].stringValue == "1" ? true : false) ,chattingOption: .fromHome)
                        }else{
                            self.showToast(Messages.NETISSUE)
                        }
                    }
                }
            }
        }else{
            /*if !self.isRequesting{
                self.isRequesting = true
                let button = sender as! UIButton
                let index = button.tag
                let one = self.ds_posts[index]
                //self.showLoadingView(vc: self)
                ApiManager.getOtherUserProfile(owner_id: "\(one.userid)") { (isSuccess, data) in
                    //self.hideLoadingView()
                    self.isRequesting = false
                    if isSuccess{
                        let one = JSON(data as Any)
                        let user = UserModel(id: one["id"].intValue, username: one["username"].stringValue, userphoto: one["picture"].stringValue, likeNumber: one["follower"].intValue, aboutme: one["aboutme"].stringValue, user_location: one["user_location"].stringValue, user_birthday: one["user_birthday"].stringValue, password: "")
                        self.gotoGeneralProfileVC(user, isLikeUser: (one["like"].stringValue == "1" ? true : false) ,chattingOption: .fromHome)
                    }else{
                        self.showToast(Messages.NETISSUE)
                    }
                }
            }*/
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.ds_posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 4 == 3{
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
            let cell: AdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
            /*cell.setAd()
            cell.delegate = self
            cell.adDelegate = self
            return cell*/
            let bannerView = AdCell.cellBannerView(rootVC: self, frame:cell.bounds)
            bannerView.adSize = GADAdSizeFromCGSize(CGSize.init(width: Constants.SCREEN_WIDTH, height: 250))
            for view in cell.contentView.subviews {
                if view.isKind(of: GADBannerView.self){
                    view.removeFromSuperview() // Make sure that the cell does not have any previously added GADBanner view as it would be reused
                }
            }

            cell.addSubview(bannerView)

            /*let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0)) { // Get the request in the background thread
                let request = GADRequest()
                request.testDevices = [kGADSimulatorID]
                dispatch_async(dispatch_get_main_queue()) { // Update the UI
                   bannerView.loadRequest(request)
                }
            }*/
            DispatchQueue.main.async {
                let request = GADRequest()
                bannerView.load(request)
            }
            
            return cell
        }else{
            if self.ds_posts[indexPath.row].toSend != nil && self.ds_posts[indexPath.row].toSend != "" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
                cell.entity = self.ds_posts[indexPath.row]
                cell.btn_chat.tag = indexPath.row
                cell.btn_reply.tag = indexPath.row
                cell.btn_report.tag = indexPath.row
                cell.btn_profile.tag = indexPath.row
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
                cell.entity = self.ds_posts[indexPath.row]
                cell.btn_chat.tag = indexPath.row
                cell.btn_reply.tag = indexPath.row
                cell.btn_report.tag = indexPath.row
                cell.btn_profile.tag = indexPath.row
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked===>",indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.size.width
        var h: CGFloat = 180
        if indexPath.row % 4 == 3{
            h = 250
            //return CGSize(width: w, height: 250)
        }else{
            if self.ds_posts[indexPath.row].toSend != nil && !self.ds_posts[indexPath.row].toSend!.isEmpty{
                //return CGSize(width: w, height: 190)
                h = 230
            }else{
                //return CGSize(width: w, height: 150)
                h = 180
            }
        }
        return CGSize(width: w, height: h)
        
        
        /*var h: CGFloat = 150
        if self.ds_posts[indexPath.row].adId{
            h = 250
        }
        return CGSize(width: w, height: h)*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Messages.WHATS_ON_YOUR_MIND
            textView.textColor = .lightGray
        }
    }
}

extension HomeVC : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        /*if addBottomLayout.constant < 50 {     // default banner height
            UIView.animate(withDuration: 1.0) {
                self.addBottomLayout.constant += 50
                self.clvBooks.contentInset.bottom += 50
                self.view.layoutIfNeeded()
            }
        }*/
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
