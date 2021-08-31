//
//  BakeryFeedView.swift
//  Bbang
//
//  Created by bart Shin on 27/06/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct BakeryFeedView: View {
	let bakery: BakeryInfoManager.Bakery
	
	var body: some View {
		VStack (alignment: .leading, spacing: 0) {
			imageView
			nameView
				.padding(.top, 10)
			HStack {
				locationView
				ratingView
				Spacer()
				distanceView
			}
			.padding(.top, 9)
			hashTagView
		}
	}
	
	private var imageView: some View {
			Group {
				if let url = bakery.imageUrl {
					WebImage(url: url)
						.resizable()
				}else {
					Image("bakery_dummy")
						.resizable()
				}
			}
			.frame(width: 120, height: 120)
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
				.font(Constant.detailFont)
		}
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
	
	private var distanceView: some View {
		Text(bakery.distanceString)
			.foregroundColor(Constant.distanceColor)
			.font(Constant.detailFont)
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
		static var titleColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 900), dark: .secondary(staturation: 50))
		}
		static let detailFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
		static var areaFontColor: Color {
			DesignConstant.getColor(light: .onPrimary(for: .medium), dark: .secondary(staturation: 200))
		}
		static var areaBackgroundColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 800))
		}
		static let distanceColor = DesignConstant.getColor(light: .primary(saturation: 500), dark: .secondary(staturation: 200))
		static let reviewTextColor = DesignConstant.getColor(light: .secondary(staturation: 500), dark: .secondary(staturation: 400))
		static let reviewNumberColor = DesignConstant.getColor(light: .secondary(staturation: 900), dark: .secondary(staturation: 50))
		static let starSize: CGFloat = 12
		static let inActiveStarColor = DesignConstant.getColor(.secondary(staturation: 200))
		static let activeStarColor = DesignConstant.getColor(.primary(saturation: 600))
		static let hashTagFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let hashTagColor = DesignConstant.getColor(.link)
	}
}

struct BakeryFeedView_Previews: PreviewProvider {
	static var previews: some View {
		BakeryFeedView(bakery: BakeryInfoManager.dummys[0])
			.previewLayout(.sizeThatFits)
			.aspectRatio(BakeryFeedView.Constant.aspectRatio ,contentMode: .fit)
			.frame(height: 319)
	}
}
