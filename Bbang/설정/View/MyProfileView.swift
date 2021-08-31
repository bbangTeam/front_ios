//
//  MyProfileView.swift
//  Bbang
//
//  Created by bart Shin on 11/07/2021.
//

import SwiftUI

struct MyProfileView: View {
	
	let image: UIImage
	let myInfo: UserInfo
	private var myActivities: [Activity: Int]
	
    var body: some View {
		VStack(spacing: 0) {
			profileImageView
			infoView
			countView
		}
		.foregroundColor(Constant.fontColor)
    }
	
	private var profileImageView: some View {
		Image(uiImage: image)
			.resizable()
			.frame(width: Constant.profileImageSize.width - Constant.profileImageBorderWidth*2,
				   height: Constant.profileImageSize.height - Constant.profileImageBorderWidth*2)
			.aspectRatio(contentMode: .fit)
			.clipShape(Circle())
			.overlay(
				loginCircle
					.fixedSize()
					.position(x: Constant.loginCirclePosition.x, y: Constant.loginCirclePosition.y)
			)
			.padding(Constant.profileImageBorderWidth)
			.background(Circle()
							.size(Constant.profileImageSize)
							.fill(Constant.profileImageBorderColor))
	}
	
	private var loginCircle: some View {
		Circle()
			.size(CGSize(width: Constant.loginCircleSize.width + Constant.loginCircleBorder,
						 height: Constant.loginCircleSize.height + Constant.loginCircleBorder))
			.fill(Color.white)
			.overlay(
				Circle()
					.size(Constant.loginCircleSize)
					.fill(Constant.loginCircleColor)
					.padding(Constant.loginCircleBorder/2)
		)
	}
	
	private var infoView: some View {
		VStack(spacing: 0) {
			Text(myInfo.nickname)
				.lineLimit(1)
				.font(Constant.titleFont)
				.padding(.top, 8)
			Text(myInfo.email)
				.lineLimit(1)
				.font(Constant.captionFont)
				.padding(.top, 4)
		}
	}
	
	private var countView: some View {
		HStack{
			ForEach([Activity.post, .comment, .like], id: \.self) { activity in
				NavigationLink(
					destination: activity.navigation ){
					VStack {
						Text(activity.labelString)
							.font(Constant.bodyFont)
						Text("\(myActivities[activity] ?? 0)")
							.font(Constant.subtitleFont)
					}
				}
			}
		}
		.padding(.top, 32)
	}
	
	
	
	init(image: UIImage?, info: UserInfo, counts: (post: Int, comment: Int, like: Int)) {
		self.image = image ?? UIImage(named: "profile_dummy")!
		myInfo = info
		myActivities = [
			.post: counts.post,
			.comment: counts.comment,
			.like: counts.like
		]
	}
	
	enum Activity: Hashable {
		
		case post
		case comment
		case like
		
		var labelString: String {
			switch self {
				case .post:
					return "내가 쓴 글"
				case .comment:
					return "내가 쓴 댓글"
				case .like:
					return "좋아요"
			}
		}
		var navigation: some View {
			Group {
				switch self {
					case .post:
						MyPostView(bsPosts: [
							.dummy,
							.dummy
						])
					default:
						 Text(labelString)
				}
			}
		}
	}
	
	private struct Constant {
		static let profileImageSize = CGSize(width: 56, height: 56)
		static let profileImageBorderWidth = CGFloat(1)
		static var profileImageBorderColor: Color {
			DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.surface): .white
		}
		static let loginCirclePosition = CGPoint(x: 44, y: 51)
		static let loginCircleSize = CGSize(width: 8, height: 8)
		static let loginCircleBorder = CGFloat(2)
		static let loginCircleColor = DesignConstant.getColor(.success)
		static let titleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 6)))
		static let subtitleFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		static let captionFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .caption))
		static let bodyFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static var fontColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 900), dark: .surface)
		}
		static let aspectRatio = CGFloat(375.0/250)
	}
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
		MyProfileView(image: nil, info: .dummy, counts: (10, 11, 30))
			.previewLayout(.fixed(width: 375.0, height: 250.0))
    }
}
