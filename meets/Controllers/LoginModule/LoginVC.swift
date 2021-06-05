//
//  LoginVC.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/10/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults

class LoginVC: BaseVC, UITextFieldDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var lbl_signin: UILabel!
    @IBOutlet weak var signBtnView: UIView!
    @IBOutlet weak var edtUsername: UITextField!
    @IBOutlet weak var edtPwd: UITextField!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var imv_backBtn: UIImageView!
    var username = ""
    var password = ""
    var ds_notifications = [NotiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editInit()
        loadLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBar()
    }
    
    func editInit() {
        setEdtPlaceholder(edtUsername, placeholderText: Messages.USERNAME, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtPwd, placeholderText: Messages.PASSWORD, placeColor: UIColor.lightGray, padding: .left(45))
    }
    
    func loadLayout() {
        self.hideKeyboardWhenTappedAround()
        lbl_signin.text = Messages.SIGNIN
        //if UserDefault.getBool(key: PARAMS.FIRSTLOGIN,defaultValue: true) {
            self.imv_backBtn.isHidden = false
            self.btn_back.isHidden = false
        //}
        
        /*self.edtUsername.text =  "tester@gmail.com"
        self.edtPwd.text = "123456"*/
    }
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        username = self.edtUsername.text ?? ""
        password = self.edtPwd.text ?? ""
        if username.isEmpty{
            self.showToast(Messages.USERNAME_REQUIRE)
            return
        }
        
        if password.isEmpty{
            self.showToast(Messages.PASSWORD_REQUIRE)
            return
        }
        else{
            self.showLoadingView(vc: self)
            ApiManager.login(username: self.username, password: self.password) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    let data = JSON(data as Any)
                    print("data =========>",data)
                    thisuser?.clearUserInfo()
                    UserDefault.setBool(key: PARAMS.LOGOUT, value: false)
                    UserDefault.setString(key: PARAMS.PASSWORD, value: self.password)
                    thisuser = UserModel(data)
                    thisuser?.password = self.password
                    thisuser?.saveUserInfo()
                    thisuser?.loadUserInfo()
                    dump(thisuser, name: "userinfo =========>")
                    //self.gotoNavPresent("RAMAnimatedTabBarController", fullscreen: true)
                    //self.gotoTabIndex(0, badgeVal: badgeVal)
                    //self.getBadge()
                    self.gotoTabControllerWithIndex(0)
                }else{
                    if data == nil{
                        self.alertDisplay(alertController: self.alertMake(Messages.NETISSUE))
                    }
                    else{
                       let result_code = data as! Int
                       if(result_code == 201){
                        self.alertDisplay(alertController: self.alertMake(Messages.USERNAME_NONE_EXIST))
                       }
                       else{
                        self.alertDisplay(alertController: self.alertMake(Messages.PASSWORD_INCORRECT))
                       }
                    
                    }
                }
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
   
    @IBAction func gotoSignUp(_ sender: Any) {
        gotoNavPresent("SignUpVC",fullscreen: true)
    }
    
    @IBAction func gotoForgot(_ sender: Any) {
       //self.gotoNavPresent("ForgotPwdVC", fullscreen: false)
        //self.showToast("Forgot Password")
        self.gotoNavPresent("ForgotVC", fullscreen: true)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        /*if UserDefault.getBool(key: PARAMS.SEARCHVC,defaultValue: false){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.gotoTabIndex(1, badgeVal: badgeVal)
        }*/
        //self.dismiss(animated: true, completion: nil)
        self.gotoTabControllerWithIndex(0)
    }
}
