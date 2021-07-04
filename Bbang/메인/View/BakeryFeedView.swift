//
//  BakeryFeedView.swift
//  Bbang
//
//  Created by bart Shin on 27/06/2021.
//

import SwiftUI

struct BakeryFeedView: View {
	let bakery: BakeryInfoManager.Bakery
	
    var body: some View {
		VStack (alignment: .leading, spacing: 0) {
			imageView
			nameView
				.padding(.top, 10)
			locationView
				.padding(.top, 9)
			ratingView
			hashTagView
		}
    }
	
	private var imageView: some View {
		Image("bakery_dummy")
			.resizable()
			.aspectRatio(Constant.imageRatio, contentMode: .fill)
			.cornerRadius(Constant.imageCornerRadius)
	}
	
	private var nameView: some View {
		Text(bakery.name)
			.lineLimit(1)
			.font(Constant.titleFont)
			.foregroundColor(Constant.titleColor)
	}
	
	private var locationView: some View {
		HStack (spacing: 8) {
			Text(bakery.area)
				.foregroundColor(Constant.areaFontColor)
				.padding(.horizontal, 6)
				.padding(.vertical, 3)
				.background(
					RoundedRectangle(cornerRadius: 2)
						.fill(Constant.areaBackgroundColor)
				)
			Text(bakery.distance)
				.foregroundColor(Constant.distanceColor)
		}
		.font(Constant.detailFont)
	}
	
	private var ratingView: some View {
		HStack(spacing: 0) {
			ForEach(1..<6) { index in
				HStack(spacing: 0) {
					Constant.activeStarColor
						.frame(width: Constant.starSize * calcWidthRate(for: index))
					Constant.inActiveStarColor
				}
				.frame(width: Constant.starSize, height: Constant.starSize)
				.clipShape(
					RatingStar(cornerRadius: 0.4))
					
			}
			Text("리뷰")
				.font(Constant.detailFont)
				.foregroundColor(Constant.reviewTextColor)
				.padding(.leading, 8)
			Text("\(bakery.reviews.count)")
				.font(Constant.detailFont)
				.foregroundColor(Constant.reviewNumberColor)
				.padding(.leading, 2)
		}
		.padding(.top, 8)
	}
	
	private func calcWidthRate(for index: Int) -> CGFloat {
		CGFloat(max(min(bakery.rating + 1 - Double(index), 1), 0))
	}
	
	private var hashTagView: some View {
		Text(bakery.hashTag.compactMap {"#\($0)"}.joined(separator: " "))
			.lineLimit(2)
			.font(Constant.hashTagFont)
			.foregroundColor(Constant.hashTagColor)
			.padding(.top, 8)
	}
	
	struct Constant {
		static let aspectRatio: CGFloat = 344/319
		static let imageRatio: CGFloat = 343/210
		static let imageCornerRadius: CGFloat = 4
		static let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		static let titleColor = DesignConstant.getColor(palette: .secondary(staturation: 900))
		static let detailFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
		static let areaFontColor = DesignConstant.getColor(palette: .onPrimary(for: .medium))
		static let areaBackgroundColor = DesignConstant.getColor(palette: .secondary(staturation: 100))
		static let distanceColor = DesignConstant.getColor(palette: .secondary(staturation: 400))
		static let reviewTextColor = DesignConstant.getColor(palette: .secondary(staturation: 500))
		static let reviewNumberColor = DesignConstant.getColor(palette: .secondary(staturation: 900))
		static let starSize: CGFloat = 12
		static let inActiveStarColor = DesignConstant.getColor(palette: .secondary(staturation: 200))
		static let activeStarColor = DesignConstant.getColor(palette: .primary(saturation: 600))
		static let hashTagFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let hashTagColor = DesignConstant.getColor(palette: .link)
	}
}

struct BakeryFeedView_Previews: PreviewProvider {
    static var previews: some View {
		BakeryFeedView(bakery: BakeryInfoManager.Bakery.dummys[0])
			.previewLayout(.sizeThatFits)
			.aspectRatio(BakeryFeedView.Constant.aspectRatio ,contentMode: .fit)
			.frame(height: 319)
    }
}
