//
//  WorldCupContent.swift
//  Bbang
//
//  Created by bart Shin on 26/06/2021.
//

import UIKit
import SDWebImage

class WorldCupContent {
	
	private let id = UUID()
	private(set) var fragments: [Fragment]
	@Published private(set) var fetcedImageCount = 0
	private(set) var images = [Fragment: UIImage]() {
		didSet {
			fetcedImageCount = images.values.count
		}
	}
	
	func fetchImages() {
		fragments.forEach { fragment in
			guard let url = URL(string: fragment.imageUrl) else {
				return
			}
			SDWebImageDownloader.shared.downloadImage(with: url) {  [weak  self] image, data, error, _ in
				guard let strongSelf = self else {
					return
				}
				if image != nil {
					strongSelf.images[fragment] = image!
				}
				else {
					print("Fail to download worldcup image for \(fragment.name) \(error?.localizedDescription ?? "")")
				}
			}
		}
	}
	
	init?(from data: Data) {
		guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			  let breadList = json["breadList"] as? [[String:Any]] else {
			return nil
		}
		self.fragments = breadList.compactMap {
			.init(from: $0)
		}
	}
	
	struct Fragment: Codable, Hashable {
		let id: String
		let imageUrl: String
		let name: String
		
		init?(from dictionary: [String: Any]) {
			if let id = dictionary["id"] as? String,
			   let imageUrl = dictionary["imageUrl"] as? String,
			   let name = dictionary["name"] as? String {
				self.id = id
				self.name = name
				self.imageUrl = imageUrl
			}
			else {
				return nil
			}
		}
	}
}

extension WorldCupContent: Equatable, Hashable {
	
	static func == (lhs: WorldCupContent, rhs: WorldCupContent) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
