//
//  AdShowVC.swift
//  meets
//
//  Created by top Dev on 10/19/20.
//

import UIKit
import GoogleMobileAds
import SwiftyJSON

class AdShowVC: BaseVC {

    @IBOutlet weak var uiv_dlg: UIView!
    var bannerView: GADBannerView?
    @IBOutlet weak var uiv_adview: UIView!
    @IBOutlet weak var imv_advertise: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard bannerView == nil else { return}
        
//        bannerView = addBannerView(toView: uiv_dlg, bannerViewDelegate: self, rootController: self)
    }
    
    func addBannerView(toView view: UIView, bannerViewDelegate: GADBannerViewDelegate, rootController: UIViewController) -> GADBannerView {
//        let bannerView = RMAppDelegate.adBannerView
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = Constants.admob_id
        view.addSubview(bannerView)
        // add constraints
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        /*view.addConstraints(
           [NSLayoutConstraint(item: bannerView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: bannerView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
           ])*/
        
        // load request
        //bannerView.frame = self.uiv_adview.frame
        bannerView.adSize = GADAdSizeFromCGSize(CGSize.init(width: Constants.SCREEN_WIDTH - 20, height: 300))
        bannerView.load(GADRequest())
        
        bannerView.delegate = bannerViewDelegate
        bannerView.rootViewController = rootController
        
        return bannerView
    }
    
    @IBAction func adShowbtnClicked(_ sender: Any) {
        guard bannerView == nil else { return}
        bannerView = addBannerView(toView: uiv_dlg, bannerViewDelegate: self, rootController: self)
    }
}

extension AdShowVC: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        self.imv_advertise.isHidden = true
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
        self.dismiss(animated: false, completion: nil)
        let profiel_count = UserDefault.getInt(key: PARAMS.PROFILE_LIMIT, defaultValue: 0)
        let message_count = UserDefault.getInt(key: PARAMS.MESSAGE_LIMIT, defaultValue: 0)
        if profiel_count > Constants.profile_limit{
            let new_profile_count = 0
            UserDefault.setInt(key: PARAMS.PROFILE_LIMIT, value: new_profile_count)
            UserDefault.Sync()
        }else if message_count > Constants.message_limit{
            let new_message_count = 0
            UserDefault.setInt(key: PARAMS.MESSAGE_LIMIT, value: new_message_count)
            UserDefault.Sync()
        }
    }
}
