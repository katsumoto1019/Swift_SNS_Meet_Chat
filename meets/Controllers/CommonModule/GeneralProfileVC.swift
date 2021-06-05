//
//  GeneralProfileVC.swift
//  meets
//
//  Created by top Dev on 9/28/20.
//

import UIKit
import Twinkle

class GeneralProfileVC: BaseVC {

    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_usercontent: UILabel!
    @IBOutlet weak var txv_about: UITextView!
    @IBOutlet weak var lbl_likenumber: UILabel!
    @IBOutlet weak var uiv_like: UIView!
    @IBOutlet weak var imv_like: UIImageView!
    @IBOutlet weak var imv_profile: UIImageView!
    @IBOutlet weak var uiv_likeEffecct: UIView!
    
    var islike: Bool = false
    var likeNumber: Int?
    var user: UserModel?
    var chattingOption: ChattingOptionVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI(user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiv_likeEffecct.isHidden = true
        self.addleftButton()
        self.addRightBtn()
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func addRightBtn() {
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage (named: "more")!.withRenderingMode(.alwaysTemplate), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreBtnClicked), for: .touchUpInside)
        moreBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        moreBtn.tintColor = UIColor.white
        let moreBtnItem = UIBarButtonItem(customView: moreBtn)
        moreBtnItem.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        moreBtnItem.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.navigationItem.rightBarButtonItem = moreBtnItem
    }
    
    @objc func moreBtnClicked() {
        if thisuser!.isValid{
            self.presentAlert(from: view, index: user?.id ?? 0)
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    
    public func presentAlert(from sourceView: UIView, index: Int) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let action = self.action(title: Messages.BLOCKTHISUSER, index: index) {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: Messages.CANCEL, style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    private func action(title: String, index: Int) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if title != "Cancel"{
                print("clicked===>\(index)")
                self.showLoadingView(vc: self)
                ApiManager.setBlockUser(user_id: "\(index)") { (isSuccess, data) in
                    self.hideLoadingView()
                    if isSuccess{
                        self.showAlert()
                    }else{
                        self.showAlerMessage(message: Messages.NETISSUE)
                    }
                }
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: nil, message: Messages.BLOCK_USER_SUCCESS, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.navigationController?.popViewController(animated: false)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
    func setLikeView(_ islikeState: Bool)  {
        if islikeState{
            self.uiv_like.backgroundColor = UIColor.init(named: "color_Primary")
            self.imv_like.image = UIImage.init(named: "like_filled")
        }else{
            self.uiv_like.backgroundColor = .lightGray
            self.imv_like.image = UIImage.init(named: "like")
        }
    }
    
    func setUI(_ user: UserModel?)  {
        if let userphoto = user?.user_photo{
            let url = URL(string: userphoto )
            imv_profile.kf.setImage(with: url,placeholder: UIImage.init(named: "logo"))
        }
        self.title = "プロフィール"
        self.lbl_username.text = user?.user_name
        self.txv_about.text = user?.aboutme
        self.lbl_usercontent.text = user!.user_location! + " " + "|" + " " + getAgeFromString(user!.user_birthday!)
        self.lbl_likenumber.text = "\(user?.likeNumber ?? 0)"
        self.likeNumber = user?.likeNumber ?? 0
        // TODO: must be set of like state
        self.setLikeView(self.islike)
    }
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        
        if thisuser!.isValid{
            self.islike = !self.islike
            if self.islike{
                ApiManager.follow(owner_id: user?.id ?? 0) { (isSuccess, data) in
                    if isSuccess{
                        if let likeNum = self.likeNumber{
                            UIView.animate(withDuration: 0.5) {
                                self.uiv_likeEffecct.isHidden = false
                                self.uiv_likeEffecct.twinkle()
                            }
                            self.lbl_likenumber.text = "\(likeNum + 1)"
                            self.likeNumber = likeNum + 1
                            DispatchQueue.main.asyncAfter(deadline:.now() +  3.0) {
                                UIView.animate(withDuration: 0.5) {
                                    self.uiv_likeEffecct.isHidden = true
                                }
                            }
                        }
                    }else{
                        self.showToast(Messages.NETISSUE)
                    }
                }
                
            }else{
                ApiManager.unfollow(owner_id: user?.id ?? 0) { (isSuccess, data) in
                    if isSuccess{
                        if let likeNum = self.likeNumber{
                            self.lbl_likenumber.text = "\(likeNum - 1)"
                            self.likeNumber = likeNum - 1
                        }
                    }else{
                        self.showToast(Messages.NETISSUE)
                    }
                }
                
            }
            self.setLikeView(self.islike)
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
    
    @IBAction func gotoEditProfile(_ sender: Any) {
        // TODO: goto message send view
        if thisuser!.isValid{
            chattingOptionVC = self.chattingOption
            if let user = self.user{
                self.gotoMessageSendVC(user)
            }
        }else{
            self.gotoVCModal(VCs.SIGNREQUEST)
        }
    }
}


