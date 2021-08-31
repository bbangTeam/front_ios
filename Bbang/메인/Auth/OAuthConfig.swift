//
//  OauthConfig.swift
//  Bbang
//
//  Created by bart Shin on 2021/08/02.
//

import Foundation
import CommonCrypto

struct OAuthConfig {
	
	static let baseUrl = URL(string: "http://125.240.27.115:7000/api/oauth")!
	static let callbackBaseUrl = URL(string: "http://125.240.27.115:7000/api/oauth/callback")!
	let provider: Provider
	
	enum Provider: String {
		case naver
		case google
		case kakao
		
		var koreanString: String {
			switch self {
				case .naver:
					return "네이버"
				case .google:
					return "구글"
				case .kakao:
					return "카카오"
			}
		}
		
		var loginUrl: URL {
			OAuthConfig.baseUrl.appendingPathComponent(self.rawValue)
		}
	}
	
	enum OAuthError: Error {
		case serverError
	}
}
