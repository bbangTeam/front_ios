//
//  MapSearchController.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import Foundation

class MapSearchController: ObservableObject {
	let server: ServerDataOperator
	var searchString: String = ""
	
	func search(for searchString: String) {
		print("searching: \(searchString)")
		self.searchString = searchString
		objectWillChange.send()
	}
	
	init(server: ServerDataOperator) {
		self.server = server
	}
	
	struct Store: Identifiable {
		let name: String
		let imageUrl: URL
		let rating: Int
		let hashTag: [String]
		let promoText: [String]
		let id = UUID()
		
		static let dummys: [Store] = [
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 4,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						]),
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 3,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						]),
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 5,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						]),
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 5,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						]),
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 5,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						]),
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 5,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						]),
			.init(name: "매장 이름",
						imageUrl: URL(string: "https://www.google.com")!,
						rating: 5,
						hashTag: ["#단팥빵", "#크로와상", "#커피맛집"],
						promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						])
		]
	}
}

