//
//  BSFeed.swift
//  Bbang
//
//  Created by bart Shin on 04/07/2021.
//

import Foundation

struct BSFeed: Identifiable, Hashable {
	
	let id: String
	let like: Int
	let breadName: String
	let bakeryName: String
	let cityName: String
	let imageUrls: [URL]
	
	init?(from dictionary: [String: Any]) {
		if let id = dictionary["id"] as? String,
		   let like = dictionary["like"] as? Int,
		   let cityName = dictionary["cityName"] as? String,
		   let urlStrings = dictionary["imageUrlList"] as? [String],
		   let breadName = dictionary["breadName"] as? String,
		   let bakeryName = dictionary["breadStoreName"] as? String{
			self.id = id
			self.like = like
			self.cityName = cityName
			self.breadName = breadName
			self.bakeryName = bakeryName
			self.imageUrls = urlStrings.compactMap {
				URL(string: $0)
			}
		}else {
			return nil
		}
	}
	
	private init() {
		id = "feedID" + UUID().uuidString
		like = 100
		breadName = "단팥빵"
		bakeryName = "장블랑제리"
		cityName = "seoul"
		imageUrls = [URL(string: "www.google.com")!]
	}
	
	static let dummy: BSFeed = BSFeed()
}


