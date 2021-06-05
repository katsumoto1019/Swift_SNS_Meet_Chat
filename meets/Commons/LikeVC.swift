//
//  LikeVC.swift
//  meets
//
//  Created by top Dev on 10/10/20.
//

import UIKit
import SwiftyJSON

class LikeVC: BaseVC {

    @IBOutlet weak var tbv_favourite: UITableView!
    var ds_favorites = [NotiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Messages.FAVORITELIST
        tbv_favourite.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if thisuser!.isValid{
            getDataSource()
        }
        self.addleftButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.hud != nil{
            if hud!.isFocused{
                self.hideLoadingView()
            }
        }
    }
    
    func addleftButton() {
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(gotoHome), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemBack
    }
    
    @objc func gotoHome() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getDataSource()  {
        /*self.ds_favorites.removeAll()
        var num = 0
        for i in 0 ... 9{
            num += 1
            let userone = UserModel(id: i, username: TestData.userNames[i], userphoto: TestData.images[i], likeNumber: TestData.likeNum[i], aboutme: TestData.postContent[i], user_location: TestData.userLocation[i], user_age: TestData.userAge[i])
            self.ds_favorites.append(NotiModel(id: "\(i)", senderInfo: userone, time: TestData.postTime[i], content: TestData.postContent[i]))
            if num == 10{
                self.tbv_favourite.reloadData()
            }
        }*/
        self.showLoadingView(vc: self)
        ApiManager.getLikers { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                self.ds_favorites.removeAll()
                let dict = JSON(data as Any)
                let notification_info = dict["follower_info"].arrayObject
                var num = 0
                if let notificationinfo = notification_info{
                    if notificationinfo.count != 0{
                        for one in notificationinfo{
                            num += 1
                            let jsonone = JSON(one as Any)
                                 
                            let user = UserModel(id: jsonone["owner_id"].intValue, username: jsonone["username"].stringValue, userphoto: jsonone["picture"].stringValue, likeNumber: jsonone["follower"].intValue, aboutme: jsonone["about_me"].stringValue, user_location: jsonone["user_location"].stringValue, user_birthday: jsonone["user_birthday"].stringValue, password: jsonone["password"].stringValue)
                            
                            let notimodel = NotiModel(id: jsonone["id"].stringValue, senderInfo: user, time: jsonone["created_at"].stringValue, content: jsonone["type"].stringValue)
                            self.ds_favorites.append(notimodel)
                            if num == notificationinfo.count{
                                self.tbv_favourite.reloadData()
                            }
                        }
                    }else{
                        //まだ通知はありません。
                        print("no notifications yet.")
                        self.tbv_favourite.reloadData()
                        self.showToast("お気に入りのユーザーはまだいません。")
                    }
                }
            }
        }
    }
    @IBAction func deleteBtnClickekd(_ sender: Any) {
        let button = sender as! UIButton
        let indexpath = button.tag
        ApiManager.unfollow(owner_id: self.ds_favorites[indexpath].senderInfo.id) { (isSuccess, data) in
            if isSuccess{
                self.getDataSource()
            }else{
                self.showToast(Messages.NETISSUE)
            }
        }
    }
}

extension LikeVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ds_favorites.count
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tbv_favourite?.dequeueReusableCell(withIdentifier: "FavoriteCell", for:indexPath) as! FavoriteCell
        cell.selectionStyle = .none
        cell.entity = ds_favorites[indexPath.section]
        cell.btn_delete.tag = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.SCREEN_HEIGHT / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gotoGeneralProfileVC(self.ds_favorites[indexPath.section].senderInfo, isLikeUser: false, chattingOption: .fromNotiVC)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
