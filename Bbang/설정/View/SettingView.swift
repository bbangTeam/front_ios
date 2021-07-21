//
//  SettingView.swift
//  Bbang
//
//  Created by bart Shin on 11/07/2021.
//

import SwiftUI

struct SettingView: View {
	var body: some View {
		NavigationView {
			GeometryReader { geometry in
				VStack {
					MyProfileView(image: nil, info: .dummy, counts: (10, 11, 30))
						.frame(width: geometry.size.width)
						.padding(.top, 45)
					Divider()
						.frame(height: Constant.dividerBoder)
					RecentBakeryView(bakeries: BakeryInfoManager.dummys)
						.padding(.vertical, 16)
					Divider()
						.frame(height: Constant.dividerBoder)
					MenuListView(menuIcons: MenuListView_Previews.menuIcons)
					Spacer()
				}
				settingButton
					.position(x: geometry.size.width - Constant.settingIconSize.width - Constant.settingIconSize.width - 16, y: 48)
			}
			.navigationBarHidden(true)
		}
    }
	fileprivate var settingButton: some View {
		NavigationLink(destination: Text("Setting"))
		{
			Image(systemName: "gearshape")
				.renderingMode(.template)
				.foregroundColor(Constant.settingButtonColor)
				.frame(width: Constant.settingIconSize.width - 5,
					   height: Constant.settingIconSize.height - 5)
				.padding(5)
				.background(Circle()
								.fill(Constant.settingButtonBackgroundColor))
		}
	}
	
	struct Constant {
		static let dividerBoder = CGFloat(8)
		static let settingIconSize = CGSize(width: 19, height: 19)
		static var settingButtonColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 900), dark: .surface)
		}
		static var settingButtonBackgroundColor: Color {
			DesignConstant.getColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 800))
		}
	}
}














struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
