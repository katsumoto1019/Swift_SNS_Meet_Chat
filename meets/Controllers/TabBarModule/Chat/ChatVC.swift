//
//  ChatVC.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import SwipeCellKit
import SwiftyJSON
import SwiftyUserDefaults
import Firebase
import FirebaseDatabase

class ChatVC: BaseVC {

    @IBOutlet weak var ui_collectionView: UICollectionView!
    var msgDatasource = [MessageSwipeModel]()
    var msgDatasource1 = [MessageSwipeModel]()
    var newChatHandle: UInt?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Messages.MESSAGE
        //self.setEditBtn()
    }
    
    func setEditBtn() {
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(goedit))
        editBarButtonItem.tintColor = .white
            self.navigationItem.rightBarButtonItem  = editBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let roomId = "u1"
        let roomId = "u" + "\(thisuser!.id ?? 0)"
        userlistListner(roomId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.hud != nil{
            if hud!.isFocused{
                self.hideLoadingView()
            }
        }
    }
    
    @objc func goedit() {
        
    }
    
    func userlistListner(_ userRoomid : String)  {
        
        self.msgDatasource.removeAll()
        newChatHandle = FirebaseAPI.getUserList(userRoomid : userRoomid, vc: self ,handler: { (userlist) in
            
            guard userlist.id != nil else{
                return
            }
            
            self.msgDatasource.append(userlist)
            var ids = [String]()
            for one in self.msgDatasource{
                ids.append(one.id!)
            }
            //print(ids.removeDuplicates())
            var num = 0
            self.msgDatasource1.removeAll()
            for  one in ids.removeDuplicates(){
                num += 1
                self.msgDatasource1.append(self.getDataFromID(one))
                if num == ids.removeDuplicates().count{
                    //dump(self.msgDatasource1, name: "msgDatasource1====>")
                    //dump(self.msgDatasource, name: "msgDatasource====.")
                    
                    self.ui_collectionView.reloadData()
                }
             }
          }
       )
    }
    
    func getDataFromID(_ id: String) -> MessageSwipeModel {
        var returnModel : MessageSwipeModel?
        for one in self.msgDatasource{
            if id == one.id{
                returnModel = one
            }
        }
        return returnModel ?? MessageSwipeModel()
    }
}

extension ChatVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msgDatasource1.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageSwipeCell", for: indexPath) as! MessageSwipeCell
        
        cell.entity = msgDatasource1[indexPath.row]
        cell.delegate = self
    
    if self.msgDatasource1[indexPath.row].unreadMsgNum != "0" && self.msgDatasource1[indexPath.row].unreadMsgNum.toInt() ?? 0 > 0{
        cell.msgUnreadNum.text = self.msgDatasource1[indexPath.row].unreadMsgNum
        cell.UnreadView.isHidden = false
        cell.msgReadTick.isHidden = true
    }else{
        cell.msgUnreadNum.text = ""
        cell.UnreadView.isHidden = true
        cell.msgReadTick.isHidden = false
    }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*chatting_option = .chatList
        msgIndexId = msgDatasource1[indexPath.row].id!
        msgPartnerName = msgDatasource1[indexPath.row].msgUserName
        msgPartnerPicture = msgDatasource1[indexPath.row].sender_photo
        
        self.gotoVC("MessageSendVC")*/
        
        //chatting_option = .chatList
        let profiel_count = UserDefault.getInt(key: PARAMS.PROFILE_LIMIT, defaultValue: 0)
        let message_count = UserDefault.getInt(key: PARAMS.MESSAGE_LIMIT, defaultValue: 0)
        print("\(profiel_count), \(message_count)")
        
        if message_count > Constants.message_limit{
            self.gotoVCModal(VCs.ADSHOWVC)
        }else{
            let new_message_count = message_count + 1
            UserDefault.setInt(key: PARAMS.MESSAGE_LIMIT, value: new_message_count)
            UserDefault.Sync()
            chattingOptionVC = .fromChattingList
            let one = self.msgDatasource1[indexPath.row]
            let userinfo = UserModel(id: one.sender_id.toInt() ?? 0, username: one.msgUserName, userphoto: one.sender_photo)
            self.gotoMessageSendVC(userinfo)
        }
    }
}

extension ChatVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h: CGFloat = 80
        let w = collectionView.frame.size.width
        return CGSize(width: w, height: h)
    }
}

extension ChatVC: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
           return nil
        }
        //let requestId = msgDatasource[indexPath.row].requestFriendId
        let deleteAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            //self.msgDatasource[indexPath.row].requestFriendName)
            
            let ref = Database.database().reference()
            let userchattingRoom = "u" + "\(thisuser!.id ?? 0)"
            let partnerid = "u" + self.msgDatasource1[indexPath.row].sender_id
            ref.child("list").child(userchattingRoom).child(partnerid).observe(.childAdded, with: { (snapshot) in

                    snapshot.ref.removeValue(completionBlock: { (error, reference) in
                        if error != nil {
                            print("There has been an error:\(error)")
                        }
                    })
                })
            self.msgDatasource1.remove(at: indexPath.row)
            self.ui_collectionView.reloadData()
        }
               // customize swipe action
        deleteAction.transitionDelegate = ScaleTransition(duration: 0.15, initialScale: 0.7, threshold: 0.8)
        deleteAction.backgroundColor = .red
        deleteAction.title = "削除"
        deleteAction.textColor = .white
        return [deleteAction]

    }
}


