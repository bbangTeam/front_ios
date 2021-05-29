//
//  SlideCollectionView.swift
//  Bbang
//
//  Created by bart Shin on 27/05/2021.
//  Retouching Exapnding-collection by Alex K in Ramtoion

import UIKit

class SlideCollectionView: UICollectionView {
	
	class func create(in parentView: UIView,
													layout: UICollectionViewLayout,
													height: CGFloat,
													dataSource: UICollectionViewDataSource,
													delegate: UICollectionViewDelegate) -> SlideCollectionView {

		let collectionView = SlideCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.decelerationRate = .fast
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.dataSource = dataSource
		collectionView.delegate = delegate
		collectionView.backgroundColor = .clear
		parentView.addSubview(collectionView)
		
		collectionView.snp.makeConstraints {
			$0.height.equalTo(height)
			$0.left.right.centerY.equalTo(parentView)
		}
		return collectionView
	}
}
