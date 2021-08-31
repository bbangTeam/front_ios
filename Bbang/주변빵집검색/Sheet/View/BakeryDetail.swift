//
//  BakeryDetail.swift
//  Bbang
//
//  Created by bart Shin on 19/06/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct BakeryDetail: View {
	@EnvironmentObject var infoManager: BakeryInfoManager
	
	var bakery: BakeryInfoManager.Bakery? {
		infoManager.focusedBakery
	}
	
	var body: some View {
		if bakery != nil {
			VStack {
				Text(bakery!.name)
				getImage(for: bakery!)
				Spacer()
			}
			.onDisappear {
				infoManager.focusedBakery = nil
			}
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
}

struct BakeryDetail_Previews: PreviewProvider {
	
	static var previews: some View {
		BakeryDetail()
	}
}
