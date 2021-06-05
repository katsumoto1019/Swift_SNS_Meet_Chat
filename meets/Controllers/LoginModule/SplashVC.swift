//
//  SplashVC.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/10/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import _SwiftUIKitOverlayShims


class SplashVC: BaseVC {
    
    var networkStatus = 0
    var ds_notifications = [NotiModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: {
                self.networkStatus = 1
                if self.networkStatus == 1{
                    //self.showAlerMessage(message: "No  Internet connection")
                }
                else{
                    return
                }
            }
        )
        self.checkBackgrouond()
    }
   
    func checkBackgrouond(){
        if thisuser!.isValid{
            self.showLoadingView(vc: self)
            ApiManager.login(username: thisuser!.user_name ?? "", password: thisuser!.password ?? "") { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    let data = JSON(data as Any)
                    print("data =========>",data)
                    let password = thisuser!.password!
                    thisuser?.clearUserInfo()
                    thisuser = UserModel(data)
                    thisuser?.password = password
                    thisuser?.saveUserInfo()
                    thisuser?.loadUserInfo()
                    dump(thisuser, name: "userinfo =========>")
                    //self.getBadge()
                    self.gotoTabControllerWithIndex(0)
                }else{
                    thisuser?.clearUserInfo()
                    self.gotoTabControllerWithIndex(0)
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.gotoTabControllerWithIndex(0)
            }
        }
    }
    func getBadge() {
        /*ApiManager.getNotys { (isSuccess, data) in
            if isSuccess{
                self.ds_notifications.removeAll()
                let dict = JSON(data as Any)
                print("this is the notification data==>", dict)
                let notification_info = dict["notification_info"].arrayObject
                var num = 0
                if let notificationinfo = notification_info{
                    
                    if notificationinfo.count != 0{
                        for one in notificationinfo{
                            num += 1
                            let jsonone = JSON(one as Any)
                            
                            let type = jsonone["type"].stringValue
                            let read_state = jsonone["read_state"].stringValue
                                if type == "follow" || type == "like"{
                                    if read_state == "false"{
                                        let notimodel = NotiModel(id: jsonone["id"].stringValue,owner_id: jsonone["owner_id"].stringValue, user_id: jsonone["user_id"].stringValue, user_name: jsonone["user_name"].stringValue, photo_url: jsonone["user_photo"].stringValue, type: jsonone["type"].stringValue)
                                        self.ds_notifications.append(notimodel)
                                    }
                                }
                            
                            if num == notificationinfo.count{
                                if self.ds_notifications.count == 0{
                                    badgeVal = nil
                                }else{
                                    badgeVal = "\(self.ds_notifications.count)"
                                }
                                //print("thisis the badgeval=====>",badgeVal)
                                self.gotoTabIndex(0, badgeVal: badgeVal)
                            }
                        }
                    }else{
                        //まだ通知はありません。
                        badgeVal = nil
                        self.gotoTabIndex(0, badgeVal: nil)
                        //print("no notifications yet.")
                        self.showToast("まだ通知はありません。")
                    }
                }
            }
        }*/
    }
}
