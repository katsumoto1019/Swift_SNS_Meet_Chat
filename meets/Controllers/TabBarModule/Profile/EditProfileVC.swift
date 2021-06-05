//
//  EditProfileVC.swift
//  emoglass
//
//  Created by Mac on 7/13/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class EditProfileVC: BaseVC{

    var settingDatasource = [SettingModel]()
    
    @IBOutlet weak var tbv_settings: UITableView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var imv_avatar: UIImageView!
    @IBOutlet weak var uiv_settings: UIView!
    @IBOutlet weak var uiv_dlgback: UIView!
    var noti = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadLayout()
        self.getNotiState()
        //initDatasource(false)
        self.addleftButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.gotoTabControllerWithIndex(4)
    }
    
    func getNotiState()  {
        self.showLoadingView(vc: self)
        ApiManager.getNotification { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                let state = data as! Int
                let stateBool = state == 1 ? true : false
                self.initDatasource(stateBool)
            }
        }
    }
    
    func loadLayout() {
        self.title = Messages.PROFILE
        let url = URL(string: thisuser!.user_photo ?? "")
        self.imv_avatar.kf.setImage(with: url,placeholder: UIImage(named: "icon_user"))
        self.lbl_userName.text = thisuser?.user_name
        self.uiv_settings.isHidden = true
        self.uiv_dlgback.isHidden = true
    }
    
    func initDatasource( _ state: Bool) {
        self.settingDatasource.removeAll()
        
        /* マイアカウント   My Account
        通知     Notification
        利用規約    Terms and conditions
        個人情報保護方針  Privacy Policy
        パスワードを変更する  Change Password
        アカウントを閉じる close account
        ログアウト log out*/
        
        var num = 0
        for i in 0 ... SettingOptions.images.count - 1 {
            num += 1
            let one = SettingModel (SettingOptions.settingOption[i],image: SettingOptions.images[i], state: state)
            settingDatasource.append(one)
            if num == SettingOptions.images.count{
                self.tbv_settings.reloadData()
            }
        }
    }
    @IBAction func switchBtnclicked(_ sender: Any) {
        let btn = sender as! UISwitch
        if btn.isOn{
            ApiManager.setNotification(state: 1) { (isSuccess, data) in
                if isSuccess{
                    self.showToast("通知が有効になっています") //  setting state
                    self.initDatasource(true)
                }
            }
            
                
        }else{
            ApiManager.setNotification(state: 0) { (isSuccess, data) in
                if isSuccess{
                    self.showToast("通知が無効になっています。")// not setting state
                    self.initDatasource(false)
                }
            }
        }
    }
    
    @IBAction func gotoMain(_ sender: Any) {
        //self.gotoTabIndexController(index: 4)
        //self.dismiss(animated: false, completion: nil)
        //self.gotoTabIndex(4, badgeVal: badgeVal)
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {// delete account action
        
        self.showLoadingView(vc: self)
        ApiManager.closeAccount { (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                self.uiv_settings.isHidden = true
                thisuser!.clearUserInfo()
                self.gotoVC("LoginNav")
            }
        }
        /*self.uiv_dlgback.isHidden = true
        self.uiv_settings.isHidden = true
        thisuser?.id = 0
        thisuser?.saveUserInfo()
        self.gotoVC("LoginNav")*/
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.uiv_dlgback.isHidden = true
        self.uiv_settings.isHidden = true
    }
    
    func showPasswordAlert() {
        let loginAlert = UIAlertController(title: "パスワードを再設定する", message: "現在のパスワードを入力してください。", preferredStyle: .alert)
        loginAlert.view.tintColor = .systemBlue
        
        loginAlert.addTextField { passwordField in
            passwordField.font = .systemFont(ofSize: 14.0)
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "現在のパスワード。"
            //currentPwd = usernameField.text ?? ""
        }
        loginAlert.addTextField { passwordField in
            passwordField.font = .systemFont(ofSize: 14.0)
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "新しいパスワード。"
           // newPwd = passwordField.text ?? ""
        }
        
        loginAlert.addTextField { passwordField in
            passwordField.font = .systemFont(ofSize: 14.0)
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "新しいパスワードを確認。"
            //confirmPwd = passwordField.text ?? ""
        }
        
        let loginAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (authAction) in
                
                // Get user name value.
                let userNameTextField = loginAlert.textFields![0] as UITextField
               
                
                // Get password value.
                let passwordTextField = loginAlert.textFields![1] as UITextField
                
            
                // Get password value.
                let confirmTextField = loginAlert.textFields![2] as UITextField
                
                  
            if((userNameTextField.text!.elementsEqual("\(thisuser?.password ?? "")")) &&  !(passwordTextField.text!.elementsEqual("")) && (passwordTextField.text!.elementsEqual(confirmTextField.text! ))){
                    self.showLoadingView(vc: self)
                    ApiManager.changePwd(password: passwordTextField.text!) { (isSuccess, data) in
                        self.hideLoadingView()
                        if isSuccess{
                            print("success")
                            thisuser?.password = passwordTextField.text!
                            thisuser?.saveUserInfo()
                            thisuser?.loadUserInfo()
                            self.showToast( "パスワードは正常に変更されました。")
                        }else{
                            print("networkproblem")
                            self.showToast( "ネットワークの問題。")
                        }
                    }
                }else{
                    print("current password incorrect")
                    self.showToast("現在のパスワードと新しいパスワードを正しく入力してください。")
                }
                
                
        }

        let cancelAction = UIAlertAction(title: "取消",
                                         style: .destructive,
                                         handler: { _ in
                                            // self.handleUsernamePasswordCanceled(loginAlert: loginAlert)
                                            loginAlert.dismiss(animated: true)
                                            
        })
        

        
        loginAlert.addAction(loginAction)
        loginAlert.addAction(cancelAction)
        loginAlert.preferredAction = loginAction
        present(loginAlert, animated: true, completion: nil)
    }
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return settingDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        cell.entity = settingDatasource[indexPath.row]
        let indextValue = indexPath.row
        
        if(indextValue == 3){
            cell.switch_btn.isHidden = false
        }
        else{
            cell.switch_btn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aa = indexPath.row
        switch  aa {
        
        case 0 :// my account
            //self.gotoNavPresent("MyaccountVC", fullscreen: true)
            //self.gotoVC(VCs.MYACCOUNT)
            self.gotoNavPresent(VCs.MYACCOUNT, fullscreen: true)
            break
        case 1 : // like list
            self.gotoNavPresent(VCs.LIKEVC, fullscreen: true)
            break
        case 2 : //block list
            
            self.gotoNavPresent(VCs.BLOCKUSERVC, fullscreen: true)
            break
        case 3 :// notification
            //self.gotoNavPresent("PrivacyVC", fullscreen: true)
            break
        case 4 :// terms
            self.gotoWebViewWithProgressBar(Constants.TERMS_LINK)
            break
        case 5 :// privacy
            self.gotoWebViewWithProgressBar(Constants.PRIVACY_LINK)
            break
        case 6 :// contact us
            self.gotoNavPresent(VCs.SUPPORT, fullscreen: true)
            break
        case 7 :// password change
            self.showPasswordAlert()
            break
        case 8 :// delete account
            self.uiv_settings.isHidden = false
            self.uiv_dlgback.isHidden = false
            break
        case 9 :// logout
            UserDefault.setBool(key: PARAMS.LOGOUT, value: true)
            thisuser?.clearUserInfo()
            UserDefault.setString(key: PARAMS.PASSWORD, value: nil)
            self.gotoVC(VCs.LOGINAV)
            break
            
        default :
            print(aa)
        }
        tableView.reloadData()
    }
}

