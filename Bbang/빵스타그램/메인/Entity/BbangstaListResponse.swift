//
//  BbangstaListResponse.swift
//  Bbang
//
//  Created by 소영 on 2021/08/07.
//

struct BbangstaListResponse: Decodable {
    var result: String
    var code: Int
    var breadstagramList: [BreadstagramList]?
}

struct BreadstagramList: Decodable {
    var id: String?
    var storeId: String?
    var cityName: String?
    var breadStoreName: String?
    var breadName: String?
    var content: String?
    var imageList: [ImageList]?
}

struct ImageList: Decodable {
    var id: String?
    var num: Int?
    var imageUrl: String?
}
