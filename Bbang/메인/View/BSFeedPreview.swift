//
//  BSFeedPreview.swift
//  Bbang
//
//  Created by bart Shin on 04/07/2021.
//

import SwiftUI

struct BSFeedPreview: View {
	
	let feed: BSFeed
	@Binding var mainImage: UIImage?
	static let placeHolderImage = UIImage(named: "bbangstargram_dummy")!
	
    var body: some View {
		VStack (alignment: .leading, spacing: 0){
			previewImage
			VStack (alignment: .leading, spacing: 2) {
				bakeryName
				breadName
				hashTag
			}
			.padding(.horizontal, 16)
			.padding(.top, 8)
		}
    }
	
	private var previewImage: some View {
		Image(uiImage: mainImage ?? Self.placeHolderImage)
			.resizable()
			.frame(width: Constant.imageSize, height: Constant.imageSize)
			.cornerRadius(Constant.imageSize / 2)
	}
	
	private var bakeryName: some View {
		Text(feed.bakeryName)
			.lineLimit(1)
			.font(Constant.bakeryFont)
			.foregroundColor(Constant.primaryFontColor)
	}
	
	private var breadName: some View {
		Text(feed.breadName)
			.lineLimit(1)
			.font(Constant.breadFont)
			.foregroundColor(Constant.primaryFontColor)
	}
	
	private var hashTag: some View {
		Text("좋아요 \(feed.like)개")
			.lineLimit(1)
			.font(Constant.hashTagfont)
			.foregroundColor(Constant.hashTagFontColor)
	}
	
	struct Constant {
		static let imageSize: CGFloat = 140
		static let bakeryFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		static let breadFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let hashTagfont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
		static var primaryFontColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 900), dark: .secondary(staturation: 50))
		}
		static var secondaryFontColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 800), dark: .secondary(staturation: 200))
		}
		static let hashTagFontColor = DesignConstant.getColor(.secondary(staturation: 400))
	}
}

struct BSFeedPreview_Previews: PreviewProvider {
    static var previews: some View {
		BSFeedPreview(
			feed: BSFeed.dummy,
			mainImage: .constant(BSFeedPreview.placeHolderImage))
    }
}
