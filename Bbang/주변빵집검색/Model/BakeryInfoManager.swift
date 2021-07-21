//
//  BakeryInfoManager.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import Foundation
import CoreLocation

class BakeryInfoManager: ObservableObject {
	let server: ServerDataOperator
	let location: LocationGather
	
	static var dummys: [Bakery] {
		[Bakery(), Bakery(), Bakery(), Bakery(), Bakery(), Bakery()]
	}
	
	func search(for searchString: String) {
		print("searching: \(searchString)")
		objectWillChange.send()
	}
	
	init(server: ServerDataOperator, location: LocationGather) {
		self.server = server
		self.location = location
	}
	
	struct Bakery: Identifiable {
		let name: String
		let area: String
		let rating: Double
		let hashTag: [String]
		let promoText: [String]
		let distance: String
		let reviews: [Review]
		let id: String
		let location: CLLocationCoordinate2D
		var isClear: Bool
		let imageUrl: URL?
		
		init?(from dictionary: [String: Any]) {
			guard let name = dictionary["storeName"] as? String,
				  let id = dictionary["id"] as? String,
				  let isClear = dictionary["clear"] as? Int,
				  let longitude = dictionary["longitude"] as? Double,
				  let latitude = dictionary["latitude"] as? Double ,
				  let urlString = dictionary["imageUrl"] as? String else {
				print("Fail to create parse store information from \(dictionary)")
				return nil
			}
			self.name = name
			self.id = id
			if isClear == 0 {
				self.isClear = false
			}else if isClear == 1 {
				self.isClear = true
			}else {
				print("Invaild clear value of \(name)")
				return nil
			}
			//FIXME: Missing data from server
			self.area = ""
			self.distance = ""
			self.promoText = []
			self.rating = 0
			self.hashTag = []
			self.reviews = []
			self.imageUrl = URL(string: urlString)
			self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		}
		
		fileprivate init() {
			id = UUID().uuidString
			distance = "700m"
			name = "매장 이름"
			area = "둔촌동"
			location = .init(latitude: LocationGather.seoulLocation.latitude, longitude: LocationGather.seoulLocation.longitude)
			imageUrl = URL(string: "https://www.google.com")!
			rating = 2.5
			hashTag = ["단팥빵", "크로와상", "커피맛집", "크로와상", "커피맛집"]
			promoText = [
			"아침에 빵과 커피를 즐겨보세요",
			"매일 맛있는 빵이 새로 나와요"
			]
			isClear = false
			reviews = .init(repeating: Review(author: "작성자", content: "리뷰 내용", date: Date(), rating: 2, bakeryId: id), count: 3)
		}
		
		struct Review {
			let author: String
			let content: String
			let date: Date
			let rating: Int
			let bakeryId: String
		}
	}
}

