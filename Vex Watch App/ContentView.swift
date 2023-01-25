//
//  ContentView.swift
//  VexWatch Watch App
//
//  Created by Digvijay Ghildiyal on 05/12/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
	private var healthStore = HKHealthStore()
    let viewModel = WatchConnectivityViewModel()
	@State var totalTime = 5
	@State var timerTime : Float = 0
	@State var minute: Float = 0.0
	@State var navigationFlag = false
	@State var navigationFlag2 = false
	@State var value = 0
	let heartRateQuantity = HKUnit(from: "count/min")
	@StateObject var connectivityViewModel = WatchConnectivityViewModel()
	
	let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
	
	var body: some View {
		NavigationView{
			VStack {
				HStack{
					ZStack{
						
						Button {
							print("Hello")
							self.navigationFlag = true
						} label: {
							Text("Connection\n Successful \(connectivityViewModel.isSuccessfulLoginFromPhone)")
								.foregroundColor(.white)
								.font(.system(size: 16)
									.weight(.semibold)
								)
						}
						
						
						
						NavigationLink(destination:
										EnterCodeView()
							.navigationBarHidden(true)
							.navigationBarBackButtonHidden(true),
									   isActive: self.$navigationFlag,
									   label: {
							EmptyView()
						}).opacity(0)
					}
					
					
				}
				.cornerRadius(22)
				.background(Color("Color 3")
					.clipShape(RoundedRectangle(cornerRadius:12)))
				.padding(.top, 80)
				.padding(.leading, 2)
				.padding(.trailing, 2)
				Spacer()
			}
			.edgesIgnoringSafeArea(.all)
			.overlay(
				NavigationLink(destination: ConfirmAlertView()
					.navigationBarHidden(true)
					.navigationBarBackButtonHidden(false), isActive: $navigationFlag2, label: {
						
					}).opacity(0)
			)
		}
		.onAppear(perform: start)
		.onReceive(connectivityViewModel.$isSuccessfulLoginFromPhone, perform: { str in
			print("Login from app check in watch -->",str)
			if str != ""{
				self.navigationFlag2 = false
			}else{
				self.navigationFlag2 = true
			}
		})
	}
	func start() {
		UserDefaults.userName = ""
		autorizeHealthKit()
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
			self.connectivityViewModel.session.sendMessage(["currentHeartRate": self.value], replyHandler: nil)
			
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
