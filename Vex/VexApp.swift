//
//  VexApp.swift
//  Vex
//
//  Created by Digvijay Ghildiyal on 10/12/22.
//

import SwiftUI

@main
struct VexApp: App {
//	let token = UserDefaults.standard.string(forKey: "TerraToken")
//	@StateObject var viewModel = IphoneConnectivityViewModel()
    var body: some Scene {
        WindowGroup {
			NavigationView{
				if UserDefaults.accessToken != ""{
					CalliberationView()
//					HeartRateView()
//					if UserDefaults.classCodeValue != ""{
//					}else{
//						CalliberationView()
//					}
				}else{
					ContentView()
				}
			}
			.hiddenNavigationBarStyle()
        }
    }
}
