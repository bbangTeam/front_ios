//
//  Collapsable.swift
//  Bbang
//
//  Created by bart Shin on 29/05/2021.
//

import UIKit

protocol Collapsable: UIViewController  {
	
	var expandedHeight: CGFloat { get }
	var collapsedHeight: CGFloat { get }
	var isCollapsed: Bool { get }
	var handleHeight: CGFloat { get }
	var sheetHandle: UIView! { get }
	var frameAnimator: UIViewPropertyAnimator? { get set }
	
	func changeState (toCollapse: Bool, duration: TimeInterval, dampingRatio: CGFloat) -> Void
}
