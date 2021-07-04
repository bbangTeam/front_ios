//
//  ReviewWritingView.swift
//  Bbang
//
//  Created by bart Shin on 19/06/2021.
//

import SwiftUI

struct ReviewWritingView: View {
	
	@Environment(\.presentationMode) var presentationMode
	private static let placeHolder = "가게와 빵에 대한 솔직한 리뷰를 남겨주세요. 허위 리뷰를 작성 시 이용에 제한이 있을 수 있습니다."
	let bakery: BakeryInfoManager.Bakery
	@EnvironmentObject var infoManager: BakeryInfoManager
	@State private var breadName = ""
	@State private var ratingPoint: Int?
	@State private var reviewContent = Self.placeHolder
	
	var body: some View {
		NavigationView {
			ScrollView(showsIndicators: false) {
				VStack (spacing: 0) {
					ratingStars
					textLabel
					breadNameTextField
					reviewTextField
					confirmButton
				}
			}
			.padding(.horizontal, 16)
			.navigationBarTitle(bakery.name, displayMode: .inline)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: backButton)
		}
	}
	
	private var ratingStars: some View {
		HStack(spacing: Constant.starInteval){
			ForEach(1..<6) { index in
				RatingStar(cornerRadius: 3)
					.tag(index)
					.frame(width: Constant.starSize, height: Constant.starSize)
					.foregroundColor(getStarColor(for: index))
					.onTapGesture {
						ratingPoint = index
					}
					.gesture(dragGesture(from: index))
			}
		}
		.padding(.top, 32)
	}
	
	private func dragGesture(from index: Int) -> some Gesture {
		DragGesture()
			.onChanged {
				ratingPoint = max(
					min(index + Int($0.translation.width / Constant.starSize), 5)
					, 1)
			}
	}
	
	private func getStarColor(for index: Int) -> Color {
		if let currentRating = ratingPoint ,
		   index <= currentRating {
			return Constant.activeStarColor
		}else {
			return Constant.inActiveStarColor
		}
	}
	
	private var textLabel: some View {
		Text("맛을 별점으로 표현해주세요")
			.font(Constant.labelFont)
			.foregroundColor(.black)
			.padding(.top, 16)
	}
	
	private var breadNameTextField: some View {
		TextField("드신 빵이름을 적어주세요", text: $breadName)
			.font(Constant.textFont)
			.foregroundColor(.black)
			.autocapitalization(.none)
			.disableAutocorrection(true)
			.padding(.vertical, 10.5)
			.padding(.leading, 16)
			.padding(.trailing, 64)
			.border(Constant.borderColor, width: 1)
			.padding(.top, 32)
		
	}
	
	private var reviewTextField: some View {
		TextEditor(text: $reviewContent)
			.font(Constant.textFont)
			.foregroundColor(reviewContent == Self.placeHolder ? Constant.textColor: .primary)
			.padding(.top, 10)
			.padding(.horizontal, 16)
			.border(Constant.borderColor, width: 1)
			.padding(.top, 32)
			.multilineTextAlignment(.leading)
			.lineLimit(nil)
			.frame(height: 260)
			.onTapGesture {
				if reviewContent == Self.placeHolder {
					reviewContent = ""
				}
			}
	}
	
	private var confirmButton: some View {
		Button(action: {
			
		}) {
			ZStack {
				RoundedRectangle(cornerRadius: 8, style: .circular)
					.fill(Constant.confirmButtonColor)
					.frame(width: 343, height: 48)
				Text("작성 완료")
					.font(Constant.confirmButtonFont)
					.foregroundColor(Constant.confirmButtonTextColor)
			}
			.padding(.top, 65)
			.padding(.bottom)
		}
	}
	
	private var backButton: some View {
		Button(action: {
			presentationMode.wrappedValue.dismiss()
		}) {
			Image(systemName: "arrow.left")
				.foregroundColor(Constant.backButtonColor)
				.padding()
		}
	}
		
	struct Constant {
		static let starInteval: CGFloat = 2
		static let starSize: CGFloat = 48
		static let labelFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let textColor = DesignConstant.getColor(palette: .secondary(staturation: 400))
		static let textFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static let inActiveStarColor = DesignConstant.getColor(palette: .secondary(staturation: 200))
		static let activeStarColor = DesignConstant.getColor(palette: .primary(saturation: 600))
		static let borderColor = DesignConstant.getColor(palette: .secondary(staturation: 200))
		static let confirmButtonFont = DesignConstant.getFont(.init(family: .Roboto, style: .button(scale: 1)))
		static let confirmButtonTextColor = DesignConstant.getColor(palette: .secondary(staturation: 900))
		static let confirmButtonColor = DesignConstant.getColor(palette: .primary(saturation: 600))
		static let backButtonColor = DesignConstant.getColor(palette: .secondary(staturation: 900))
	}
	
	init(bakery: BakeryInfoManager.Bakery) {
		self.bakery = bakery
		let customNavigationBar = UINavigationBarAppearance()
		customNavigationBar.backgroundColor = .white
		UINavigationBar.appearance().standardAppearance = customNavigationBar
	}
}

struct ReviewWritingView_Previews: PreviewProvider {
	static var previews: some View {
		ReviewWritingView(bakery: BakeryInfoManager.Bakery.dummys[0])
			.environmentObject(BakeryInfoManager(server: ServerDataOperator()))
	}
}
