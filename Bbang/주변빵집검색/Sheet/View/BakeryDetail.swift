//
//  BakeryDetail.swift
//  Bbang
//
//  Created by bart Shin on 19/06/2021.
//

import SwiftUI

struct BakeryDetail: View {
	@EnvironmentObject var searchController: BakeryInfoManager
	let bakery: BakeryInfoManager.Bakery
	
	var body: some View {
		VStack {
			Text(bakery.name)
			Image("bakery_dummy")
			Spacer()
		}
	}
}

struct BakeryDetail_Previews: PreviewProvider {
	
	static var previews: some View {
		BakeryDetail(bakery: BakeryInfoManager.dummys[0])  
			.environmentObject(BakeryInfoManager(server: ServerDataOperator(), location: LocationGather()))
	}
}
