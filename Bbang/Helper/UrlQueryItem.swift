//
//  UrlQueryItem.swift
//  Bbang
//
//  Created by bart Shin on 15/06/2021.
//

import Foundation

extension URLComponents  {
	mutating func addQueryItems(_ dictionary: [String: String]) {
		self.queryItems = dictionary.map {
			URLQueryItem(name: $0, value: $1)
		}.sorted {
			$0.name < $1.name
		}
	}
}
