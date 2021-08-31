//
//  ResizedPageControl.swift
//  Bbang
//
//  Created by bart Shin on 07/06/2021.
//

import UIKit

class ResizedPageControl: UIPageControl {

	private func sizeOfDot(at index: Int) -> CGSize {
		if index == currentPage {
			return CGSize(width: 8, height: 8)
		}else {
			return CGSize(width: 6, height: 6)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard let dots = subviews.first?.subviews.first?.subviews else {
			return
		}
		dots.enumerated().forEach { (index, dot) in
			dot.bounds.size = sizeOfDot(at: index)
		}
	}
	
	override func size(forNumberOfPages pageCount: Int) -> CGSize {
		let width = CGFloat((6+4)*(numberOfPages-1) + 18)
		return CGSize(width: width, height: 10)
	}
}
