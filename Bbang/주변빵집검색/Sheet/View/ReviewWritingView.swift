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
			.navigationBarColor(titleColor: Constant.navigationTitleColor, backgroundColor: Constant.navigationBackgroundColor)
			.navigationBarTitle(bakery.name, displayMode: .inline)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: backButton)
			.background(DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.secondary(staturation: 900)): .white)
		}
	}
	
	private var ratingStars: some View {
		HStack(spacing: Constant.starInteval){
			ForEach(1..<6) { index in
				RatingStar(cornerRadius: 3)
					.stroke(getStarBorderColor(for: index), lineWidth: 4)
					.overlay(
						RatingStar(cornerRadius: 3)
							.fill(getStarColor(for: index))
							.padding(2)
					)
					.tag(index)
					.frame(width: Constant.starSize, height: Constant.starSize)
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
	
	private func getStarBorderColor(for index: Int) -> Color {
		if let currentRating = ratingPoint ,
		   index <= currentRating {
			return Constant.activeStarBorderColor
		}else {
			return Constant.inActiveStarBorderColor
		}
	}
	
	private var textLabel: some View {
		Text("맛을 별점으로 표현해주세요")
			.font(Constant.labelFont)
			.foregroundColor(Constant.labelColor)
			.padding(.top, 16)
	}
	
	private var breadNameTextField: some View {
		TextField("드신 빵이름을 적어주세요", text: $breadName)
			.font(Constant.textFont)
			.foregroundColor(.primary)
			.autocapitalization(.none)
			.disableAutocorrection(true)
			.padding(.vertical, 10.5)
			.padding(.leading, 16)
			.padding(.trailing, 64)
			.background(Constant.textFieldBackgroundColor)
			.overlay(RoundedRectangle(cornerRadius: 4)
						.stroke(Constant.textFieldBorderColor))
			.cornerRadius(4)
			.padding(.top, 32)
	}
	
	private var reviewTextField: some View {
		TextEditor(text: $reviewContent)
			.font(Constant.textFont)
			.foregroundColor(reviewContent == Self.placeHolder ? Constant.placeHolderColor: .primary)
			.padding(.top, 10)
			.padding(.horizontal, 16)
			.background(Constant.textFieldBackgroundColor)
			.overlay(RoundedRectangle(cornerRadius: 4)
						.stroke(Constant.textFieldBorderColor))
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
		static var labelColor: Color {
			DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.surface): .black
		}
		static let placeHolderColor = DesignConstant.getColor(.secondary(staturation: 400))
		static let textFont = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .body(scale: 2)))
		static var textFieldBorderColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 200), dark: .secondary(staturation: 800))
		}
		static var textFieldBackgroundColor: Color {
			DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.secondary(staturation: 900)): .white
		}
		static var inActiveStarBorderColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 200), dark: .secondary(staturation: 500))
		}
		static var activeStarBorderColor: Color {
			DesignConstant.shared.interface == .dark ? DesignConstant.getColor(.primary(saturation: 900)):
				.black
		}
		static var inActiveStarColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 900))
		}
		static let activeStarColor = DesignConstant.getColor(.primary(saturation: 600))
		static let confirmButtonFont = DesignConstant.getFont(.init(family: .Roboto, style: .button(scale: 1)))
		static let confirmButtonTextColor = DesignConstant.getColor(.secondary(staturation: 900))
		static let confirmButtonColor = DesignConstant.getColor(.primary(saturation: 600))
		static var backButtonColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 900), dark: .surface)
		}
		static var navigationTitleColor: UIColor {
			DesignConstant.getUIColor(light: .secondary(staturation: 900), dark: .surface)
		}
		static var navigationBackgroundColor: UIColor? {
			DesignConstant.shared.interface == .dark ? DesignConstant.getUIColor(.secondary(staturation: 900)): nil
		}
	}
	
	init(bakery: BakeryInfoManager.Bakery) {
		self.bakery = bakery
		UITextView.appearance().backgroundColor = .clear
	}
}

struct ReviewWritingView_Previews: PreviewProvider {
	static var previews: some View {
		ReviewWritingView(bakery: BakeryInfoManager.dummys[0])
			.environmentObject(BakeryInfoManager(server: ServerDataOperator(), location: LocationGather()))
	}
}
