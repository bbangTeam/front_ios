//
//  BbangstaWriteRequest.swift
//  Bbang
//
//  Created by 소영 on 2021/08/22.
//

struct BbangstaWriteRequest: Encodable {
    var id: String
    var cityName: String
    var storeName: String
    var breadName: String
    var content: String
    var imageList: [ImageLists]?
}

struct ImageLists: Encodable {
    var id: String
    var num: Int
    var imageUrl: String
}
