//
//  StreamView.swift
//  VexWatch Watch App
//
//  Created by Digvijay Ghildiyal on 05/12/22.
//

import SwiftUI
import HealthKit
import ActivityIndicatorView
import WatchConnectivity
import TerraRTiOS
import UIKit
import Foundation
import WatchKit

struct StreamView: View {
    
	var healthStore = HKHealthStore()
	let heartRateQuantity = HKUnit(from: "count/min")
	@StateObject var connectivityViewModel = WatchConnectivityViewModel()
	@ObservedObject var viewModel = VerificationViewModel()
	var sessionValue = ""
	var codeValue: String = ""
    @State var showLoadingIndicator: Bool = true
    
    @State var startAndOff = ""
	@State var value = 0
//	@Environment(\.dismiss) var dismiss
	@State var isStreamStarted = false
	@State var showingAlert = false
	@State var navigationFlag = false
	@State var navigationFlag2 = false
	@State var classCodeValue : String = ""
	@Environment(\.scenePhase) var scenePhase
//	@Binding var shouldPopToRootView : Bool
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
	var appState = AppState()
    
	var body: some View {
		VStack(spacing: 20){
			HStack(spacing: 10){
					Text("\(value)")
						.font(.system(size: 70)
							.weight(.semibold)
						)
//				Text("\(connectivityViewModel.isSessionEnded)")
//					.font(.system(size: 20)
//						.weight(.regular)
//					)
						.foregroundColor(.black)
				Image("cardiogram").resizable()
					.frame(width: 40, height: 40)
					.padding(.top, 5)
			}
			.frame(width: 180, height: 100, alignment: .top)
			.background(Color(red: 151/255, green: 220/255, blue: 95/255))
			.cornerRadius(24)
			.padding(.leading, 10)
			.padding(.trailing, 10)
			.padding(.top, 5)
//			.edgesIgnoringSafeArea(.all)
			Spacer()
			VStack{
				HStack{
					Button {
						print("Hello")
						if self.isStreamStarted{
							self.showingAlert = true
						}else{
							self.showingAlert = false
							self.isStreamStarted = true
							self.connectivityViewModel.session.sendMessage(["isStreamStarted": self.isStreamStarted], replyHandler: nil)
                            self.startAndOff = "1"
                            self.connectivityViewModel.session.sendMessage(["startAndOff": self.startAndOff], replyHandler: nil)
						}
//						do{
//							let terra: Terra = try Terra()
//							terra.connect()
//							terra.startStream(forDataTypes: Set(arrayLiteral: .HEART_RATE)){_ in
//
//							}
//						} catch let error{
//							print("Getting Error===>>", error.localizedDescription)
//						}
//						send(heartRate: value)
					} label: {
						Text(isStreamStarted || connectivityViewModel.isStreamFromPhone ? "Stop Stream" : "Start Stream")
							.foregroundColor(.black)
							.font(.system(size: 16)
								.weight(.semibold)
							)
					}
					.alert(isPresented:$showingAlert) {
						Alert(
							title: Text("Permission"),
							message: Text("Are you sure you want to stop stream?"),
							primaryButton: .destructive(Text("OK")) {
								self.isStreamStarted = false
                                self.startAndOff = "2"
                                self.connectivityViewModel.session.sendMessage(["startAndOff": self.startAndOff], replyHandler: nil)
                                self.startAndOff = ""
								UserDefaults.classCodeValue = ""
								self.connectivityViewModel.session.sendMessage(["isStreamStarted": self.isStreamStarted, "classCodeValue":UserDefaults.classCodeValue, "isStopSessionFromWatch":"true"], replyHandler: nil)
								self.value = 0
								self.navigationFlag = true
							},
							secondaryButton: .cancel()
						)
					}
				}
                
				.cornerRadius(22)
				.background(Color("Color")
					.clipShape(RoundedRectangle(cornerRadius:12)))
				.padding(.top, -8)
				.padding(.leading, 10)
				.padding(.trailing, 10)
				Spacer()
				
			}
			.padding(.bottom, 16)
			.overlay(
				NavigationLink(destination: EnterCodeView()
					.navigationBarHidden(true)
					.navigationBarBackButtonHidden(false),
							   isActive: self.$navigationFlag, label: {
						EmptyView()
							   }).opacity(0)
					.frame(height: 0)
			)
			.overlay(
				NavigationLink(destination: ContentView()
					.navigationBarHidden(true)
					.navigationBarBackButtonHidden(false),
							   isActive: self.$navigationFlag2, label: {
								   EmptyView()
							   }).opacity(0)
					.frame(height: 0)
			)
			
		}
		.background(.black)
		.onAppear(perform: start)
        
		.onChange(of: connectivityViewModel.isStreamFromPhone2, perform: {newValue in
			if !newValue{
				self.isStreamStarted = newValue
			}else{
				self.isStreamStarted = newValue
			}
		})
        
//        .onReceive(timer, perform: {_ in
//           self.connectivityViewModel.session.sendMessage(["isStreamStarted": self.isStreamStarted], replyHandler: nil)
//        })
//		.onReceive(connectivityViewModel.$isStreamFromPhone, perform: {_ in
//			if !connectivityViewModel.isStreamFromPhone{
//				self.isStreamStarted = connectivityViewModel.isStreamFromPhone
//			}else{
//				self.isStreamStarted = connectivityViewModel.isStreamFromPhone
//			}
//		})
//		.onReceive(connectivityViewModel.$isSessionEnded, perform: {str in
//			if str == "true"{
//				self.navigationFlag2 = true
//			}else{
//				self.navigationFlag2 = false
//			}
//		})
		.onChange(of: connectivityViewModel.isSessionEnded, perform: {newValue in
			if connectivityViewModel.isSessionEnded == "true"{
				self.navigationFlag = true
			}else{
				self.navigationFlag = false
			}
		})
	}
	
	func send(heartRate: Int) {
		let session = WatchConnectivityViewModel()
		guard WCSession.default.isReachable else {
			print("Phone is not reachable")
			return
		}
		WCSession.default.sendMessage(["Heart Rate" : heartRate], replyHandler: nil) { error in
			print("Error sending message to phone: \(error.localizedDescription)")
		}
	}
	
	func start() {
		print("appear")
		print("CodeValue====>>>>", self.codeValue)
//		WKInterfaceDevice.current().play(.success)
//		activateSession()
//		autorizeHealthKit()
//		let terra: Terra = try! Terra()
//		terra.connect()
//		terra.startStream(forDataTypes: Set(arrayLiteral: .HEART_RATE)){_ in
//			
//		}
		do{
			print("Called")
//			let terra: Terra = try Terra()
//			terra.connect()
//			terra.startStream(forDataTypes: Set(arrayLiteral: .HEART_RATE)){_ in
//
//			}
		} catch let error{
			print("Getting Error===>>", error.localizedDescription)
		}
//		autorizeHealthKit()
		startHeartRateQuery(quantityTypeIdentifier: .heartRate)
	}
	
	func autorizeHealthKit() {
		let healthKitTypes: Set = [
			HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
		
		healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
	}
	
	func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
		self.connectivityViewModel.session.sendMessage(["isDataLoadedOnPhone": true], replyHandler: nil)
		// 1
		let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
		// 2
		let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
			query, samples, deletedObjects, queryAnchor, error in
			
			// 3
			guard let samples = samples as? [HKQuantitySample] else {
				return
			}
			
			self.process(samples, type: quantityTypeIdentifier)
			
		}
		
		// 4
		let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
		
		query.updateHandler = updateHandler
		
		// 5
		healthStore.execute(query)
	}
	
	func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
//        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .arcs()).frame(width: 50, height: 50).foregroundColor(.red)
		var lastHeartRate = 0.0
		
		for sample in samples {
			if type == .heartRate {
				lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
			}
			
			self.value = Int(lastHeartRate)
            
            self.connectivityViewModel.session.sendMessage(["currentHeartRate": self.value, "classCodeValue":UserDefaults.classCodeValue, "startAndOff": self.startAndOff, "isStreamStarted": self.isStreamStarted], replyHandler: nil)
            
		}
	}
    
}

//struct StreamView_Previews: PreviewProvider {
//	static var previews: some View {
//		StreamView()
//	}
//}
