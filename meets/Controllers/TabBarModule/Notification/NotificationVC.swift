//
//  NotificationVC.swift
//  emoglass
//
//  Created by Mac on 7/8/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationVC: BaseVC{

    @IBOutlet weak var tbv_notification: UITableView!
    var ds_notifications = [NotiModel]()
    var isRequesting = false
    var ds_blockusers = [NotiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //toVC?.animatedItems[3].badgeValue = nil
        //badgeVal = nil
        //self.tabBarController?.delegate = self
        //toVC?.animatedItems[3].badgeValue = nil
        self.title = Messages.NOTIFICATION
        tbv_notification.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.isRequesting = false
        //UserDefault.setBool(key: PARAMS.SEARCHVC, value: false)
        if !thisuser!.isValid{
            //self.gotoVC("LoginNav")
            //self.gotoVCModal("SigninRequestVC")
        }else{
            getDataSource()
        }
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
                                self.getData4Notificaiton()
                            }
                        }
                    }else{
                        self.getData4Notificaiton()
                    }
                }
            }else{
                self.showToast(Messages.NETISSUE)
            }
        }
    }
    
    func getData4Notificaiton()  {
        /*self.ds_notifications.removeAll()
        var num = 0
        for i in 0 ... 9{
            num += 1
            let userone = UserModel(id: i, username: TestData.userNames[i], userphoto: TestData.images[i], likeNumber: TestData.likeNum[i], aboutme: TestData.postContent[i], user_location: TestData.userLocation[i], user_age: TestData.userAge[i])
            self.ds_notifications.append(NotiModel(id: "\(i)", senderInfo: userone, time: TestData.postTime[i], content: TestData.postContent[i]))
            if num == 10{
                self.tbv_notification.reloadData()
            }
        }*/
        var ds_posts_temp = [NotiModel]()
        ApiManager.getNotys { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                ds_posts_temp.removeAll()
                self.ds_notifications.removeAll()
                let dict = JSON(data as Any)
                let notification_info = dict["notification_info"].arrayObject
                var num = 0
                if let notificationinfo = notification_info{
                    if notificationinfo.count != 0{
                        for one in notificationinfo{
                            num += 1
                            let jsonone = JSON(one as Any)
                                 
                            let user = UserModel(id: jsonone["user_id"].intValue, username: jsonone["user_name"].stringValue, userphoto: jsonone["user_photo"].stringValue, likeNumber: jsonone["follower"].intValue, aboutme: jsonone["about_me"].stringValue, user_location: jsonone["user_location"].stringValue, user_birthday: jsonone["user_birthday"].stringValue, password: jsonone["password"].stringValue)
                            
                            let notimodel = NotiModel(id: jsonone["id"].stringValue, senderInfo: user, time: jsonone["created_at"].stringValue, content: jsonone["type"].stringValue)
                            ds_posts_temp.append(notimodel)
                            if num == notificationinfo.count{
                                var post_temp_num = 0
                                if self.ds_blockusers.count != 0{
                                    for all in ds_posts_temp{
                                        post_temp_num += 1
                                        var isblocked = true
                                        for blocked  in self.ds_blockusers{
                                            if all.senderInfo.id == blocked.senderInfo.id{
                                                isblocked = false
                                                break
                                            }
                                        }
                                        if isblocked{
                                            self.ds_notifications.append(all)
                                        }
                                        if post_temp_num == ds_posts_temp.count{
                                            self.tbv_notification.reloadData()
                                        }
                                    }
                                }else{
                                    self.ds_notifications = ds_posts_temp
                                    self.tbv_notification.reloadData()
                                }
                            }
                        }
                    }else{
                        //まだ通知はありません。
                        print("no notifications yet.")
                        self.showToast("まだ通知はありません。")
                    }
                }
            }
        }
    }
}

extension NotificationVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ds_notifications.count
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

        let cell = tbv_notification?.dequeueReusableCell(withIdentifier: "NotiCell", for:indexPath) as! NotiCell
        cell.selectionStyle = .none
        cell.entity = ds_notifications[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.SCREEN_HEIGHT / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isRequesting{
            self.isRequesting = true
            let one = self.ds_notifications[indexPath.section]
            ApiManager.getOtherUserProfile(owner_id: "\(one.senderInfo.id ?? 0)") { (isSuccess, data) in
                if isSuccess{
                    self.isRequesting = false
                    let one = JSON(data as Any)
                    let user = UserModel(id: one["id"].intValue, username: one["username"].stringValue, userphoto: one["picture"].stringValue, likeNumber: one["follower"].intValue, aboutme: one["aboutme"].stringValue, user_location: one["user_location"].stringValue, user_birthday: one["user_birthday"].stringValue, password: "")
                    self.gotoGeneralProfileVC(user, isLikeUser: (one["like"].stringValue == "1" ? true : false) ,chattingOption: .fromHome)
                }else{
                    self.showToast(Messages.NETISSUE)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension NotificationVC: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         /*let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 3 {
             //do your stuff
            ApiManager.setNotiRead { (isSuccess, data) in
                if isSuccess{
                    self.tabBarController?.viewControllers?[3].tabBarItem.badgeValue = nil
                }else{
                    self.showToast("ネットワークの問題。")
                }
            }
         }*/
    }
}
