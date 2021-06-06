//
//  StoreAnnotation.swift
//  Bbang
//
//  Created by bart Shin on 30/05/2021.
//

import MapKit


class StoreAnnotation: NSObject, MKAnnotation {
	
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	
	
	init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
	}
}

class StoreAnnotationView: MKAnnotationView {

	let imageName = "bread_icon"
	let imageSize = CGSize(width: 45, height: 45)
	
}
