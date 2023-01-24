//
//  WaitingView.swift
//  Vex
//
//  Created by Digvijay Ghildiyal on 13/01/23.
//

import SwiftUI

struct WaitingView: View {
	@StateObject var viewModel = IphoneConnectivityViewModel()
	@State var navigationFlag = false
    var body: some View {
		ZStack{
			Image("backgroundNoLogo")
				.resizable()
				.scaledToFill()
				.edgesIgnoringSafeArea(.all)
			VStack{
				Text("Please wait while we caliberate app with watch\n\n This might take upto a minute.")
					.frame(height: 200, alignment: .center)
					.padding(.leading, 16)
					.padding(.trailing, 16)
					.font(.title2
						.weight(.semibold))
			}
			.background(.white)
			.frame(width: UIScreen.main.bounds.width * 0.8)
			.cornerRadius(20)
		}
//		.overlay(
//			NavigationLink(destination: HeartRateView()
//				.navigationBarHidden(true)
//				.navigationBarBackButtonHidden(true),
//						   isActive: self.$navigationFlag, label: {
//							   EmptyView()
//						   }).opacity(0)
//				.frame(height: 0)
//		)
//		.onReceive(viewModel.$navigationFlag, perform:{ _ in
//			if viewModel.navigationFlag{
//				self.navigationFlag = false
//			}else{
//				self.navigationFlag = true
//			}
//		})
//		.onAppear(perform: {
//			if viewModel.diffTimeStamp > 0.5{
//				self.navigationFlag = true
//			}else{
//				self.navigationFlag = false
//			}
//		})
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}
