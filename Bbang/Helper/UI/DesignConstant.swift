//
//  DesignConstant.swift
//  Bbang
//
//  Created by bart Shin on 07/06/2021.
//

import SwiftUI

struct DesignConstant {
	
	static func getUIFont(_ font: BbangFont) -> UIFont {
		guard let size = font.style.size ,
					let found = UIFont(name: font.name, size: size) else {
			assertionFailure("\(font) is not available")
			return UIFont()
		}
		return found
	}
	
	static func getUIColor(palette: Palette) -> UIColor {
		guard let hexValue = palette.hexValue else {
			assertionFailure("\(palette) is not in Palette")
			return UIColor()
		}
		return UIColor(hexValue: hexValue).withAlphaComponent(palette.alpha)
	}
	
	static func getFont(_ font: BbangFont) -> Font {
		if let size = font.style.size {
			return Font.custom(font.name, fixedSize: size)
		}
		assertionFailure("\(font) size is not available")
		return Font.custom(font.name, size: 18)
	}
	
	static func getColor(palette: Palette) -> Color {
		Color(getUIColor(palette: palette))
	}
	
	struct BbangFont {
		
		let family: Family
		let style: Style
		
		var name: String {
			"\(family)-\(style.weight)"
		}
		
		enum Family: String {
			case NotoSansCJKkr
			case Roboto
		}
		
		/// Scale :  Headline ( 1~6 ) / Sub title (1,2) / Body (1,2) / Button (1,2)
		enum Style {
			case headline(scale: Int)
			case subtitle(scale: Int)
			case body (scale: Int)
			case button (scale: Int)
			case caption
			case overline
			
			fileprivate var size: CGFloat? {
				switch self {
				case .headline(let scale):
					return [1: 48,
					 2: 32,
					 3: 24,
					 4: 20,
					 5: 18,
					 6: 16][scale]
				case .subtitle(let scale):
					return [
						1: 14,
						2: 13
					][scale]
				case .body(let scale):
					return [
						1: 14,
						2: 13
					][scale]
				case .button(let scale):
					return [
						1: 15,
						2: 14
					][scale]
				case .caption:
					return 12
				case .overline:
					return 10
				}
			}
			fileprivate var weight: Weight {
				switch self {
				case .headline, .subtitle:
					return .Bold
				case .body, .caption:
					return .Regular
				case .button, .overline:
					return .Medium
				}
			}
			fileprivate enum Weight {
				case Bold
				case Medium
				case Regular
			}
		}
	}
	
	/// Saturation: Base on 600 ( 900, 800, 700, 600, 500, 400, 300, 200, 100, 50 )
	enum Palette {
		
		case primary (saturation: Int)
		case secondary (staturation: Int)
		case background
		case surface
		case error
		case success
		case link
		case onPrimary (for: Emphasis)
		case onSecondary (for: Emphasis)
		case onBackground 
		case onSurface (for: Emphasis)
		case onError
		case onSuccess
		case onLink
		case outline
		
		fileprivate var hexValue: Int? {
			switch self {
			case .primary(let saturation):
				return [
					900: 0xD85D04,
					800: 0xF16B09,
					700: 0xFA7C08,
					600: 0xFE8E28,
					500: 0xFFA34F,
					400: 0xFFAD62,
					300: 0xFFC580,
					200: 0xFFDCB3,
					100: 0xFFEFDB,
					50: 0xFFF6EA
				][saturation]
			case .secondary(let saturation):
				return [
					900: 0x222222,
					800: 0x3A3A3A,
					700: 0x505050,
					600: 0x636363,
					500: 0x7A7A7A,
					400: 0x989898,
					300: 0xC2C2C2,
					200: 0xDEDEDE,
					100: 0xEFEFEF,
					50: 0xF8F8F8
				][saturation]
			case .background, .surface, .onSecondary, .onError, .onSuccess, .onLink, .outline:
				return 0xFFFFFF
			case .error:
				return 0xF53C14
			case .success:
				return 0x52C41A
			case .link:
				return 0x1890FF
			case .onPrimary, .onBackground, .onSurface:
				return 0x222222
			}
		}
		enum Emphasis {
			case high
			case medium
			case disabled
		}
		fileprivate var alpha: CGFloat {
			switch self {
			case .outline:
				return 0.12
			case .onPrimary(let emphasis):
				switch emphasis {
				case .high:
					return 1
				case .medium:
					return 0.6
				case .disabled:
					return 0.2
				}
			case .onSecondary(let emphasis):
				switch emphasis {
				case .high:
					return 1
				case .medium:
					return 0.6
				case .disabled:
					return 0.4
				}
			case .onSurface(let emphasis):
				switch emphasis {
				case .high:
					return 1
				case .medium:
					return 0.6
				case .disabled:
					return 0.2
				}
			default:
				return 1
			}
		}
	}
}
