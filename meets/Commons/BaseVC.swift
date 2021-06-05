//
//  BaseVC.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import Toast_Swift
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import KAWebBrowser

var gifSearchVC:SearchVC!
var darkVC :DarkVC!

class DarkVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseVC: UIViewController {

    var hud: MBProgressHUD?
    var alertController : UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        /*let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))*/
        downSwipe.direction = .down
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !(self.hud?.isHidden ?? false){
            self.hideLoadingView()
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            if let animvc = animVC{
                self.closeMenu(animvc)
                openStatue = false
            }
        }
    }
    
    func creatNav(_ vcType: AnimVC) {
        if vcType == .gifSearch{
            gifSearchVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: VCs.GIFSEARCH) as! SearchVC)
            gifSearchVC.view.frame = CGRect(x:0 , y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            darkVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DarkVC") as! DarkVC)
            darkVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    func openMenu(_ vcType: AnimVC){
         if vcType == .gifSearch{
            darkVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view.addSubview(darkVC.view)
            self.addChild(darkVC)
            _ = self.navigationController?.navigationBar.height
            UIView.animate(withDuration: 0.5, animations: {
                gifSearchVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view.addSubview(gifSearchVC.view)
                self.addChild(gifSearchVC)
            })
        }
    }
    
    func closeMenu(_ vcType: AnimVC){
        if vcType == .gifSearch{
            
            NotificationCenter.default.post(name:.gifSearch, object: nil)
            
            darkVC.view.frame = CGRect(x:0 , y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            darkVC.view.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                gifSearchVC.view.frame = CGRect(x:0 , y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                gifSearchVC.view.willRemoveSubview(gifSearchVC.view)
            })
        }
    }
    
    func showNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // for general part for common project
    func gotoVC(_ nameVC: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: nameVC)
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: true, completion: nil)
    }
    
    func gotoVCModal(_ name: String) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: name)
        targetVC.modalPresentationStyle = .overFullScreen
        //targetVC.modalTransitionStyle = .crossDissolve
        self.present(targetVC, animated: false, completion: nil)
    }
    
    func gotoStoryBoardVC(_ name: String, fullscreen: Bool) {
        let storyboad = UIStoryboard(name: name, bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: name)
        if fullscreen{
            targetVC.modalPresentationStyle = .fullScreen
        }
        self.present(targetVC, animated: false, completion: nil)
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
    
    func hideLoadingView() {
       if let hud = hud {
           hud.hide(animated: true)
       }
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(text.filter {okayChars.contains($0) })
    }
    
    func showLoadingView(vc: UIViewController, label: String = "") {
        
        hud = MBProgressHUD .showAdded(to: vc.view, animated: true)
        
        if label != "" {
            hud!.label.text = label
        }
        hud!.mode = .indeterminate
        hud!.animationType = .zoomIn
        hud!.bezelView.color = .clear
        hud!.bezelView.style = .solidColor
    }
    
    //MARK:- Toast function
    func showToast(_ message : String) {
        self.view.makeToast(message)
    }
    
    func showToast(_ message : String, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = .bottom) {
        self.view.makeToast(message, duration: duration, position: position)
    }
    
    func showToastCenter(_ message : String, duration: TimeInterval = ToastManager.shared.duration) {
        showToast(message, duration: duration, position: .center)
    }
    
    func setEdtPlaceholder(_ edittextfield : UITextField , placeholderText : String, placeColor : UIColor, padding: UITextField.PaddingSide)  {
        edittextfield.attributedPlaceholder = NSAttributedString(string: placeholderText,
        attributes: [NSAttributedString.Key.foregroundColor: placeColor])
        edittextfield.addPadding(padding)
    }
    
    func gotoNavPresent(_ storyname : String, fullscreen: Bool) {
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: storyname)
        if fullscreen{
            toVC?.modalPresentationStyle = .fullScreen
        }else{
            toVC?.modalPresentationStyle = .pageSheet
        }
        self.navigationController?.pushViewController(toVC!, animated: true)
    }
    
    
    // MARK: for custom  part for only this project
    
    func gotoMessageSendVC(_ userinfo: UserModel) {
        
        chattingUser = userinfo
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: VCs.MESSAGESENDNAV)
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: false, completion: nil)
        //self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    func gotoWebViewWithProgressBar(_ link: String)  {
        let browser = KAWebBrowser()
        show(browser, sender: nil)
        browser.loadURLString(link)
    }
    
    func gotoGeneralProfileVC(_ userinfo: UserModel, isLikeUser: Bool, chattingOption: ChattingOptionVC) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: VCs.GENERALPROFILEVC) as! GeneralProfileVC
        toVC.modalPresentationStyle = .fullScreen
        toVC.user = userinfo
        toVC.islike = isLikeUser
        toVC.chattingOption = chattingOption
        //self.present(toVC, animated: false, completion: nil)
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    func gotoTabControllerWithIndex(_ index: Int) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: VCs.HOMETABBARVC) as! UITabBarController
        toVC.selectedIndex = index
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: false, completion: nil)
    }
    
    // MARK: UIAlertView Controller
    func alertMake(_ msg : String) -> UIAlertController {
        alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alertController!.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController!
    }
    
    func alertDisplay(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}
