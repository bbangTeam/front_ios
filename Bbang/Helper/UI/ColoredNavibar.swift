//
//  ColoredNavibar.swift
//  Bbang
//
//  Created by bart Shin on 11/07/2021.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
	
	var backgroundColor: UIColor?
	var titleColor: UIColor
	private let coloredAppearance: UINavigationBarAppearance
	private let originalTitleColor: UIColor?
	private let originalBackgroundColor: UIColor?
	
	init(titleColor: UIColor, backgroundColor: UIColor?) {
		self.titleColor = titleColor
		self.backgroundColor = backgroundColor
		coloredAppearance = UINavigationBarAppearance()
		
		originalBackgroundColor = coloredAppearance.backgroundColor
		originalTitleColor = coloredAppearance.titleTextAttributes[.foregroundColor] as? UIColor
		coloredAppearance.configureWithTransparentBackground()
		coloredAppearance.backgroundColor = .clear
		coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
		coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
		
		UINavigationBar.appearance().standardAppearance = coloredAppearance
		UINavigationBar.appearance().compactAppearance = coloredAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
		UINavigationBar.appearance().tintColor = .white
		
	}
	
	func body(content: Content) -> some View {
		ZStack{
			content
			VStack {
				GeometryReader { geometry in
					Color(self.backgroundColor ?? .clear)
						.frame(height: geometry.safeAreaInsets.top)
						.edgesIgnoringSafeArea(.top)
					Spacer()
				}
			}
		}
	}
}
extension View {
	
	func navigationBarColor(titleColor: UIColor, backgroundColor: UIColor?) -> some View {
		self.modifier(NavigationBarModifier(titleColor: titleColor, backgroundColor: backgroundColor))
	}
	
}
