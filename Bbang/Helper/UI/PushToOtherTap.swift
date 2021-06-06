//
//  PushToOtherTap.swift
//  Bbang
//
//  Created by bart Shin on 29/05/2021.
//

import UIKit

protocol PushToOtherTap: UIViewController {
	
}

extension PushToOtherTap {
	func changeTapWithAnimation(from startView: UIView?, to destination: UIViewController, duration: Double = 0.3, completion: @escaping (UIViewController) -> Void) {
		let tabBarHeight = tabBarController?.tabBar.bounds.height
		let snapShotSize = CGSize(width: destination.view.bounds.width,
															height: destination.view.bounds.height - (tabBarHeight ?? 0))
		let snapShotFrame = CGRect(origin: startView?.frame.origin ?? .zero, size: snapShotSize)
		guard startView != nil ,
			let snapshotImage = destination.view.takeSnapshot(snapShotFrame) else {
			tabBarController?.selectedViewController = destination
			completion(destination)
			return
		}
		
		let transitionView = UIImageView(image: snapshotImage)
		transitionView.frame.origin = CGPoint(x: view.bounds.maxX,
																					y: view.bounds.minY)
		startView!.addSubview(transitionView)
		UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut]) {
			transitionView.frame.origin = self.view.bounds.origin
		} completion: {[weak weakSelf = self] isEnd in
			if isEnd {
				transitionView.removeFromSuperview()
				weakSelf?.tabBarController?.selectedViewController = destination
				completion(destination)
			}
		}
	}
	
	func findSuperView(from view: UIView) -> UIView? {
		if view.superview == nil {
			return view
		}
		if view.superview?.bounds.size == view.window?.bounds.size {
			return view.superview
		}else {
			return findSuperView(from: view.superview!)
		}
	}
}
