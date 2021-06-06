//
//  ContainSheet.swift
//  Bbang
//
//  Created by bart Shin on 29/05/2021.
//

import UIKit

protocol ContainSheet: UIViewController {
	
	var sheetVC: Collapsable { get }
	var blurView: UIVisualEffectView! { get set }
	var blurAnimator: UIViewPropertyAnimator? { get set }
	var sheetPauseFraction: CGFloat { get set }
}

extension ContainSheet {
	
	func moveSheet() {
		guard blurAnimator == nil, sheetVC.frameAnimator == nil else {
			return
		}
		let blur: UIBlurEffect? = sheetVC.isCollapsed ? UIBlurEffect(style: .light): nil
		sheetVC.changeState(toCollapse: sheetVC.isCollapsed ? false: true ,duration: 1, dampingRatio: 1)
		let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak weakSelf = self] in
				weakSelf?.blurView.effect = blur
		}
		animator.addCompletion { [weak weakSelf = self] _ in
			weakSelf?.blurAnimator = nil
		}
		blurAnimator = animator
		animator.startAnimation()
	}
	
	
	func startDragSheet() {
		if blurAnimator == nil && sheetVC.frameAnimator == nil {
			moveSheet()
		}
		blurAnimator?.pauseAnimation()
		sheetVC.frameAnimator?.pauseAnimation()
		sheetPauseFraction = blurAnimator?.fractionComplete ?? 0
	}
	
	func updateSheetState(_ delta: CGFloat) {
		blurAnimator?.fractionComplete = sheetPauseFraction + delta
		sheetVC.frameAnimator?.fractionComplete = sheetPauseFraction + delta
	}
	
	func continueSheetMoving(toReverse: Bool) {
		blurAnimator?.isReversed = toReverse
		sheetVC.frameAnimator?.isReversed = toReverse
		blurAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		sheetVC.frameAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
	}
}
