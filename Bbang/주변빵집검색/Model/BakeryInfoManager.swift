//
//  BakeryInfoManager.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import Foundation
import CoreLocation
import Combine

class BakeryInfoManager: ObservableObject {
	let server: ServerDataOperator
	let location: LocationGather
	private var serverResponseObserver: AnyCancellable?
	private(set) var bakeriesNearLocation = [CLLocationCoordinate2D: [Bakery]]()
	@Published private(set) var currentShowingCoordinateKey: CLLocationCoordinate2D?
	@Published private(set) var bakeriesOnMap = [Bakery]()
	@Published var focusedBakery: Bakery? {
		didSet {
			if let bakery = focusedBakery {
				moveToFront(bakery)
			}
		}
	}
	
	static var dummys: [Bakery] {
		[Bakery(), Bakery(), Bakery(), Bakery(), Bakery(), Bakery()]
	}
	
	func search(for searchString: String) {
		print("searching: \(searchString)")
		objectWillChange.send()
	}
	
	func respondToMovingMap(for coordinate: CLLocationCoordinate2D) {
		requestBakeryIfNeeded(near: coordinate)
			.observe { [weak self = self] result in
				if case let .success(isUpToDate) = result,
				   let strongSelf = self,
				   let key = strongSelf.currentShowingCoordinateKey,
				   isUpToDate{
					let center = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
					let numberOfList = strongSelf.bakeriesNearLocation[key]!.count
					DispatchQueue.main.async {
						guard numberOfList > 0 else {
							strongSelf.bakeriesOnMap = []
							return
						}
						strongSelf.bakeriesOnMap = Array(strongSelf.bakeriesNearLocation[key]!.sorted {
							let lhsLocation = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
							let rhsLocation = CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude)
							return center.distance(from: lhsLocation) < center.distance(from: rhsLocation)
						}[0...min(numberOfList - 1, 10)])
					}
				}else {
					print("Request bakery info respond to map \n \(result)")
				}
			}
	}
	
	func requestBakeryIfNeeded(near coordinate: CLLocationCoordinate2D) -> Promise<Bool> {
		let minDistanceForNewDistance: Double = 1000 // Distance by meter
		var minDistance: Double? = nil
		let newLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		bakeriesNearLocation.keys.forEach {
			let existLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
			let distance = newLocation.distance(from: existLocation)
			if minDistance == nil ||
				minDistance! > distance {
				minDistance = distance
			}
		}
		if minDistance == nil ||
			minDistance! > minDistanceForNewDistance {
			bakeriesNearLocation[coordinate] = []
			return server.requestBakeryNear(location: coordinate)
		}else {
			return Promise<Bool>(value: true)
		}
	}
	
	func observeServerResponse() {
		serverResponseObserver = server.objectWillChange.sink {
			[self] in
			if server.responses[.bakeryNearLocation] != nil,
			   !server.responses[.bakeryNearLocation]!.isEmpty{
				extractBakeryNearLocation()
			}
		}
	}
	
	private func extractBakeryNearLocation() {
		server.responses[.bakeryNearLocation]!.forEach {
			server.removeResponse($0, in: .bakeryNearLocation)
			if let data = $0.data,
			   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			   let bakeryList = json["storeList"] as? [[String: Any]],
			   let tag = $0.requestTag?.data(using: .utf8),
			   let location = try? JSONSerialization.jsonObject(with: tag, options: []) as? [String: Double],
			   let latitude = location["latitude"],
			   let logitude = location["longitude"]{
				let clLocation = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
				bakeriesNearLocation[clLocation] = bakeryList.compactMap {
					Bakery(from: $0, baseLocation: self.location.lastLocation)
				}
				DispatchQueue.main.async {
					self.currentShowingCoordinateKey = clLocation
				}
			}else {
				print("Fail to get data from \($0)")
			}
		}
	}
	
	private func moveToFront(_ bakery: Bakery) {
		if let index = bakeriesOnMap.firstIndex(where: {
			$0.id == bakery.id
		}) {
			bakeriesOnMap.remove(at: index)
		}
		bakeriesOnMap.insert(bakery, at: 0)
	}
	
	init(server: ServerDataOperator, location: LocationGather) {
		self.server = server
		self.location = location
		observeServerResponse()
	}
	
	struct Bakery: Identifiable {
		let name: String
		let area: String
		let rating: Double
		let hashTag: [String]
		let promoText: [String]
		let distance: Double?
		var distanceString: String {
			guard let distance = distance else {
				return ""
			}
			return distance > 1000 ? String(format: "%.2f", distance/1000) + " KM": String(format: "%.2f", distance) + " M"
		}
		let reviews: [Review]
		let id: String
		let coordinate: CLLocationCoordinate2D
		var isClear: Bool
		let imageUrl: URL?
		
		init?(from dictionary: [String: Any], baseLocation: CLLocation?) {
			guard let name = dictionary["storeName"] as? String,
				  let id = dictionary["id"] as? String,
				  let longitude = dictionary["longitude"] as? Double,
				  let latitude = dictionary["latitude"] as? Double  else {
				print("Fail to create parse store information from \(dictionary)")
				return nil
			}
			let rating = dictionary["star"] as? Double
			let isClear = dictionary["clear"] as? Int
			let address = dictionary["loadAddr"] as? String
			let imageUrlString = dictionary["imageUrl"] as? String
			self.name = name
			self.id = id
			if isClear == nil || isClear! == 0 {
				self.isClear = false
			}else if isClear! == 1 {
				self.isClear = true
			}else {
				print("Invaild clear value of \(name)")
				return nil
			}
			self.area = address ?? ""
			if baseLocation != nil {
				let bakeryLocation = CLLocation(latitude: latitude, longitude: longitude)
				self.distance = baseLocation!.distance(from: bakeryLocation)
				
			}else {
				self.distance = nil
			}
			self.promoText = []
			self.rating = rating ?? 0
			self.hashTag = []
			self.reviews = []
			if imageUrlString != nil,
			   let url = URL(string: imageUrlString!) {
				self.imageUrl = url
			}else {
				self.imageUrl = nil
			}
			self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		}
		
		fileprivate init() {
			id = UUID().uuidString
			distance = 700
			name = "매장 이름"
			area = "둔촌동"
			coordinate = .init(latitude: LocationGather.seoulLocation.latitude, longitude: LocationGather.seoulLocation.longitude)
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

extension CLLocationCoordinate2D: Hashable {
	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.latitude)
		hasher.combine(self.longitude)
	}
}
