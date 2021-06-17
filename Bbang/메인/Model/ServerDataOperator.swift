//
//  ServerDataOperator.swift
//  Bbang
//
//  Created by bart Shin on 12/06/2021.
//

import Foundation

class ServerDataOperator {
	
	typealias StatusCode = Int
	
	@Published private(set) var responses = [APICategory: Set<Response>]()
	
	func checkServerStatus() {
		sendReqeust(.healthCheck, authToken: nil)
			.observe { result in
				if case let .failure(error) = result {
					print("Server status: \(error)")
				}else if case let .success(response) = result {
					print("Sever status: \(response.statusCode)")
				}
			}
	}
	
	func reqeustWorldCupData() -> Promise<Bool> {
		sendReqeust(.worldCup, authToken: Constants.tokenForTest)
			.chained { [weak weakSelf = self] result in
				weakSelf?.responses[.worldCup]!.insert(result)
				return Promise<Bool>(value: true)
			}
	}
	
	func requestFamous(nearby area: Area, lengthDemand: Int, needDetail: Bool) -> Promise<Bool> {
		return sendReqeust(.famous(city: area.rawValue,
												needDetail: needDetail,
												demandNumber: lengthDemand), authToken: Constants.tokenForTest)
			.chained { [weak weakSelf = self] result in
				weakSelf?.responses[.famous]!.insert(result)
				return Promise<Bool>(value: true)
			}
	}
	
	func removeResponse(_ response: Response, in category: APICategory) {
		responses[category]?.remove(response)
	}
	
	fileprivate func sendReqeust(_ request: Constants.Reqeust, authToken: String?) -> Promise<Response> {
		guard var urlComponents = URLComponents(string: Constants.host + request.path) else {
			assertionFailure("Error creating url component for \(request)")
			return Promise.rejected(with: ServerError.badRequest)
		}
		if let parameters = request.parameters {
			urlComponents.addQueryItems(parameters)
		}
		guard let url = urlComponents.url else  {
			assertionFailure("Error creating url for \(request)")
			return Promise.rejected(with: ServerError.badRequest)
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.rawValue
		urlRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Content-Type")
		urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
		urlRequest.setValue(request.contentLength == nil ? nil: String(request.contentLength!), forHTTPHeaderField: "Content-Length")
		let date = Date()
		let promise = Promise<Response>()
		URLSession.shared.dataTask(with: urlRequest)
		{ data, response, error in
			if error != nil {
				promise.reject(with: ServerError.unSpecified(error!.localizedDescription))
			}
			let statusCode: Int
			if let response = response as? HTTPURLResponse {
				statusCode = response.statusCode
			}else {
				statusCode = 404
			}
			promise.resolve(with: .init(statusCode: statusCode,
																	data: data
																	,requestDate: date,
																	requestTag: request.tag))
		}.resume()
		return promise
	}
	
	init() {
		APICategory.allCases.forEach {
			responses[$0] = Set<Response>()
		}
	}
	
	enum APICategory: CaseIterable {
		case worldCup
		case famous
	}
	
	struct Response: Hashable {
		let requestDate: Date
		let requestTag: String?
		let statusCode: Int
		let data: Data?
		
		init(statusCode: Int, data: Data?, requestDate: Date, requestTag: String?) {
			self.requestDate = requestDate
			self.statusCode = statusCode
			self.data = data
			self.requestTag = requestTag
		}
	}
	
	struct Constants {
		static let host = "http://125.240.27.115:7000"
		static let tokenForTest = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyIiwiZXhwIjoxNjIyOTA0MDA1LCJ1c2VySWQiOiI2MGI3NzkzNTU4NjdlODExZTdmYWRiZTAifQ.Sb91WW9CaEwc-H5jQYGQAPGvnVQG3UJss6Fi5WGP1Apq6nIpvZDdRxuQs8sQTfp-z1oLFEHPePvnwKOXxHDg2g"
		
		enum Reqeust {
			case healthCheck
			case worldCup
			case famous(city: String, needDetail: Bool, demandNumber: Int)
			
			var path: String {
				switch self {
				case .healthCheck:
					return "/api/healthcheck"
				case .worldCup:
					return "/api/ideal/content"
				case .famous:
					return "/api/pilgrimage/list"
				}
			}
			
			var method: Method {
				switch self {
				case .healthCheck, .worldCup, .famous:
					return .get
				}
			}
			
			var contentType: ContentType  {
				switch self {
				case .healthCheck, .worldCup, .famous:
					return .json
				}
			}
			var parameters: [String: String]? {
				switch self {
				case .healthCheck, .worldCup:
					return nil
				case .famous(let city, let needDetail, _):
					return [
						"id": city + "001", // FIXME: What the heck this 001
						"option": needDetail ? "all": "none"
					]
				}
			}
			
			var contentLength: Int? {
				switch self {
				case .healthCheck, .worldCup:
					return nil
				case .famous(_, _, let demandNumber):
					return demandNumber
				}
			}
			/// Identify request when handle response
			var tag: String? {
				switch self {
				case .famous(let cityName, _, _):
					return cityName
				default:
					return nil
				}
			}
		}
		enum Method: String {
			case post
			case get
			case put
		}
		
		enum ContentType: String {
			case json = "Application/json"
		}
	}
	
	enum ServerError: Error {
		case badRequest
		case notFound
		case unSpecified (String)
	}
}
