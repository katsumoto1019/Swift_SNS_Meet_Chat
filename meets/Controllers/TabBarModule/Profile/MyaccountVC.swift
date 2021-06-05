//
//  MyaccountVC.swift
//  emoglass
//
//  Created by Mac on 7/13/20.
//  Copyright © 2020 Mac. All rights reserved.
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

class MyaccountVC: BaseVC{
    
    @IBOutlet weak var signBtnView: UIView!
    @IBOutlet weak var edtuserName: UITextField!
    @IBOutlet weak var edtage: UITextField!
    @IBOutlet weak var edtlocation: UITextField!
    //@IBOutlet weak var edtpassword: UITextField!
    //@IBOutlet weak var edtconfirmpassword: UITextField!
    @IBOutlet weak var txv_aboutme: UITextView!
    
    @IBOutlet weak var imv_avatar: UIImageView!
    @IBOutlet weak var checkBox: GDCheckbox!
    var imagePicker: ImagePicker1!
    
    var imageFils = [String]()
    
    var usertName = ""
    var userage = ""
    var userlocation = ""
    var latitude = ""
    var longitude = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editInit()
        loadLayout()
        imv_avatar.addTapGesture(tapNumber: 1, target: self, action: #selector(onEdtPhoto))
        //test()
        self.addleftButton()
        self.imagePicker = ImagePicker1(presentationController: self, delegate: self)
    }
    
    func addleftButton() {
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(gotoBack), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemBack
    }
    
    @objc func gotoBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadLayout() {
        self.title = Messages.MY_ACCOUNT
        if let userphoto = thisuser?.user_photo{
            let url = URL(string:userphoto)
            self.imv_avatar.kf.setImage(with: url,placeholder: UIImage(named: "icon_user"))
        }
        
        self.edtuserName.text = thisuser?.user_name
        self.edtage.text = thisuser?.user_birthday
        // TODO: you must change this as date picker
        self.edtlocation.text = thisuser?.user_location
        self.txv_aboutme.text = thisuser?.aboutme
    }
    
    func editInit() {
        setEdtPlaceholder(edtuserName, placeholderText:Messages.USERNAME, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtage, placeholderText: Messages.BIRTHDAY, placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtlocation, placeholderText: Messages.LOCATION, placeColor: UIColor.lightGray, padding: .left(45))
        /*setEdtPlaceholder(edtpassword, placeholderText: "新しいパスワード", placeColor: UIColor.lightGray, padding: .left(45))
        setEdtPlaceholder(edtconfirmpassword, placeholderText: "新しいパスワードを確認する", placeColor: UIColor.lightGray, padding: .left(45))*/
        txv_aboutme.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @objc func onEdtPhoto(gesture: UITapGestureRecognizer) -> Void {
        self.openProfile()
    }
    
    func openProfile() {
        //self.gotoUploadProfile(image)
        self.imagePicker.present(from: view)
    }
    
    func gotoUploadProfile(_ image: UIImage?) {
        self.imageFils.removeAll()
        if let image = image{
            imageFils.append(saveToFile(image:image,filePath:"photo",fileName:randomString(length: 2))) // Image save action
            self.imv_avatar.image = image
        }
    }
    
   /* @IBAction func signupBtnClicked(_ sender: Any) {
        usertName = self.edtuserName.text ?? ""
        email = self.edtemail.text ?? ""
        password = self.edtpassword.text ?? ""
        confirmpassword = self.edtconfirmpassword.text ?? ""
        
        if self.imageFils.count == 0{
            self.showToast("Take a photo")
            return
        }
        
        if usertName.isEmpty{
            self.showToast("Enter your User name.")
            return
        }
        
        if email.isEmpty{
            self.showToast("Enter your email.")
            return
        }
        
        if !isValidEmail(testStr: email){
            self.showToast("Invalid email")
            return
        }
        
        
        if password.isEmpty{
            self.showToast("Enter your Password.")
            return
        }
        
        if password != confirmpassword{
            self.showToast("Please Confirm Password")
            return
        }
        
        if !self.checkBox.isOn{
            self.showToast("Are you agree to the Terms & Privacy Police?")
            return
        }
        else{
            //TODO: SEND OTP ACTION
            thisuser?.id = 1
            thisuser?.saveUserInfo()
            self.gotoNavPresent("RAMAnimatedTabBarController", fullscreen: true)
        }
    }*/
    
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func gotoUpdate(_ sender: Any) {
        
        usertName = self.edtuserName.text ?? ""
        userage = self.edtage.text ?? ""
        userlocation = self.edtlocation.text ?? ""
        /*password = self.edtpassword.text ?? ""
        confirmpassword = self.edtconfirmpassword.text ?? ""*/
        
        /*if self.imageFils.count == 0{
            self.showToast("写真を撮る。")
            return
        }*/
        if usertName.isEmpty{
            self.showToast(Messages.USERNAME_REQUIRE)
            return
        }
        if userage.isEmpty{
            self.showToast(Messages.BIRTHDAY_REQUIRE)
            return
        }
        if userlocation.isEmpty{
            self.showToast(Messages.ADD_LOCATION)
            return
        }
        
        else{
            self.showLoadingView(vc: self)
            ApiManager.editProfile(username: self.usertName, picture: imageFils.first ?? "", aboutme: self.txv_aboutme.text, userlocation: self.userlocation, birthday: self.userage, lat: self.latitude, long: self.longitude) { (isSuccess, data) in
                self.hideLoadingView()
                if isSuccess{
                    if let picture = data as? String{
                        if !picture.isEmpty{
                            thisuser!.user_photo = picture
                        }
                    }
                    thisuser!.user_name = self.usertName
                    thisuser!.user_location = self.userlocation
                    thisuser!.aboutme = self.txv_aboutme.text
                    thisuser?.user_birthday = self.userage
                    thisuser!.saveUserInfo()
                    thisuser!.loadUserInfo()
                    let alertController = UIAlertController(title: nil, message: Messages.UPDATE_SUCCESS, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        //self.gotoTabIndexController(index: 0)
                        //self.gotoTabIndex(0)
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(action1)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    self.showAlerMessage(message: Messages.NETISSUE)
                }
            }
            /*self.showLoadingView(vc: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
                self.showToast(Messages.UPDATE_SUCCESS)
            }*/
        }
    }
    
    @IBAction func textFieldTapped(_ sender: Any) {
//      edtlocation.resignFirstResponder()
//      let acController = GMSAutocompleteViewController()
//      acController.delegate = self
//      present(acController, animated: true, completion: nil)
    }
    
    @IBAction func birthdayBtnClicked(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: Messages.BIRTHDAY, datePickerMode: UIDatePicker.Mode.date, selectedDate: NSDate() as Date?, doneBlock: {
            picker, value, index in
            let dateTime = "\(value ?? "")"
            self.edtage.text = String(dateTime.split(separator: " ").first!)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!.superview)
        
        datePicker?.show()
    }
}

extension MyaccountVC: ImagePickerDelegate1{
    
    func didSelect(image: UIImage?) {
        self.gotoUploadProfile(image)
    }
}

extension MyaccountVC: GMSAutocompleteViewControllerDelegate {
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


