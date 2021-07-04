//
//  MapBakeryList.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import SwiftUI

struct MapBakeryList: View {
	
	@EnvironmentObject var infoManager: BakeryInfoManager
	@State private var showReviewSheet = false
	
	var body: some View {
		NavigationView {
			ScrollView{
				LazyVStack(spacing: 0) {
					ForEach(BakeryInfoManager.Bakery.dummys) { bakery in
						NavigationLink(
							destination: BakeryDetail(bakery: bakery))
						{
							VStack {
								drawTitle(for: bakery)
									.padding(.top, 17)
									.sheet(isPresented: $showReviewSheet) {
										ReviewWritingView(bakery: bakery)
									}
								drawDetail(for: bakery)
									.padding(.top, 9)
									.padding(.bottom, 16)
							}
							.padding(.horizontal, 16)
						}
						Divider()
					}
				}
				.navigationBarHidden(true)
			}
		}
	}
	
	private func drawTitle(for bakery: BakeryInfoManager.Bakery) -> some View {
		HStack {
			Text(bakery.name)
				.font(Constant.titleFont)
				.foregroundColor(Constant.primaryTextColor)
			Spacer()
			Button(action: {
				showReviewSheet = true
			}) {
				Image("pen_icon")
					.resizable()
					.frame(width: Constant.reviewButtonSize.width,
						   height: Constant.reviewButtonSize.height)
					.foregroundColor(.black)
			}
		}
	}
	
	private func drawDetail(for bakery: BakeryInfoManager.Bakery) -> some View {
		HStack {
			Image("bakery_dummy")
			VStack (alignment: .leading, spacing: 8){
				drawStar(count: bakery.rating,
								 size: Constant.ratingStarSize)
				Text(bakery.hashTag.compactMap {"#\($0)"}.joined(separator: " "))
					.font(Constant.hashTagFont)
					.lineLimit(2)
					.foregroundColor(Constant.secondaryTextColor)
				ForEach(bakery.promoText, id: \.self) {
					Text($0)
						.font(Constant.promoTextFont)
						.foregroundColor(Constant.primaryTextColor)
						.padding(.horizontal, 6)
						.padding(.vertical, 4)
						.background(
							Color(DesignConstant.getUIColor(palette: .secondary(staturation: 100)))
						)
						.cornerRadius(5)
				}
			}
			Spacer()
		}
	}
	
	private func drawStar(count: Double, size: CGSize) -> some View {
		HStack(spacing: 0){
			ForEach(Range<Int>(1...5)) { index in
				RatingStar(cornerRadius: 1.5)
					.size(size)
					// FIXME: - Fill stars with decimal parts
					.fill(index <= Int(count) ? Constant.ratingStarColor: Color.gray)
					.frame(width: size.width,
								 height: size.height)
			}
		}
	}
	
	private struct Constant {
		static let ratingStarSize = CGSize(width: 20, height: 20)
		static let ratingStarColor = DesignConstant.getColor(palette: .primary(saturation: 600))
		static let reviewButtonSize = CGSize(width: 20, height: 20)
		static let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 6)))
		static let primaryTextColor = DesignConstant.getColor(palette: .secondary(staturation: 900))
		static let hashTagFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let secondaryTextColor = DesignConstant.getColor(palette: .secondary(staturation: 600))
		static let promoTextFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
	}
}


struct MapBakeryList_Previews: PreviewProvider {
	static var previews: some View {
		MapBakeryList().environmentObject(BakeryInfoManager(server: ServerDataOperator()))
	}
}
