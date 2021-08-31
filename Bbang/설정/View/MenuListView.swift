//
//  MenuListView.swift
//  Bbang
//
//  Created by bart Shin on 12/07/2021.
//

import SwiftUI

struct MenuListView: View {
	
	var menuIcons: [Menu: UIImage]
	
	var body: some View {
		VStack(alignment: .leading) {
			drawMenu(for: .config)
			drawMenu(for: .email)
			drawMenu(for: .logout)
			drawMenu(for: .withdraw)
		}
		
		.padding(.horizontal, 16)
    }
	
	private func drawMenu(for menu: Menu) -> some View {
		NavigationLink(destination: Text(menu.rawValue)) {
			
			HStack(spacing: 11) {
				Image(uiImage: menuIcons[menu]!)
					.resizable()
					.renderingMode(.template)
					.frame(width: Constant.iconSize.width, height: Constant.iconSize.height)
				Text(menu.rawValue)
				Spacer()
			}
			.padding(.vertical, 16)
			.font(Constant.font)
			.foregroundColor(Constant.color)
		}
	}
	
	private struct Constant {
		static let iconSize = CGSize(width: 14, height: 13)
		static let font = DesignConstant.getFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 6)))
		static let color = DesignConstant.getColor(light: .secondary(staturation: 900), dark: .surface)
	}
	
	enum Menu: String, CaseIterable {
		case config = "환경설정"
		case email = "이메일 문의"
		case logout = "로그아웃"
		case withdraw = "회원탈퇴"
	}
}

struct MenuListView_Previews: PreviewProvider {
	static let menuIcons = MenuListView.Menu.allCases.reduce(into: [:]) { dict, menu in
		dict[menu] = UIImage(systemName: "heart")!
	}
	
    static var previews: some View {
		MenuListView(menuIcons: menuIcons)
			.previewLayout(.fixed(width: 375.0, height: 352.0))
			
    }
}


