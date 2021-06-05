//
//  PeopleVC.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import AORangeSlider
import SwiftyJSON

class PeopleVC: BaseVC {
    
    @IBOutlet weak var col_peopleShow: UICollectionView!
    @IBOutlet weak var uiv_search: UIView!
    @IBOutlet weak var indicatorSlider: AORangeSlider!
    @IBOutlet weak var cus_gender: MSDropDown!
    @IBOutlet weak var cus_kinkRole: MSDropDown!
    @IBOutlet weak var cus_lookingfor: MSDropDown!
    
    var isSearchViewShow: Bool = false
    var ds_posts = [PostModel]()
    var isThumb: Bool = false
    var search_gender: String = ""
    var search_age: String = ""
    var search_purpose: String = ""
    var search_attr: String = ""
    var isNearBy: Bool  = false
    
    let gender_Options : [KeyValueModel] = [
    KeyValueModel(key: "0", value: "フェム"),
    KeyValueModel(key: "1", value: "中性"),
        KeyValueModel(key: "2", value: "ボーイッシュ"),
        KeyValueModel(key: "3", value: "Xジェンダー"),
        KeyValueModel(key: "4", value: "FTM"),
        KeyValueModel(key: "5", value: "MTF"),
        KeyValueModel(key: "6", value: "クエスチョニング")]
    
    let hobby_Options : [KeyValueModel] = [KeyValueModel(key: "0", value: "タチ"),
    KeyValueModel(key: "1", value: "ネコ"),
    KeyValueModel(key: "2", value: "リバ"),
    KeyValueModel(key: "3", value: "バイセクシュアル"),
    KeyValueModel(key: "4", value: "パンセクシュアル"),
    KeyValueModel(key: "5", value: "ストレート"),
    KeyValueModel(key: "6", value: "クエスチョニング")]
    // placeholder:探している
    let lookingfor_Options : [KeyValueModel] = [KeyValueModel(key: "0", value: "恋人募集"),
    KeyValueModel(key: "1", value: "友達募集"),
    KeyValueModel(key: "2", value: "趣味友達"),
    KeyValueModel(key: "3", value: "悩み相談")]
    var ds_blockusers = [NotiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Messages.LOOK_FOR
        self.addRightBtn()
        self.addleftButton(false)
        self.setupAgeSlider()
        self.setUpDropDownFilter()
        //self.uiv_search.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataSource()
        self.isSearchViewShow = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.hud != nil{
            if hud!.isFocused{
                self.hideLoadingView()
            }
        }
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
            }
        }
    }
   
    func setUpDropDownFilter() {
        self.cus_gender.keyvalueCount = self.gender_Options.count
        self.cus_gender.delegate = self
        self.cus_gender.keyValues = self.gender_Options
        self.cus_gender.isMultiSelect = true
        self.cus_gender.tag = searchDropDownTag.gender.rawValue
        self.cus_kinkRole.keyvalueCount = self.hobby_Options.count
        self.cus_kinkRole.delegate = self
        self.cus_kinkRole.keyValues = self.hobby_Options
        self.cus_kinkRole.isMultiSelect = true
        self.cus_kinkRole.tag = searchDropDownTag.kinkRole.rawValue
        self.cus_lookingfor.keyvalueCount = self.lookingfor_Options.count
        self.cus_lookingfor.delegate = self
        self.cus_lookingfor.keyValues = self.lookingfor_Options
        self.cus_lookingfor.isMultiSelect = true
        self.cus_lookingfor.tag = searchDropDownTag.lookingfor.rawValue
        /*self.cus_distance.keyvalueCount = self.distance_Options.count
        self.cus_distance.delegate = self
        self.cus_distance.keyValues = self.distance_Options
        self.cus_distance.isMultiSelect = false
        self.cus_distance.tag = searchDropDownTag.distance.rawValue*/
    }
    
    
    func setupAgeSlider() {

        let contentView = indicatorSlider.superview!

        indicatorSlider.minimumValue = 18
        indicatorSlider.maximumValue = 80
        indicatorSlider.lowValue = 18
        indicatorSlider.highValue = 30
        indicatorSlider.minimumDistance = 5

        let lowLabel = UILabel()
        contentView.addSubview(lowLabel)
        lowLabel.textAlignment = .center
        lowLabel.frame = CGRect(x:0, y:0, width: 60, height: 20)
        lowLabel.font = .systemFont(ofSize: 15)

        let highLabel = UILabel()
        contentView.addSubview(highLabel)
        highLabel.textAlignment = .center
        highLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        highLabel.font = .systemFont(ofSize: 15)

        indicatorSlider.valuesChangedHandler = { [weak self] in
            guard let `self` = self else {
                return
            }
            let lowCenterInSlider = CGPoint(x:self.indicatorSlider.lowCenter.x, y: self.indicatorSlider.lowCenter.y)
            let highCenterInSlider = CGPoint(x:self.indicatorSlider.highCenter.x, y: self.indicatorSlider.highCenter.y)
            let lowCenterInView = self.indicatorSlider.convert(lowCenterInSlider, to: contentView)
            let highCenterInView = self.indicatorSlider.convert(highCenterInSlider, to: contentView)

            lowLabel.center = lowCenterInView
            highLabel.center = highCenterInView
            lowLabel.text = String(format: "%.0f", self.indicatorSlider.lowValue)
            highLabel.text = String(format: "%.0f", self.indicatorSlider.highValue)
            self.search_age = lowLabel.text! + "," + highLabel.text!
        }
    }
    
    func getDataSource4Posts()  {
        var ds_posts_temp = [PostModel]()
        ApiManager.getTotalUsers { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                self.ds_posts.removeAll()
                ds_posts_temp.removeAll()
                let dict = JSON(data as Any)
                let user_info = dict["user_info"].arrayObject
                var num = 0
                if let userinfo = user_info{
                    for one in userinfo{
                        num += 1
                        let one = JSON(one as Any)
                        if one["id"].intValue != thisuser?.id{
                            ds_posts_temp.append(PostModel(one))
                        }
                        
                        if num == userinfo.count{
                            if ds_posts_temp.count == 0{
                                self.showToast("まだ人はいません。")
                            }else{
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
                                            self.col_peopleShow.reloadData()
                                        }
                                    }
                                }else{
                                    self.ds_posts = ds_posts_temp
                                    self.col_peopleShow.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addleftButton(_ isthumb: Bool) {
        // if needed i will add
        if !isthumb{
            let btn_back = UIButton(type: .custom)
            btn_back.setImage(UIImage (named: "thumb")!.withRenderingMode(.alwaysTemplate), for: .normal)
            btn_back.addTarget(self, action: #selector(thmbBtnClicked), for: .touchUpInside)
            btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            btn_back.tintColor = UIColor.white
            let barButtonItemBack = UIBarButtonItem(customView: btn_back)
            barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
            barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
            self.navigationItem.leftBarButtonItem = barButtonItemBack
        }else{
            let btn_back = UIButton(type: .custom)
            btn_back.setImage(UIImage (named: "title")!.withRenderingMode(.alwaysTemplate), for: .normal)
            btn_back.addTarget(self, action: #selector(thmbBtnClicked), for: .touchUpInside)
            btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            btn_back.tintColor = UIColor.white
            let barButtonItemBack = UIBarButtonItem(customView: btn_back)
            barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
            barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
            self.navigationItem.leftBarButtonItem = barButtonItemBack
        }
    }
    
    func addRightBtn() {
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "search")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItemBack
    }
    
    @objc func thmbBtnClicked() {
        self.isThumb = !self.isThumb
        self.addleftButton(isThumb)
        self.col_peopleShow.reloadData()
    }
    
    @objc func searchBtnClicked() {
        self.isSearchViewShow = !self.isSearchViewShow
        self.setSearchView(self.isSearchViewShow)
    }
    
    func setSearchView(_ isShow: Bool)  {
        UIView.animate(withDuration: 1.0) {
            if isShow{
                self.uiv_search.isHidden = false
            }else{
                self.uiv_search.isHidden = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        /*let button = sender as! UIButton
        let index = button.tag
        //let lastNumber = self.ds_posts[index].likeNumber
        if  self.ds_posts[index].isLike == 1{
            /*self.ds_posts[index].likeNumber = lastNumber - 1
            self.ds_posts[index].isLike = false*/
            ApiManager.unfollow(owner_id: self.ds_posts[index].id.toInt() ?? 0) { (isSuccess, data) in
                if isSuccess{
                    var indexPaths = [IndexPath]()
                    indexPaths.removeAll()
                    indexPaths.append(IndexPath.init(row: index, section: 0))
                    self.col_peopleShow.reloadItems(at: indexPaths)
                }else{
                    self.showToast(Messages.NETISSUE)
                }
            }
        }else{
            /*self.ds_posts[index].isLike = true
            self.ds_posts[index].likeNumber = lastNumber + 1*/
            ApiManager.follow(owner_id: self.ds_posts[index].id.toInt() ?? 0) { (isSuccess, data) in
                if isSuccess{
                    var indexPaths = [IndexPath]()
                    indexPaths.removeAll()
                    indexPaths.append(IndexPath.init(row: index, section: 0))
                    self.col_peopleShow.reloadItems(at: indexPaths)
                }else{
                    self.showToast(Messages.NETISSUE)
                }
            }
        }*/
        
    }
    @IBAction func searchCloseBtnClicked(_ sender: Any) {
        self.isSearchViewShow = false
        self.setSearchView(self.isSearchViewShow)
    }
    
    @IBAction func searchBtnClicked4search(_ sender: Any) {
        self.isSearchViewShow = false
        self.setSearchView(self.isSearchViewShow)
        self.showLoadingView(vc: self)
        ApiManager.filterUsers(gender: self.search_gender, attr: self.search_attr, purpose: self.search_purpose, age: self.search_age, nearby: self.isNearBy ? "1" : "0") { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                self.ds_posts.removeAll()
                let dict = JSON(data as Any)
                print(dict)
                let user_info = dict["users"].arrayObject
                if let userinfo = user_info{
                    if userinfo.count != 0{
                        var num = 0
                        for one in userinfo{
                            num += 1
                            let one = JSON(one as Any)
                            self.ds_posts.append(PostModel(one))
                            if num == userinfo.count{
                                if self.ds_posts.count == 0{
                                    self.showToast("まだ人はいません。")
                                }else{
                                    self.col_peopleShow.reloadData()
                                }
                            }
                        }
                    }else{
                        self.col_peopleShow.reloadData()
                    }
                }
            }
        }
    }
    @IBAction func clickNearBy(_ sender: Any) {
        self.isNearBy = !self.isNearBy
    }
}

extension PeopleVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.ds_posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.isThumb {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbViewCell", for: indexPath) as! ThumbViewCell
            if indexPath.row <= self.ds_posts.count - 1{
                cell.entity = self.ds_posts[indexPath.row]
            }
            cell.btn_like.tag = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleViewCell", for: indexPath) as! titleViewCell
            if indexPath.row <= self.ds_posts.count - 1{
                cell.entity = self.ds_posts[indexPath.row]
            }
            cell.btn_more.tag = indexPath.row
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isThumb{
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
                    let one = self.ds_posts[indexPath.row]
                    let user = UserModel(id: one.userid, username: one.userName, userphoto: one.userPhoto, likeNumber: one.likeNumber, aboutme: one.userAbout, user_location: one.userLocation, user_birthday: one.user_birthday, password: "")
                    self.gotoGeneralProfileVC(user, isLikeUser: (one.isLike == 1 ? true : false),chattingOption: .fromPeopleVC)
                }
            }else{
                self.gotoVCModal(VCs.SIGNREQUEST)
            }
        }else{
            self.isThumb = true
            self.col_peopleShow.reloadData()
            col_peopleShow.scrollToItem(at:indexPath, at: .bottom, animated: false)
            self.addleftButton(self.isThumb)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}

extension PeopleVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isThumb {
            let w = collectionView.frame.size.width
            let h: CGFloat = w * 1.25
            return CGSize(width: w, height: h)
        
        }else{
            let w = collectionView.frame.size.width / 2.05
            let h = w * 1.3
            return CGSize(width: w, height: h)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //return (Constants.SCREEN_WIDTH - 2 * collectionView.frame.size.width / 2.05) / 3
        return 0
    }
}

extension PeopleVC: MSDropDownDelegate{
    func dropdownSelected(tagId: Int, answer: String, value: String, isSelected: Bool) {
        switch tagId {
        case searchDropDownTag.gender.rawValue:
            self.search_gender = answer.replacingOccurrences(of: "|", with: ",")
            break
        case searchDropDownTag.kinkRole.rawValue:
            self.search_attr = answer.replacingOccurrences(of: "|", with: ",")
            break
        case searchDropDownTag.lookingfor.rawValue:
            self.search_purpose = answer.replacingOccurrences(of: "|", with: ",")
            break
        default:
            print("default")
        }
    }
}

enum searchDropDownTag: Int{
    case gender = 2001
    case kinkRole = 2002
    case lookingfor = 2003
}
