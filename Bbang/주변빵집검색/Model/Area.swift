//
//  Area.swift
//  Bbang
//
//  Created by bart Shin on 13/06/2021.
//

import CoreLocation
import CoreGraphics

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
	
	func calcOffset(for location: CLLocationCoordinate2D, in bound: CGSize) -> CGSize {
		let x = bound.height * CGFloat((location.longitude - geometry.longitude) / (geometry.deltaLongitude * 2))
		let y = bound.width * CGFloat((location.latitude - geometry.latitude) / (geometry.deltaLatitdue * 2))
		return CGSize(width: x, height: y)
	}
	
	fileprivate var geometry: (latitude: Double, longitude: Double, deltaLatitdue: Double, deltaLongitude: Double) {
		switch self {
			case .seoul:
				return (37.540705, 126.956764, 0.551279, 0.483654)
			case .incheon:
				return (37.469221, 126.573234, 0.513281, 0.449886)
			case .gwangju:
				return (35.126033, 126.831302, 0.488798, 0.415746)
			case .daegu:
				return (35.798838, 128.583052, 0.477603, 0.409637)
			case .ulsan:
				return (35.519301, 129.239078, 0.581102, 0.496665)
			case .daejeon:
				return (36.321655, 127.378953, 0.431948, 0.372948)
			case .busan:
				return (35.198362, 129.053922, 0.650120, 0.553922)
			case .gyeonggi:
				return (37.567167, 127.190292, 1.454663, 1.276685)
			case .gangwon:
				return (37.555837, 128.209315, 2.734753, 2.399858)
			case .southChungcheong:
				return (36.557229, 126.779757, 1.640025, 1.420338)
			case .northChungcheong:
				return (36.628503, 127.929344, 1.638511, 1.420338)
			case .northGyeongsang:
				return (36.248647, 128.664734, 2.132939, 1.839925)
			case .southGyeongsang:
				return (35.259787, 128.664734, 2.255005, 1.921210)
			case .northJeolla:
				return (35.716705, 127.144185, 1.610107, 1.379571)
			case .southJeolla:
				return (34.819400, 126.893113, 2.338820, 1.981914)
			case .jeju:
				return (33.364805, 126.542671, 1.133116, 0.943816)
		}
	}
	
	
	init?(koreanName: String) {
		if let found = Self.allCases.first(where: {
			$0.koreanName == koreanName
		}) {
			self = found
		}else {
			return nil
		}
	}
}
