//
//  UserInfo.swift
//  Bbang
//
//  Created by bart Shin on 11/07/2021.
//

import Foundation

struct UserInfo {
	let email: String
	let nickname: String
	let profileImageUrl: URL?
	
	static let dummy = UserInfo(email: "bartshin@icloud.com", nickname: "바트", profileImageUrl: URL(string: "https://bartshin.github.io")!)
}
