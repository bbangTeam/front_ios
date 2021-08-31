//
//  SlideViewLayout.swift
//  Bbang
//
//  Created by bart Shin on 27/05/2021.
//  Retouching Exapnding-collection by Alex K in Ramtoion

import UIKit
import SnapKit

class SlideViewLayout: UICollectionViewFlowLayout {
	
	private var storedCollectionViewSize: CGSize = CGSize.zero
	
	var scalingMinimumLimit: CGFloat = 200
	var minimumScaleFactor: CGFloat = 0.9
	var minimumAlphaFactor: CGFloat = 0.3
	var scaleItems: Bool = true
	
	init(itemSize: CGSize) {
		super.init()
		scrollDirection = .horizontal
		minimumLineSpacing = 25
		self.itemSize = itemSize
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
		super.invalidateLayout(with: context)
		
		guard let collectionView = self.collectionView else { return }
		
		if collectionView.bounds.size != storedCollectionViewSize {
			
			let horizontalInset = collectionView.bounds.size.width / 2 - itemSize.width / 2
			collectionView.contentInset = UIEdgeInsets.init(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
			collectionView.contentOffset = CGPoint(x: -horizontalInset, y: 0)
			storedCollectionViewSize = collectionView.bounds.size
		}
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		true
	}
	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard let collectionView = self.collectionView else {
				return proposedContentOffset
		}
		
		let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
		guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {
			return proposedContentOffset
		}
		
		var attributesOfMostLikely: UICollectionViewLayoutAttributes?
		let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2
		
		for attributes in layoutAttributes {
				if attributes.representedElementCategory != .cell {
						continue
				}

				if attributesOfMostLikely == nil {
						attributesOfMostLikely = attributes
						continue
				}

				if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(attributesOfMostLikely!.center.x - proposedContentOffsetCenterX) {
						attributesOfMostLikely = attributes
				}
		}
		guard attributesOfMostLikely != nil else {
			return proposedContentOffset
		}
		
		let offsetXMostLikely = attributesOfMostLikely!.center.x - collectionView.bounds.size.width/2
		var offsetXAdjusted = offsetXMostLikely
		let deltaNatural = offsetXMostLikely - collectionView.contentOffset.x
		
		// Force to move to swiped direction
		if (velocity.x < 0 && deltaNatural > 0) || (velocity.x > 0 && deltaNatural < 0) {
				let pageWidth = itemSize.width + minimumLineSpacing
			offsetXAdjusted += velocity.x > 0 ? pageWidth : -pageWidth
		}
		return CGPoint(x: offsetXAdjusted, y: proposedContentOffset.y)
	}
	
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
			guard let collectionView = self.collectionView,
					let superAttributes = super.layoutAttributesForElements(in: rect) else {
					return super.layoutAttributesForElements(in: rect)
			}
			if scaleItems == false {
					return super.layoutAttributesForElements(in: rect)
			}

			let contentOffset = collectionView.contentOffset
			let size = collectionView.bounds.size

			let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
			let visibleCenterX = visibleRect.midX

			guard case let newAttributesArray as [UICollectionViewLayoutAttributes] = NSArray(array: superAttributes, copyItems: true) else {
					return nil
			}

			newAttributesArray.forEach {
					let distanceFromCenter = visibleCenterX - $0.center.x
					let distanceToUse = min(abs(distanceFromCenter), self.scalingMinimumLimit)
					let scale = distanceToUse * (self.minimumScaleFactor - 1) / self.scalingMinimumLimit + 1
					$0.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)

					let alpha = distanceToUse * (self.minimumAlphaFactor - 1) / self.scalingMinimumLimit + 1
					$0.alpha = alpha
			}

			return newAttributesArray
	}
}
