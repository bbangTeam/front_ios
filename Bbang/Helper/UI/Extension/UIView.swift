//
//  ScreenShotHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 11/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//


import UIKit
import SnapKit

extension UIView {
	
	class func fromNib<T: UIView>() -> T {
		return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
	}
	
	func takeSnapshot(_ frame: CGRect) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
		
		let context = UIGraphicsGetCurrentContext()
		context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
		
		guard let currentContext = UIGraphicsGetCurrentContext() else {
			return nil
		}
		
		layer.render(in: currentContext)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
	static func createShadowView(in parentView: UIView?,
															 behind originalView: UIView?,
															 radius: CGFloat = 10,
															 opacity: Float = 0.3,
															 widthScale: CGFloat = 0.8,
															 heightScale: CGFloat = 0.9,
															 offset: CGSize = .zero) -> UIView? {
		guard let view = originalView else {
			return nil
		}
		let shadow = UIView(frame: .zero)
		shadow.backgroundColor = .clear
		shadow.translatesAutoresizingMaskIntoConstraints = false
		shadow.layer.masksToBounds = false
		shadow.layer.shadowColor = UIColor.black.cgColor
		shadow.layer.shadowRadius = radius
		shadow.layer.shadowOpacity = opacity
		shadow.layer.shadowOffset = offset
		parentView?.insertSubview(shadow, belowSubview: view)
		
		shadow.snp.makeConstraints {
			$0.width.equalTo(view.snp.width).multipliedBy(widthScale)
			$0.height.equalTo(view.snp.height).multipliedBy(heightScale)
			$0.centerX.equalTo(view.snp.centerX)
			$0.centerY.equalTo(view.snp.centerY).offset(30)
		}
		guard let viewWidth = view.getConstraint(.width)?.constant,
					let viewHeight =  view.getConstraint(.height)?.constant else {
			assertionFailure("Fail to get size of shadow for \(String(describing: originalView))")
			return nil
		}
		shadow.layer.shadowPath = UIBezierPath(
			roundedRect: CGRect(x: 0, y: 0,
													width: viewWidth * widthScale,
													height: viewHeight * heightScale), cornerRadius: 0).cgPath
		return shadow
	}
	
	func getConstraint(_ attributes: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
			return constraints.filter {
					if $0.firstAttribute == attributes && $0.secondItem == nil {
							return true
					}
					return false
			}.first
	}
}

protocol DecendantsViews {
		func decedantsForEach(_ f: (UIView) -> Void)
}

extension DecendantsViews where Self: UIView {

		func decedantsForEach(_ f: (UIView) -> Void) {
				forEachView(self, f: f)
		}

		fileprivate func forEachView(_ view: UIView, f: (UIView) -> Void) {
				view.subviews.forEach {
						f($0)

						if $0.subviews.count > 0 {
								forEachView($0, f: f)
						}
				}
		}
}

extension UIView: DecendantsViews {}
