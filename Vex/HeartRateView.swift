//
//  HeartRateView.swift
//  Vex
//
//  Created by Digvijay Ghildiyal on 10/12/22.
//

import SwiftUI
import ActivityIndicatorView
import WatchConnectivity
import HealthKit
import AlertToast
import SSSwiftUIGIFView

struct HeartRateView: View {
	private var healthStore = HKHealthStore()
	@StateObject var viewModel = IphoneConnectivityViewModel()
	@StateObject var terraViewMode = TerraViewModel()
	let heartRateQuantity = HKUnit(from: "count/min")
	@State private var showLoadingIndicator: Bool = true
	@State private var value = 0
	@State private var isStreamStarted = false
	@State var isHideLoader: Bool = true
	@State var navigationFlag = false
	@State var navigationFlag2 = false
	@State private var showingAlert = false
	@State private var alertMessage = ""
	@State private var anotherAlertMessage = ""
	@State private var showToast = false
	@State private var showAnotherAlert = false
	@Environment(\.scenePhase) var scenePhase
	@Environment(\.dismiss) var dismiss
	@State private var opacity = 1.0
	let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    let timer_ = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
	let NC = NotificationCenter.default
	
	var body: some View {
		ScrollView{
			ZStack{
				Color.white.ignoresSafeArea()
				LoaderView(tintColor: .white, scaleSize: 2.0).padding(.bottom,70).hidden(isHideLoader)
                VStack(spacing: 8){
					VStack{
						Text("\(UserDefaults.standard.string(forKey: "firstName") ?? "")")
							.font(.title3)
							.fontWeight(.semibold)
							.padding(.top, 16)
							.foregroundColor(.black)
						ZStack{
							HStack{
								Button {
									print("Hello")
									UserDefaults.accessToken = ""
									self.viewModel.session.sendMessage(["sessionEnded": "true"], replyHandler: nil)
									self.navigationFlag = true
									
								} label: {
									Text("LogOut")
										.foregroundColor(.red)
										.font(.system(size: 20)
											.weight(.regular)
										)
										.frame(width: 100, height: 30, alignment: .center)
								}
							}
						}
						Spacer()
						.background(Color.gray.opacity(0.5))
						.cornerRadius(12)
						.padding(.top, 16)
						HStack(spacing: 10){
//							Text("\(viewModel.heartRate)")
//								.font(.system(size: 130)
//									.weight(.bold)
//								)
//								.foregroundColor(.black)
//								.onChange(of: viewModel.heartRate) { newValue in
//									print("the terra token", viewModel.token)
//								}
//							
//							
//							Image("cardiogram (1)").resizable()
//								.frame(width: 70, height: 70)
//								.padding(.top, 5)
							if viewModel.diffTimeStamp > 0.9{
								Text("\(viewModel.heartRate)")
									.font(.system(size: 130)
										.weight(.bold)
									)
									.foregroundColor(.black)
									.onChange(of: viewModel.heartRate) { newValue in
										print("the terra token", viewModel.token)
									}


								Image("cardiogram (1)").resizable()
									.frame(width: 70, height: 70)
									.padding(.top, 5)
							}
                            else{
//									.padding([.left], 20)
								VStack{
//									SwiftUIGIFPlayerView(gifName: "loader")
//										.frame(width: 30,height: 30)
									Text("Please wait while we calibrate app with watch\n\n This might take upto a minute.")
										.font(.system(size: 20)
											.weight(.regular)
										)
										.foregroundColor(.red)
										.cornerRadius(12)
										.opacity(opacity)
										.onReceive(timer) { _ in
											withAnimation(.easeInOut(duration: 0.5)) {
												self.opacity = self.opacity == 1.0 ? 0.0 : 1.0
											}
										}
									//									.padding(.leading, 12)
									//									.padding(.trailing, 12)
									//									.padding(.top, 0)
									//									.padding(.bottom, 12)
										.padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
								}
								.frame(width: UIScreen.main.bounds.width * 0.8, height: 120)
								.background(.white)
								.border(.black, width: 2)
								}
						}
						.frame(width: UIScreen.main.bounds.width, height: 150, alignment: .top)
						.padding(.leading, 10)
						.padding(.trailing, 10)
						.padding(.top, 20)
						Spacer()
						if viewModel.diffTimeStamp > 0.9{
							HStack{
								Text("70%")
									.font(.system(size: 18)
										.weight(.bold)
									)
									.padding(.bottom, 16)
									.frame(width: (UIScreen.main.bounds.width - 70) / 2,alignment: .leading)
									.foregroundColor(.black)
								Text("140 kcal")
									.font(.system(size: 18)
										.weight(.bold)
									)
									.padding(.bottom, 16)
									.frame(width: (UIScreen.main.bounds.width - 70) / 2,alignment: .trailing)
									.foregroundColor(.black)
							}
							.frame(width: UIScreen.main.bounds.width - 40)
						}
						
					}
					.frame(width: UIScreen.main.bounds.width - 40, height: 330, alignment: .top)
					.background(.green)
					.cornerRadius(20)
					.padding(.top, 5)
					Spacer()
					
					VStack{
						AsyncImage(url: URL(string: "https://vexfitnessuploads.s3.us-west-1.amazonaws.com/\(UserDefaults.standard.string(forKey: "coverPic") ?? "")"),
								   content: { image in
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
						}, placeholder: {
							Color.gray
						})
							.frame(width: 120, height: 120)
							.padding(.top, 24)
						Text("Welcome to\n\(UserDefaults.standard.string(forKey: "gymName") ?? "")")
							.font(.system(size: 24)
								.weight(.semibold)
							)
							.fixedSize(horizontal: false, vertical: true)
							.frame(alignment: .center)
							.padding(.top, 16)
							.foregroundColor(.black)
						HStack{
							Button {
								print("Hello")
								self.isHideLoader = false
								if viewModel.classCodeValue == ""{
									showAnotherAlert = true
									self.isHideLoader = true
									anotherAlertMessage = "Please connect to the watch first to start stream."
								}else{
									showAnotherAlert = false
                                    if self.viewModel.isStreamStarted{
                                        self.isHideLoader = true
                                        self.isStreamStarted = false
                                        self.viewModel.isStreamStarted = false
                                        alertMessage = "Streaming Stopped Successfully"
                                        self.viewModel.session.sendMessage([ "isStreamStarted": self.isStreamStarted], replyHandler: nil)
										self.terraViewMode.stopStreaming()
									}else{
										self.terraViewMode.generateWidgetSession { url in
											print(url)

											self.terraViewMode.settingUpTerra(byToken: self.viewModel.token) {
												self.isHideLoader = true
                                                self.isStreamStarted = true
                                                self.viewModel.isStreamStarted = true
                                                self.viewModel.session.sendMessage([ "isStreamStarted": self.isStreamStarted], replyHandler: nil)
                                                showingAlert = false
											}
										}
									}
								}
							} label: {
								Text(isStreamStarted || viewModel.isStreamFromWatch ? "Stop HR Stream" : "Start HR Stream")
									.foregroundColor(.black)
									.font(.system(size: 20)
										.weight(.semibold)
									)
									.frame(width: UIScreen.main.bounds.width*0.7, height: 50, alignment: .center)
							}
							.alert(alertMessage, isPresented: $showingAlert) {
								Button("OK", role: .cancel) { }
							}
							
							.alert(anotherAlertMessage, isPresented: $showAnotherAlert) {
								Button("OK", role: .cancel) { }
							}
						}
						.background(Color.gray.opacity(0.5))
						.cornerRadius(12)
//						.padding(.top, 16)
						
					}
					.frame(width: UIScreen.main.bounds.width - 40, height: 330, alignment: .top)
					.background(.white)
					.padding(.top, 5)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.black, lineWidth: 1.0)
					)
					.clipped(antialiased: true)
					Spacer()
				}
				LoaderView(tintColor: .black, scaleSize: 2.0).padding(.bottom,80).hidden(isHideLoader)
			}
			NavigationLink(destination:
							ContentView()
				.navigationBarHidden(true)
				.navigationBarBackButtonHidden(true),
						   isActive: self.$navigationFlag,
						   label: {
				EmptyView()
			}).opacity(0)
			NavigationLink(destination:
							CalliberationView()
				.navigationBarHidden(true)
				.navigationBarBackButtonHidden(true),
						   isActive: self.$navigationFlag2,
						   label: {
				EmptyView()
			}).opacity(0)
			.accentColor(.white)
			.onAppear {
//				self.NC.post(name: NSNotification.Name(rawValue: "wating_booking"), object: nil)
//				startTimer()
                    self.start()

			}
			.onReceive(viewModel.$isStopSessionFromWatch, perform: { str in
				if str != ""{
					self.navigationFlag2 = true
				}else{
					self.navigationFlag2 = false
				}
				
			})
			
//			.onChange(of: viewModel.isStreamFromWatch2, perform:{newValue in
//				print(newValue)
//				if newValue{
//					self.isStreamStarted = newValue
//					self.terraViewMode.postHeartRate(){_ in
//						showingAlert = false
//					}
//				}else{
//					self.isStreamStarted = newValue
//					self.terraViewMode.endStreaming(){_ in
//
//					}
//				}
//			})
			.onReceive(timer_, perform: {_ in
				if viewModel.isStreamFromWatch{
					self.isStreamStarted = viewModel.isStreamFromWatch
				}else{
					self.isStreamStarted = viewModel.isStreamStarted//isStreamFromWatch
//					self.terraViewMode.endStreaming{_ in
//					}
//					self.terraViewMode.stopStreaming()
//					dismiss()
				}
			})
			.onReceive(viewModel.$isDataLoadedOnPhone, perform:{_ in
				if viewModel.isDataLoadedOnPhone{
					self.showToast = true
				}else{
//					self.showToast = false
				}
//				if viewModel.heartRate != 0{
//					self.showToast = true
//				}else{
//					self.showToast = false
//				}
			})
			.onChange(of: scenePhase) { newPhase in
				if newPhase == .inactive {
					print("Inactive")
				} else if newPhase == .active {
					print("Active")
				} else if newPhase == .background {
					print("Background")
				}
			}
		}
		.toast(isPresenting: $showToast, duration: 5){
			AlertToast(type: .regular, title: "Calibrating...")
		}
	}
	
//	func startTimer() {
//		let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
//	}
	
	func start() {
//		self.NC.addObserver(forName: NSNotification.Name(rawValue: "wating_booking"), object: nil, queue: nil,
//							using: self.VPNDidChangeStatus)
		self.terraViewMode.connectWatchApp()
		autorizeHealthKit()
		startHeartRateQuery(quantityTypeIdentifier: .heartRate)
	}
	
	func autorizeHealthKit() {
		let healthKitTypes: Set = [
			HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
		
		healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
	}
	
	private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
		
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
	
	private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
		ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .arcs()).frame(width: 50, height: 50).foregroundColor(.red)
		var lastHeartRate = 0.0
		
		for sample in samples {
			if type == .heartRate {
				lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
			}
			
			self.value = Int(lastHeartRate)
			
			self.viewModel.session.sendMessage(["currentHeartRate": self.value], replyHandler: nil)
			
			
			
		}
	}
	
	func VPNDidChangeStatus(_ notification: Notification) {
		
		
	}
}

struct HeartRateView_Previews: PreviewProvider {
	static var previews: some View {
		HeartRateView()
	}
}
