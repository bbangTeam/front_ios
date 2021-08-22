//
//  BbangstaCommentWriteRequest.swift
//  Bbang
//
//  Created by 소영 on 2021/08/22.
//

struct BbangstaCommentWriteRequest: Encodable {
    var id: String // 게시글 고유 번호
    var type: String // 게시글 종류
    var content: String
}
