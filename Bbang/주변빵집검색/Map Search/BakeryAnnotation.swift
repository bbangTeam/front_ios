//
//  BakeryAnnotation.swift
//  Bbang
//
//  Created by bart Shin on 30/05/2021.
//

import MapKit

class BakeryAnnotation: NSObject, MKAnnotation {
	
	var bakery: BakeryInfoManager.Bakery
	var coordinate: CLLocationCoordinate2D {
		bakery.coordinate
	}
	var title: String? {
		bakery.name
	}
	var subtitle: String? {
		bakery.area
	}
	init(bakery: BakeryInfoManager.Bakery) {
		self.bakery = bakery
	}
}

class BakeryAnnotationView: MKAnnotationView {

	let imageName = "bread_icon"
	let imageSize = CGSize(width: 30, height: 30)
	
}
