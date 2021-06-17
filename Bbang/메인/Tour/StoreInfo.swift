//
//  StoreInfo.swift
//  Bbang
//
//  Created by bart Shin on 16/06/2021.
//

import CoreLocation

struct StoreInfo {
	let name: String
	let id: String
	let location: CLLocationCoordinate2D
	var isClear: Bool
	
	init?(from dictionary: [String: Any]) {
		guard let name = dictionary["storeName"] as? String,
					let id = dictionary["id"] as? String,
					let isClear = dictionary["isClear"] as? Int,
					let longitude = dictionary["longitude"] as? Double,
					let latitude = dictionary["latitude"] as? Double else {
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
		self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
