//
//  MyPostView.swift
//  Bbang
//
//  Created by bart Shin on 01/08/2021.
//

import SwiftUI

struct MyPostView: View {
	@State private var currentCategory: Category = .bbangstargram
	let bsPosts: [BbangstargramPost]
	
    var body: some View {
		VStack {
			categorySelector
				.frame(width: Constant.segmentedSize.width,
					   height: Constant.segmentedSize.height)
			if currentCategory == .bbangstargram {
				bsPostsView
			}
		}
    }
	
	private var categorySelector: some View {
		Picker("Category", selection: $currentCategory) {
			ForEach(Category.allCases, id: \.rawValue) {
				Text($0.rawValue)
					.tag($0)
			}
		}
		.padding(4)
		.pickerStyle(SegmentedPickerStyle()) 
		.background(
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color.black, lineWidth: 1)
		)
	}
	
	private var bsPostsView: some View {
		ScrollView {
			VStack {
				if bsPosts.isEmpty {
					// TODO: Empty post placeholder
				}else {
					ForEach(bsPosts) { post in
						BbangstargramPostView(post: post)
					}
				}
			}
		}
	}
	
	enum Category: String, CaseIterable {
		case bbangstargram = "빵스타 그램"
		case famousBakery = "빵지 순례"
	}
	
	init(bsPosts: [BbangstargramPost]) {
		UISegmentedControl.appearance().selectedSegmentTintColor = Constant.segmentedTintColor
		UISegmentedControl.appearance().backgroundColor = .white
		self.bsPosts = bsPosts
	}
	
	private struct Constant {
		static let segmentedTintColor = DesignConstant.getUIColor(.primary(saturation: 500))
		static let segmentedSize = CGSize(width: 177, height: 39)
	}
}

struct MyPostView_Previews: PreviewProvider {
    static var previews: some View {
		MyPostView(bsPosts: [
			.dummy,
			.dummy
		])
    }
}
