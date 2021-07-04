//
//  RatingStar.swift
//  Bbang
//
//  Created by bart Shin on 17/06/2021.
//

import SwiftUI

struct RatingStar: Shape {
	private let rotation: CGFloat = 55
	let cornerRadius: CGFloat
	
	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let r = rect.width/2
		let rc = cornerRadius
		let rn = r * 0.95 - rc
		var cangle = rotation
		return Path { path in
			
			for i in 1 ... 5 {
				// compute center point of tip arc
				let cc = CGPoint(x: center.x + rn * cos(cangle * .pi / 180), y: center.y + rn * sin(cangle * .pi / 180))
				
				// compute tangent point along tip arc
				let p = CGPoint(x: cc.x + rc * cos((cangle - 72) * .pi / 180), y: cc.y + rc * sin((cangle - 72) * .pi / 180))
				
				if i == 1 {
					path.move(to: p)
				} else {
					path.addLine(to: p)
				}
				
				// add 144 degree arc to draw the corner
				path.addArc(center: cc,
							radius: rc,
							startAngle: Angle(degrees: Double(cangle - 72)),
							endAngle: Angle(degrees: Double(cangle + 72)), clockwise: false)
				cangle += 144
			}
			path.closeSubpath()
		}
	}
	
	init(cornerRadius: CGFloat = 10) {
		self.cornerRadius = cornerRadius
	}
}

struct RatingStar_Previews: PreviewProvider {
	static var previews: some View {
		RatingStar(cornerRadius: 2)
			.size(CGSize(width: 20, height: 20))
			.fill()
	}
}
