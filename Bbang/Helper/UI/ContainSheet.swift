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
	var mainVCAnimator: UIViewPropertyAnimator? { get set }
	var sheetPauseFraction: CGFloat { get set }
	var blurView: UIVisualEffectView? { get }
	var blurEffect: UIBlurEffect? { get }
	/// Set animation and assign to mainVC animator which will automatically run when sheet moving
	func setAnimation(toCollapse: Bool) -> Void
	
}

extension ContainSheet {
	
	 func moveSheet() {
		guard mainVCAnimator == nil, sheetVC.frameAnimator == nil else {
			return
		}
		let toCollapse = !sheetVC.isCollapsed
		sheetVC.changeState(toCollapse: toCollapse,
							duration: durationForMoveSheet,
							dampingRatio: 1)
		setAnimation(toCollapse: toCollapse)
		mainVCAnimator?.addCompletion { [weak weakSelf = self] position in
			weakSelf?.mainVCAnimator = nil
		}
		mainVCAnimator?.startAnimation()
	}
	
	func startDragSheet() {
		if mainVCAnimator == nil && sheetVC.frameAnimator == nil {
			moveSheet()
		}
		mainVCAnimator?.pauseAnimation()
		sheetVC.frameAnimator?.pauseAnimation()
		sheetPauseFraction = mainVCAnimator?.fractionComplete ?? 0
	}
	
	func updateSheetState(_ delta: CGFloat) {
		mainVCAnimator?.fractionComplete = sheetPauseFraction + delta
		sheetVC.frameAnimator?.fractionComplete = sheetPauseFraction + delta
	}
	
	func continueSheetMoving(toReverse: Bool) {
		mainVCAnimator?.isReversed = toReverse
		sheetVC.frameAnimator?.isReversed = toReverse
		mainVCAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		sheetVC.frameAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
	}
}
