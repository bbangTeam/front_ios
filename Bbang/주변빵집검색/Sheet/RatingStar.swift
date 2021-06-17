//
//  RatingStar.swift
//  Bbang
//
//  Created by bart Shin on 17/06/2021.
//

import SwiftUI

struct RatingStar: Shape {
	let rotation: CGFloat = 55
	
	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let r = rect.width/2
		let rn = r * 0.95
		var cangle = rotation
		return Path { path in
			for i in 1...5 {
				// Compute center point of tip arc
				let cc = CGPoint(x: center.x + rn*cos(cangle * .pi / 180),
												 y: center.y + rn*sin(cangle * .pi / 180))
				// Compute tangent point along tip arc
				let p = CGPoint(
					x: cc.x + cos(cangle - 72) * .pi / 180,
					y: cc.y + sin(cangle - 72) * .pi / 180)
				if i == 1 {
					path.move(to: p)
				} else {
					path.addLine(to: p)
				}
				cangle += 144
			}
			path.closeSubpath()
		}
	}
}
