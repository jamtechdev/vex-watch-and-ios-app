//
//  VerificationView.swift
//  VexWatch Watch App
//
//  Created by Digvijay Ghildiyal on 05/12/22.
//

import SwiftUI



struct VerificationView: View {
	
	var codeValue: [String]
	@Binding var rootIsActive : Bool
	@State var navigationFlag = false
	@State private var otpValue : String = ""
	@State private var status : String = ""
	@State private var otpErrorMessage : String = ""
	@State private var showingAlert = false
	@ObservedObject var connectivityViewModel = WatchConnectivityViewModel()
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject private var viewModel = VerificationViewModel()
	
	func getOtpValueIn(singleString otpArr : [String]) -> String {
		for singleOtp in otpArr {
			print("the orp data===", singleOtp)
			self.otpValue += singleOtp
		}
		
		return self.otpValue
		
	}
	
	var body: some View {
		
//		NavigationView {
			VStack{
				HStack{
					Button {
						print("Hello")
						print(codeValue)
						
						
						if self.status == "Failed" {
							self.navigationFlag = false
							dismiss()
						} else if self.status == "Success" {
							
							if self.otpErrorMessage == "pin confirmed" {
								self.navigationFlag = true
								
							} else  if self.otpErrorMessage == "No class found for today with this pin!" {
								
								self.navigationFlag = false
								dismiss()
								
							}
							
						} else if self.status == "" {
							self.navigationFlag = false
						} else {
							self.navigationFlag = true
						}

					} label: {
						
						if self.status == "" {
							Text("Please Wait...")
								.foregroundColor(.black)
								.font(.system(size: 16)
									.weight(.semibold)
								)
						} else if self.status == "Failed" {
							Text("Server Error")
								.foregroundColor(.black)
								.font(.system(size: 16)
									.weight(.semibold)
								)
						} else if self.status == "Success" {
							
							if self.otpErrorMessage == "pin confirmed" {
								
								Text("Great. Lets start streaming\(connectivityViewModel.isSuccessfulLoginFromPhone)")
									.foregroundColor(.black)
									.font(.system(size: 16)
										.weight(.semibold)
									)
								
							} else  if self.otpErrorMessage == "No class found for today with this pin!" {
								
								Text("No class found for today with this pin!")
									.foregroundColor(.black)
									.font(.system(size: 16)
										.weight(.semibold)
									)
								
							}
							
						}
                    
					}
					ZStack{
						
						NavigationLink(destination:
										StreamView(codeValue: getOtpValueIn(singleString: self.codeValue))
							.navigationBarHidden(true)
							.navigationBarBackButtonHidden(true),
									   isActive: self.$navigationFlag,
									   label: {
							EmptyView()
						})
						.frame(width: 0)
					}
				}
				.cornerRadius(22)
				.background(Color("Color")
					.clipShape(RoundedRectangle(cornerRadius:12)))
				.padding(.top, 80)
				.padding(.leading, 2)
				.padding(.trailing, 2)
				.edgesIgnoringSafeArea(.all)
				Spacer()
			}
			.alert(isPresented:$showingAlert) {
				Alert(title: Text("Message"),message: Text("Please make sure you are logged in the app first."), dismissButton: .destructive(Text("OK")){
					dismiss()
				})
			}
		
			.onAppear(perform: {
//				if UserDefaults.loginValue != ""{
//					showingAlert = false
//					
//				}else{
//					showingAlert = true
//				}
				print("Login from app check in watch -->",connectivityViewModel.isSuccessfulLoginFromPhone)
				print("Enetered Code Value", self.codeValue)
				print("the Final Otp Data=", getOtpValueIn(singleString: self.codeValue))
				let strParam = "\(self.codeValue[0])\(self.codeValue[1])\(self.codeValue[2])\(self.codeValue[3])"
				
				self.viewModel.checkingVerificationCode(otp: (strParam)) { status, otpMSg, token  in
					
					print("The server code=================\(status) & == \(otpMSg) && THE TOKEN ====\(token)")
					self.status = status
					self.otpErrorMessage = otpMSg
                    if status == "Success" {
                        if otpMSg == "pin confirmed" { // "No class found for today with this pin!"
                            self.connectivityViewModel.session.sendMessage(["isClassCodeVerifiedOnWatch": true], replyHandler: nil)
                        }
                        UserDefaults.classCodeValue = getOtpValueIn(singleString: self.codeValue)
                        if let tToken = token {
                            print(tToken)
                            self.connectivityViewModel.session.sendMessage(["token": tToken], replyHandler: nil)
                        }
                    }
					
				}
//				if connectivityViewModel.isSuccessfulLoginFromPhone == "true"{
//					showingAlert = false
//					print("Enetered Code Value", self.codeValue)
//					print("the Final Otp Data=", getOtpValueIn(singleString: self.codeValue))
//					UserDefaults.classCodeValue = getOtpValueIn(singleString: self.codeValue)
//					let strParam = "\(self.codeValue[0])\(self.codeValue[1])\(self.codeValue[2])\(self.codeValue[3])"
//
//					self.viewModel.checkingVerificationCode(otp: (strParam)) { status, otpMSg, token  in
//
//						print("The server code=================\(status) & == \(otpMSg) && THE TOKEN ====\(token)")
//						self.status = status
//						self.otpErrorMessage = otpMSg
//						self.connectivityViewModel.session.sendMessage(["isClassCodeVerifiedOnWatch": true], replyHandler: nil)
//						if let tToken = token {
//							print(tToken)
//							self.connectivityViewModel.session.sendMessage(["token": tToken], replyHandler: nil)
//						}
//
//					}
//				}else{
//					print("Login from app check in watch -->",connectivityViewModel.isSuccessfulLoginFromPhone)
//					showingAlert = true
//				}
//				if connectivityViewModel.isSuccessfulLoginFromPhone{
//					showingAlert = false
//
//				}else{
//					showingAlert = true
//				}
				
			})
		//}
	}
}

//struct VerificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerificationView(codeValue: "2222")
//    }
//}
