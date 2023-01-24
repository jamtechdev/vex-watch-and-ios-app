//
//  TerraViewModel.swift
//  Vex
//
//  Created by Jamtech 01 on 13/12/22.
//

import Foundation
import TerraRTiOS
import SwiftUI

class TerraViewModel : NSObject, ObservableObject {
    
    
    let terra : TerraRT? = nil
    @Published var token : String = ""
	var isStreamStarted = false
    
   
	let terraRt = TerraRT(devId: "vex-fitness-dev-9fESfy2QgQ", referenceId: "f5491477daf64f44ce53489234d77cacaac5f24ed80411d00ad353234144d700") {_ in
//        print("the sucees", _isSuccess)
//        if _isSuccess {
//
//        }
    }
    
    func settingUpTerra(byToken token : String, complitionHandler : @escaping() -> Void) {
		DispatchQueue.main.async {
			print(token)
			self.token = token
		}
        print("the params token \(token) and the published var token \(self.token)")
		self.generateAuthToken { token in
			self.terraRt.initConnection(token:token) { isAuth in
				let userId = self.terraRt.getUserid()
				print("UserId=======>>>>>>>",userId as Any)
				print("the token auth", isAuth)
				self.saveUserId(userId: userId ?? "")
				complitionHandler()
				
			}
		}
        
//        self.streamData()
        
    }
	
	func generateAuthToken(complitionHandler : @escaping(String) -> Void){
		var urlRequest = URLRequest(url: URL(string: "https://api.tryterra.co/v2/auth/generateAuthToken")!)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
		urlRequest.allHTTPHeaderFields = ["dev-id": "vex-fitness-dev-9fESfy2QgQ" ,"X-API-Key":"f5491477daf64f44ce53489234d77cacaac5f24ed80411d00ad353234144d700"]
		
		do {
			
//			let param : [String : String] = [
//				"terra_user_id": userId
//			]
			
			let request = try JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
			
			urlRequest.httpBody = request
			
			URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
				
				if httpData?.count ?? 0 > 0 && httpError == nil {
					
					let strData = String(data: httpData!, encoding: .utf8)
					
					do {
						
						let jsonData = try JSONSerialization.jsonObject(with: httpData!, options: .mutableContainers)
						print("the json data", jsonData)
						if let success = jsonData as? [String : Any] {
							
							if let status = success["status"] as? String {
								
								complitionHandler(success["token"] as? String ?? "")
								
							}
							
						}
						
					} catch {
						debugPrint("Error occured while decoding response", error)
					}
					
				} else {
					
					print("Error in response", httpError?.localizedDescription)
					
				}
				
			}.resume()
			
		} catch {
			debugPrint("error occured while decoding body", error)
		}
	}
	
	func postHeartRate(complitionHandler : @escaping(String) -> Void){
		var urlRequest = URLRequest(url: URL(string: "https://o5dgnltzhf.execute-api.us-west-1.amazonaws.com/staging/v1/postHeartRate")!)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
		urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(UserDefaults.accessToken)"]
		
		do {
			
						let param : [String : Any] = [
							"heart_rate": Int(UserDefaults.standard.string(forKey: "heartRate") ?? "") ?? 0
						]
			
			let request = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
			
			urlRequest.httpBody = request
			
			URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
				
				if httpData?.count ?? 0 > 0 && httpError == nil {
					
					let strData = String(data: httpData!, encoding: .utf8)
					
					do {
						
						let jsonData = try JSONSerialization.jsonObject(with: httpData!, options: .mutableContainers)
						print("the heart data", jsonData)
						if let success = jsonData as? [String : Any] {
							
							if let status = success["status"] as? Int {
								
								complitionHandler(success["token"] as? String ?? "")
								
							}
							
						}
						complitionHandler("")
					} catch {
						debugPrint("Error occured while decoding response", error)
					}
					
				} else {
					
					print("Error in response", httpError?.localizedDescription)
					
				}
				
			}.resume()
			
		} catch {
			debugPrint("error occured while decoding body", error)
		}
	}
	
	func endStreaming(complitionHandler : @escaping(String) -> Void){
		var urlRequest = URLRequest(url: URL(string: "https://o5dgnltzhf.execute-api.us-west-1.amazonaws.com/staging/v1/stopStream")!)
		urlRequest.httpMethod = "GET"
		urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
		urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(UserDefaults.accessToken)"]
		
		do {
			
//			let request = try JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
//			
//			urlRequest.httpBody = request
			
			URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
				
				if httpData?.count ?? 0 > 0 && httpError == nil {
					
					let strData = String(data: httpData!, encoding: .utf8)
					
					do {
						
						let jsonData = try JSONSerialization.jsonObject(with: httpData!, options: .mutableContainers)
						print("the heart data", jsonData)
						if let success = jsonData as? [String : Any] {
							
							if let status = success["statusCode"] as? Int {
								
								complitionHandler(success["message"] as? String ?? "")
								
							}
							
						}
						
					} catch {
						debugPrint("Error occured while decoding response", error)
					}
					
				} else {
					
					print("Error in response", httpError?.localizedDescription)
					
				}
				
			}.resume()
			
		} catch {
			debugPrint("error occured while decoding body", error)
		}
	}
    
    func generateWidgetSession(complitionHandler : @escaping(String) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "https://api.tryterra.co/v2/auth/generateWidgetSession")!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.allHTTPHeaderFields = ["dev-id": "vex-fitness-dev-9fESfy2QgQ" ,"X-API-Key":"f5491477daf64f44ce53489234d77cacaac5f24ed80411d00ad353234144d700"]
        
        do {
            
            let param : [String : String] = [
                "reference_id": "",
                "providers": "APPLE",
                "auth_success_redirect_url": "",
                "auth_failure_redirect_url": "https://sad-developer.com",
                "language": "EN"
            ]
            
            let request = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            
            urlRequest.httpBody = request
            
            URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
                
                if httpData?.count ?? 0 > 0 && httpError == nil {
                    
                    let strData = String(data: httpData!, encoding: .utf8)
                    
                    do {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: httpData!, options: .mutableContainers)
                        print("the json data", jsonData)
                        
                        if let success = jsonData as? [String : Any] {
                            
                            if let status = success["status"] as? String {
                                
                                complitionHandler(success["url"] as? String ?? "")
                                
                            }
                            
                        }
                        
                    } catch {
                        debugPrint("Error occured while decoding response", error)
                    }
                    
                } else {
                    
                    print("Error in response", httpError?.localizedDescription)
                    
                }
                
            }.resume()
            
        } catch {
            debugPrint("error occured while decoding body", error)
        }
    }
	
	func saveUserId(userId:String){
		var urlRequest = URLRequest(url: URL(string: "https://o5dgnltzhf.execute-api.us-west-1.amazonaws.com/staging/v1/saveTerraUserId")!)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
		urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "TerraToken") ?? "")"]
		
		do {
			
			let param : [String : String] = [
				"terra_user_id": userId
			]
			
			let request = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
			
			urlRequest.httpBody = request
			
			URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
				
				if httpData?.count ?? 0 > 0 && httpError == nil {
					
					let strData = String(data: httpData!, encoding: .utf8)
					
					do {
						
						let jsonData = try JSONSerialization.jsonObject(with: httpData!, options: .mutableContainers)
						print("the json data", jsonData)
						self.genrateUserIdToken(userId: userId)
					} catch {
						debugPrint("Error occured while decoding response", error)
					}
					
				} else {
					
					print("Error in response", httpError?.localizedDescription)
					
				}
				
			}.resume()
			
		} catch {
			debugPrint("error occured while decoding body", error)
		}
	}
	
	func genrateUserIdToken(userId:String){
		var urlRequest = URLRequest(url: URL(string: "https://ws.tryterra.co/auth/user?id=\(userId)")!)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
		urlRequest.allHTTPHeaderFields = ["dev-id": "vex-fitness-dev-9fESfy2QgQ" ,"X-API-Key":"f5491477daf64f44ce53489234d77cacaac5f24ed80411d00ad353234144d700"]
		
		do {
			
			let request = try JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
			
			urlRequest.httpBody = request
			
			URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
				
				if httpData?.count ?? 0 > 0 && httpError == nil {
					
					let strData = String(data: httpData!, encoding: .utf8)
					
					do {
						
						let jsonData = try JSONSerialization.jsonObject(with: httpData!, options: .mutableContainers)
						print("the json data", jsonData)
						let data = jsonData as! [String:Any]
						self.streamData(token: data["token"] as! String)
						
					} catch {
						debugPrint("Error occured while decoding response", error)
					}
					
				} else {
					
					print("Error in response", httpError?.localizedDescription)
					
				}
				
			}.resume()
			
		} catch {
			debugPrint("error occured while decoding body", error)
		}
	}
    
    
    func settingUpTheBLE() {
        
		terraRt.startBluetoothScan(type: .APPLE, callback: { isSuccess in
            
            print("the success", isSuccess)
            
        })
        
    }
	
	func connectWatchApp(){
		try? terraRt.connectWithWatchOS()
	}
    
	func streamData(token:String) {
		terraRt.startRealtime(type: .WATCH_OS, dataType: Set(arrayLiteral: .HEART_RATE), token: token)
    }
    
    func stopStreaming() {
		terraRt.stopRealtime(type: .WATCH_OS)
    }
    
}
