//
//  WatchConnectivityClass.swift
//  VexWatch Watch App
//
//  Created by Jamtech 01 on 08/12/22.
//

import Foundation
import WatchConnectivity
import SwiftUI
import WatchKit

class WatchConnectivityViewModel : NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
	@Published var isStreamFromPhone = false
	@State var isStreamFromPhone2 = false
	@Published var isSessionEnded = ""
	@Published var isSuccessfulLoginFromPhone = ""
	
    init(session: WCSession = .default){
		if WCSession.isSupported(){
			self.session = session
			super.init()
			self.session.delegate = self
			session.activate()
		}
        else{
			self.session = session
			super.init()
			print("Session not supported")
		}
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("userInfo:========== \(userInfo)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("applicationContext:========== \(applicationContext)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("ActivationState==========>", activationState)
    }
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		print("************************",message)
		DispatchQueue.main.async {
			print("************************",message)
			self.isStreamFromPhone = message["isStreamStarted"] as? Bool ?? false
			self.isSuccessfulLoginFromPhone = message["isSuccessfulLoginFromPhone"] as? String ?? ""
            UserDefaults.standard.setValue(message["isSuccessfulLoginFromPhone"] as? String ?? "", forKey: "ok")
			self.isSessionEnded = message["sessionEnded"] as? String ?? ""
//			print(self.isSessionEnded)
			
		}
	}
    
}
