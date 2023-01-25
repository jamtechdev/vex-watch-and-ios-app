//
//  UserDefaults+Extension.swift
//  MentorPOS
//
//  Created by admin on 3/3/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    
    static var language:String {
        set(input){
            self.standard.setValue(input, forKey: "language")
        }
        get{
            return self.standard.value(forKey: "language") as? String ?? ""
        }
    }
    
    static var accessToken:String {
         set(input){
             self.standard.setValue(input, forKey: "access_token")
         }
         get{
             return self.standard.value(forKey: "access_token") as? String ?? ""
         }
     }
    
    static var baseUrl:String {
        set(input){
            self.standard.setValue(input, forKey: "base_Url")
        }
        get{
            return self.standard.value(forKey: "base_Url") as? String ?? ""
        }
    }
    static var refreshToken:String {
         set(input){
             self.standard.setValue(input, forKey: "refresh_token")
         }
         get{
             return self.standard.value(forKey: "refresh_token") as? String ?? ""
         }
     }
    static var firebaseToken:String {
        set(input){
            self.standard.setValue(input, forKey: "firebase_token")
        }
        get{
            return self.standard.value(forKey: "firebase_token") as? String ?? ""
        }
        }
    static var deviceId:String {
          set(input){
              self.standard.setValue(input, forKey: "deviceId")
          }
          get{
              return self.standard.value(forKey: "deviceId") as? String ?? ""
          }
      }
    
    static var userData:Data {
          set(input){
            self.standard.setValue(input, forKey: "userData")
          }
          get{
         
            return self.standard.value(forKey: "userData") as! Data
          }
      }
    
    static var userName:String{
        set(input){
          self.standard.setValue(input, forKey: "userName")
        }
        get{
       
          return self.standard.value(forKey: "userName") as? String ?? ""
        }
    }
    
    static var userImage:String{
        set(input){
          self.standard.setValue(input, forKey: "userImage")
        }
        get{
       
          return self.standard.value(forKey: "userImage") as? String ?? ""
        }
    }
    
	static var classCodeValue:String{
		set(input){
			self.standard.setValue(input, forKey: "classCodeValue")
		}
		get{
			
			return self.standard.value(forKey: "classCodeValue") as? String ?? ""
		}
	}
	
	static var loginValue:String{
		set(input){
			self.standard.setValue(input, forKey: "loginValue")
		}
		get{
			
			return self.standard.value(forKey: "loginValue") as? String ?? ""
		}
	}
	
    static var useFaceId:Bool{
        set(input){
          self.standard.setValue(input, forKey: "useFaceId")
        }
        get{
       
          return self.standard.value(forKey: "useFaceId") as? Bool ?? false
        }
    }
	
	static var isStreamStarted:Bool{
		set(input){
			self.standard.setValue(input, forKey: "isStreamStarted")
		}
		get{
			
			return self.standard.value(forKey: "isStreamStarted") as? Bool ?? false
		}
	}
	
	static var userPassword:String{
		set(input){
			self.standard.setValue(input, forKey: "userPassword")
		}
		get{
			
			return self.standard.value(forKey: "userPassword") as? String ?? ""
		}
	}
    
    static var userId:Int{
        set(input){
          self.standard.setValue(input, forKey: "userId")
        }
        get{
          return self.standard.value(forKey: "userId") as? Int ?? 0
        }
    }
    
    static var userEmail:String{
        set(input){
          self.standard.setValue(input, forKey: "userEmail")
        }
        get{
       
          return self.standard.value(forKey: "userEmail") as? String ?? ""
        }
    }
	
	static var userEmailPass:[[String:Any]]{
		set(input){
			self.standard.setValue(input, forKey: "userEmailPass")
		}
		get{
			
			return self.standard.value(forKey: "userEmailPass") as? [[String:Any]] ?? [[String:Any]]()
		}
	}
    
    static var settingData:Data {
          set(input){
            self.standard.setValue(input, forKey: "settingData")
          }
          get{
         
            return self.standard.value(forKey: "settingData") as! Data
          }
      }
    static var Houtlet:String {
        set(input){
            self.standard.setValue(input, forKey: "Houtlet")
        }
        get{
            return self.standard.value(forKey: "Houtlet") as? String ?? ""
        }
    }
    
    static var walkThroughEnabled:String {
        set(input){
            self.standard.setValue(input, forKey: "walkThroughEnabled")
        }
        get{
            return self.standard.value(forKey: "walkThroughEnabled") as? String ?? ""
        }
    }
}
