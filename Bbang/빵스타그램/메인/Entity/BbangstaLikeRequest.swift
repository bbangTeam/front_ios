//
//  BbangstaLikeRequest.swift
//  Bbang
//
//  Created by 소영 on 2021/08/22.
//

struct BbangstaLikeRequest: Encodable {
    var like: Bool
    var id: String // store 고유 번호
}
