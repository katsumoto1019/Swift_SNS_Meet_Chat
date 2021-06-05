//
//  Constants.swift
//  emoglass
//
//  Created by Mac on 7/7/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

//public let GOOGLE_PLACES_API_KEY = "AIzaSyDIy5OhjI6sI_SpqwMc-VIrdkWSRQfI6Ic"
public let GOOGLE_PLACES_API_KEY = "AIzaSyAkM5hztqgNfAZ2peq1j_C3jz28DfsRVbw"
struct Constants {
    static let PROGRESS_COLOR      = UIColor.black
    static let SAVE_ROOT_PATH      = "save_root"
    static let SCREEN_HEIGHT       = UIScreen.main.bounds.height
    static let SCREEN_WIDTH        = UIScreen.main.bounds.width
    static let TENOR_API_KEY       = "8QGMQYVHRCBT"
    static let deviceToken         = UIDevice.current.identifierForVendor!.uuidString
    static let mapBoxAccessToken    = "pk.eyJ1IjoiaG15b25nc29uZyIsImEiOiJjazc3aTJ6amwwODZnM2hsa2VwZnU5OGxvIn0.WzP_Y-tKr0U1jQWTJMCBeQ"
    
    static var mapbox_api = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    static var mapbox_access_token = Constants.mapBoxAccessToken
    static var SERVER_DOMAIN = "http://localhost/meet_app/"
    static let TERMS_LINK    = SERVER_DOMAIN + "terms"
    static let PRIVACY_LINK  = SERVER_DOMAIN + "privacy"
//    static let admob_id    = "ca-app-pub-9097716631152830/1485976526" // real id
    static let admob_id = "ca-app-pub-3940256099942544/6300978111" //test id
    static let profile_limit = 15
    static let message_limit = 30
}

struct TestData {
    static let images = ["https://i.pinimg.com/564x/43/21/e6/4321e657a1bb66da9d898c107150a192.jpg",
                    "https://i.pinimg.com/236x/05/3f/14/053f14c2848b277ad5733cddfea8add3.jpg",
                    "https://i.pinimg.com/236x/35/81/fd/3581fdcac2712c336ad397a1569e8712.jpg",
                    "https://i.pinimg.com/236x/42/26/93/422693374aee5bee79657fc4d7a750bd.jpg",
                    "https://i.pinimg.com/236x/e7/10/29/e7102938bc64cb5303616616647b69ab.jpg",
                    "https://i.pinimg.com/236x/79/92/fc/7992fc5e5986a22fcc97a18df45f2f3a.jpg",
                    "https://i.pinimg.com/236x/b4/40/4a/b4404a0052a23c540e07f4ce88540c97.jpg",
                    "https://i.pinimg.com/236x/5f/21/8f/5f218f7ae414726ff55c53c83ad6386a.jpg",
                    "https://i.pinimg.com/236x/25/7b/b3/257bb3e1e1e4f9f8d68f75abbf312b23.jpg",
                    "https://i.pinimg.com/236x/30/1b/bb/301bbb583bd3485073c63ed0ef46c66f.jpg"]
    static let userNames = ["Rin","Kei","Kanna","Koharu","Mio","Tsumugi","Emika","Kokoro","Nozomi","Kumiko"]
    static let userAge = ["23","25","20","26","24","19","21","20","25","24"]
    static let postTime = ["2s","5s","10s","1min","2min","5min","8min","10min","12min","20min"]
    static let userLocation = ["Fukuoka","Iyo","Gunma","Sumitomo Mitsui","Wakayama","Hokkaido","Kanagawa","Okayama","Tokyo","Suruga"]
    static let postContent = ["猫の手も借りたい","目の中に入れても痛くない","耳にたこができる","喉から手が出る","まな板の上の鯉","ほっぺたが落ちる","雀の涙","烏の行水","犬猿の仲","箸より重いものを持ったことがない"]
    static let likeNum = [10, 13, 45, 67, 43, 23, 34, 34, 64, 67]
}

struct SettingOptions{
    static let settingOption = ["マイアカウント","お気に入りリスト","ブロックリスト","通知","利用規約","個人情報保護方針","お問い合わせ","パスワードを変更する","アカウントを閉じる","ログアウト"]
    
    static let images = ["icon_user","likelist","blocklist","noti","terms","privacy","contactus","lock","logout","logout"]
}

struct VCs {
    static let BLOCKUSERVC        = "BlockUserVC"
    static let CHATVC             = "ChatVC"
    static let EDITPROFILE        = "EditProfileVC"
    static let EDITPROFILENAV     = "EdtiProfileNav"
    static let GENERALPROFILEVC   = "GeneralProfileVC"
    static let GIFSEARCH          = "SearchVC"
    static let HOMETABBARVC       = "HomeTabBarVC"
    static let HOMEVC             = "HomeVC"
    static let LIKEVC             = "LikeVC"
    static let LOGINAV            = "LoginNav"
    static let MESSAGESENDNAV     = "MessageSendNav"
    static let MESSAGESENDVC      = "MessageSendVC"
    static let MYACCOUNT          = "MyaccountVC"
    static let NOTIFICATIONVC     = "NotificationVC"
    static let PEOPLEVC           = "PeopleVC"
    static let PICTUREATTACHPOPUP = "PictureAttachVC"
    static let PROFILEVC          = "ProfileVC"
    static let SIGNREQUEST        = "SigninRequestVC"
    static let SUPPORT            = "SupportVC"
    static let ADSHOWVC           = "AdShowVC"
}

struct Messages {
    
    static let ADD_LOCATION             = "あなたの場所を追加してください。"
    static let ADD_PHOTO                = "写真を追加してください。"
    static let BIRTHDAY                 = "誕生日"
    static let BIRTHDAY_REQUIRE         = "誕生日を追加してください。"
    static let BLOCKTHISUSER            = "このユーザーをブロックする"
    static let BLOCK_USER_SUCCESS       = "このユーザーはブロックされています"
    static let CANCEL                   = "取消"
    static let CONFIRM_PASSWORD         = "パスワードを認証する"
    static let CONFIRM_PASSWORD_MATCH   = "パスワードが一致していることを確認してください。"
    static let CONTACT_US               = "お問い合わせ"
    static let FAVORITELIST             = "お気に入りリスト"
    static let IMAGE_UPLOAD_FAIL        = "画像のアップロードに失敗しました。"
    static let LOCATION                 = "場所"
    static let LOOK_FOR                 = "プロフ検索"
    static let MESSAGE                  = "メッセージ"
    static let MY_ACCOUNT               = "マイアカウント"
    static let MY_PAGE                  = "マイページ"
    static let NETISSUE                 = "ネットワークの問題。"
    static let NOTIFICATION             = "通知"
    static let NO_ARTICLE_PREVIOUS_POST = "あなたが以前に投稿したり、フォローしている記事がありません。"
    static let PASSWORD                 = "パスワード"
    static let PASSWORD_INCORRECT       = "正しくないパスワード。"
    static let PASSWORD_REQUIRE         = "パスワードを入力してください。"
    static let POST_TEXT_REQUIRE        = "投稿テキストを入力してください。"
    static let PROFILE                  = "プロフィール"
    static let REPLY_TEXT_REQUIRE       = "返信テキストを入力してください。"
    static let REPORT_SUCCESS           = "正常に報告されました"
    static let REPORT_THIS_POST         = "この投稿を報告する"
    static let RESET_PASSWORD           = "パスワードを再設定する"
    static let SIGNIN                   = "ログイン"
    static let SIGNUP                   = "会員登録"
    static let TERMS_AGREE              = "利用規約とプライバシーポリシーに同意しますか?"
    static let TWEET                    = "つぶやき"
    static let UPDATE_SUCCESS           = "正常な更新"
    static let USERNAME                 = "ユーザー名"
    static let USERNAME_EXIST           = "ユーザー名は既に存在します。"
    static let USERNAME_NONE_EXIST      = "ユーザー名は存在しません。"
    static let USERNAME_REQUIRE         = "ユーザー名を入力してください。"
    static let WHATS_ON_YOUR_MIND       = "つぶやいてみよう！"
}

enum ChattingOptionVC {
    case fromHome
    case fromChattingList
    case fromPeopleVC
    case fromNotiVC
    case normal
}

var chattingOptionVC: ChattingOptionVC = .normal

var openStatue: Bool = false
var chattingUser: UserModel?

enum AnimVC: Int {
    case gifSearch
    case picturePop
    case normal
}


var animVC: AnimVC? = .normal
let randomInt = Int.random(in: 0 ..< 9)


