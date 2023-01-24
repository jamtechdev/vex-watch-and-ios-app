//
//  Utilities.swift
//  MentorPOS
//
//  Created by admin on 3/3/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


//var userModelData = SignInDataModel(JSON: [String : Any]())
//var userModelData2 = SignInDataModel(JSON: [String : Any]())
//var appVersion = ""

class Utilities:NSObject{
    
    static let sharedInstance = Utilities()
//    var fullUrl = "https://\(Utilities.sharedInstance.baseUrl).mentorpos.com/api/"
    
    override private init() {
        super.init()
    }
    
    
    //MARK:- NUMBER FILER
    
    func numberFiler(string:String) -> Bool
    {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if string != numberFiltered
        {
            return false
            //return true // not a number
        }
        //return false
        return true
    }
    
    func getPrecisedFormat(format:String, value:String) -> String{
        let floatValue = Float(value) ?? 0
        let stringValue = String(format: format, floatValue)
        return stringValue
    }
    
    
//    func clearBackgroundColor(searchBar:UISearchBar) {
//        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
//
//        for view in searchBar.subviews {
//            for subview in view.subviews {
//                if subview.isKind(of: UISearchBarBackground) {
//                    subview.alpha = 0
//                }
//            }
//        }
//        searchBar.placeholder = "Search"
//		searchBar.searchTextField.font = UIFont(name: "Lato-Regular", size: 16)
////        searchBar.layer.borderWidth = 1
//
////        searchBar.layer.borderColor = UIColor.gray.cgColor
////        searchBar.layer.cornerRadius = 5
//
//        let txt:UITextField = searchBar.value(forKey: "searchField") as! UITextField
//
//
//        txt.textColor = UIColor.defaultBlackColor
//        txt.backgroundColor = UIColor.clear
//        txt.clearButtonMode = UITextField.ViewMode.never
//        txt.leftViewMode = .always
//        txt.textAlignment = .left
//        txt.returnKeyType = .search
//		txt.setLeftPaddingPoints(0)
////        txt.leftViewMode = UITextField.ViewMode.never
////        txt.rightViewMode = UITextField.ViewMode.never
//
//
//    }
    
    func presentStatusVC(title:String,message:String,source:UIViewController, isSuccess:Bool){
//        let vc = self.getVC(storyBoardName: "Main", vcId: "ErrorSuccessViewControllerID") as! ErrorSuccessViewController
//        vc.isStatus = title
//        vc.showData = message
//        vc.isSuccess = isSuccess
//        source.present(vc, animated: true)
    }
    
//    func showAlert(title:String,message:String,logout:Bool,completion:@escaping () -> ())
//    {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//            if logout{
//            logOut()
////            UserDefaults.accessToken = ""
////            appDel.navigateToLandingScreen()
//            }
//            else{
//                completion()
//            }
//        }))
//        if UIApplication.topViewController() is UIAlertController{
//            return
//        }
//        UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
//    }
    
     func showAlertController(title:String,message:String,sourceViewController:UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            print("Okay Button Pressed...")
        }
        
        alertController.addAction(okButton)
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert2(title:String,message:String,sourceViewController:UIViewController,completionHandler: @escaping (_ result:Bool) -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            completionHandler(true)
            print("Okay Button Pressed...")
        }
        
//        let cancelButton = UIAlertAction(title: "No", style: .default)
//        { (alertAction) in
//            print("Cancel Button Pressed..")
//        }
        
        alertController.addAction(okButton)
//        alertController.addAction(cancelButton)
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert3(title:String,message:String,sourceViewController:UIViewController,completionHandler: @escaping (_ result:Bool) -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            completionHandler(true)
            print("Okay Button Pressed...")
        }
        
        let cancelButton = UIAlertAction(title: "No", style: .default)
        { (alertAction) in
            print("Cancel Button Pressed..")
        }
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:Get ViewController
    
    func getVC(storyBoardName:String, vcId:String) -> UIViewController{
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: vcId)
        return vc
    }
    
    
    //MARK:Date Conversion
    
    func convertStringDate(date:String) -> Date?{
        let isoDate = date

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.date(from:isoDate)
        return convertedDate
    }
    
    func convertDate(date:String, format:String) -> Date?{
        let day = date
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US") // set locale to reliable US_POSIX
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.locale = Locale.current
        dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from:day)!
        return date
    }
	
	func getStringDateFromDate(date:Date, format:String) -> String{
		let formatter = DateFormatter()
		formatter.dateFormat = format
		let stringDate = formatter.string(from: date)
		return stringDate
	}
    
    func getCurrentDate(format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
    
    func getFormattedDateFromString(dateString:String,toFormat:String,fromFormat:String,timeZone:String) -> String{
        
        if dateString == ""
        {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        dateFormatter.timeZone = timeZone != "" ? TimeZone(identifier: timeZone) : TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = fromFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        guard let getData = dateFormatter.date(from: dateString) else { return ""}
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: getData)
        
    }
    
   
    
    
//MARK:- ATTRIBUTED TEXT
    
    func getAttributedText(string : NSString , strToReplace : NSString , setColor : UIColor) -> NSAttributedString
    {
        let attributedString1 = NSMutableAttributedString(string: "\(string)")
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: setColor, range: string.range(of: strToReplace as String))
        return attributedString1
    }
    
    func getAttributedFont(string : NSString , strToReplace : NSString , fontType : UIFont) -> NSAttributedString
    {
      let attributedString1 = NSMutableAttributedString(string: "\(string)")
        attributedString1.addAttribute(NSAttributedString.Key.font, value: fontType, range: string.range(of: strToReplace as String))
      return attributedString1
    }
    
    
    func getAttributedText2(stringToChange:String, unchangedString:String, font1:UIFont, font2:UIFont) -> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: stringToChange, attributes: [NSAttributedString.Key.font: font1])
        
        attributedText.append(NSAttributedString(string: unchangedString, attributes: [NSAttributedString.Key.font: font2, NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        return attributedText
    }
    
    //MARK:- CONVERT MODEL TO JSON
    
//    func convertModelToJSON(createOrderData:CreateOrderModel) -> [String:Any]{
//        let encoder = JSONEncoder()
//
//              guard let jsonData = try? encoder.encode(createOrderData) else { return [String:Any]()}
//              guard let dataDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] else { return [String:Any]()}
//        return dataDict
//
//    }
    
}//closing of Utilities


//MARK:- CHECK FOR NIL AND NULL

func checkForNilAndNull(dictionary:[String:Any],key:String) -> Bool
{
    if dictionary[key] == nil || dictionary[key] is NSNull{
        return false
    }
    return true
}

extension Encodable {

    /// Converting object to postable dictionary
//    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
//        encoder.outputFormatting = .prettyPrinted
//        let data = try encoder.encode(self)
//        let object = try JSONSerialization.jsonObject(with: data)
////        guard let json = object as? [String: Any] else {
//////            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
//////            throw DecodingError.typeMismatch(type(of: object), context)
////        }
//        return json
//    }

      func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
      }
}
//    
//  
//    
//    //MARK:Date Formats
//    
//    
//    
//}
extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}


//func logOut(){
//     CommonService.requestWith(APIManager.logOut) { (json, error, code, header) in
//           if code == 200{
//            UserDefaults.accessToken = ""
//            selectedIndexPath.row = 0
////                Houtlet = "1"
//            UserDefaults.Houtlet = ""
////            selectedOutletIndex = 0
//            userModelData = UserModel(JSON: [String : Any]())
//            appDel.navigateToLandingScreen()
//           }
//       }
//}
