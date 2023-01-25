//
//  FlashText.swift
//  Vex
//
//  Created by Digvijay Ghildiyal on 16/01/23.
//

import SwiftUI

struct FlashText: View {
	@State private var opacity = 1.0
	let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
	
	var body: some View {
		Text("Flash Text")
			.opacity(opacity)
			.onReceive(timer) { _ in
				withAnimation(.easeInOut(duration: 0.5)) {
					self.opacity = self.opacity == 1.0 ? 0.0 : 1.0
				}
			}
			.onAppear {
				startTimer()
			}
	}
}

func startTimer() {
	let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
}

struct FlashText_Previews: PreviewProvider {
    static var previews: some View {
        FlashText()
    }
}
