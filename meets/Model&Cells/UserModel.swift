//
//  UserModel.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 1/18/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel: NSObject {
    
    var id : Int!
    var user_name : String?
    var user_photo : String?
    var likeNumber: Int!
    var aboutme : String?
    var user_location : String?
    var user_birthday : String?
    var password : String?
    
    override init() {
       super.init()
        id = 1
        user_name = ""
        user_photo = ""
        likeNumber = 0 // noti off
        aboutme = ""
        user_location = ""
        user_birthday = ""
        password = ""
    }
    
    init(id: Int, username: String, userphoto: String){
        self.id = id
        self.user_name = username
        self.user_photo = userphoto
    }
    
    init(id: Int, username: String, userphoto: String, likeNumber: Int,aboutme: String, user_location: String, user_birthday: String, password: String){
        self.id = id
        self.user_name = username
        self.user_photo = userphoto
        self.likeNumber = likeNumber
        self.aboutme = aboutme
        self.user_location = user_location
        self.user_birthday = user_birthday
        self.password = password
    }
    
    init(_ json : JSON) {
        self.id = json[PARAMS.USER_ID].intValue
        self.user_name = json[PARAMS.USERNAME].stringValue
        self.user_photo = json[PARAMS.PICTURE].stringValue
        self.likeNumber = json[PARAMS.FOLLOWER].intValue
        self.aboutme = json[PARAMS.ABOUT_ME].stringValue
        self.user_location = json[PARAMS.USER_LOCATION].stringValue
        self.user_birthday = json[PARAMS.USER_BIRTHDAY].stringValue
        self.password = UserDefault.getString(key: PARAMS.PASSWORD,defaultValue: "")
    }
    // Check and returns if user is valid user or not
   var isValid: Bool {
       return id != nil && id != 0
   }
    
    // Recover user credential from UserDefault
    func loadUserInfo() {
       
        id = UserDefault.getInt(key: PARAMS.ID, defaultValue: 0)
        user_name = UserDefault.getString(key: PARAMS.USERNAME, defaultValue: "")
        aboutme = UserDefault.getString(key: PARAMS.ABOUT_ME, defaultValue: "")
        user_photo = UserDefault.getString(key: PARAMS.PICTURE, defaultValue: "")
        likeNumber = UserDefault.getInt(key: PARAMS.FOLLOWER, defaultValue: 0)
        user_location = UserDefault.getString(key: PARAMS.USER_LOCATION, defaultValue: "")
        user_birthday = UserDefault.getString(key: PARAMS.USER_BIRTHDAY, defaultValue: "")
        password = UserDefault.getString(key: PARAMS.PASSWORD, defaultValue: "")
    }
    // Save user credential to UserDefault
    func saveUserInfo() {
        UserDefault.setInt(key: PARAMS.ID, value: id)
        UserDefault.setString(key: PARAMS.USERNAME, value: user_name)
        UserDefault.setString(key: PARAMS.ABOUT_ME, value: aboutme)
        UserDefault.setString(key: PARAMS.PICTURE, value: user_photo)
        UserDefault.setInt(key: PARAMS.FOLLOWER, value: likeNumber)
        UserDefault.setString(key: PARAMS.USER_LOCATION, value: user_location)
        UserDefault.setString(key: PARAMS.USER_BIRTHDAY, value: user_birthday)
        UserDefault.setString(key: PARAMS.PASSWORD, value: password)
    }
    // Clear save user credential
    func clearUserInfo() {
        
        id = 0
        user_name = ""
        user_photo = ""
        aboutme = ""
        likeNumber = 0
        user_birthday = ""
        user_location = ""
        //password = ""
        
        UserDefault.setInt(key: PARAMS.ID, value: 0)
        UserDefault.setString(key: PARAMS.USERNAME, value: nil)
        UserDefault.setString(key: PARAMS.ABOUT_ME, value: nil)
        UserDefault.setString(key: PARAMS.PICTURE, value: nil)
        UserDefault.setInt(key: PARAMS.FOLLOWER, value: 0)
        UserDefault.setString(key: PARAMS.USER_LOCATION, value: nil)
        UserDefault.setString(key: PARAMS.USER_BIRTHDAY, value: nil)
        //UserDefault.setString(key: PARAMS.PASSWORD, value: nil)
    }
    
    func updateUserInfo(user: UserModel) {
        id = user.id
        user_name = user.user_name
        user_photo = user.user_photo
        aboutme = user.aboutme
        likeNumber = user.likeNumber
        user_birthday = user.user_birthday
        user_location = user.user_location
        password = user.password
    }
}

