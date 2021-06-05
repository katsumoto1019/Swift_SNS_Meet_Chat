//
//  ForgotVC.swift
//  emoglass
//
//  Created by Mac on 7/13/20.
//  Copyright © 2020 Mac. All rights reserved.
//

/*import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import GDCheckbox*/

/*class ForgotVC: BaseVC , UITextFieldDelegate{

    @IBOutlet weak var sendCaption: UILabel!
    @IBOutlet weak var sendBtn: UIView!
    
    @IBOutlet weak var edtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCaption.text = "送る"
        editInit()
        
    }
    func editInit()  {
        setEdtPlaceholder(edtEmail, placeholderText: "Eメール", placeColor: UIColor.darkGray, padding: .left(0))
       }
    override func viewWillAppear(_ animated: Bool) {
            
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        let email = self.edtEmail.text ?? ""
        if email.isEmpty{
            self.showToast("メールを入力します。")
            return
        }
        
        if !isValidEmail(testStr: email){
            self.showToast("無効な電子メールです。")
            return
        }else{
            forgotapi(useremail: edtEmail.text!)
        }
    }
    
    func forgotapi(useremail : String){
        /*showProgressSet_withMessage("  Connecting ... \n Just a moment!", msgOn: true, styleVal: 2, backColor: UIColor.init(named: "ColorBlur")!, textColor: .white, imgColor: .clear, headerColor: .red, trailColor: .yellow)
        
        ApiManager.forgot(email: useremail) { (isSuccess, data) in
            self.hideProgress()
            self.showLoginAlert()
            if isSuccess{
                //self.showMessage1(data as! String)
                
                
            }
            else{
                if data == nil{
                    self.alertDisplay(alertController: self.alertMake("Connection Error!"))
                }
                else{
                    let result_message = data as! String
                    if(result_message == "1"){
                        
                    self.alertDisplay(alertController: self.alertMake("Non Exist Email!"))
                    }
                    
                }
                
            }
            
        }*/
        self.showLoginAlert()
    }
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func showLoginAlert() {
        let loginAlert = UIAlertController(title: "パスワードを再設定する", message: "最初にピンを入力してください。", preferredStyle: .alert)
        loginAlert.view.tintColor = .systemBlue

        loginAlert.addTextField { usernameField in
            usernameField.font = .systemFont(ofSize: 14.0)
            usernameField.placeholder = "PINはこちら。"
        }
        loginAlert.addTextField { passwordField in
            passwordField.font = .systemFont(ofSize: 14.0)
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "新しいパスワード。"
        }
        
        loginAlert.addTextField { passwordField in
            passwordField.font = .systemFont(ofSize: 14.0)
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "新しいパスワードを確認。"
        }
        
        let loginAction = UIAlertAction(title: "OK",
                                        style: .default,
                                        handler: { _ in
                                            // self.handleUsernamePasswordEntered(loginAlert: loginAlert)
                                            self.navigationController?.popViewController(animated: true)
                                             loginAlert.dismiss(animated: true)
        })

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
}*/
//
//  ForgotPwdVC.swift
//  EveraveUpdate
//
//  Created by Mac on 6/29/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//
import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import FirebaseAuth
import KAPinField

class ForgotVC: BaseVC {

    @IBOutlet weak var otpCodeView: KAPinField!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_userName: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    //var verificationID = ""
    @IBOutlet weak var uiv_dlg: UIView!
    @IBOutlet weak var uiv_dlgBack: UIView!
    
    @IBOutlet weak var edt_newPwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    var pincode = ""
    var email = ""
    var username = ""
                 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStyle()
        self.setDlg()
        self.edt_email.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavBar()
        self.title = Messages.RESET_PASSWORD
        self.addleftButton()
    }
    
    func addleftButton() {
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(leftBtnClicked), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemBack
    }
    
    @objc func leftBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setDlg()  {
        self.uiv_dlgBack.isHidden = true
        self.uiv_dlg.isHidden = true
        self.edt_newPwd.text = ""
        self.confirmPwd.text = ""
    }
    
    @IBAction func gotoSend(_ sender: Any) {
        self.username = self.edt_userName.text!
        self.email = self.edt_email.text!
        if email.isEmpty{
            self.showToast("ピンコードを受け取るには、メールアドレスを入力してください。")
            return
        }
        
        if !(email.isValidEmail()){
            self.showToast("無効なメール")
            //self.progShowInfo(true, msg: "Invalid phone number")
            return
        }
        if username.isEmpty{
            self.showToast(Messages.USERNAME_REQUIRE)
            return
        }
        
        else{
            self.showLoadingView(vc: self)
            ApiManager.forgot(email: self.email, username:self.username ) { (isSuccess, data) in
                self.hideLoadingView()
                self.edt_userName.text = ""
                self.edt_email.text = ""
                if isSuccess{
                    self.pincode = data as! String
                    print(self.pincode)
                    self.refreshPinField()
                    self.sendOTP()
                }else{
                    self.showAlerMessage(message: "ユーザー名は存在しません。")// username not exist
                    //メールが存在しません。
                }
            }
        }
    }
    
    @IBAction func sendNewPwd(_ sender: Any) {
        let newPwd = self.edt_newPwd.text
        let confirmPwd = self.confirmPwd.text
        if newPwd == "" || confirmPwd == ""{
            self.showAlerMessage(message: "パスワードを入力してください。")
            return
        }
        if confirmPwd != newPwd{
            self.showAlerMessage(message: "あなたのパスワードを確認。")
            return
        }else{
            self.showLoadingView(vc: self)
            
            ApiManager.setPassword(username: self.username, password: newPwd ?? "") { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    self.uiv_dlgBack.isHidden = true
                    self.uiv_dlg.isHidden = true
                    self.edt_newPwd.text = ""
                    self.confirmPwd.text = ""
                    print("success")
                    //self.navigationController?.popViewController(animated: true)
                    //self.showAlerMessage(message: "更新に成功。")
                    let alertController = UIAlertController(title: nil, message:"更新に成功。", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(action1)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    print("network problem.")
                    self.showAlerMessage(message: "ネットワークの問題。")
                    self.uiv_dlgBack.isHidden = true
                    self.uiv_dlg.isHidden = true
                    self.edt_newPwd.text = ""
                    self.confirmPwd.text = ""
                }
            }
        }
    }
    
    @IBAction func cancelPwd(_ sender: Any) {
        self.uiv_dlgBack.isHidden = true
        self.uiv_dlg.isHidden = true
        self.edt_newPwd.text = ""
        self.confirmPwd.text = ""
    }
    
    @IBAction func backtoLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendOTP()  {
        if self.btn_submit.currentTitle == "送る"{
            print("input pincode.")
            self.otpCodeView.becomeFirstResponder()
            self.showAlerMessage(message: "PINコードを入力してください。")
            //self.showAlerMessage(message: "Please input your verification code.")
            self.btn_submit.setTitle("再送", for: .normal)
            self.dismissKeyboard()
            
        }else{
            refreshPinField()
            self.email = self.edt_email.text!
            if !(email.isValidEmail()){
                self.showToast("無効なメール")
                //self.progShowInfo(true, msg: "Invalid phone number")
                return
            }
            
            else if self.email != ""{
                /*self.showLoadingView(vc: self)
                ApiManager.forgot(email: email) { (isSuccess, data) in
                    self.hideLoadingView()
                    self.edt_email.text = ""
                    if isSuccess{
                        self.pincode = data as! String
                        self.sendOTP()
                    }else{
                        self.showAlerMessage(message: "メールが存在しません。")
                        //メールが存在しません。
                    }
                }*/
            }
            self.dismissKeyboard()
        }
    }
    
    func setStyle() {
        otpCodeView.properties.delegate = self
//        otpCodeView.properties.token = "-"
        otpCodeView.properties.animateFocus = true
        otpCodeView.text = ""
        otpCodeView.keyboardType = .numberPad
        otpCodeView.properties.numberOfCharacters = 6
        otpCodeView.appearance.tokenColor = UIColor.black.withAlphaComponent(0.2)
        otpCodeView.appearance.tokenFocusColor = UIColor.black.withAlphaComponent(0.2)
        otpCodeView.appearance.textColor = UIColor.black
        otpCodeView.appearance.font = .menlo(40)
        otpCodeView.appearance.kerning = 24
        otpCodeView.appearance.backOffset = 5
        otpCodeView.appearance.backColor = UIColor.clear
        otpCodeView.appearance.backBorderWidth = 1
        otpCodeView.appearance.backBorderColor = UIColor.black.withAlphaComponent(0.2)
        otpCodeView.appearance.backCornerRadius = 4
        otpCodeView.appearance.backFocusColor = UIColor.clear
        otpCodeView.appearance.backBorderFocusColor = UIColor.black.withAlphaComponent(0.8)
        otpCodeView.appearance.backActiveColor = UIColor.clear
        otpCodeView.appearance.backBorderActiveColor = UIColor.black
        otpCodeView.appearance.backRounded = false
        
    }
    
     func refreshPinField() {
        otpCodeView.text = ""
        setStyle()
    }
}

extension ForgotVC : KAPinFieldDelegate {
    
    func pinField(_ field: KAPinField, didChangeTo string: String, isValid: Bool) {
        if isValid {
            print("Valid input: \(string) ")
        } else {
            print("Invalid input: \(string) ")
            self.otpCodeView.animateFailure()
        }
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        
        print("didFinishWith : \(code)")
        
        if self.pincode == code{
            field.animateSuccess(with: "👍") {
                print("OK")
                self.uiv_dlg.isHidden = false
                self.uiv_dlgBack.isHidden = false
            }
        }else{
            self.showAlerMessage(message: "PINコードが正しくありません。")
            field.animateFailure()
            self.otpCodeView.becomeFirstResponder()
            return
        }
    }
}

