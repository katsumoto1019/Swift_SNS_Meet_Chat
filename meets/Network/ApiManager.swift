//
//  ApiManager.swift
//  Everave Update
//
//  Created by Ubuntu on 16/01/2020
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
// ************************************************************************//
                            // meets project //
// ************************************************************************//

let SERVER_URL = "http://52.69.71.93/meet_app/api/"
//let SERVER_URL = "http://localhost/meet_app/api/"

let SUCCESSTRUE = 200   
//let ALREADY_EXIST = 202
//let INVALIDLOGIN = 201
//let ALEADY_SENT = 204
let SIGNUP = SERVER_URL + "signup"
let SIGNIN = SERVER_URL + "signin"
let EDITPROFILE = SERVER_URL + "editProfile"
let FORGOT = SERVER_URL + "forgot"
let SETPASSWORD = SERVER_URL + "reset_password"  // forgot reset password
let CHANGEPASSWORD = SERVER_URL + "change_password"
let GETTOTALPOST = SERVER_URL + "getTotalPost"
let GETTOTALUSERS = SERVER_URL + "getTotalUsers"
let GETOTHERUSERPROFILE = SERVER_URL + "getOtherUserProfile"
let GETMYPOST = SERVER_URL + "getMyPost"
let GETOTHERUSERPOST = SERVER_URL + "getOtherUserPost"
let LIKE = SERVER_URL + "like"
let UNLIKE = SERVER_URL + "unlike"
let FOLLOW = SERVER_URL + "follow"
let UNFOLLOW = SERVER_URL + "unfollow"
let GETCOMMENTS = SERVER_URL + "getComments"
let COMMENT = SERVER_URL + "comment"
let SETNOTIFICATION = SERVER_URL + "setNotification"
let GETNOTIFICATION = SERVER_URL + "getNotification"
let GETLIKERS = SERVER_URL + "getLikers"
let SETBLOCKUSER = SERVER_URL + "setBlockUser"
let REMOVEBLOCKUSER = SERVER_URL + "removeBlockUser"
let UPLOADPOST = SERVER_URL + "uploadPost"
let GETNOTYS = SERVER_URL + "getNotys"
let GETFOLLOWER = SERVER_URL + "getFollower"
let GETFOLLOWING = SERVER_URL + "getFollowing"
let DELETEPOST = SERVER_URL + "deletePost"
let CLOSEACCOUNT = SERVER_URL + "closeAccount"
let SETNOTIREAD = SERVER_URL + "setNotiRead"
let GETBLOCKUSERS = SERVER_URL + "getBlockUsers"
let FILTERUSERS = SERVER_URL + "filterusers"

struct PARAMS {
    static let ABOUT_ME        = "about_me"
    static let FOLLOWER        = "follower"
    static let FOLLOWER_NUMBER = "follower_number"
    static let ID              = "id"
    static let LOGOUT          = "logout"
    static let MESSAGE_LIMIT   = "message_limit"
    static let OWNER_ID        = "owner_id"
    static let PASSWORD        = "password"
    static let PICTURE         = "picture"
    static let PIN_CODE        = "pin_code"
    static let POST_CONTENT    = "post_content"
    static let POST_ID         = "post_id"
    static let PROFILE_LIMIT   = "profile_limit"
    static let RESULTCODE      = "result_code"
    static let STATE           = "state"
    static let TOKEN           = "token"
    static let TO_SEND         = "to_send"
    static let USERNAME        = "username"
    static let USER_BIRTHDAY   = "user_birthday"
    static let USER_ID         = "user_id"
    static let USER_INFO       = "user_info"
    static let USER_LOCATION   = "user_location"
    static let USER_NAME       = "user_name"
    static let USER_PHOTO      = "user_photo"
}



class ApiManager {

    class func login(username : String,password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {

        let params = [PARAMS.USERNAME : username, PARAMS.PASSWORD: password,PARAMS.TOKEN: deviceTokenString ] as [String : Any]

        Alamofire.request(SIGNIN, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)

                //print("userinformation =====> ",dict)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                let user_data = dict[PARAMS.USER_INFO].object
                let userdata = JSON(user_data)
                
                if status == SUCCESSTRUE {
                    completion(true, userdata)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func signup(username : String,password: String,picture: String,aboutme: String,userlocation: String, birthday: String, user_gender: String, latitude: String, longitude: String, purpose: String,attribute: String,completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let requestURL = SIGNUP
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if !picture.isEmpty{
                    multipartFormData.append(URL(fileURLWithPath: picture), withName: PARAMS.PICTURE)
                }
                multipartFormData.append( username.data(using:.utf8)!, withName: PARAMS.USERNAME)
                multipartFormData.append( password.data(using:.utf8)!, withName: PARAMS.PASSWORD)
                multipartFormData.append( aboutme.data(using:.utf8)!, withName: PARAMS.ABOUT_ME)
                multipartFormData.append( userlocation.data(using:.utf8)!, withName: PARAMS.USER_LOCATION)
                multipartFormData.append( birthday.data(using:.utf8)!, withName: PARAMS.USER_BIRTHDAY)
                multipartFormData.append( deviceTokenString.data(using:.utf8)!, withName: PARAMS.TOKEN)
                multipartFormData.append( latitude.data(using:.utf8)!, withName: "latitude")
                multipartFormData.append( longitude.data(using:.utf8)!, withName: "longitude")
//                var _gender = ""
//                var _attribute = ""
//                var  _purpose = ""
//                if user_gender.isEmpty{
//                    _gender = "フェム"
//                }
                //print("this is _gender",_gender)
                multipartFormData.append( user_gender.data(using:.utf8)!, withName: "user_gender")
                
//                if attribute.isEmpty{
//                    _attribute = "タチ"
//                }
                //print("this is _attribut",_attribute)
                multipartFormData.append( attribute.data(using:.utf8)!, withName: "attribute")
                
//                if purpose.isEmpty{
//                    _purpose = "恋人募集"
//                }
                //print("this is _purpose",_purpose)
                multipartFormData.append( purpose.data(using:.utf8)!, withName: "purpose")
                print("\(username) \n \(password) \n \(picture)\n \(deviceTokenString) \(aboutme)\n \(userlocation)\n \(birthday)\n \(latitude)\n \(longitude) \n \(user_gender) \n \(purpose) \n \(attribute)")
            },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                            case .failure: completion(false, nil)
                            case .success(let data):
                            let dict = JSON(data)
                            let status = dict[PARAMS.RESULTCODE].intValue

                            if status == SUCCESSTRUE {
                                completion(true, dict)
                            } else if(status == 201)  {// email exist
                                completion(false, status)
                            } else if(status == 202)  {// pictuer upload fail
                                completion(false, status)
                            } else{
                                completion(false, status)
                            }
                        }
                    }
                    case .failure( _):
                    completion(false, nil)
                }
            }
        )
    }
    
    class func editProfile( username : String,picture: String,aboutme: String,userlocation: String, birthday: String,lat: String, long: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let requestURL = EDITPROFILE
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if !picture.isEmpty{
                    multipartFormData.append(URL(fileURLWithPath: picture), withName: PARAMS.PICTURE)
                }
                multipartFormData.append( "\(thisuser!.id ?? 0)".data(using:.utf8)!, withName: PARAMS.USER_ID)
                multipartFormData.append( username.data(using:.utf8)!, withName: PARAMS.USERNAME)
                
                multipartFormData.append( aboutme.data(using:.utf8)!, withName: PARAMS.ABOUT_ME)
                multipartFormData.append( userlocation.data(using:.utf8)!, withName: PARAMS.USER_LOCATION)
                multipartFormData.append( birthday.data(using:.utf8)!, withName: PARAMS.USER_BIRTHDAY)
                
                multipartFormData.append( lat.data(using:.utf8)!, withName:"latitude")
                multipartFormData.append( long.data(using:.utf8)!, withName:"longitude")
            },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                            case .failure: completion(false, nil)
                            case .success(let data):
                            let dict = JSON(data)
                            let status = dict[PARAMS.RESULTCODE].intValue
                            let picture = dict[PARAMS.PICTURE].stringValue

                            if status == SUCCESSTRUE {
                                completion(true, picture)
                            } else if(status == 201)  {// file uploadfail
                                completion(false, status)
                            } else{
                                completion(false, status)
                            }
                        }
                    }
                    case .failure( _):
                    completion(false, nil)
                }
            }
        )
    }
    
    class func forgot(email: String, username: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USERNAME: username, "email": email] as [String : Any]
        Alamofire.request(FORGOT, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                //print("sellers =====> ",dict)
                let status = dict[PARAMS.RESULTCODE].intValue// 0,1,2
                let pin_code = dict[PARAMS.PIN_CODE].stringValue// 0,1,2
                if status == SUCCESSTRUE {
                    completion(true,pin_code)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func filterUsers(gender: String,attr: String,purpose: String,age: String,nearby: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["user_id": "\(thisuser!.id ?? 0)", "gender": gender, "attr":attr, "purpose":purpose, "age": age, "nearby": nearby] as [String : Any]
        Alamofire.request(FILTERUSERS, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                //print("sellers =====> ",dict)
                let status = dict[PARAMS.RESULTCODE].intValue// 0,1,2
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func setPassword(username: String,password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USERNAME: username, PARAMS.PASSWORD: password] as [String : Any]
        Alamofire.request(SETPASSWORD, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                //print("sellers =====> ",dict)
                let status = dict[PARAMS.RESULTCODE].intValue// 0,1,2
                if status == SUCCESSTRUE {
                    completion(true,status)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func changePwd(password: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_ID: "\(thisuser!.id ?? 0)", PARAMS.PASSWORD: password] as [String : Any]
        Alamofire.request(CHANGEPASSWORD, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                //print("sellers =====> ",dict)
                let status = dict[PARAMS.RESULTCODE].intValue// 0,1,2
                if status == SUCCESSTRUE {
                    completion(true,status)
                } else {
                    completion(false, status)
                }
            }
        }
    }

    class func getTotalPost( completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        if thisuser!.isValid{
            let params = [PARAMS.USER_ID: "\(thisuser!.id ?? 0)"] as [String : Any]
            Alamofire.request(GETTOTALPOST, method:.post,parameters: params)
            .responseJSON { response in
                switch response.result {
                    case .failure:
                    completion(false, nil)
                    case .success(let data):
                    let dict = JSON(data)
                    let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                    //let seller_infoJSON = JSON(seller_info as Any)
                    if status == SUCCESSTRUE {
                        completion(true,dict)
                    } else {
                        completion(false, status)
                    }
                }
            }
        }else{
            Alamofire.request(GETTOTALPOST, method:.post)
            .responseJSON { response in
                switch response.result {
                    case .failure:
                    completion(false, nil)
                    case .success(let data):
                    let dict = JSON(data)
                    let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                    //let seller_infoJSON = JSON(seller_info as Any)
                    if status == SUCCESSTRUE {
                        completion(true,dict)
                    } else {
                        completion(false, status)
                    }
                }
            }
        }
    }
    
    class func getTotalUsers( completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        if thisuser!.isValid{
            let params = [PARAMS.USER_ID: "\(thisuser!.id ?? 0)"] as [String : Any]
            Alamofire.request(GETTOTALUSERS, method:.post,parameters: params)
            .responseJSON { response in
                switch response.result {
                    case .failure:
                    completion(false, nil)
                    case .success(let data):
                    let dict = JSON(data)
                    let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                    //let seller_infoJSON = JSON(seller_info as Any)
                    if status == SUCCESSTRUE {
                        completion(true,dict)
                    } else {
                        completion(false, status)
                    }
                }
            }
        }else{
            Alamofire.request(GETTOTALUSERS, method:.post)
            .responseJSON { response in
                switch response.result {
                    case .failure:
                    completion(false, nil)
                    case .success(let data):
                    let dict = JSON(data)
                    let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                    //let seller_infoJSON = JSON(seller_info as Any)
                    if status == SUCCESSTRUE {
                        completion(true,dict)
                    } else {
                        completion(false, status)
                    }
                }
            }
        }
    }
    
    class func getOtherUserProfile( owner_id: String,  completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_ID: "\(thisuser!.id ?? 0)", PARAMS.OWNER_ID: owner_id] as [String : Any]
        Alamofire.request(GETOTHERUSERPROFILE, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    /*class func getMyPost( userid: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["user_id" : userid ] as [String : Any]
        Alamofire.request(GETMYPOST, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func getOtherUserPost( otherUserId: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["me_id":"\(thisuser?.id ?? 0)","user_id" : otherUserId ] as [String : Any]
        Alamofire.request(GETOTHERUSERPOST, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }*/
    
    class func follow( owner_id : Int ,completion :  @escaping (_ success: Bool, _ response : Any?) -> ()){
        let params = [PARAMS.OWNER_ID: owner_id, PARAMS.USER_ID: "\(thisuser?.id ?? 0)", PARAMS.USER_NAME : thisuser?.user_name ?? "",PARAMS.USER_PHOTO: thisuser?.user_photo ?? ""] as [String : Any]
        
        Alamofire.request(FOLLOW, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func unfollow( owner_id : Int ,completion :  @escaping (_ success: Bool, _ response : Any?) -> ()){
        let params = [PARAMS.OWNER_ID: owner_id,PARAMS.USER_ID: "\(thisuser?.id ?? 0)",PARAMS.USER_NAME : thisuser?.user_name ?? "",PARAMS.USER_PHOTO: thisuser?.user_photo ?? ""] as [String : Any]
        Alamofire.request(UNFOLLOW, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func setNotification(state: Int, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {// if state 1, notification is set:(default state is 1) if 0, notification is off
        let params = [PARAMS.USER_ID: "\(thisuser?.id ?? 0)" , PARAMS.STATE:state ] as [String : Any]
        Alamofire.request(SETNOTIFICATION, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func getNotification( completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["user_id" : "\(thisuser?.id ?? 0)"] as [String : Any]
        Alamofire.request(GETNOTIFICATION, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                let state = dict[PARAMS.STATE].intValue
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,state)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    
    class func uploadPost( post_content : String,to_send: String?, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let requestURL = UPLOADPOST
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append( "\(thisuser!.id ?? 0)".data(using:.utf8)!, withName: PARAMS.USER_ID)
                multipartFormData.append( thisuser!.user_name!.data(using:.utf8)!, withName: PARAMS.USER_NAME)
                multipartFormData.append( thisuser!.user_photo!.data(using:.utf8)!, withName: PARAMS.USER_PHOTO)
                multipartFormData.append( post_content.data(using:.utf8)!, withName: PARAMS.POST_CONTENT)
                multipartFormData.append( thisuser!.user_location!.data(using:.utf8)!, withName: PARAMS.USER_LOCATION)
                multipartFormData.append( thisuser!.user_birthday!.data(using:.utf8)!, withName: PARAMS.USER_BIRTHDAY)
                
                if let to_send = to_send{
                    multipartFormData.append( to_send.data(using:.utf8)!, withName: PARAMS.TO_SEND)
                }else{
                    multipartFormData.append( "".data(using:.utf8)!, withName: PARAMS.TO_SEND)
                }
                multipartFormData.append( "\(thisuser!.likeNumber!)".data(using:.utf8)!, withName: PARAMS.FOLLOWER_NUMBER)
                multipartFormData.append( thisuser!.aboutme!.data(using:.utf8)!, withName: PARAMS.ABOUT_ME)
                
            },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                            case .failure: completion(false, nil)
                            case .success(let data):
                            let dict = JSON(data)
                            let status = dict[PARAMS.RESULTCODE].intValue
                            let picture = dict[PARAMS.PICTURE].stringValue

                            if status == SUCCESSTRUE {
                                completion(true, picture)
                            } else if(status == 201)  {// file uploadfail
                                completion(false, status)
                            } else{
                                completion(false, status)
                            }
                        }
                    }
                    case .failure( _):
                    completion(false, nil)
                }
            }
        )
    }
    
    class func getNotys( completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.OWNER_ID: "\(thisuser?.id ?? 0)"] as [String : Any]
        Alamofire.request(GETNOTYS, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    /*class func getFollower(owner_id: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["owner_id" : owner_id ] as [String : Any]
        Alamofire.request(GETFOLLOWER, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func getFollowing(user_id: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["user_id" : user_id ] as [String : Any]
        Alamofire.request(GETFOLLOWING, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }*/
    
    class func deletePost(post_id: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.POST_ID: post_id ] as [String : Any]
        Alamofire.request(DELETEPOST, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func closeAccount(completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_ID: "\(thisuser?.id ?? 0)" ] as [String : Any]
        Alamofire.request(CLOSEACCOUNT, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func setNotiRead(completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.OWNER_ID: "\(thisuser?.id ?? 0)" ] as [String : Any]
        Alamofire.request(SETNOTIREAD, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue // 0,1,2
                //let seller_infoJSON = JSON(seller_info as Any)
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func getLikers( completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.USER_ID: "\(thisuser?.id ?? 0)"] as [String : Any]
        Alamofire.request(GETLIKERS, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func setBlockUser( user_id: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["block_user_id": user_id, PARAMS.OWNER_ID: "\(thisuser?.id ?? 0)"] as [String : Any]
        Alamofire.request(SETBLOCKUSER, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func removeBlockUser( user_id: String, completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = ["block_user_id": user_id, PARAMS.OWNER_ID: "\(thisuser?.id ?? 0)"] as [String : Any]
        Alamofire.request(REMOVEBLOCKUSER, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
    
    class func getBlockUsers( completion :  @escaping (_ success: Bool, _ response : Any?) -> ()) {
        let params = [PARAMS.OWNER_ID: "\(thisuser?.id ?? 0)"] as [String : Any]
        Alamofire.request(GETBLOCKUSERS, method:.post, parameters:params)
        .responseJSON { response in
            switch response.result {
                case .failure:
                completion(false, nil)
                case .success(let data):
                let dict = JSON(data)
                let status = dict[PARAMS.RESULTCODE].intValue
                if status == SUCCESSTRUE {
                    completion(true,dict)
                } else {
                    completion(false, status)
                }
            }
        }
    }
}

