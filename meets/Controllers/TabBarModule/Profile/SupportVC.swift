//
//  SupportVC.swift
//  meets
//
//  Created by top Dev on 10/10/20.
//


import UIKit
import MessageUI


class SupportVC: BaseVC ,MFMailComposeViewControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    @IBAction func gotoMail(_ sender: Any) {
        sendEmail()
    }
    
    func setUI() {
        self.title = Messages.CONTACT_US
        self.addleftButton()
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
    
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let subject = "MeetsAppサポートチーム"
        let body = "私の名前は "
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["support@meet.email"])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: false)
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        self.showAlerMessage( message: "デバイスは電子メールを送信できませんでした。メールの設定を確認して、もう一度お試しください。")
    }
}

extension MFMailComposeViewControllerDelegate {
    
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
            
            case MFMailComposeResult.cancelled.rawValue:
                print("Cancelled")
            case MFMailComposeResult.saved.rawValue:
                print("Saved")
            case MFMailComposeResult.sent.rawValue:
                print("Sent")
            case MFMailComposeResult.failed.rawValue:
                print("Error: \(String(describing: error?.localizedDescription))")
            default:
                break
            }
        controller.dismiss(animated: true, completion: nil)
    }
}
