//
//  MapBakeryList.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MapBakeryList: View {
	
	@EnvironmentObject var infoManager: BakeryInfoManager
	@State private var showReviewSheet = false
	@State private var navigateBakery = false
	
	var body: some View {
		NavigationView {
			ScrollView{
				navigationLink
				LazyVStack(spacing: 0) {
					ForEach(infoManager.bakeriesOnMap) { bakery in
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
						.onTapGesture {
							infoManager.focusedBakery = bakery
							navigateBakery = true
						}
						Divider()
					}
				}
				.navigationBarHidden(true)
			}
		}
	}
	
	private var navigationLink: some View {
		NavigationLink("Navigation",
					   isActive: $navigateBakery
		) {
			BakeryDetail()
				.environmentObject(infoManager)
		}
		.onReceive(infoManager.$focusedBakery) {
			navigateBakery = $0 != nil
		}
		.hidden()
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
					.renderingMode(.template)
					.resizable()
					.frame(width: Constant.reviewButtonSize.width,
						   height: Constant.reviewButtonSize.height)
					.foregroundColor(Constant.reviewButtonColor)
			}
		}
	}
	
	private func drawDetail(for bakery: BakeryInfoManager.Bakery) -> some View {
		HStack {
			getImage(for: bakery)
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
							DesignConstant.getColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 800))
						)
						.cornerRadius(5)
				}
			}
			Spacer()
		}
	}
	
	private func getImage(for bakery: BakeryInfoManager.Bakery) -> some View {
		Group {
			if let url = bakery.imageUrl {
				WebImage(url: url)
					.resizable()
			}else {
				Image("bakery_dummy")
					.resizable()
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.frame(width: 120, height: 120)
	}
	
	private func drawStar(count: Double, size: CGSize) -> some View {
		HStack(spacing: 0){
			ForEach(Range<Int>(1...5)) { index in
				RatingStar(cornerRadius: 1.5)
					.size(size)
					.fill(index <= Int(count) ? Constant.ratingStarColor: Color.gray)
					.frame(width: size.width,
								 height: size.height)
			}
		}
	}
	
	private struct Constant {
		static let ratingStarSize = CGSize(width: 20, height: 20)
		static let ratingStarColor = DesignConstant.getColor(.primary(saturation: 600))
		static let reviewButtonSize = CGSize(width: 20, height: 20)
		static var reviewButtonColor: Color {
			DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.surface): .black
		}
		static let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 6)))
		static let primaryTextColor = DesignConstant.getColor(light: .secondary(staturation: 900), dark: .surface)
		static let hashTagFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let secondaryTextColor = DesignConstant.getColor(light: .secondary(staturation: 600), dark: .link)
		static let promoTextFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
	}
}


struct MapBakeryList_Previews: PreviewProvider {
	static var previews: some View {
		MapBakeryList().environmentObject(BakeryInfoManager(server: ServerDataOperator(), location: LocationGather()))
			.colorScheme(.dark)
	}
}
