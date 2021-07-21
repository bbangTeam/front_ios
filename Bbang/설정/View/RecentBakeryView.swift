//
//  RecentBakeryView.swift
//  Bbang
//
//  Created by bart Shin on 12/07/2021.
//

import SwiftUI

struct RecentBakeryView: View {
	
	let bakeries: [BakeryInfoManager.Bakery]

    var body: some View {
		VStack {
			titleBar
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 16) {
					ForEach(bakeries) { bakery in
						NavigationLink(
							destination: Text(bakery.name)) {
							drawBakeryPreview(for: bakery)
						}
					}
				}
			}
		}
		.padding(.leading, 16)
	}
	
	fileprivate var titleBar: some View {
		HStack {
			Text("최근 본 빵집")
				.font(Constant.titleFont)
				.foregroundColor(Constant.titleColor)
			Spacer()
			Button(action: {
				
			}) {
				Text("더보기")
					.font(Constant.moreButtonFont)
					.foregroundColor(Constant.moreButtonColor)
			}
		}
	}
	
	fileprivate func drawBakeryPreview(for bakery: BakeryInfoManager.Bakery) -> some View {
		VStack(spacing: 0) {
			Image("bakery_dummy")
				.resizable()
				.frame(width: Constant.imageSize.width, height: Constant.imageSize.height)
				.aspectRatio(contentMode: .fit)
			drawBakeryInfo(for: bakery)
				.padding(.top, 8)
		}
	}
	
	fileprivate func drawBakeryInfo(for bakery: BakeryInfoManager.Bakery) -> some View {
		VStack {
			Text(bakery.name)
				.font(Constant.titleFont)
				.foregroundColor(Constant.titleColor)
			HStack(spacing: 8){
				Text(bakery.area)
					.foregroundColor(Constant.areaFontColor)
					.padding(.vertical, 3)
					.padding(.horizontal, 6)
					.background(Constant.areaBackgroundColor)
					.cornerRadius(2)
				Text(bakery.distance)
					.foregroundColor(Constant.distanceColor)
			}
			.font(Constant.captionFont)
		}
	}
	
	struct Constant {
		static let imageSize = CGSize(width: 96, height: 96)
		static let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		static let titleColor = DesignConstant.getColor(light: .secondary(staturation: 900), dark: .surface)
		static let moreButtonFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let moreButtonColor = DesignConstant.getColor(.secondary(staturation: 500))
		static var areaBackgroundColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 800))
		}
		static let captionFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
		static var areaFontColor: Color {
			DesignConstant.getColor(light: .onPrimary(for: .medium), dark: .secondary(staturation: 200))
		}
		static let distanceColor = DesignConstant.getColor(.secondary(staturation: 400))
	}
}

struct RecentBakeryView_Previews: PreviewProvider {
    static var previews: some View {
		RecentBakeryView(bakeries: BakeryInfoManager.dummys)
			.padding(.vertical, 24)
			.previewLayout(.fixed(width: 375.0, height: 275.0))
    }
}



