//
//  EnterCodeView.swift
//  VexWatch Watch App
//
//  Created by Jamtech 01 on 06/12/22.
//

import SwiftUI
import Combine
import WatchConnectivity
import WatchKit

class AppState: ObservableObject {
	@Published var moveToDashboard: Bool = false
}

struct EnterCodeView: View {
	
	@State private var isTitleHidden : Bool = false
	
	@State private var showEnteredText : [String] = [String]()
	@State private var enteredCodeData : [String] = [String]()
	@State private var isPushedToAnotherScreen : Bool = false
	@StateObject var connectivityViewModel = WatchConnectivityViewModel()
	@State var isActive : Bool = false
	@State var navigationFlag = false
	var appState = AppState()
	
	var body: some View {
		
//		NavigationView{
			VStack {
				if isTitleHidden {
					PinCode(showEnteredText: $showEnteredText)
					NumberPad(showClassCode: $isTitleHidden, showEnteredText: $showEnteredText, enteredCodeData: $enteredCodeData, movedToAnotherScreen: $isPushedToAnotherScreen)
						.padding(.horizontal, 10)
						.overlay(
							NavigationLink(destination: VerificationView(codeValue: self.enteredCodeData, rootIsActive: $isActive)
										   //							.navigationBarHidden(true)
								.navigationBarBackButtonHidden(false), isActive: $isPushedToAnotherScreen, label: {
									
								}).opacity(0)
						)
					
				} else {
					
					Text("Enter Class Code")
						.font(.system(size: 12, weight: .medium))
						.padding(.bottom, 3)
						.frame(height: 20)
					
					
					
					NumberPad(showClassCode: $isTitleHidden, showEnteredText: $showEnteredText, enteredCodeData: $enteredCodeData, movedToAnotherScreen: $isPushedToAnotherScreen)
						.padding(.horizontal, 10)
						.overlay(
							
							NavigationLink(destination: VerificationView(codeValue: self.enteredCodeData, rootIsActive: $isActive).navigationBarBackButtonHidden(true) , isActive: $isPushedToAnotherScreen, label: {
								
							}).opacity(0)
						)
					
				}
				
				
				
				
				
				
			}
		//}
		
//		.onChange(of: connectivityViewModel.isSuccessfulLoginFromPhone, perform: {newValue in
//			print("Login from app check in watch -->",newValue)
//		})
//		.onReceive(connectivityViewModel.$isSuccessfulLoginFromPhone, perform: { str in
//			if str != ""{
//				self.navigationFlag = false
//			}else{
//				self.navigationFlag = true
//			}
//		})
//		.onAppear(perform: {
//			if connectivityViewModel.isSuccessfulLoginFromPhone != ""{
//				self.navigationFlag = false
//			}else{
//				self.navigationFlag = true
//			}
//		})
		.onDisappear(perform: {
			self.showEnteredText = [String]()
			self.enteredCodeData = [String]()
			self.isTitleHidden = false
		})
		
		
		
		
		
	}
}



//struct EnterCodeView_Previews: PreviewProvider {
//	static var previews: some View {
//		EnterCodeView()
//	}
//}



