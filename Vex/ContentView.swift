//
//  ContentView.swift
//  Vex
//
//  Created by Digvijay Ghildiyal on 10/12/22.
//

import SwiftUI
import HealthKit
import TerraRTiOS

struct ContentView: View {
	@ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 3)
	@StateObject var terraViewMode = TerraViewModel()
	private var healthStore = HKHealthStore() 
	@State private var name: String = ""
	@State private var password: String = ""
	@State var navigationFlag = false
	@State var calliNavigationFlag = false
	@State var isHideLoader: Bool = true
	@FocusState var isInputActive: Bool
//	@ObservedObject var keyboardManager = KeyboardManager()
	@StateObject var viewModel = IphoneConnectivityViewModel()
	let verticalPaddingForForm = 20
	var body: some View {
//		NavigationView{
//			ScrollView{
				ZStack{
					Image("backgroundNoLogo")
						.resizable()
						.scaledToFill()
						.edgesIgnoringSafeArea(.all)
					LoaderView(tintColor: .white, scaleSize: 2.0).padding(.bottom,70).hidden(isHideLoader)
					VStack {
						HStack(){
							VStack(spacing: CGFloat(verticalPaddingForForm)) {
								Text("LOGIN")
									.font(.title2
										.weight(.semibold))
									.frame(width: UIScreen.main.bounds.width, alignment: .leading)
									.padding(.leading, 24)
									.foregroundColor(.black)
								HStack(){
									Text("")
										.frame(width: 40, height: 2)
								}
								.background(.black)
								.frame(width: UIScreen.main.bounds.width, alignment: .leading)
								.padding(.leading, 24)
								HStack {
									Image(systemName: "person")
										.foregroundColor(.secondary)
									TextField("Email", text: $name)
										.foregroundColor(Color.black)
										.keyboardType(.emailAddress)
								}
								.padding()
								.overlay(
									RoundedRectangle(cornerRadius: 20)
										.stroke(Color.gray, lineWidth: 1.0)
								)
								
								HStack {
									Image(systemName: "lock")
										.foregroundColor(.secondary)
									SecureField("Password", text: $password)
										.foregroundColor(Color.black)
								}
								.padding()
								.overlay(
									RoundedRectangle(cornerRadius: 20)
										.stroke(Color.gray, lineWidth: 1.0)
								)
								
								
								
								Button(action: {
									self.isHideLoader = false
									if name != "" && password != ""{
										LoginApi().authenticateUser(email: name, password: password, userRole: "user", deviceType: "ios"){
                                            self.viewModel.session.sendMessage(["isSuccessfulLoginFromPhone": UserDefaults.accessToken], replyHandler: nil)
											if UserDefaults.classCodeValue != ""{
												self.navigationFlag = true
												self.isHideLoader = true
											}else{
												self.calliNavigationFlag = true
												self.isHideLoader = true
											}
										}
									}
								}) {
									Text("Login")
										.padding()
										.foregroundColor(.white)
										.font(.system(size: 20)
											.weight(.semibold)
										)
									
								}
								.frame(width: UIScreen.main.bounds.width * 0.91, height: 60)
								.background(Color.black)
								.foregroundColor(Color.white)
								.cornerRadius(20)
								.frame(width: 200)
								
							}.padding(.horizontal, CGFloat(verticalPaddingForForm))
							
						}
					}
					.frame(width: UIScreen.main.bounds.width, height: 350)
					.background(.white)
					.cornerRadius(20)
					.padding(.bottom, 0)
					.padding(.top, UIScreen.main.bounds.height * 0.5)
					
				}
				.overlay(
					NavigationLink(destination:
									HeartRateView()
						.navigationBarHidden(true)
						.navigationBarBackButtonHidden(true),
								   isActive: self.$navigationFlag,
								   label: {
									   EmptyView()
								   }).opacity(0)
				)
		
				.overlay(
					NavigationLink(destination:
									CalliberationView()
						.navigationBarHidden(true)
						.navigationBarBackButtonHidden(true),
								   isActive: self.$calliNavigationFlag,
								   label: {
									   EmptyView()
								   }).opacity(0)
				)
		
//				.padding(.bottom, keyboardManager.keyboardHeight)
//				.edgesIgnoringSafeArea(keyboardManager.isVisible ? .bottom : [])
		.onAppear(perform: start)
		.hiddenNavigationBarStyle()
	}
	func start() {
//		self.viewModel.session.sendMessage(["isSuccessfulLoginFromPhone":""], replyHandler: nil)
		print(self.navigationFlag)
		print(UserDefaults.classCodeValue)
	}
	
	func autorizeHealthKit() {
		let healthKitTypes: Set = [
			HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
		
		healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoaderView: View {
	var tintColor: Color = .blue
	var scaleSize: CGFloat = 1.0
	
	var body: some View {
		ProgressView()
			.scaleEffect(scaleSize, anchor: .center)
			.progressViewStyle(CircularProgressViewStyle(tint: tintColor))
	}
}

struct GeometryGetter: View {
	@Binding var rect: CGRect
	
	var body: some View {
		GeometryReader { geometry in
			Group { () -> AnyView in
				DispatchQueue.main.async {
					self.rect = geometry.frame(in: .global)
				}
				
				return AnyView(Color.clear)
			}
		}
	}
}

extension View {
	@ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
		switch shouldHide {
		case true: self.hidden()
		case false: self
		}
	}
}
