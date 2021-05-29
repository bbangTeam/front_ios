//
//  SlideViewController.swift
//  Bbang
//
//  Created by bart Shin on 27/05/2021.
//  Retouching Exapnding-collection by Alex K in Ramtoion

import UIKit

class SlideViewController: UIViewController {
	
	open var itemSize: CGSize = .zero
	open var collectionView: UICollectionView?
	
	open var currentIndex: Int {
		guard let collectionView = self.collectionView else { return 0 }
		
		let startOffset = (collectionView.bounds.size.width - itemSize.width) / 2
		guard let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
			return 0
		}
		
		let minimumLineSpacing = collectionLayout.minimumLineSpacing
		let currentOffset = collectionView.contentOffset.x + startOffset + itemSize.width / 2
		let unitWidth = itemSize.width + minimumLineSpacing
		return Int(currentOffset / unitWidth)
	}
	
	open override func viewDidLoad() {
		guard itemSize != .zero else {
			assertionFailure("Item size for \(self) is not set")
			return
		}
		super.viewDidLoad()
		let layout = SlideViewLayout(itemSize: itemSize)
		collectionView = SlideCollectionView.create(
			in: view,
			layout: layout,
			height: itemSize.height,
			dataSource: self,
			delegate: self)
		collectionView?.clipsToBounds = false
		if #available(iOS 10.0, *) {
			collectionView?.isPrefetchingEnabled = false
		}
	}
}

extension SlideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard case let cell as SlideCardCell = cell else {
			return
		}
		cell.adjustSubviewsConstraint(itemSize: itemSize)
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assertionFailure("Not implemented")
		return 0
	}
	
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		assertionFailure("Not implemented")
		return UICollectionViewCell()
	}
	
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		assertionFailure("Not implemented")
		return 0
	}
	
	open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Select slide card is not implemented")
	}
	open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		print("Scroll card slide is not implemented")
	}
}
