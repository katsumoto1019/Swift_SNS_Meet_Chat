//
//  MessageSendVC.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/26/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import Firebase
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Photos
import ISEmojiView
import SwiftyGif
import Kingfisher

class MessageSendVC: BaseVC {
    
    //@IBOutlet weak var edt_msgSend: UITextField!
    @IBOutlet weak var edt_msgSend: UITextView!
    @IBOutlet weak var tbl_Chat: UITableView!
    @IBOutlet weak var uiv_postView: UIView!
    @IBOutlet weak var imv_Post: UIImageView!
    //@IBOutlet weak var cons_w_uivWarning: NSLayoutConstraint!
    //@IBOutlet weak var cons_w_lblPlus: NSLayoutConstraint!
    
    @IBOutlet weak var uiv_totalAttach: UIView!
    /*@IBOutlet weak var uiv_warning: UIView!
    @IBOutlet weak var uiv_attach: UIView!
    @IBOutlet weak var uiv_gift: UIView!
    @IBOutlet weak var uiv_gif: UIView!
    @IBOutlet weak var uiv_emoji: UIView!
    @IBOutlet weak var uiv_phoneCall: UIView!
    @IBOutlet weak var uiv_videoCamera: UIView!
    @IBOutlet weak var uiv_verifyCheck: UIView!
    @IBOutlet weak var uiv_eye: UIView!*/
    
    @IBOutlet weak var cons_btm_edtmsgSend: NSLayoutConstraint!
    @IBOutlet weak var cons_btm_attachedView: NSLayoutConstraint!
    @IBOutlet private weak var emojiView: EmojiView! {
        didSet {
            emojiView.delegate = self
        }
    }
    
    @IBOutlet weak var uiv_msgSend: UIView!
    @IBOutlet weak var uiv_emojiBack: UIView!
    @IBOutlet weak var lbl_ueserProfileContent: UILabel!
    //@IBOutlet weak var cons_edtMessageSend: NSLayoutConstraint!
    @IBOutlet weak var uiv_dlg: UIView!
    
    let cellSpacingHeight: CGFloat = 10 // cell line spacing must use section instead of row

    var messageSendHandle: UInt?
    var newStatusHandle: UInt?
    var msgdataSource =  [ChatModel]()
    var statuesList =  [StatusModel]()
    let ref = Database.database().reference()
    var meListroomId = "u" + "\(thisuser!.id!)"
    
    var mestatusroomID = ""
    var partnerstatusroomID = ""
    var partnerListroomId = ""
    
    let pathList = Database.database().reference().child("list")
    let pathStatus = Database.database().reference().child("status")
    var partnerOnline = false
    var messageNum: Int = 0
    var isBlock: String? = "false"
    var downloadURL: URL?
    /*var gifURL: String?
    var thumbURL: String?*/
    var gifURL: String?
    var working4imagesend = false
    var working4textsend = false
    
    var imageFils = [String]()
    
    var isattachedViewShow = false
    var isemojiViewShow = false
    var isworkingForGif = false
    var isgifSending = false
    var isdosending = false
    var isImagesending = false
    var partner: UserModel!
    let requestPath = Database.database().reference().child("request")
    var animator = CPImageViewerAnimator()
    var imagePicker: ImagePicker1!
    var ds_attachMenuData  = [AttachModel]()
    var images4AttachMenu = ["","attach","gifBtn","emoji"]
    var colorBack: [UIColor] = [.white,UIColor.init(named: "color_Primary")!,UIColor.init(named: "color_Primary")!,UIColor.init(named: "color_Primary")!]
    var currentChattingUser: UserModel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setOnlinestatus4me()
        self.setAttachedView(isShow: isattachedViewShow)
        self.setEmojiView(isShow: isemojiViewShow)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveGif(_:)),name: .gifSend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openGalleryObj),name: .opneGallery, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let chattingUser = chattingUser{
            self.currentChattingUser = chattingUser
        }
        self.edt_msgSend.delegate = self
        //currentVC = VCs.MESSAGESEND
        
        self.setTableView()
        self.setChatRoomID_ChatListener()
        //self.setUnreadMessageNum4me()
        //self.setOnlinestatus4me()
        
        self.uiv_emojiBack.addTapGesture(tapNumber: 1, target: self, action: #selector(tapEmojiBack))
        edt_msgSend.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 36)
        self.imagePicker = ImagePicker1(presentationController: self, delegate: self)
        self.setDataSource4Attach()
        
        let downSwipeAction = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        /*let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))*/
        downSwipeAction.direction = .down
        self.uiv_dlg.addGestureRecognizer(downSwipeAction)
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        let roomID   = "\(thisuser!.id!)" + "_" +  "\(currentChattingUser.id ?? 0)"
        partnerstatusroomID = "\(thisuser!.id!)" + "_" + "\(currentChattingUser.id ?? 0)"
        partnerListroomId = "u" + "\(currentChattingUser.id ?? 0)"
        mestatusroomID = "\(currentChattingUser.id ?? 0)" + "_" + "\(thisuser!.id!)"
        
        if let messageSendHandle = messageSendHandle{
            FirebaseAPI.removeChattingRoomObserver(roomID, messageSendHandle)
        }
        self.setOfflinestatus4me()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uiv_dlg.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func addleftButton() {
        
        let btn_back = UIButton(type: .custom)
        btn_back.setImage(UIImage (named: "back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_back.addTarget(self, action: #selector(backBtnclicked), for: .touchUpInside)
        btn_back.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn_back.tintColor = UIColor.white
        let barButtonItemBack = UIBarButtonItem(customView: btn_back)
        barButtonItemBack.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemBack.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemBack
    }
    
    func addRightBtn() {
        let phoneBtn = UIButton(type: .custom)
        phoneBtn.setImage(UIImage (named: "phone")!.withRenderingMode(.alwaysTemplate), for: .normal)
        phoneBtn.addTarget(self, action: #selector(phoneBtnClicked), for: .touchUpInside)
        phoneBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //phoneBtn.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        phoneBtn.tintColor = UIColor.white
        
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage (named: "more")!.withRenderingMode(.alwaysTemplate), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreBtnClicked), for: .touchUpInside)
        moreBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        moreBtn.tintColor = UIColor.white
        let moreBtnItem = UIBarButtonItem(customView: moreBtn)
        let phoneBtnItem = UIBarButtonItem(customView: phoneBtn)
        
        moreBtnItem.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        moreBtnItem.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        phoneBtnItem.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        phoneBtnItem.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.navigationItem.rightBarButtonItems = [moreBtnItem, phoneBtnItem]
    }
    
    @objc func backBtnclicked() {
        if chattingOptionVC == .fromHome{
            self.gotoTabControllerWithIndex(0)
        }else if chattingOptionVC == .fromPeopleVC{
            self.gotoTabControllerWithIndex(1)
        }else if chattingOptionVC == .fromChattingList{
            self.gotoTabControllerWithIndex(2)
        }else if chattingOptionVC == .fromNotiVC{
            self.gotoTabControllerWithIndex(3)
        }
    }
    
    @objc func phoneBtnClicked() {
        // show search action for the peoples
    }
    
    @objc func moreBtnClicked() {
        // show search action for the peoples
    }
    
    
    @objc func handleSwipeDown(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            self.uiv_postView.isHidden = true
            self.imageFils.removeAll()
            self.imv_Post.image = nil
        }
    }
    
    func setDataSource4Attach()  {
        self.ds_attachMenuData.removeAll()
        for i in 0 ... 3{
            self.ds_attachMenuData.append(AttachModel(str_image: self.images4AttachMenu[i], color_back: colorBack[i]))
        }
    }
    
    @objc func tapEmojiBack(gesture: UITapGestureRecognizer) -> Void {
        self.isemojiViewShow = false
        self.setEmojiView(isShow: false)
    }
    
    @objc func receiveGif(_ notification: NSNotification){
        
        if let dict = notification.userInfo as NSDictionary?, let selectedGifURL = dict["selected_gif_url"] as? String{
            self.gifURL = selectedGifURL
            self.sendGifWithOnlineCheck4Partner()
        }
    }
    
    @objc func openGalleryObj(){
        self.openGallery()
    }
    
    func setStatusAccept4partner(_ state: String, partnerId: String, completion: @escaping (_ success: Bool) -> ()) {
        requestPath.child("u" + partnerId).child("u" + "\(thisuser!.id!)").child("state").setValue(state)
        completion(true)
    }
    
    func setAttachedView(isShow: Bool) {
        if isShow{
            self.uiv_totalAttach.isHidden = false
            self.cons_btm_edtmsgSend.constant = 0
        }else{
            self.uiv_totalAttach.isHidden = true
            self.cons_btm_edtmsgSend.constant = -50
        }
    }
    
    func setEmojiView(isShow: Bool) {
        if isShow{
            self.emojiView.isHidden = false
            self.uiv_emojiBack.isHidden = false
            self.cons_btm_attachedView.constant = 0
        }else{
            self.emojiView.isHidden = true
            self.uiv_emojiBack.isHidden = true
            self.cons_btm_attachedView.constant = -236
        }
    }
    
    func setupUI() {
        self.uiv_postView.isHidden = true
        self.addleftButton()
        //self.addRightBtn()
        self.title = currentChattingUser.user_name
    }
    
    func setChatRoomID_ChatListener() {
        var roomID = ""
        roomID   = "\(thisuser!.id!)" + "_" +  "\(currentChattingUser.id ?? 0)"
        partnerstatusroomID = "\(thisuser!.id!)" + "_" + "\(currentChattingUser.id ?? 0)"
        partnerListroomId = "u" + "\(currentChattingUser.id ?? 0)"
        mestatusroomID = "\(currentChattingUser.id ?? 0)" + "_" + "\(thisuser!.id!)"
        self.fireBaseNewChatListner(roomID)
    }
    
    func setTableView() {
        
        tbl_Chat.delegate = self
        tbl_Chat.dataSource = self
        self.tbl_Chat.allowsSelection = true
        self.tbl_Chat.separatorStyle = .none
        self.tbl_Chat.estimatedRowHeight = 80
    }
    
    /*func setUnreadMessageNum4me(){
        let usersRef = self.pathList.child(self.meListroomId).child(self.partnerListroomId)
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("messageNum"){
               self.pathList.child(self.meListroomId).child(self.partnerListroomId).child("messageNum").setValue("0")
            }else{
                print("false")
            }
        })
    }*/
    
    func setOnlinestatus4me()  {
        //if chatting_option == 0{
        pathStatus.child(mestatusroomID).removeValue()
        var statusObject = [String: String]()
        statusObject["online"] = "online"
        statusObject["sender_id"] = "\(thisuser!.id!)"
        statusObject["time"] = "\(Int(NSDate().timeIntervalSince1970) * 1000)"
        pathStatus.child(mestatusroomID).childByAutoId().setValue(statusObject)
       // }
    }
    
    func getPartnerOnlineStatus(completion :  @escaping (_ success: Bool, _ onineval: Bool) -> ()){
        let usersRef = pathStatus.child(partnerstatusroomID)
        let queryRef = usersRef.queryOrdered(byChild: "sender_id")
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                for snap in snapshot.children {
                    let userSnap = snap as! DataSnapshot
                    //let uid = userSnap.key //the uid of each user
                    let userDict = userSnap.value as! [String:AnyObject]
                    let online = userDict["online"] as! String
                    if online != ""{
                        let status = online == "online" ? true : false
                        completion(true, status)
                    }else{
                        completion(true, false)
                    }
                }
            }else{
                completion(true, false)
            }
        })
    }
    
    func getPartnerTotalMessageAndBlockState(completion :  @escaping (_ success: Bool, _ number: String, _ isBlock: String) -> ()){
            let usersRef = pathList.child(partnerListroomId).child(meListroomId)
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("messageNum") && snapshot.hasChild("isBlock"){
             if let userDict = snapshot.value as? [String:AnyObject]{
                if let number = userDict["messageNum"] as? String, let isBlock = userDict["isBlock"] as? String{
                    completion(true,number, isBlock)
                }
             }else{
                 completion(true,"0", "false")
             }
            }else{
                completion(true,"0", "false")
            }
        })
    }
    
    func fireBaseNewChatListner(_ roomId : String)  {
        //self.showLoadingView(vc: self)HUDHUD()
        var num  = 0
        messageSendHandle = FirebaseAPI.setMessageListener(roomId){ [self] (chatModel) in
            //self.hideLoadingView()
            //dump(chatModel, name: "Chatmodel=====>")
            num += 1
            self.msgdataSource.append(chatModel)
            if num == self.msgdataSource.count{
                dump(msgdataSource)
                self.tbl_Chat.reloadData()
                self.tbl_Chat.scrollToBottomRow()
            }
        }
    }
    
    func setOfflinestatus4me()  {
        pathStatus.child(mestatusroomID).removeValue()
        var statusObject = [String: String]()
        statusObject["online"] = "offline"
        statusObject["sender_id"] = "\(thisuser!.id!)"
        statusObject["time"] = "\(Int(NSDate().timeIntervalSince1970) * 1000)"
        pathStatus.child(mestatusroomID).childByAutoId().setValue(statusObject)
    }
    
    func openGallery() {
        self.imagePicker.present(from: view)
    }
    
    func gotoUploadProfile(_ image: UIImage?) {
        self.imageFils.removeAll()
        if let image = image{
            self.uiv_postView.isHidden = false
            imageFils.append(saveToFile(image:image,filePath:"photo",fileName:randomString(length: 2))) // Image save action
            self.imv_Post.image = image
            
            self.uploadFile2Firebase(imageFils.first!) { (isSuccess, downloadURL) in
               
                if isSuccess{
                    guard  let downloadURL = downloadURL else {
                        return
                    }
                    self.downloadURL = downloadURL
                }else{
                }
            }
        }
    }
    
    func setNewUnreadMessage4partner(number: Int, completion: @escaping (_ success: Bool) -> ()) {
        if chattingOptionVC == .fromChattingList{
            pathList.child(partnerListroomId).child(meListroomId).child("messageNum").setValue("\(number)")
            completion(true)
        }else{
            completion(true)
        }
    }
    
    func checkValid() -> Bool {
        self.view.endEditing(true)
        if edt_msgSend.text!.isEmpty {
            return false
        }
        return true
    }
    
    func doSend(_ online: Bool) {
        
        if !isdosending{
            isdosending = true
            let msgcontent = edt_msgSend.text!
            self.edt_msgSend.text! = ""
            
            if msgcontent != ""{
                let timeNow = Int(NSDate().timeIntervalSince1970) * 1000
                 var chatObject = [String: String]()
                 // MARK: for message object for partner - chatObject
                 chatObject["message"]     = msgcontent
                 chatObject["image"]       = ""
                 chatObject["photo"]       = thisuser!.user_photo
                 chatObject["sender_id"]   = "\(thisuser!.id!)"
                 chatObject["time"]        = "\(timeNow)" as String
                 chatObject["name"]         = thisuser!.user_name
                
                let roomId1   = "\(currentChattingUser.id ?? 0)" + "_" + "\(thisuser!.id!)"
                 // MARK: for partner message send action
                 FirebaseAPI.sendMessage(chatObject, roomId1) { (status, message) in
                     
                     if status {
                        if online{
                           chatObject["read_time"] = "\(timeNow)" as String
                        }
                        let roomId2   = "\(thisuser!.id!)" + "_" +  "\(self.currentChattingUser.id ?? 0)"
                        
                        // MARK: for me message send action
                        
                         // MARK: for message object for me - chatObject same object
                         FirebaseAPI.sendMessage(chatObject, roomId2) { (status, message) in
                            
                             if status {
                                 var listObject = [String: String]()
                                 listObject["id"]   = "\(self.currentChattingUser.id ?? 0)"
                                 // MARK: for list view for my list object - - listobject
                                 
                                 listObject["message"]        = msgcontent
                                 listObject["sender_id"]     = "\(self.currentChattingUser.id ?? 0)"
                                 listObject["sender_name"]    = self.currentChattingUser.user_name
                                 listObject["sender_photo"]  = self.currentChattingUser.user_photo
                                 listObject["time"]           = "\(timeNow)" as String
                                 listObject["isBlock"]            = "false"
                                 FirebaseAPI.sendListUpdate(listObject, "u" + "\(thisuser!.id!)", partnerid: "u" + listObject["id"]!){
                                     (status,message) in
                                     if status{
                                         var listObject1 = [String: String]()
                                         // MARK:  for list view for partner's list object - listobject1
                                         listObject1["id"]              = "\(thisuser!.id!)"
                                         listObject1["message"]         = msgcontent
                                         listObject1["sender_id"]       = "\(thisuser!.id!)"
                                         listObject1["sender_name"]     = thisuser!.user_name
                                         listObject1["sender_photo"]    = thisuser!.user_photo
                                         listObject1["time"]            = "\(timeNow)" as String
                                         listObject1["isBlock"]         = self.isBlock
                                         FirebaseAPI.sendListUpdate(listObject1, "u" + "\(self.currentChattingUser.id ?? 0)", partnerid: "u" + "\(thisuser!.id!)"){
                                            (status,message) in
                                            if status{
                                                self.isdosending = false
                                                self.working4textsend = false
                                            }
                                         }
                                         
                                         /*if !online{
                                             // for testing add part
                                             self.messageNum += 1
                                             listObject1["messageNum"]      =  "\(self.messageNum)"
                                             FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                 (status,message) in
                                                 if status{
                                                    self.working4textsend = false
                                                 }
                                             }
                                             // end for testing part
                                             
                                             /*// for the real part
                                             self.messageNum += 1
                                             ApiManager.submitFCM(friend_id: partnerid, notitext: msgcontent) { (isSuccess, data) in
                                                 if isSuccess{
                                                     listObject1["unread"]        =  "\(self.messageNum)"
                                                     FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                         (status,message) in
                                                         if status{
                                                             self.working4textsend = false
                                                         }
                                                     }
                                                 }else{
                                                     listObject1["unread"]        =  "\(self.messageNum)"
                                                     FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                         (status,message) in
                                                         if status{
                                                             self.working4textsend = false
                                                         }
                                                     }
                                                 }
                                             }*/
                                             
                                         }else{
                                             listObject1["messageNum"]       =  "0"
                                             FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                 (status,message) in
                                                 if status{
                                                     self.working4textsend = false
                                                 }
                                             }
                                         }*/
                                     }
                                 }
                             } else {
                                 //print(message)
                             }
                         }
                     } else {
                         //print(message)
                     }
                 }
            }
        }
    }
    
    func uploadFile2Firebase(_ localFile: String, completion: @escaping (_ success: Bool, _ path: URL?) -> ())  {
        self.showLoadingView(vc: self)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riversRef = storageRef.child("/" + "\(randomString(length: 2))" + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = riversRef.putFile(from: URL(fileURLWithPath: localFile), metadata: metadata) { metadata, error in
            self.hideLoadingView()
            guard metadata != nil else {
                completion(false, nil)
                return
            }
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(false,nil)
                    return
                }
                completion(true, downloadURL)
            }
        }
    }
    
    func imgageSend(_ online: Bool)  {
        
        if !working4imagesend{
            
            working4imagesend = true
            guard let downloadRL = self.downloadURL else {
                return
            }
            
             self.showLoadingView(vc: self)
             let timeNow = Int(NSDate().timeIntervalSince1970) * 1000
             var chatObject = [String: String]()
             // MARK: for message object for partner - chatObject
             chatObject["message"]     = ""
             chatObject["image"]       = "\(downloadRL)"
             chatObject["photo"]       = thisuser!.user_photo
             chatObject["sender_id"]   = "\(thisuser!.id!)"
             chatObject["time"]        = "\(timeNow)" as String
             chatObject["name"]        = thisuser!.user_name
             let roomId1   = "\(currentChattingUser.id ?? 0)" + "_" + "\(thisuser!.id!)"
            // MARK: for partner message send action
            
             FirebaseAPI.sendMessage(chatObject, roomId1) { (status, message) in
                 if status {
                    if online{
                       chatObject["read_time"] = "\(timeNow)" as String
                    }
                    let roomId2   = "\(thisuser!.id!)" + "_" +  "\(self.currentChattingUser.id ?? 0)"
                    
                    
                     // MARK:  // MARK: for message object for me send action - chatObject same object
                     FirebaseAPI.sendMessage(chatObject, roomId2) { (status, message) in
                         if status {
                            var listObject = [String: String]()
                            listObject["id"]   = "\(self.currentChattingUser.id ?? 0)"
                            
                             // MARK: for list view for my list object - - listobject
                             listObject["message"]       = "Shared a file"
                             listObject["sender_id"]     = "\(self.currentChattingUser.id ?? 0)"
                             listObject["sender_name"]    = self.currentChattingUser.user_name
                             listObject["sender_photo"]  = self.currentChattingUser.user_photo
                             listObject["time"]           = "\(timeNow)" as String
                             listObject["isBlock"]            = "false"
                             
                             FirebaseAPI.sendListUpdate(listObject, "u" + "\(thisuser!.id!)", partnerid: "u" + listObject["id"]!){
                                 (status,message) in
                                 if status{
                                     var listObject1 = [String: String]()
                                     listObject1["id"]              = "\(thisuser!.id!)"
                                     listObject1["message"]         = "Shared a file"
                                     listObject1["sender_id"]       = "\(thisuser!.id!)"
                                     listObject1["sender_name"]     = thisuser!.user_name
                                     listObject1["sender_photo"]    = thisuser!.user_photo
                                     listObject1["time"]            = "\(timeNow)" as String
                                     listObject1["isBlock"]         = self.isBlock
                                     FirebaseAPI.sendListUpdate(listObject1, "u" + "\(self.currentChattingUser.id ?? 0)", partnerid: "u" + "\(thisuser!.id!)"){
                                        (status,message) in
                                        if status{
                                           self.hideLoadingView()
                                           self.working4imagesend = false
                                           self.isImagesending = false
                                           self.uiv_postView.isHidden = true
                                           self.imageFils.removeAll()
                                           self.imv_Post.image = nil
                                           self.tbl_Chat.scrollToBottomRow()
                                        }
                                    }
                                     /*if !online{
                                         self.messageNum += 1
                                         listObject1["messageNum"]      =  "\(self.messageNum)"
                                         /*ApiManager.submitFCM(friend_id: partnerid, notitext: "Shared a file") { (isSuccess, data) in
                                            if isSuccess{
                                                FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                    (status,message) in
                                                    if status{
                                                       self.hideLoadingView()
                                                       self.working4imagesend = false
                                                       self.uiv_postView.isHidden = true
                                                       self.imageFils.removeAll()
                                                       self.imv_Post.image = nil
                                                       self.tbl_Chat.scrollToBottomRow()
                                                    }
                                                }
                                            }else{
                                                FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                    (status,message) in
                                                    if status{
                                                       self.hideLoadingView()
                                                       self.working4imagesend = false
                                                       self.uiv_postView.isHidden = true
                                                       self.imageFils.removeAll()
                                                       self.imv_Post.image = nil
                                                       self.tbl_Chat.scrollToBottomRow()
                                                    }
                                                }
                                            }
                                        }*/
                                        // add for testing start part
                                        FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                            (status,message) in
                                            if status{
                                               self.hideLoadingView()
                                               self.working4imagesend = false
                                               self.uiv_postView.isHidden = true
                                               self.imageFils.removeAll()
                                               self.imv_Post.image = nil
                                               self.tbl_Chat.scrollToBottomRow()
                                            }
                                        }
                                        // end for testing part
                                     }else{
                                          listObject1["messageNum"]      =  "0"
                                          FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                            (status,message) in
                                            if status{
                                               self.hideLoadingView()
                                               self.working4imagesend = false
                                               self.uiv_postView.isHidden = true
                                               self.imageFils.removeAll()
                                               self.imv_Post.image = nil
                                               self.tbl_Chat.scrollToBottomRow()
                                            }
                                        }
                                     }*/
                                 }
                             }
                         } else {
                             //print(message)
                         }
                     }
                 } else {
                     //print(message)
                 }
             }
        }
    }
    
    func gifSend(_ online: Bool)  {
        
        if !isgifSending{
            isgifSending = true
            self.showLoadingView(vc: self)
            guard let gifurl = self.gifURL else {
                return
            }
             let timeNow = Int(NSDate().timeIntervalSince1970) * 1000
             var chatObject = [String: String]()
             // MARK: for message object for partner - chatObject
             chatObject["message"]     = ""
             chatObject["image"]       = "\(gifurl)"
             chatObject["photo"]       = thisuser!.user_photo
             chatObject["sender_id"]   = "\(thisuser!.id!)"
             chatObject["time"]        = "\(timeNow)" as String
             chatObject["name"]        = thisuser!.user_name
             let roomId1   = "\(currentChattingUser.id ?? 0)" + "_" + "\(thisuser!.id!)"
            // MARK: for partner message send action
             FirebaseAPI.sendMessage(chatObject, roomId1) { (status, message) in
                 
                 if status {
                    if online{
                       chatObject["read_time"] = "\(timeNow)" as String
                    }
                    let roomId2   = "\(thisuser!.id!)" + "_" +  "\(self.currentChattingUser.id ?? 0)"
                    
                     // MARK: for message object for me - chatObject same object
                     FirebaseAPI.sendMessage(chatObject, roomId2) { (status, message) in
                         if status {
                            var listObject = [String: String]()
                            listObject["id"]   = "\(self.currentChattingUser.id ?? 0)"
                            
                             // MARK: for list view for my list object - - listobject
                             listObject["message"]       = "Shared a file"
                             listObject["sender_id"]     = "\(self.currentChattingUser.id ?? 0)"
                             listObject["sender_name"]    = self.currentChattingUser.user_name
                             listObject["sender_photo"]  = self.currentChattingUser.user_photo
                             listObject["time"]           = "\(timeNow)" as String
                             listObject["isBlock"]            = "false"
                            
                             FirebaseAPI.sendListUpdate(listObject, "u" + "\(thisuser!.id!)", partnerid: "u" + listObject["id"]!){
                                 (status,message) in
                                 if status{
                                    var listObject1 = [String: String]()
                                    listObject1["id"]              = "\(thisuser!.id!)"
                                    listObject1["message"]         = "Shared a file"
                                    listObject1["sender_id"]       = "\(thisuser!.id!)"
                                    listObject1["sender_name"]     = thisuser!.user_name
                                    listObject1["sender_photo"]    = thisuser!.user_photo
                                    listObject1["time"]            = "\(timeNow)" as String
                                    listObject1["isBlock"]         = self.isBlock
                                      FirebaseAPI.sendListUpdate(listObject1, "u" + "\(self.currentChattingUser.id ?? 0)", partnerid: "u" + "\(thisuser!.id!)"){
                                        (status,message) in
                                        if status{
                                           self.hideLoadingView()
                                           self.working4imagesend = false
                                           self.uiv_postView.isHidden = true
                                           self.imageFils.removeAll()
                                           self.imv_Post.image = nil
                                           self.tbl_Chat.scrollToBottomRow()
                                           self.isworkingForGif = false
                                           self.isgifSending = false
                                           NotificationCenter.default.post(name:.gifSendSuccess, object: nil)
                                        }
                                    }
                                     /*if !online{
                                         self.messageNum += 1
                                         listObject1["messageNum"]      =  "\(self.messageNum)"
                                         /*ApiManager.submitFCM(friend_id: partnerid, notitext: "Shared a file") { (isSuccess, data) in
                                            if isSuccess{
                                                FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                    (status,message) in
                                                    if status{
                                                       self.hideLoadingView()
                                                       self.working4imagesend = false
                                                       self.uiv_postView.isHidden = true
                                                       self.imageFils.removeAll()
                                                       self.imv_Post.image = nil
                                                       self.tbl_Chat.scrollToBottomRow()
                                                    }
                                                }
                                            }else{
                                                FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                                    (status,message) in
                                                    if status{
                                                       self.hideLoadingView()
                                                       self.working4imagesend = false
                                                       self.uiv_postView.isHidden = true
                                                       self.imageFils.removeAll()
                                                       self.imv_Post.image = nil
                                                       self.tbl_Chat.scrollToBottomRow()
                                                    }
                                                }
                                            }
                                        }*/
                                        // add for testing start part
                                        FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                            (status,message) in
                                            if status{
                                               self.hideLoadingView()
                                               self.working4imagesend = false
                                               self.uiv_postView.isHidden = true
                                               self.imageFils.removeAll()
                                               self.imv_Post.image = nil
                                               self.tbl_Chat.scrollToBottomRow()
                                               self.isworking = -1
                                               NotificationCenter.default.post(name:.gifSendSuccess, object: nil)
                                            }
                                        }
                                        // end for testing part
                                     }else{
                                          listObject1["messageNum"]      =  "0"
                                          FirebaseAPI.sendListUpdate(listObject1, "u" + partnerid, partnerid: "u" + "\(thisuser!.id!)"){
                                            (status,message) in
                                            if status{
                                               self.hideLoadingView()
                                               self.working4imagesend = false
                                               self.uiv_postView.isHidden = true
                                               self.imageFils.removeAll()
                                               self.imv_Post.image = nil
                                               self.tbl_Chat.scrollToBottomRow()
                                               self.isworking = -1
                                               NotificationCenter.default.post(name:.gifSendSuccess, object: nil)
                                            }
                                        }
                                     }*/
                                 }
                             }
                         } else {
                             //print(message)
                         }
                     }
                 } else {
                     //print(message)
                 }
             }
        }
    }
    
    func sendGifWithOnlineCheck4Partner() {
        
        if !isworkingForGif{
            isworkingForGif = true
            self.getPartnerTotalMessageAndBlockState{ (isSuccess, num, isBlock) in
                if isSuccess{
                    self.messageNum = num.toInt() ?? 0
                    self.isBlock = isBlock
                    print("messageNum==>",self.messageNum)
                    self.getPartnerOnlineStatus { (isSuccess, online) in
                        if isSuccess{
                            print("successstate==>",online)
                            self.gifSend(online)
                        }else{
                            print("failedstate===>",online)
                            self.showToast("Network issue")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
       
        if !working4textsend{
            if checkValid() {
                self.getPartnerTotalMessageAndBlockState { (isSuccess, num, isBlock) in
                    if isSuccess{
                        self.messageNum = num.toInt() ?? 0
                        self.isBlock = isBlock
                        print("messageNum==>",self.messageNum)
                        self.getPartnerOnlineStatus { (isSuccess, online) in
                            if isSuccess{
                                print("successstate==>",online)
                                self.doSend(online)
                            }else{
                                print("failedstate===>",online)
                                self.showToast("Network issue")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func postImageBtnclicked(_ sender: Any) {
        if !isImagesending{
            isImagesending = true
            self.getPartnerTotalMessageAndBlockState { (isSuccess, num, isBlock) in
                if isSuccess{
                    self.messageNum = num.toInt() ?? 0
                    self.isBlock = isBlock
                    print("messageNum==>",self.messageNum)
                    self.getPartnerOnlineStatus { (isSuccess, online) in
                        if isSuccess{
                            print("successstate==>",online)
                            self.imgageSend(online)
                        }else{
                            print("failedstate===>",online)
                            self.showToast("Network issue")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func attachBtnClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.isattachedViewShow = !self.isattachedViewShow
            self.setAttachedView(isShow: self.isattachedViewShow)
            self.isemojiViewShow = false
            self.setEmojiView(isShow: self.isemojiViewShow)
        }
    }
    
    @IBAction func cancelImageBtnClicked(_ sender: Any) {
        self.uiv_postView.isHidden = true
        self.imageFils.removeAll()
        self.imv_Post.image = nil
    }
    
    
    func attachPinBtnClicked() {
        self.openGallery()
    }
    
    func gifBtnClicked() {
        animVC = .gifSearch
        self.creatNav(.gifSearch)
        self.openMenu(.gifSearch)
    }
    
    func emojiBtnClicked() {
        self.isemojiViewShow = !isemojiViewShow
        self.setEmojiView(isShow: self.isemojiViewShow)
    }
    
    @IBAction func meBtnClicked(_ sender: Any) {
        print("me")
        let button = sender as! UIButton
        let indexpathrow = button.tag
        if self.msgdataSource[indexpathrow].image != "" && !self.msgdataSource[indexpathrow].image.contains(".gif"){
            if self.msgdataSource[indexpathrow].me{
                /*let toVC = self.storyboard?.instantiateViewController(withIdentifier: VCs.IMAGESHOW) as! ImageShowVC
                toVC.modalPresentationStyle = .fullScreen
                toVC.imageURL = self.msgdataSource[indexpathrow].image
                self.navigationController?.pushViewController(toVC, animated: true)*/
                let url = URL(string: self.msgdataSource[indexpathrow].image)
                KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    //print(image)
                    let controller = CPImageViewer()
                    controller.image = image
                    self.navigationController?.delegate = self.animator
                    self.present(controller, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                })
            }
        }
    }
    
    @IBAction func youBtnClicked(_ sender: Any) {
        print("you")
        let button = sender as! UIButton
        let indexpathrow = button.tag
        if self.msgdataSource[indexpathrow].image != "" && !self.msgdataSource[indexpathrow].image.contains(".gif"){
            if !self.msgdataSource[indexpathrow].me{
                /*let toVC = self.storyboard?.instantiateViewController(withIdentifier: VCs.IMAGESHOW) as! ImageShowVC
                toVC.modalPresentationStyle = .fullScreen
                toVC.imageURL = self.msgdataSource[indexpathrow].image
                self.navigationController?.pushViewController(toVC, animated: true)*/
                
                let url = URL(string: self.msgdataSource[indexpathrow].image)
                KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    //print(image)
                    let controller = CPImageViewer()
                    controller.image = image
                    self.navigationController?.delegate = self.animator
                    self.present(controller, animated: true, completion: nil)
                    //self.present(controller, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func photoAttachTopBtnClicked(_ sender: Any) {
        self.uiv_postView.isHidden = true
        self.imageFils.removeAll()
        self.imv_Post.image = nil
    }
    
    @IBAction func spaceBtnClicked(_ sender: Any) {
        self.uiv_postView.isHidden = true
        self.imageFils.removeAll()
        self.imv_Post.image = nil
    }
}

extension MessageSendVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.msgdataSource.count
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

        if self.msgdataSource[indexPath.section].image == ""{
            let cell = tbl_Chat.dequeueReusableCell(withIdentifier: "ChatCell", for:indexPath) as! ChatCell
            cell.selectionStyle = .none
            cell.entity = msgdataSource[indexPath.section]
            
            if self.msgdataSource[indexPath.section].me{
                cell.meView.isHidden = false
                cell.youView.isHidden = true
                cell.imv_partner.isHidden = true
                cell.youlblTime.isHidden = true
                cell.melblTime.isHidden = false
                cell.lbl_readReceipt.isHidden = false
            }else{
                cell.meView.isHidden = true
                cell.youView.isHidden = false
                cell.imv_partner.isHidden = false
                cell.youlblTime.isHidden = false
                cell.melblTime.isHidden = true
                cell.lbl_readReceipt.isHidden = true
            }
            return cell
        }else{
            
            if self.msgdataSource[indexPath.section].image.contains(".gif"){
                let cell = tbl_Chat.dequeueReusableCell(withIdentifier: "chatGifCell", for:indexPath) as! chatGifCell
                cell.selectionStyle = .none
                cell.entity = msgdataSource[indexPath.section]
                cell.btn_me.tag = indexPath.section
                cell.btn_you.tag = indexPath.section
                if self.msgdataSource[indexPath.section].me{
                    cell.uiv_me.isHidden = false
                    cell.uiv_you.isHidden = true
                    cell.imv_partner.isHidden = true
                    cell.btn_me.isHidden = false
                    cell.btn_you.isHidden = true
                }else{
                    cell.uiv_me.isHidden = true
                    cell.uiv_you.isHidden = false
                    cell.imv_partner.isHidden = false
                    cell.btn_me.isHidden = true
                    cell.btn_you.isHidden = false
                }
                return cell
            }else{
                let cell = tbl_Chat.dequeueReusableCell(withIdentifier: "chatImageCell", for:indexPath) as! chatImageCell
                cell.selectionStyle = .none
                cell.entity = msgdataSource[indexPath.section]
                cell.btn_me.tag = indexPath.section
                cell.btn_you.tag = indexPath.section
                if self.msgdataSource[indexPath.section].me{
                    cell.uiv_me.isHidden = false
                    cell.uiv_you.isHidden = true
                    cell.imv_partner.isHidden = true
                    cell.btn_me.isHidden = false
                    cell.btn_you.isHidden = true
                }else{
                    cell.uiv_me.isHidden = true
                    cell.uiv_you.isHidden = false
                    cell.imv_partner.isHidden = false
                    cell.btn_me.isHidden = true
                    cell.btn_you.isHidden = false
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 30
        }else{
            return cellSpacingHeight
        }
    }
}

extension MessageSendVC : EmojiViewDelegate{
    
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        self.edt_msgSend.insertText(emoji)
    }
    
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        self.edt_msgSend.deleteBackward()
    }
}

extension MessageSendVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tbl_Chat.scrollToBottomRow()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      self.tbl_Chat.scrollToBottomRow()
    }
}

extension MessageSendVC: ImagePickerDelegate1{
    
    func didSelect(image: UIImage?) {
        self.gotoUploadProfile(image)
    }
}

 
//MARK: UICollectionViewDataSource
extension MessageSendVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ds_attachMenuData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachCell", for: indexPath) as! AttachCell
            
        cell.entity = ds_attachMenuData[indexPath.row]
        cell.uiv_back.cornerRadius = collectionView.frame.size.height * 0.4
        if indexPath.row != 0{
            cell.lbl_plus.isHidden = true
        }else{
            cell.lbl_plus.isHidden = false
        }
        return cell
    }
}

extension MessageSendVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:// warning
            //self.waringBtnClicked()
            break
        case 1:// attach
            self.attachPinBtnClicked()
            break
        case 2:// gift
            self.gifBtnClicked()
            break
        case 3:// blank
            self.emojiBtnClicked()
            break
        
        default:
            print("clicked")
        }
        // TODO: goto detail show vc
    }
}

extension MessageSendVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height * 0.8
        let w = h
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}




