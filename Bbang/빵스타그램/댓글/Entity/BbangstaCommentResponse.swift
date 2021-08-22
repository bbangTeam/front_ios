//
//  BbangstaCommentResponse.swift
//  Bbang
//
//  Created by 소영 on 2021/08/22.
//

struct BbangstaCommentResponse: Decodable {
    var result: String
    var code: Int
    var commentList: [CommentList]?
}

struct CommentList: Decodable {
    var nickname: String
    var content: String
}
