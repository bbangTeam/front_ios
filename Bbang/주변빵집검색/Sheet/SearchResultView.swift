//
//  SearchResultView.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import SwiftUI

struct SearchResultView: View {
	
	@ObservedObject var searchController: MapSearchController
	
	var body: some View {
		ScrollView{
			LazyVStack(spacing: 0) {
				ForEach(MapSearchController.Store.dummys) { store in
					Group {
						drawTitle(store.name)
							.padding(.top, 17)
						drawDetail(for: store)
							.padding(.top, 9)
							.padding(.bottom, 16)
					}
					.padding(.horizontal, 16)
					Divider()
				}
			}
		}
	}
	
	private func drawTitle(_ title: String) -> some View {
		HStack {
			Text(title)
				.font(Constant.titleFont)
				.foregroundColor(Constant.primaryTextColor)
			Spacer()
			Button(action: {
				print("Write review")
			}) {
				Image("pen_icon")
					.resizable()
					.frame(width: Constant.reviewButtonSize.width,
								 height: Constant.reviewButtonSize.height)
					.foregroundColor(.black)
			}
		}
	}
	
	private func drawDetail(for store: MapSearchController.Store) -> some View {
		HStack {
			Image("bakery_dummy")
			VStack (alignment: .leading, spacing: 8){
				drawStar(count: store.rating,
								 size: Constant.ratingStarSize)
				Text(store.hashTag.joined(separator: " "))
					.font(Constant.hashTagFont)
					.foregroundColor(Constant.secondaryTextColor)
				ForEach(store.promoText, id: \.self) {
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
	
	private func drawStar(count: Int, size: CGSize) -> some View {
		HStack(spacing: 0){
			ForEach(Range<Int>(1...5)) { index in
				RatingStar()
					.size(size)
					.fill(index <= count ? Constant.ratingStarColor: Color.gray)
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


struct SearchResultView_Previews: PreviewProvider {
	static var previews: some View {
		SearchResultView(searchController: MapSearchController(server: ServerDataOperator()))
	}
}
