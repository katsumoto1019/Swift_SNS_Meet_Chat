
import Foundation
import Firebase
import SwiftyUserDefaults
import FirebaseDatabase
import MBProgressHUD

var hud1: MBProgressHUD?

class FirebaseAPI {
    
    
    static let ref = Database.database().reference()
    
    //static let CONV_REFERENCE = ""
    static let MESSAGE = "message"
    static let LIST = "list"
    static let STATUS = "status"

    
     //MARK: - Set/remove Add/change observer
    static func setMessageListener(_ roomId: String, handler:@escaping (_ msg: ChatModel)->()) -> UInt {
        return ref.child(MESSAGE).child(roomId).observe(.childAdded) { (snapshot, error) in

            let childref = snapshot.value as? NSDictionary
            if let childRef = childref {
                //print(childRef)
                let msg = parseMsg(childRef)
                handler(msg)
            } else {
            }
        }
    }
    
    static func getPartnerOnlinestatus(_ path: String, handler:@escaping (_ msg: StatusModel)->()) -> UInt {

        return ref.child("status").child(path).observe(.value) { (snapshot, error) in

            let childref = snapshot.value as? NSDictionary
            if let childRef = childref {
                //print(childRef)
                let msg = parseStatus(childRef)
                handler(msg)
            } else {
            }
        }
    }
    
    static func parseStatus(_ snapshot: NSDictionary) -> StatusModel {

        let status = StatusModel()
        //print(snapshot)
        status.online = snapshot["online"] as! String
        status.sender_id = snapshot["sender_id"] as! String
        status.timesVal = snapshot["time"] as! String
        
        return status
    }
    
    static func parseMsg(_ snapshot: NSDictionary) -> ChatModel {

        let message = ChatModel()
        //print(snapshot)
        message.image = snapshot["image"] as! String
        message.msgContent = snapshot["message"] as! String
        message.name = snapshot["name"] as! String
        message.photo = snapshot["photo"] as! String
        message.sender_id = snapshot["sender_id"] as! String
        
        if "\(thisuser!.id ?? 0)" == message.sender_id{
            message.me = true
        }
        else{
            message.me = false
        }
        message.timestamp = snapshot["time"] as! String
        return message
    }
    
    func showProgressHUDHUD(view : UIView, mode: MBProgressHUDMode = .annularDeterminate) -> MBProgressHUD {
    
        let hud = MBProgressHUD .showAdded(to:view, animated: true)
        hud.mode = mode
        hud.label.text = "Loading";
        hud.animationType = .zoomIn
        hud.tintColor = UIColor.red
        hud.contentColor = .darkGray
        return hud
    }
    
    static func getUserList(userRoomid : String,vc: UIViewController ,handler:@escaping (_ userList: MessageSwipeModel)->()) -> UInt {
        // in the firebase don't need to pick the terminal node.. if select top node, then will get all values automatically.
        
        return ref.child(LIST).child(userRoomid).observe(.childAdded) { (snapshot, error) in
            print(error as Any)
            let childref = snapshot.value as? NSDictionary
            if let childRef = childref {
                print(childRef)
                let userlist = parseList(childRef)
                handler(userlist)
            } else {
                handler(MessageSwipeModel())
            }
        }
    }
    
    static func removeChattingRoomObserver(_ roomId: String, _ handle : UInt) {
        ref.child(MESSAGE).child(roomId).child(roomId).removeObserver(withHandle: handle)
    }
    
    
    static func parseList(_ snapshot: NSDictionary) -> MessageSwipeModel {

        let userlist = MessageSwipeModel()
        print("userList ==" ,snapshot)
        if let snapshotid = snapshot["id"] as? String, let snapshotcontent = snapshot["message"] as? String, let snapshotsenderid = snapshot["sender_id"] as? String, let snapshotsendername = snapshot["sender_name"] as? String, let snapshosenderphoto = snapshot["sender_photo"] as? String, let snapshotmsgTime = snapshot["time"] as? String{
            userlist.id = snapshotid
            userlist.msgContent = snapshotcontent
            userlist.sender_id = snapshotsenderid
            userlist.msgUserName = snapshotsendername
            userlist.sender_photo = snapshosenderphoto
            userlist.msgTime = snapshotmsgTime
        }
        
        
        var unreadNum = ""
        if let unreadnum = snapshot["unread"] as? String{
            unreadNum = unreadnum
        }
        
        userlist.unreadMsgNum = unreadNum
        if unreadNum == ""{
            userlist.readStatus = false
        }
        else{
            userlist.readStatus = true
        }
        
        return userlist
    }
    
//    static func getUserList( userRoomid : String,completion: @escaping (_ user:[MessageSwipeModel]) -> ()) {
//
//        ref.child(CONV_REFERENCE).child(LIST).child(userRoomid).observeSingleEvent(of: .value, with: { (snapshot) in
//
//        let childref = snapshot.children.allObjects as? [DataSnapshot]
//        if let childRef = childref {
//
//            var userlist = [
//                MessageSwipeModel]()
//            // get all alarms in the property
//            for item in childRef {
//                let list = parseUserList(item.value as! NSDictionary)
//                userlist.append(list)
//            }
//
//            completion(userlist.reversed())
//        } else {
//            completion([])
//        }
//    })
//}
    
    

//    static func parseUserList(_ snapshot: NSDictionary) -> MessageSwipeModel {
//
//        let partner = MessageSwipeModel()
//        print(snapshot)
//        partner.id = snapshot["id"] as! String
//        partner.msgContent = snapshot["message"] as! String
//        partner.sender_id = snapshot["sender_id"] as! String
//        partner.msgUserName = snapshot["sender_name"] as! String
//        partner.msgAvatar = snapshot["sender_photo"] as! String
//        partner.msgTime = snapshot["time"] as! String
//        partner.unreadMsgNum = snapshot["unread"] as! String
//
//        return partner
//    }
//
//    static func removeRoyaltyObserver(_ roomId: String, _ handle : UInt) {
//        ref.child(CONV_REFERENCE).child(CHAT_CONTENT).child(roomId).removeObserver(withHandle: handle)
//    }
//
//
//
    // MARK: - send Chat
    static func sendMessage(_ chat:[String:String], _ roomId: String, completion: @escaping (_ status: Bool, _ message: String) -> ()) {

        ref.child(MESSAGE).child(roomId).childByAutoId().setValue(chat) { (error, dataRef) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Sent a message successfully.")
            }
        }
    }
    
    static func sendListUpdate(_ chat:[String:String], _ myid: String,partnerid : String, completion: @escaping (_ status: Bool, _ message: String) -> ()) {

        ref.child(LIST).child(myid).child(partnerid).setValue(chat) { (error, dataRef) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Userlist updated successfully.")
            }
        }
    }
//
//    static func registerUser(_ userinfo:[String:String] , _ id: String, completion: @escaping (_ status: Bool, _ message: String) -> ()) {
//        ref.child(CONV_REFERENCE).child(USER_LIST).childByAutoId().setValue(userinfo) { (error, dataRef) in
//            if let error = error {
//                completion(false, error.localizedDescription)
//            } else {
//                completion(true, "register success!")
//            }
//        }
//    }
//    static func removeRoyaltyObserver(_ roomId: String, _ handle : UInt) {
//        ref.child(CONV_REFERENCE).child(CHAT_CONTENT).child(roomId).removeObserver(withHandle: handle)
//    }
    
}
