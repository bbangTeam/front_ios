//
//  BakeryInfoManager.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import Foundation

class BakeryInfoManager: ObservableObject {
	let server: ServerDataOperator
	
	func search(for searchString: String) {
		print("searching: \(searchString)")
		objectWillChange.send()
	}
	
	init(server: ServerDataOperator) {
		self.server = server
	}
	
	struct Bakery: Identifiable {
		let name: String
		let area: String
		let imageUrl: URL
		let rating: Double
		let hashTag: [String]
		let promoText: [String]
		let distance: String
		let reviews: [Review]
		let id: UUID
		
		static var dummys: [Bakery] {
			var dummys = [Bakery]()
			(0...5).forEach { _ in
				dummys.append(
					Bakery(name: "매장 이름",
						   area: "둔촌동",
						   imageUrl: URL(string: "https://www.google.com")!,
						   rating: 2.5,
						   hashTag: ["단팥빵", "크로와상", "커피맛집", "크로와상", "커피맛집"],
						   promoText: [
							"아침에 빵과 커피를 즐겨보세요",
							"매일 맛있는 빵이 새로 나와요"
						   ],
						   distance: "700m",
						   reviews: .init(
							repeating: Review.dummy, count: 3),
						   id: UUID())
				)
			}
			return dummys
		}
		struct Review {
			let author: String
			let content: String
			let date: Date
			
			static let dummy = Review(author: "작성자",
									  content: "리뷰 내용",
									  date: Date())
		}
	}
}

