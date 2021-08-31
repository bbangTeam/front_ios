//
//  BbangstargramPostView.swift
//  Bbang
//
//  Created by bart Shin on 02/08/2021.
//

import SwiftUI

struct BbangstargramPostView: View {
	
	let post: BbangstargramPost
	@State private var currentImageIndex = 0
	@State private var isCommentsCollapse = true
	
	private var breadNameString: String {
		post.breadNames.joined(separator: " ")
	}
	private var hashTagString: String {
		post.hashTag.compactMap {
			"#\($0)"
		}.joined(separator: " ")
	}
	private var imageViewSize: CGSize {
		CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
	}
	
	
	var body: some View {
		VStack (alignment: .leading, spacing: 8) {
			topBar
			postImageView
				.frame(width: imageViewSize.width, height: imageViewSize.height)
				.overlay(imageOveraly)
			likeBar
			bodyText
			if post.comments.isEmpty {
				emptyComment
			}else {
				commentView
			}
		}
	}
	
	private var topBar: some View {
		HStack (spacing: 0) {
			Image(uiImage: post.writerProfileImage)
				.resizable()
				.frame(width: Constant.profileImageSize.width,
					   height: Constant.profileImageSize.height)
				.clipShape(Circle())
				.padding(.trailing, 8)
			VStack (spacing: 4) {
				Text(post.writerName)
					.font(Constant.writerNameFont)
					.foregroundColor(Constant.writerNameColor)
				Text(createDateString(for: post.lastModifedDate))
					.font(Constant.postCreatedDateFont)
					.foregroundColor(Constant.postCreatedDateColor)
			}
			Spacer()
			moreButton
		}
		.padding(.horizontal, 16)
	}

	private var moreButton: some View {
		Button {
			print("Show more")
		} label: {
			Image(systemName: "ellipsis")
				.foregroundColor(.black)
		}
	}
	
	private func createDateString(for date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "kr_KR")
		dateFormatter.dateFormat = "YYYY.MM.dd"
		return dateFormatter.string(from: date)
	}
	
	private var postImageView: some View {
		TabView (selection: $currentImageIndex) {
			ForEach(0..<post.images.count) { index in
				Image(uiImage: post.images[index])
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: imageViewSize.width, height: imageViewSize.height)
			}
		}
		.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
	}
	
	private var imageOveraly: some View {
		VStack (alignment: .leading) {
			HStack {
				Text(post.bakery.name)
					.font(Constant.bakeryNameFont)
				Text(hashTagString)
					.font(Constant.overlaySubTitleFont)
				Spacer()
			}
			Text(breadNameString)
				.font(Constant.overlaySubTitleFont)
			Spacer()
			HStack {
				Image(systemName: "heart")
					.font(.title)
				Image(systemName: "bubble.left")
					.font(.title)
				Spacer()
				Text("\(currentImageIndex + 1) / \(post.images.count)")
					.font(Constant.overlaySubTitleFont)
					.padding(4)
					.background(RoundedRectangle(cornerRadius: 20)
									.fill(Color.black))
			}
		}
		.foregroundColor(.white)
		.padding(.horizontal, 16)
		.padding(.top, 25)
		.padding(.bottom, 16)
	}
	
	private var likeBar: some View {
		HStack {
			if post.peopleLikePost.isEmpty {
				Text("첫 번째 좋아요를 눌러주세요")
			}else {
				if post.peopleLikePost.count == 1{
					Text("\(post.peopleLikePost.first!.nickname)님이 좋아합니다.")
				}
				else {
					Text("\(post.peopleLikePost.first!.nickname)님 외 \(post.peopleLikePost.count - 1)명이 좋아합니다.")
				}
			}
		}
		.font(Constant.likeBarFont)
		.foregroundColor(Constant.likeBarTextColor)
		.padding(.horizontal, 16)
	}
	
	private var bodyText: some View {
		Text(post.contentText)
			.lineLimit(nil)
			.font(Constant.bodyFont)
			.foregroundColor(Constant.bodyTextColor)
			.padding(.horizontal, 16)
	}
	
	private var emptyComment: some View {
		Text("첫 번째 댓글을 작성해 주세요.")
			.font(Constant.commentTitleFont)
			.foregroundColor(Constant.commentTitleColor)
	}
	
	private var commentView: some View {
		VStack (alignment: .leading, spacing: 4) {
			if post.comments.count > 2 {
				Button (action: {
					withAnimation{
						isCommentsCollapse.toggle()
					}
				}, label: showMoreCommentButton)
			}
			if isCommentsCollapse || post.comments.count == 1 {
				drawCommentView(post.comments.first!)
			}
			else {
				allCommentView
			}
		}
		.padding(.horizontal, 16)
	}
	
	private func showMoreCommentButton() -> some View {
		Text("\(post.comments.count)개의 댓글 모두 보기")
			.font(Constant.bodyFont)
			.foregroundColor(Constant.moreCommentColor)
		
	}
	
	private func drawCommentView(_ comment: BbangstargramPost.Comment) -> some View {
		HStack(alignment:.top, spacing: 8) {
			Text(comment.writerName)
				.font(Constant.commentTitleFont)
				.foregroundColor(Constant.commentTitleColor)
				.frame(width: 52)
			Text(comment.content)
				.font(Constant.commentBodyFont)
				.foregroundColor(Constant.commentBodyColor)
		}
	}
	
	private var allCommentView: some View {
		VStack {
			ForEach(post.comments, id: \.self) { comment in
				drawCommentView(comment)
			}
		}
	}
	
	private struct Constant {
		static let profileImageSize = CGSize(width: 40, height: 40)
		static let writerNameFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		static let writerNameColor = Color.black
		static let postCreatedDateFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
		static let postCreatedDateColor = DesignConstant.getColor(.secondary(staturation: 400))
		static let bakeryNameFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr,
																 style: .headline(scale: 5)))
		static let overlaySubTitleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 2)))
		static let likeBarFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		static let likeBarTextColor = DesignConstant.getColor(.secondary(staturation: 700))
		static let bodyFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 1)))
		static let bodyTextColor = DesignConstant.getColor(.secondary(staturation: 700))
		static let commentTitleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 2)))
		static let commentTitleColor = DesignConstant.getColor(.secondary(staturation: 900))
		static let commentBodyFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let commentBodyColor = DesignConstant.getColor(.secondary(staturation: 700))
		static let moreCommentColor = DesignConstant.getColor(.link)
	}
}

struct BbangstargramPostView_Previews: PreviewProvider {
    static var previews: some View {
		BbangstargramPostView(post: .dummy)
    }
}
