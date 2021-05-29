//
//  SlideCardCell.swift
//  Bbang
//
//  Created by bart Shin on 27/05/2021.
//  Retouching Exapnding-collection by Alex K in Ramtoion

import UIKit

class SlideCardCell: UICollectionViewCell {
	
	// MARK: UI adjust
	/// A Boolean value that indicates whether the cell is opened.
	open var isOpened = false
	open var animationDuration: TimeInterval = 0.5
	
	/// DEPRECATED! Animation oposition offset when cell is open
	@IBInspectable open var yOffset: CGFloat = 40
	/// Spacing between centers of views
	@IBInspectable open var ySpacing: CGFloat = CGFloat.greatestFiniteMagnitude
	/// Additional height of back view, when it grows
	@IBInspectable open var additionalHeight: CGFloat = CGFloat.greatestFiniteMagnitude
	/// Additional width of back view, when it grows
	@IBInspectable open var additionalWidth: CGFloat = CGFloat.greatestFiniteMagnitude
	/// Should front view drow shadow to bottom or not
	@IBInspectable open var dropShadow: Bool = true

	
	/// The view used as the face of the cell must connectid from xib or storyboard.
	@IBOutlet open var frontContainerView: UIView!
	/// Set view tag in nib to hide when card is open
	let viewTagForHide = 99
	/// The view used as the back of the cell must connectid from xib or storyboard.
	@IBOutlet open var backContainerView: UIView!
	
	/// constraints for backContainerView must connectid from xib or storyboard
	@IBOutlet open var backConstraintY: NSLayoutConstraint!
	/// constraints for frontContainerView must connectid from xib or storyboard
	@IBOutlet open var frontConstraintY: NSLayoutConstraint!
	var shadowView: UIView?
	
	
	// MARK:- Set up
	override init(frame: CGRect) {
		super.init(frame: frame)
		initLayers()
		shadowView = UIView.createShadowView(in: contentView, behind: frontContainerView)
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		initLayers()
		shadowView = UIView.createShadowView(in: contentView, behind: frontContainerView)
	}
	
	fileprivate func initLayers() {
		backContainerView.layer.masksToBounds = true
		backContainerView.layer.cornerRadius = 5

		frontContainerView.layer.masksToBounds = true
		frontContainerView.layer.cornerRadius = 5

		contentView.layer.masksToBounds = false
		layer.masksToBounds = false
	}
	
	func adjustSubviewsConstraint(itemSize: CGSize) {
		guard isOpened == false && frontContainerView.getConstraint(.width)?.constant != itemSize.width else { return }

		[frontContainerView, backContainerView].forEach {
				let constraintWidth = $0?.getConstraint(.width)
				constraintWidth?.constant = itemSize.width

				let constraintHeight = $0?.getConstraint(.height)
				constraintHeight?.constant = itemSize.height
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		connectOutletFromDecoder(aDecoder)
	}
	
	fileprivate func connectOutletFromDecoder(_ coder: NSCoder) {
			if case let shadowView as UIView = coder.decodeObject(forKey: Constants.shadowView) {
					self.shadowView = shadowView
			}

			if case let backView as UIView = coder.decodeObject(forKey: Constants.backContainer) {
					backContainerView = backView
			}

			if case let frontView as UIView = coder.decodeObject(forKey: Constants.frontContainer) {
					frontContainerView = frontView
			}

			if case let constraint as NSLayoutConstraint = coder.decodeObject(forKey: Constants.frontContainerY) {
					frontConstraintY = constraint
			}

			if case let constraint as NSLayoutConstraint = coder.decodeObject(forKey: Constants.backContainerY) {
					backConstraintY = constraint
			}
	}
	
	// MARK: Transition
	
	public func changeState(toOpen: Bool, animated: Bool = true) {
		if toOpen == isOpened {
			backContainerView?.alpha = isOpened ? 1: 0
			contentView.decedantsForEach { view in
				if view.tag == viewTagForHide {
					view.alpha = isOpened ? 0: 1
				}
			}
			return
		}

		if ySpacing == .greatestFiniteMagnitude {
				frontConstraintY.constant = toOpen ? -frontContainerView.bounds.size.height / 6 : 0
				backConstraintY.constant = toOpen ? frontContainerView.bounds.size.height / 6 - yOffset / 2 : 0
		} else {
				frontConstraintY.constant = toOpen ? -ySpacing / 2 : 0
				backConstraintY.constant = toOpen ? ySpacing / 2 : 0
		}

		if let widthConstant = backContainerView.getConstraint(.width) {
				if additionalWidth == .greatestFiniteMagnitude {
						widthConstant.constant = toOpen ? frontContainerView.bounds.size.width + yOffset : frontContainerView.bounds.size.width
				} else {
						widthConstant.constant = toOpen ? frontContainerView.bounds.size.width + additionalWidth : frontContainerView.bounds.size.width
				}
		}

		if let heightConstant = backContainerView.getConstraint(.height) {
				if additionalHeight == .greatestFiniteMagnitude {
						heightConstant.constant = toOpen ? frontContainerView.bounds.size.height + yOffset : frontContainerView.bounds.size.height
				} else {
						heightConstant.constant = toOpen ? frontContainerView.bounds.size.height + additionalHeight : frontContainerView.bounds.size.height
				}
		}

		isOpened = toOpen

		if animated {
				UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(), animations: { [self] in
					contentView.layoutIfNeeded()
					backContainerView?.alpha = isOpened ? 1: 0
					contentView.decedantsForEach { view in
						if view.tag == viewTagForHide {
							view.alpha = isOpened ? 0: 1
						}
					}
				}, completion: nil)
		} else {
				contentView.layoutIfNeeded()
			self.backContainerView?.alpha = self.isOpened ? 1: 0
		}
	}
	
	
	struct Constants {
		 static let backContainer = "backContainerViewKey"
		 static let shadowView = "shadowViewKey"
		 static let frontContainer = "frontContainerKey"

		 static let backContainerY = "backContainerYKey"
		 static let frontContainerY = "frontContainerYKey"
	}
}


