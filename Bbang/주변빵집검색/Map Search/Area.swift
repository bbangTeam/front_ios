//
//  Area.swift
//  Bbang
//
//  Created by bart Shin on 13/06/2021.
//

import CoreLocation
import UIKit

enum Area: String, CaseIterable {
	case gyeonggi
	case gangwon
	case jeju
	case northChungcheong
	case southChungcheong
	case northJeolla
	case southJeolla
	case northGyeongsang
	case southGyeongsang
	case seoul
	case busan
	case incheon
	case daejeon
	case daegu
	case gwangju
	case ulsan
	
	var koreanName: String {
		switch self {
		case .gyeonggi: return "경기"
		case .gangwon: return "강원"
		case .jeju: return "제주"
		case .northChungcheong: return "충청북도"
		case .southChungcheong: return "충청남도"
		case .northJeolla: return "전라북도"
		case .southJeolla: return "전라남도"
		case .northGyeongsang: return "경상북도"
		case .southGyeongsang: return "경상남도"
		case .seoul: return "서울"
		case .busan: return "부산"
		case .incheon: return "인천"
		case .daejeon: return "대전"
		case .daegu: return "대구"
		case .gwangju: return "광주"
		case .ulsan: return "울산"
		}
	}
	
	func calcOffset(location: CLLocationCoordinate2D, in bound: CGSize) -> CGPoint? {
		guard let horizontal = self.latitudeRange,
					let vertical = self.longitudeRange else {
			return nil
		}
		let x = bound.width * CGFloat((location.latitude - horizontal.min) / (horizontal.max - horizontal.min))
		let y = bound.height * CGFloat((location.longitude - vertical.min) / (vertical.max - vertical.min))
		return CGPoint(x: x, y: y)
	}
	
	fileprivate var latitudeRange: (min: Double, max: Double)?{
		switch self {
		case .seoul:
			return (37.413294, 37.715133)
		default:
			return nil
		}
	}
	
	fileprivate var longitudeRange: (min: Double, max: Double)? {
		switch self {
		case .seoul:
			return (126.734086, 127.269311)
		default:
			return nil
		}
	}
}
