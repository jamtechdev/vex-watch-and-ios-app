//
//  ConfirmAlertView.swift
//  Vex Watch App
//
//  Created by Digvijay Ghildiyal on 16/01/23.
//

import SwiftUI

struct ConfirmAlertView: View {
	@StateObject var connectivityViewModel = WatchConnectivityViewModel()
	@State var navigationFlag = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("Please make sure you are logged in the app first.")
			.overlay(
				NavigationLink(destination: EnterCodeView()
					.navigationBarHidden(true)
					.navigationBarBackButtonHidden(false), isActive: $navigationFlag, label: {
						
					}).opacity(0)
			)
            .onReceive(timer, perform: { _ in
                print("updating watch")
                if UserDefaults.standard.string(forKey: "ok") ?? "" != ""{
                    self.navigationFlag = true
                }else{
                    self.navigationFlag = false
                }
            })
//			.onReceive(connectivityViewModel.$isSuccessfulLoginFromPhone, perform: { str in
//				if str != ""{
//					self.navigationFlag = true
//				}else{
//					self.navigationFlag = false
//				}
//			})
    }
}

struct ConfirmAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAlertView()
    }
}
