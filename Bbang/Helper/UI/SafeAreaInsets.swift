//
//  SafeAreaInsets.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import UIKit

extension UIView {
	
	func getInsetHeight(for direction: InsetDirection) -> CGFloat {
		let window = UIApplication.shared.windows[0]
		switch direction {
		case .top:
			return window.safeAreaInsets.top
		case .bottom:
			return window.safeAreaInsets.bottom
		}
	}
	
	enum InsetDirection {
		case top
		case bottom
	}
}
