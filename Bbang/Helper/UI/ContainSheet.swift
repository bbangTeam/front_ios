//
//  ContainSheet.swift
//  Bbang
//
//  Created by bart Shin on 29/05/2021.
//

import UIKit

protocol ContainSheet: UIViewController {
	
	var sheetVC: Collapsable { get }
	var durationForMoveSheet: TimeInterval { get }
	var sheetAnimator: UIViewPropertyAnimator? { get set }
	var sheetPauseFraction: CGFloat { get set }
	var blurView: UIVisualEffectView? { get }
	var blurEffect: UIBlurEffect? { get }
	func additionalAnimation(toCollapse: Bool) -> Void
}

extension ContainSheet {
	
	func moveSheet() {
		guard sheetAnimator == nil, sheetVC.frameAnimator == nil else {
			return
		}
		let toCollapse = !sheetVC.isCollapsed
		sheetVC.changeState(toCollapse: toCollapse,
												duration: durationForMoveSheet, dampingRatio: 1)
		let animator = UIViewPropertyAnimator(duration: durationForMoveSheet, curve: .linear) { [weak weakSelf = self] in
			weakSelf?.blurView?.effect = weakSelf?.blurEffect
		}
		animator.addAnimations { [weak weakSelf = self] in
			weakSelf?.additionalAnimation(toCollapse: toCollapse)
		}
		animator.addCompletion { [weak weakSelf = self] _ in
			weakSelf?.sheetAnimator = nil
		}
		sheetAnimator = animator
		animator.startAnimation()
	}
	
	func startDragSheet() {
		if sheetAnimator == nil && sheetVC.frameAnimator == nil {
			moveSheet()
		}
		sheetAnimator?.pauseAnimation()
		sheetVC.frameAnimator?.pauseAnimation()
		sheetPauseFraction = sheetAnimator?.fractionComplete ?? 0
	}
	
	func updateSheetState(_ delta: CGFloat) {
		sheetAnimator?.fractionComplete = sheetPauseFraction + delta
		sheetVC.frameAnimator?.fractionComplete = sheetPauseFraction + delta
	}
	
	func continueSheetMoving(toReverse: Bool) {
		sheetAnimator?.isReversed = toReverse
		sheetVC.frameAnimator?.isReversed = toReverse
		sheetAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		sheetVC.frameAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
	}
}
