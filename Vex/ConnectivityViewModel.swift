//
//  ConnectivityViewModel.swift
//  Vex
//
//  Created by Jamtech 01 on 13/12/22.
//

import Foundation
import WatchConnectivity
import SwiftUI

class IphoneConnectivityViewModel : NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
	var timeStamp1 = TimeInterval()
	var diffTimeStamp = TimeInterval()
	@Published var navigationFlag = false
    @Published var heartRate = 0
	@Published var isStreamFromWatch = false
    @Published var startAndOff = ""
	@State var isStreamFromWatch2 = false
	@Published var isDataLoadedOnPhone = false
	@Published var classCodeValue : String = ""
	@Published var isClassCodeVerifiedOnWatch = false
	@Published var isStopSessionFromWatch = ""
    @Published var token = ""
	var terraViewMode = TerraViewModel()
	var isStreamStarted = false
    
    
	init(session: WCSession = .default) {
		self.timeStamp1 = Date().timeIntervalSince1970
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
//			self.timeStamp1 = Date().timeIntervalSince1970
			
			self.diffTimeStamp = Date().timeIntervalSince1970 - self.timeStamp1
			print("Difference in time===>>>>", self.diffTimeStamp)
			self.timeStamp1 = Date().timeIntervalSince1970
//			if self.diffTimeStamp > 0.9{
//				self.navigationFlag = true
//			}else{
////				if self.diffTimeStamp > 0.9{
////					self.navigationFlag = false
////				}else{
////					self.navigationFlag = true
////				}
//				self.navigationFlag = false
//			}
			self.heartRate = message["currentHeartRate"] as? Int ?? 0
			print("Hello I have reached", Date().timeIntervalSince1970)
            print(message)
			self.isStreamFromWatch = message["isStreamStarted"] as? Bool ?? false
			self.isStreamFromWatch2 = message["isStreamStarted"] as? Bool ?? false
			self.isDataLoadedOnPhone = message["isDataLoadedOnPhone"] as? Bool ?? false
			self.classCodeValue = message["classCodeValue"] as? String ?? ""
			self.isClassCodeVerifiedOnWatch = message["isClassCodeVerifiedOnWatch"] as? Bool ?? false
			self.isStopSessionFromWatch = message["isStopSessionFromWatch"] as? String ?? ""
            self.startAndOff = message["startAndOff"] as? String ?? ""
                        
            if self.startAndOff == "1" {
                self.terraViewMode.postHeartRate(){_ in
                }
            }
            else if self.startAndOff == "2" {
                self.terraViewMode.endStreaming(){_ in
                    DispatchQueue.main.async {
                        self.startAndOff = ""
                    }
                }
                
            }
            
			UserDefaults.isStreamStarted = message["isStreamStarted"] as? Bool ?? false
			UserDefaults.standard.set(self.heartRate, forKey: "heartRate")
            print("the heart reate", self.heartRate)
            if let token = message["token"] as? String {
				print(token)
                self.token = token
                print("the token from watch", self.token)
            }
            
        }
       
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Iphone session is inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Iphone session is deactivate")
    }
    
    
}

extension Date {
	var millisecondsSince1970: Int64 {
		Int64((self.timeIntervalSince1970 * 1000.0).rounded())
	}
}


