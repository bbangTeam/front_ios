//
//  CGPoint.swift
//  Bbang
//
//  Created by bart Shin on 04/06/2021.
//

import CoreGraphics

extension CGPoint {
		
		func distance(from point: CGPoint) -> CGFloat {
				return hypot(point.x - self.x, point.y - self.y)
		}
}
