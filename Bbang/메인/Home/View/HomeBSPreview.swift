//
//  HomeBSPreview.swift
//  Bbang
//
//  Created by bart Shin on 04/07/2021.
//

import SwiftUI

struct HomeBSPreview<DataSourceT>: View where DataSourceT: BSPreviewDataSouce {
	
	@ObservedObject var dataSource: DataSourceT
	
	private var tapFeed: (BSFeed) -> Void
	
	private let constant = Constant()
    var body: some View {
		VStack {
			topBar
				.padding(.horizontal, 16)
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					Spacer(minLength: 16)
					ForEach(dataSource.feeds) { feed in
						BSFeedPreview(
							feed: feed,
							mainImage: $dataSource.feedImages[feed])
							.onTapGesture {
								tapFeed(feed)
							}
					}
				}
			}
		}
    }
	
	private var topBar: some View {
		HStack {
			Text("빵스타그램")
				.font(constant.titleFont)
				.foregroundColor(constant.titleColor)
			Spacer()
			Button(action: {
				
			}){
				Text("더보기")
					.font(constant.moreButtonFont)
					.foregroundColor(constant.moreButtonColor)
			}
		}
	}
	
	fileprivate struct Constant {
		let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 6)))
		var titleColor: Color {
			DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.surface): .black
		}
		let moreButtonFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		var moreButtonColor: Color {
			return DesignConstant.getColor(light: .secondary(staturation: 500), dark: .secondary(staturation: 400))		}
	}
	
	init(dataSource: DataSourceT, tapFeed: @escaping (BSFeed) -> Void) {
		self.dataSource = dataSource
		self.tapFeed = tapFeed
	}
}

protocol BSPreviewDataSouce: ObservableObject {
	var feeds: [BSFeed] { get set }
	var feedImages: [BSFeed: UIImage] { get set }
}
