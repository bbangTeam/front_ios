//
//  ServerDataOperator.swift
//  Bbang
//
//  Created by bart Shin on 12/06/2021.
//

import Foundation
import Combine

class ServerDataOperator: ObservableObject {
	
	typealias StatusCode = Int
	
	private(set) var responses = [APICategory: Set<Response>]()
	
	func checkServerStatus() {
		sendReqeust(.healthCheck, authToken: nil)
			.observe { result in
				if case let .failure(error) = result {
					print("Fail to check server: \(error.localizedDescription)")
				}
			}
	}
	
	//MARK:- WorldCup
	func reqeustWorldCupData() -> Promise<Bool> {
		sendReqeust(.worldCupData, authToken: Constants.tokenForTest)
			.chained { [weak weakSelf = self] in
				weakSelf?.storeResponse($0, in: .worldCup) ?? Promise<Bool>(value: false)
			}
	}

	func sendWorldCupWinner(_ winnerId: String) -> Promise<Response> {
		sendReqeust(.worldCupWinner(id: winnerId), authToken: Constants.tokenForTest)
	}

	func getWorldCupRaking() -> Promise<Response> {
		sendReqeust(.worldCupRaking, authToken: Constants.tokenForTest)
	}
	
	//MARK:- Bbangstargram
	func requestFeed(at pageNumber: Int, by pageSize: Int) -> Promise<Bool> {
		sendReqeust(.bbangStargramList(pageNumber: pageNumber, pageSize: pageSize), authToken: Constants.tokenForTest)
			.chained { [weak weakSelf = self] in
				weakSelf?.storeResponse($0, in: .bbangStarNewsFeed) ?? Promise<Bool>(value: false)
			}
	}
	
	//MARK:- Famous bakery
	func requestFamous(nearby area: Area, lengthDemand: Int, needDetail: Bool) -> Promise<Bool> {
		 sendReqeust(.famous(city: area.rawValue,
												needDetail: needDetail,
												demandNumber: lengthDemand), authToken: Constants.tokenForTest)
			.chained { [weak weakSelf = self] in
				weakSelf?.storeResponse($0, in: .famous) ?? Promise<Bool>(value: false)
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
		var httpBody: Data? = nil
		if let parameters = request.parameters {
			switch request.method {
				case .get:
					urlComponents.addQueryItems(parameters)
				case .put, .post:
					do {
						let json = try JSONEncoder().encode(parameters)
						httpBody = json
					}
					catch {
						return Promise.rejected(with: ServerError.badRequest)
					}
			}
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
		urlRequest.httpBody = httpBody
		
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
	
	fileprivate func storeResponse(_ response: Response, in category: APICategory) -> Promise<Bool>{
		responses[category]!.insert(response)
		objectWillChange.send()
		return Promise<Bool>(value: true)
	}
	
	init() {
		APICategory.allCases.forEach {
			responses[$0] = Set<Response>()
		}
	}
	
	enum APICategory: CaseIterable {
		case worldCup
		case famous
		case bbangStarNewsFeed
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
			case worldCupData
			case worldCupRaking
			case worldCupWinner(id: String)
			case bbangStargramList(pageNumber: Int, pageSize: Int)
			case famous(city: String, needDetail: Bool, demandNumber: Int)
			
			var path: String {
				switch self {
					case .healthCheck:
						return "/api/healthcheck"
					case .worldCupData:
						return "/api/ideal/content"
					case .worldCupRaking:
						return "/api/ideal/rank"
					case .worldCupWinner(_):
						return "/api/ideal/selected"
					case .bbangStargramList(_, _):
						return "/api/breadstagram/list"
					case .famous:
						return "/api/pilgrimage/list"
				}
			}
			
			var method: Method {
				switch self {
					case .healthCheck, .worldCupData, .worldCupRaking, .bbangStargramList(_, _), .famous:
						return .get
					case .worldCupWinner(_):
						return .put
				}
			}
			
			var contentType: ContentType  {
				switch self {
					case .healthCheck, .worldCupData, .worldCupRaking,  .worldCupWinner(_), .bbangStargramList(_, _), .famous:
						return .json
				}
			}
			var parameters: [String: String]? {
				switch self {
					case .healthCheck, .worldCupData, .worldCupRaking:
						return nil
					case .worldCupWinner(let winnerId):
						return [
							"id": winnerId
						]
					case .bbangStargramList(let pageNumber, let pageSize):
						return [
							"pageNum": String(pageNumber),
							"pageSize": String(pageSize)
						]
					case .famous(let city, let needDetail, _):
						return [
							"id": city + "001", // FIXME: What is this 001
							"option": needDetail ? "all": "none"
						]
				}
			}
			
			var contentLength: Int? {
				switch self {
					case .healthCheck, .worldCupData, .worldCupRaking, .worldCupWinner(_), .bbangStargramList(_, _):
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
