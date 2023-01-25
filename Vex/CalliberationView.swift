//
//  CalliberationView.swift
//  Vex
//
//  Created by Digvijay Ghildiyal on 13/01/23.
//

import SwiftUI

struct CalliberationView: View {
	@State var navigationFlag = false
	@StateObject var viewModel = IphoneConnectivityViewModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
		ZStack{
			Image("backgroundNoLogo")
				.resizable()
				.scaledToFill()
				.edgesIgnoringSafeArea(.all)
			VStack{
				Image("info")
					.resizable()
					.scaledToFill()
					.frame(width: 40, height: 40)
					.padding(.top, 16)
				Text("Please connect with watch app first, Using class code.")
					.frame(height: 200, alignment: .center)
					.padding(.top, -48)
					.padding(.leading, 16)
					.padding(.trailing, 16)
//					.cornerRadius(20)
					.font(.title2
						.weight(.regular))
//					.clipShape(Capsule())
			}
			.background(.white)
			.frame(width: UIScreen.main.bounds.width * 0.8)
			.cornerRadius(20)
		}
		.onReceive(viewModel.$isClassCodeVerifiedOnWatch, perform:{_ in
			if viewModel.isClassCodeVerifiedOnWatch{
				self.navigationFlag = true
			}else{
				self.navigationFlag = false
			}
		})
        .onReceive(timer, perform:{_ in
//            if viewModel.isClassCodeVerifiedOnWatch{
//                self.navigationFlag = true
//            }else{
//                self.navigationFlag = false
                self.viewModel.session.sendMessage(["isSuccessfulLoginFromPhone": UserDefaults.accessToken], replyHandler: nil)
//            }
        })
		.overlay(
			NavigationLink(destination: HeartRateView()
				.navigationBarHidden(true)
				.navigationBarBackButtonHidden(true),
						   isActive: self.$navigationFlag, label: {
							   EmptyView()
						   }).opacity(0)
				.frame(height: 0)
		)
		.onAppear(perform: {
			if viewModel.isClassCodeVerifiedOnWatch{
				self.navigationFlag = true
			}else{
				self.navigationFlag = false
			}
		})
    }
}

struct CalliberationView_Previews: PreviewProvider {
    static var previews: some View {
        CalliberationView()
    }
}
