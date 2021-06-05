//
//  AppDelegate.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import IQKeyboardManagerSwift
import UIKit
import CoreData
import FirebaseCore
import FirebaseMessaging
import EBBannerView
import UserNotifications
import GooglePlaces
import GoogleMobileAds

var thisuser:UserModel?
var deviceTokenString = ""

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = true
        
        thisuser = UserModel()
        thisuser?.loadUserInfo()
        //TODO: must be change later
        //thisuser?.id = 1
        thisuser?.saveUserInfo()
        
        FirebaseApp.configure()
        
        // push settings
        /*let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

        application.registerUserNotificationSettings(pushNotificationSettings)
        //UIApplication.shared.applicationIconBadgeNumber = 0
        registerForPushNotifications()
        application.applicationIconBadgeNumber = 0*/
        GMSPlacesClient.provideAPIKey(GOOGLE_PLACES_API_KEY)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    //MARK:-   set push notifations
    func registerForPushNotifications() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]//[.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {(granted, error) in
                if granted {
                    print("Permission granted: \(granted)")
                    DispatchQueue.main.async() {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            })
            
            Messaging.messaging().delegate = self
            Messaging.messaging().shouldEstablishDirectChannel = true
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
        
    func getRegisteredPushNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
                case .authorized, .provisional:
                    print("The user agrees to receive notifications.")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                case .denied:
                    print("Permission denied.")
                    // The user has not given permission. Maybe you can display a message remembering why permission is required.
                case .notDetermined:
                    print("The permission has not been determined, you can ask the user.")
                    self.getRegisteredPushNotifications()
                default:
                    return
            }
        })
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != [] {
            application.registerForRemoteNotifications()
        }
    }
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for notifications!")
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""

        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        let aps             = userInfo["aps"] as? [AnyHashable : Any]
        //let badgeCount      = aps!["badge"] as? Int ?? 0
        
        let alertMessage    = aps!["alert"] as? [AnyHashable : Any]
        let bodyMessage     = alertMessage!["body"] as! String
        let titleMessage    = alertMessage!["title"] as! String
        
        NotificationCenter.default.post(name: Notification.Name("changedBadgeCount"), object: nil)
        
        let banner = EBBannerView.banner({ (make) in
            make?.style     = EBBannerViewStyle(rawValue: 12)
            make?.icon      = UIImage(named: "AppIcon")
            make?.title     = titleMessage
            make?.content   = bodyMessage
            make?.date      = "Now"
        })
         
        banner?.show()
        completionHandler([])
    }
}
//
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Messaging.messaging().subscribe(toTopic: "all")
        deviceTokenString = fcmToken
        print("fcmToken: ", fcmToken)
        
//        let sender = PushNotificationSender()
//        let tk = "ffK7OmRn30cRt2vja4kT9P:APA91bEsrvHzlqF3k6iLNNVJJuU4DuXqNxfrICShG5sOK1HkAGaKKN6Sr6vM85VII2Av31D-QdLGwGCuCRREQAyqTwZoXGn8j1oHFLc3kzg8vd3oDHNzKLdiVrBrQUuddkNvuKzGWI1Y"
//        sender.sendPushNotification(to: tk, title: APP_NAME, body: CONSTANT.NOTI_BODY, badgeCount: 5)
    }
}

