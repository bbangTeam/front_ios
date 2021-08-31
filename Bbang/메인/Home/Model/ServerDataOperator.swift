//
//  ServerDataOperator.swift
//  Bbang
//
//  Created by bart Shin on 12/06/2021.
//

import Foundation
import Combine
import CoreLocation

class ServerDataOperator: ObservableObject {
	
	typealias StatusCode = Int
	
	private(set) var responses = [APICategory: Set<Response>]()
	private var accessToken: String? = Constants.tokenForTest
	
	func setAccessToken(_ token: String) {
		accessToken = token
	}
	
	func checkServerStatus() {
		sendReqeust(.healthCheck, authToken: nil)
			.observe { result in
				if case let .success(response) = result,
				   let data = response.data {
					print("Server status \n" + String(data: data, encoding: .utf8)!)
				}
				else if case let .failure(error) = result {
					print("Fail to check server: \(error.localizedDescription)")
				}
			}
	}
	
	//MARK: - Sign up
	func checkNicknameDuplicated(_ nickname: String) -> Promise<Bool> {
		guard let token = accessToken else {
			return Promise<Bool>.rejected(with: ServerError.notAuthenticated)
		}
		sendReqeust(.checkNicknameDuplicated(nickname), authToken: token)
			.observe { result in
				if case let .success(response) = result,
				   let data = response.data {
					print(String(data: data, encoding: .utf8)!)
				}else {
					print("Fail to check nickname")
				}
			}
		return Promise<Bool>.init(value: false)
	}
	
	
	//MARK: - WorldCup
	func requestWorldCupData() -> Promise<Bool> {
		sendReqeust(.worldCupData, authToken: accessToken)
			.chained { [weak weakSelf = self] in
				weakSelf?.storeResponse($0, in: .worldCup) ?? Promise<Bool>(value: false)
			}
	}

	func sendWorldCupWinner(_ winnerId: String) -> Promise<Response> {
		sendReqeust(.worldCupWinner(id: winnerId), authToken: accessToken)
	}

	func getWorldCupRaking() -> Promise<Response> {
		sendReqeust(.worldCupRaking, authToken: accessToken)
	}
	
	//MARK: - Bbangstargram
	func requestFeed(at pageNumber: Int, by pageSize: Int) -> Promise<Bool> {
		sendReqeust(.bbangStargramList(pageNumber: pageNumber, pageSize: pageSize), authToken: accessToken)
			.chained { [weak weakSelf = self] in
				weakSelf?.storeResponse($0, in: .bbangStarNewsFeed) ?? Promise<Bool>(value: false)
			}
	}
	
	//MARK: - Famous bakery
	private func requestAreaList() -> Promise<[[String: Any]]> {
		sendReqeust(.areaList, authToken: accessToken)
			.chained { response -> Promise<[[String: Any]]> in
				guard let data = response.data,
					  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
					  let areaList = json["areaList"] as? [[String: Any]] else {
					return Promise<[[String: Any]]>.rejected(with: ServerError.parseFail)
				}
				return Promise<[[String: Any]]>(value: areaList)
			}
	}
	func requestFamous(nearby area: Area, lengthDemand: Int, needDetail: Bool) -> Promise<Bool> {
		requestAreaList()
			.chained { [weak self] areaList -> Promise<Bool>  in
				guard let strongSelf = self,
					let areaKey = areaList.first(where:{
					$0["name"] as? String == area.koreanName
				}),
					let areaName = areaKey["name"] as? String,
					let areaId = areaKey["id"] as? String else {
					return Promise<Bool>.rejected(with: ServerError.notFound)
				}
				return strongSelf.sendReqeust(.famous(areaName: areaName,
													  areaId: areaId,
													  needDetail: needDetail,
													  demandNumber: lengthDemand),
											  authToken: strongSelf.accessToken)
					.chained { [weak weakSelf = self] in
						weakSelf?.storeResponse($0, in: .famous) ?? Promise<Bool>(value: false)
					}
			}
	}
	
	// MARK: - Map search
	func requestBakeryNear(location: CLLocationCoordinate2D, distance: ClosedRange<Int> = 0...4000) -> Promise<Bool> {
		sendReqeust(.bakeryNearLocation(latitude: location.latitude,
										longitude: location.longitude,
										distanceRange: distance),
					authToken: accessToken)
			.chained { [weak weakSelf = self] in
				weakSelf?.storeResponse($0, in: .bakeryNearLocation) ?? Promise<Bool>(value: false)
			}
	}
	
	func removeResponse(_ response: Response, in category: APICategory) {
		responses[category]?.remove(response)
	}
	
	
	private func sendReqeust(_ request: Constants.Request, authToken: String?) -> Promise<Response> {
		guard .healthCheck == request || authToken != nil else {
			return Promise.rejected(with: ServerError.notAuthenticated)
		}
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
//		urlRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Content-Type")
		urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
//		urlRequest.setValue(request.contentLength == nil ? nil: String(request.contentLength!), forHTTPHeaderField: "Content-Length")
		urlRequest.httpBody = httpBody
		
		let date = Date()
		let promise = Promise<Response>()
		URLSession.shared.dataTask(with: urlRequest)
		{ data, response, error in
			if error != nil {
				promise.reject(with: ServerError.unSpecified("\(error!.localizedDescription) \n \(urlRequest)"))
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
	
	private func storeResponse(_ response: Response, in category: APICategory) -> Promise<Bool>{
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
		case bakeryNearLocation
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
	
	private struct Constants {
		static let host = "http://125.240.27.115:7000"
		static let tokenForTest = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyIiwiZXhwIjoxNjMxMDI1MDE3LCJ1c2VySWQiOiI2MGU4MzMzN2Q5ZmU3NDU2ODUzNzViYTQifQ.zA8Jtznm5gdUMvaQA-nQbtV0ZWc_6owcxGWFYWrOHxa8YA8LslvlQslbVXw1s8eSZokwpxTCQ1XTB9qGwf1L9w"
		
		enum Request: Equatable {
			case checkNicknameDuplicated(String)
			case areaList
			case bbangStargramList(pageNumber: Int, pageSize: Int)
			case famous(areaName: String, areaId: String, needDetail: Bool, demandNumber: Int)
			case healthCheck
			case worldCupData
			case worldCupRaking
			case worldCupWinner(id: String)
			case bakeryNearLocation(latitude: Double, longitude: Double, distanceRange: ClosedRange<Int>)
			
			var path: String {
				switch self {
					case .checkNicknameDuplicated(_):
						return "/api/user/nickname"
					case .areaList:
						return "/api/pilgrimage/area/list"
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
					case .bakeryNearLocation(_, _, _):
						return "/api/store/list"
				}
			}
			
			var method: Method {
				switch self {
					case .checkNicknameDuplicated(_), .healthCheck, .worldCupData, .worldCupRaking, .bbangStargramList(_, _), .famous, .areaList, .bakeryNearLocation(_, _, _):
						return .get
					case .worldCupWinner(_):
						return .post
				}
			}
			
			var contentType: ContentType  {
				switch self {
					default:
						return .json
				}
			}
			var parameters: [String: String]? {
				switch self {
					case .checkNicknameDuplicated(let nickname):
						return [
							"nickname": nickname
						]
					case .worldCupWinner(let winnerId):
						return [
							"id": winnerId
						]
					case .bbangStargramList(let pageNumber, let pageSize):
						return [
							"pageNum": String(pageNumber),
							"pageSize": String(pageSize)
						]
					case .famous(_, let areaId, let needDetail, _):
						return [
							"id": areaId ,
							"option": needDetail ? "all": "none"
						]
					case .bakeryNearLocation(let latitude, let logitude, let distanceRange):
						return [
							"longitude": String(logitude),
							"latitude": String(latitude),
							"minDistance": String(distanceRange.lowerBound),
							"maxDistance": String(distanceRange.upperBound)
						]
					default:
						return nil
				}
			}
			
			var contentLength: Int? {
				switch self {
					case .famous(_, _, _, let demandNumber):
						return demandNumber
					default:
						return nil
				}
			}
			/// Identify request when handle response
			var tag: String? {
				switch self {
				case .famous(let areaName, _, _, _):
					return areaName
					case .bakeryNearLocation(let latitude, let longitude, _):
						let coordinate = [
							"latitude": latitude,
							"longitude": longitude
						]
						if let json = try? JSONEncoder().encode(coordinate) {
							return String(data: json, encoding: .utf8)
						}else {
							return nil
						}
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
		case parseFail
		case notAuthenticated
	}
}
