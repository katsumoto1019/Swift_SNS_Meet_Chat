//
//  SignUpVC.swift
//  EveraveUpdate
//
//  Created by Mac on 5/9/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//


import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import SwiftyUserDefaults
import Photos
import GDCheckbox
import ActionSheetPicker_3_0
import GooglePlaces

class SignUpVC: BaseVC {
    
    @IBOutlet weak var signBtnView: UIView!
    @IBOutlet weak var edtusername: UITextField!
    @IBOutlet weak var edtlocation: UITextField!
    @IBOutlet weak var edtbirthday: UITextField!
    @IBOutlet weak var edtpassword: UITextField!
    @IBOutlet weak var edtconfirmpassword: UITextField!
    @IBOutlet weak var imv_avatar: UIImageView!
    @IBOutlet weak var checkBox: GDCheckbox!
    @IBOutlet weak var txv_aboutme: UITextView!
    @IBOutlet weak var cus_gender: MSDropDown!
    @IBOutlet weak var cus_kinkRole: MSDropDown!
    @IBOutlet weak var cus_lookingfor: MSDropDown!
    @IBOutlet weak var uiv_dialog: UIView!
    @IBOutlet weak var uiv_dlg_back: UIView!
    @IBOutlet weak var lbl_content: UILabel!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var imageFils = [String]()
    var usertName = ""
    var userLocation = ""
    var userBirthday = ""
    var password = ""
    var confirmpassword = ""
    var aboutme = ""
    var user_gender: String?
    var latitude = ""
    var longitude = ""
    var purpose: String?
    var attribute: String?
    var imagePicker: ImagePicker1!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Messages.SIGNUP
        showNavBar()
        self.addleftButton()
        self.setConfirmDlg(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editInit()
        //loadLayout()
        imv_avatar.addTapGesture(tapNumber: 1, target: self, action: #selector(onEdtPhoto))
        //test()
        self.imagePicker = ImagePicker1(presentationController: self, delegate: self)
        self.setUpDropDownFilter()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.uiv_dlg_back.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.setConfirmDlg(false)
    }
    
    func setUpDropDownFilter() {
        self.cus_gender.keyvalueCount = self.gender_Options.count
        self.cus_gender.delegate = self
        self.cus_gender.keyValues = self.gender_Options
        self.cus_gender.isMultiSelect = false
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
    
    func setConfirmDlg(_ show: Bool) {
        if show{
            self.uiv_dlg_back.isHidden = false
            self.uiv_dialog.isHidden = false
            self.lbl_content.text = "1.局部等の卑猥な画像のアップロード \n2.他サービスへの勧誘行為 \n3.援交やギフトカード詐欺 \n4.他社サービスのIDを公開・収集行為 \n\n上記に当てはまる行為を行った場合, アカ ウントを永久凍結し, 個人を特定できる情 報（IP情報,ログ 記録、キャリア情報等） を警察に提供 ・迷惑行為で通報します。\n\n管理は人の目で行いますので, 隠語やほの めかす発言も全て通報します。迷惑行為を運営は絶対に許しません。\n\n安心安全なサービス作りに ご協力ください。"
        }else{
            self.uiv_dlg_back.isHidden = true
            self.uiv_dialog.isHidden = true
        }
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
    
    func loadLayout() {
//        self.edtrealName.text = "tester"
//        self.edtuserName.text = "tester"
//        self.edtemail.text = "tester@gmail.com"
//        self.edtpassword.text = "123"
//        self.edtconfirmpassword.text = "123"
    }
    
    func editInit() {
        setEdtPlaceholder(edtusername, placeholderText: Messages.USERNAME, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtlocation, placeholderText: Messages.LOCATION, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtbirthday, placeholderText: Messages.BIRTHDAY, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtpassword, placeholderText: Messages.PASSWORD, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtconfirmpassword, placeholderText: Messages.CONFIRM_PASSWORD, placeColor: UIColor.lightGray, padding: .left(45))
        txv_aboutme.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @objc func onEdtPhoto(gesture: UITapGestureRecognizer) -> Void {
        self.imagePicker.present(from: view)
    }
    
    func gotoUploadProfile(_ image: UIImage?) {
        self.imageFils.removeAll()
        if let image = image{
            imageFils.append(saveToFile(image:image,filePath:"photo",fileName:randomString(length: 2))) // Image save action
            self.imv_avatar.image = image
        }
    }
    
    @IBAction func gotoTerms(_ sender: Any) {
        self.gotoWebViewWithProgressBar(Constants.TERMS_LINK)
    }
    @IBAction func gotoPrivacy(_ sender: Any) {
        self.gotoWebViewWithProgressBar(Constants.PRIVACY_LINK)
    }
    
    
    @IBAction func signupBtnClicked(_ sender: Any) {
        usertName = self.edtusername.text ?? ""
        userLocation = self.edtlocation.text ?? ""
        userBirthday = self.edtbirthday.text ?? ""
        password = self.edtpassword.text ?? ""
        confirmpassword = self.edtconfirmpassword.text ?? ""
        aboutme = self.txv_aboutme.text
        if self.imageFils.count == 0{
            self.mainScrollView.setContentOffset(CGPoint.init(x: 0.0, y: -60.0), animated: true)
            self.showToast(Messages.ADD_PHOTO)
            return
        }
        if usertName.isEmpty{
            self.showToast(Messages.USERNAME_REQUIRE)
            return
        }
        if userLocation.isEmpty{
            self.showToast(Messages.ADD_LOCATION)
            return
        }        
        if userBirthday.isEmpty{
            self.showToast(Messages.BIRTHDAY_REQUIRE)
            return
        }
        if password.isEmpty{
            self.showToast(Messages.PASSWORD_REQUIRE)
            return
        }
        if password != confirmpassword{
            self.showToast(Messages.CONFIRM_PASSWORD_MATCH)
            return
        }
        if !self.checkBox.isOn{
            self.showToast(Messages.TERMS_AGREE)
            return
        }else{
            if self.user_gender!.isEmpty{
                self.user_gender = "フェム"
            }
            if self.purpose!.isEmpty{
                self.purpose = "恋人募集"
            }
            if self.attribute!.isEmpty{
                self.attribute = "タチ"
            }
            self.setConfirmDlg(true)
        }
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func birthdayBtnClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: Messages.BIRTHDAY, datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            let dateTime = "\(value ?? "")"
            self.edtbirthday.text = String(dateTime.split(separator: " ").first!)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func clickConfirm(_ sender: Any) {
        self.showLoadingView(vc: self)
        ApiManager.signup(username: usertName, password: password, picture: imageFils.first ?? "", aboutme: aboutme, userlocation: userLocation, birthday: userBirthday, user_gender: self.user_gender ?? "フェム", latitude: self.latitude, longitude: self.longitude, purpose: self.purpose ?? "恋人募集", attribute: self.attribute ?? "タチ"){ (isSuccess, data) in
            self.hideLoadingView()
            if isSuccess{
                let dict = JSON (data as Any)
                let id = dict["id"].intValue
                let picture = dict["picture"].stringValue
                thisuser!.clearUserInfo()
                thisuser!.id = id
                thisuser!.user_photo = picture
                thisuser!.user_name = self.usertName
                thisuser!.user_location = self.userLocation
                thisuser!.user_birthday = self.userBirthday
                thisuser!.password = self.password
                thisuser!.likeNumber = 0
                thisuser!.aboutme = self.aboutme
                thisuser!.saveUserInfo()
                thisuser!.loadUserInfo()
                dump(thisuser, name: "userinfo =========>")
                //self.gotoNavPresent("RAMAnimatedTabBarController", fullscreen: true)
                self.gotoTabControllerWithIndex(0)
            }else{
                if let data = data{
                    let statue = data  as! Int
                    if statue == 201{
                        self.showAlerMessage(message: Messages.USERNAME_EXIST)
                    }else if statue == 202{
                        self.showAlerMessage(message: Messages.IMAGE_UPLOAD_FAIL)
                    }else {
                        self.showAlerMessage(message: Messages.NETISSUE)
                    }
                }else{
                    self.showAlerMessage(message: Messages.NETISSUE)
                }
            }
        }
    }
    
    @IBAction func textFieldTapped(_ sender: Any) {
      edtlocation.resignFirstResponder()
      let acController = GMSAutocompleteViewController()
      acController.delegate = self
      present(acController, animated: true, completion: nil)
    }
}

extension SignUpVC: ImagePickerDelegate1{
    
    func didSelect(image: UIImage?) {
        self.gotoUploadProfile(image)
    }
}

extension SignUpVC: MSDropDownDelegate{
    func dropdownSelected(tagId: Int, answer: String, value: String, isSelected: Bool) {
        switch tagId {
        case searchDropDownTag.gender.rawValue:
            self.user_gender = answer
            print(user_gender as Any)
            break
        case searchDropDownTag.kinkRole.rawValue:
            self.attribute = answer.replacingOccurrences(of: "|", with: ",")
            print(attribute as Any)
            break
        case searchDropDownTag.lookingfor.rawValue:
            self.purpose = answer.replacingOccurrences(of: "|", with: ",")
            print(purpose as Any)
            break
        default:
            print("default")
        }
    }
}

extension SignUpVC: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Get the place name from 'GMSAutocompleteViewController'
    // Then display the name in textField
    edtlocation.text = place.name
    self.longitude = "\(place.coordinate.longitude)"
    self.latitude = "\(place.coordinate.latitude)"
    // Dismiss the GMSAutocompleteViewController when something is selected
    dismiss(animated: true, completion: nil)
  }
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // Handle the error
    print("Error: ", error.localizedDescription)
  }
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    // Dismiss when the user canceled the action
    dismiss(animated: true, completion: nil)
  }
}



