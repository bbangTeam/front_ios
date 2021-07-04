//
//  HomeBakeryList.swift
//  Bbang
//
//  Created by bart Shin on 28/06/2021.
//

import SwiftUI

struct HomeBakeryList: View {
	
	let bakeries: [BakeryInfoManager.Bakery]
	
    var body: some View {
		VStack(spacing: 0) {
			topBar
				.padding(.bottom, 16)
			ForEach(bakeries) {
				BakeryFeedView(bakery: $0)
					.padding(.bottom, 40)
			}
		}
		.padding(.top, 24)
		.padding(.horizontal, Constant.horizontalMargin)
	}
	
	private var topBar: some View {
		HStack {
			Text("내 주변 빵집")
				.font(Constant.titleFont)
			Spacer()
			Button {
				
			} label: {
				Text("더보기")
					.font(Constant.moreButtonFont)
					.foregroundColor(Constant.moreButtonColor)
			}
		}
		.frame(height: Constant.topBarHeight)
	}
	
	struct Constant {
		static let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 6)))
		static let moreButtonFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let moreButtonColor = DesignConstant.getColor(palette: .secondary(staturation: 500))
		static let topBarHeight: CGFloat = 64
		static let horizontalMargin: CGFloat = 16
	}
}

struct HomeBakeryList_Previews: PreviewProvider {
    static var previews: some View {
		HomeBakeryList(bakeries: BakeryInfoManager.Bakery.dummys)
			.previewLayout(.sizeThatFits)
			.frame(width: 375, height: 1755, alignment: .top)
    }
}
