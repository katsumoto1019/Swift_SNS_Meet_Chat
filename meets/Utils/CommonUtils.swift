//
//  CommonUtils.swift
//  Fiit
//
//  Created by JIS on 2016/12/10.
//  Copyright © 2016 JIS. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation
import UIKit

func isValidEmail(testStr:String) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
    
}

func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

func saveWatermark(image: UIImage) -> String! {
    
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0]
    
    // current document directory
    fileManager.changeCurrentDirectoryPath(documentDirectory as String)
    
    do {
        try fileManager.createDirectory(atPath: "psj", withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let savedFilePath = "\(documentDirectory)/\("psj")/watermark.png"
    
    // if the file exists already, delete and write, else if create filePath
    if (fileManager.fileExists(atPath: savedFilePath)) {
        do {
            try fileManager.removeItem(atPath: savedFilePath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    } else {
        fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
    }
    
    if let data = resize(image: image, maxHeight: 512, maxWidth: 512, compressionQuality: 1, mode: "PNG") {
        
        do {
            try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
        } catch {
            print(error)
        }
        
    }
    
    return savedFilePath
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    
    let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

let systemSoundID = 1007

func playSound() {
    
    AudioServicesPlayAlertSound(UInt32(systemSoundID))
}

func heightForView(text:String, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

func getStrDate(_ tstamp: String) -> String {
if !tstamp.contains("/"){
    var  date : Date?
    if tstamp != ""{
         date = Date(timeIntervalSince1970: TimeInterval(tstamp)!/1000)
    }
    
    
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM/dd/yyyy hh:mm a" //Specify your format that you want MM-dd HH:mm format okay, format setting is very important if you have change any things eventhough it is very small. it will be change the format
    
    let strDate = dateFormatter.string(from: date ?? Date())
    
    return strDate
}
else{
    return tstamp
}
}
func getStrDateshort(_ tstamp: String) -> String {
    if !tstamp.contains("/"){
        let date = Date(timeIntervalSince1970: TimeInterval(tstamp)!/1000)
        
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm a" //Specify your format that you want MM-dd HH:mm format okay, format setting is very important if you have change any things eventhough it is very small. it will be change the format
        
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    else{
        return tstamp
    }
}

func validatePhoneNumber(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result = phoneTest.evaluate(with: value)
    return result
}


func saveBinaryWithName(image: UIImage, name: String) -> String! {
    
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0]
    
    // current document directory
    fileManager.changeCurrentDirectoryPath(documentDirectory as String)
    
    do {
        try fileManager.createDirectory(atPath: Constants.SAVE_ROOT_PATH, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let savedFilePath = "\(documentDirectory)/\(Constants.SAVE_ROOT_PATH)/\(name)"
    
    // if the file exists already, delete and write, else if create filePath
    if (fileManager.fileExists(atPath: savedFilePath)) {
        do {
            try fileManager.removeItem(atPath: savedFilePath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    } else {
        fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
    }
    
    if let data = resize(image: image, maxHeight: 4000, maxWidth: 3000, compressionQuality: 1, mode: "PNG") {
        
        do {
            try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
        } catch {
            print(error)
        }
    }
    
    return savedFilePath
}

func getAgeFromString(_ dateStr: String) -> String {
    let now = Date()
    var returnedString = ""
    var age = 0
    let birthday: Date? = getDateFromDateStringwithFormat(dateStr, format: "yyyy-MM-dd")
    let calendar = Calendar.current
    if let birthday = birthday{
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        age = ageComponents.year!
    }
    if age == 0{
        returnedString = ""
    }else{
        returnedString = "\(age)"
    }
    return returnedString
}

extension NSNotification.Name {
    static let chatRequest      = Notification.Name("chatRequest")
    static let acceptRequest    = Notification.Name("acceptRequest")
    static let gifSearch        = Notification.Name("gifSearch")
    static let gifSend          = Notification.Name("gifSend")
    static let gifSendSuccess   = Notification.Name("gifSendSuccess")
    static let opneGallery      = Notification.Name("openGallery")
    static let gotoChattingRoom = Notification.Name("gotoChattingRoom")
}



