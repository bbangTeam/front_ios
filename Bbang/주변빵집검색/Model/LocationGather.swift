//
//  LocationGather.swift
//  Bbang
//
//  Created by bart Shin on 30/05/2021.
//

import CoreLocation
import MapKit

class LocationGather: NSObject {
	
	static let seoulLocation = CLLocationCoordinate2D(latitude: 37.532600, longitude: 127.024612)
	static let busanLocation = CLLocationCoordinate2D(latitude: 35.166668, longitude: 129.066666)
	/// Bounds base on size of Seoul
	static let cityBounds = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
	static let streetBounds = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
	
	private let manager: CLLocationManager
	private var isPermitted: Bool {
		didSet {
			if isPermitted {
				manager.requestLocation()
			}
		}
	}
	@Published private(set) var lastLocation: CLLocation? {
		didSet{
			getCityInfomation()
		}
	}
	@Published private(set) var cityname: String?
	
	func requestAuthorization() {
		if manager.authorizationStatus == .notDetermined {
			manager.requestWhenInUseAuthorization()
		}else if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse{
			isPermitted = true
		}
	}
	
	private func getCityInfomation() {
		guard let location = lastLocation else {
			return
		}
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(
			location,
			preferredLocale: .init(identifier: "Ko-kr")) {[weak weakSelf = self] placemarks, error in
			if let lastPlacemark = placemarks?.last {
				weakSelf?.cityname = lastPlacemark.administrativeArea
			}
		}
	}
	
	override init() {
		manager = CLLocationManager()
		manager.desiredAccuracy = kCLLocationAccuracyBest
		isPermitted = false
		super.init()
		manager.delegate = self
	}
}

extension LocationGather: CLLocationManagerDelegate {

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		isPermitted = manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let lastLocation = locations.last else {
			return
		}
		self.lastLocation = lastLocation
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Fail to get location \(error.localizedDescription)")
	}
}
