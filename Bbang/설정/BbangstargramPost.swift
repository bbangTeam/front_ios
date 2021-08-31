//
//  BbangstargramPost.swift
//  Bbang
//
//  Created by bart Shin on 02/08/2021.
//

import UIKit

struct BbangstargramPost {
	
	let writerName: String
	let writerProfileImage: UIImage
	let lastModifedDate: Date
	let images: [UIImage]
	let comments: [Comment]
	let peopleLikePost: [UserInfo]
	let bakery: BakeryInfoManager.Bakery
	let hashTag: [String]
	let breadNames: [String]
	let contentText: String
	let id: String
	
	struct Comment: Hashable, Identifiable {
		let writerName: String
		let lastModifiedDate: Date
		let content: String
		let id: String
	}
	
	static var dummy: BbangstargramPost {
		BbangstargramPost(
			writerName: "빵플루언서",
			writerProfileImage: UIImage(named: "profile_dummy")!,
			lastModifedDate: Calendar.current.date(byAdding: .minute,
												   value: Int.random(in: -200...0),
												   to: Date())!,
			images: dummyImages,
			comments: [
				dummyComment,
				dummyComment,
				dummyComment
			],
			peopleLikePost: [
				UserInfo.dummy,
				UserInfo.dummy
			],
			bakery: BakeryInfoManager.dummys.first!
			,hashTag: [
				"은행동",
				"크림빵",
				"타르트"
			],
			breadNames: [
				"에그 타르트",
				"커스터드 크림빵"
			],
			contentText: "빵스타그램 포스트 내용 빵스타그램 포스트 내용 빵스타그램 포스트 내용 빵스타그램 포스트 내용 빵스타그램 포스트 내용 빵스타그램 포스트 내용",
			id: UUID().uuidString)
		
	}
	static var dummyImages: [UIImage] {
		(1...5).map { index in
			UIImage(named: "cardimage\(index)")!
		}
	}
	
	static let dummyComment = Comment(writerName: "댓글 작성자",
									  lastModifiedDate: Date(),
									  content: "댓글 내용 댓글 내용 댓글 내용",
									  id: UUID().uuidString)
}

extension BbangstargramPost: Hashable, Identifiable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: BbangstargramPost, rhs: BbangstargramPost) -> Bool {
		lhs.id == rhs.id
	}
}
