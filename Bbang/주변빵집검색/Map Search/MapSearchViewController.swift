//
//  MapSearchViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	var location: LocationGather!
	var bottomVC: BottomSheetVC!
	var sheetVC: Collapsable {
		bottomVC
	}
	var blurView: UIVisualEffectView!
	var blurAnimator: UIViewPropertyAnimator?
	var sheetPauseFraction: CGFloat = 0
	var searchController: UISearchController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initMapView()
		initBottomSheet()
		initSearchController()
		initBlurView()
		bottomVC.sheetHandle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSheetHandle(_:))))
		bottomVC.sheetHandle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragSheetHandle(_:))))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		location.requestAuthorization()
	}
	
	private func initMapView() {
		mapView.isZoomEnabled = true
		mapView.isScrollEnabled = true
		mapView.delegate = self
		let seoul = MKCoordinateRegion(
			center: LocationGather.seoulLocation,
			span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5))
		mapView.setRegion(seoul, animated: false)
		mapView.showsUserLocation = true
		mapView.register(StoreAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing: StoreAnnotationView.self))
	}
	
	private func initBottomSheet() {
		let sheetHeights: (expanded: CGFloat, collapsed: CGFloat) = (view.bounds.height * 0.8, view.bounds.height * 0.2)
		let bottomVC = BottomSheetVC(heights: sheetHeights) { [weak self] isCollapsed in
			guard let strongSelf = self else {
				return
			}
			strongSelf.searchController.searchBar.resignFirstResponder()
			if !isCollapsed {
				strongSelf.moveSheet()
			}
		}
		addChild(bottomVC)
		view.addSubview(bottomVC.view)
		let sheetOrigin = CGPoint(x: view.bounds.origin.x,
															y: view.bounds.height - sheetHeights.collapsed)
		let sheetSize = CGSize(width: view.bounds.width,
													 height: sheetHeights.expanded)
		bottomVC.view.frame = CGRect(origin: sheetOrigin, size: sheetSize)
		bottomVC.mapView = self.mapView
		self.bottomVC = bottomVC
	}
	
	private func initBlurView() {
		blurView = UIVisualEffectView(frame: view.bounds)
		blurView.alpha = 0.6
		blurView.isUserInteractionEnabled = false
		view.insertSubview(blurView, belowSubview: bottomVC.view)
	}
	
	private func initSearchController() {
		let center = CGPoint(x: view.bounds.midX,
												 y: view.bounds.height * 0.1)
		let size = CGSize(width: view.bounds.width * 0.7 ,
											height: view.bounds.height * 0.15)
		let navigationBar = UINavigationBar()
		navigationBar.center = center
		navigationBar.bounds.size = size
		searchController = UISearchController(searchResultsController: nil)
		let navigationItem = UINavigationItem()
		navigationBar.pushItem(navigationItem, animated: false)
		navigationBar.topItem!.searchController = searchController
		searchController.searchResultsUpdater = bottomVC
		searchController.searchBar.center = center
		searchController.searchBar.sizeToFit()
		searchController.showsSearchResultsController = false
		searchController.searchBar.layer.cornerRadius = 12
		searchController.searchBar.autocapitalizationType = .none
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
			textfield.clipsToBounds = true
			if let leftView = textfield.leftView as? UIImageView {
				leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
				leftView.tintColor = UIColor.black
			}
			
			if let rightView = textfield.rightView as? UIImageView {
				rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
				rightView.tintColor = UIColor.black
			}
		}
		
		view.addSubview(navigationBar)
	}
}

extension MapSearchViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation.isKind(of: MKUserLocation.self) {
			return nil
		}
		let reuseId = String(describing: StoreAnnotationView.self)
		let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)  ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
		if let storeAnnotation = annotation as? StoreAnnotationView {
			storeAnnotation.image = UIImage(named: storeAnnotation.imageName)
			storeAnnotation.bounds.size = storeAnnotation.imageSize
		}
		
		return annotation
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		let region = MKCoordinateRegion(center: userLocation.coordinate, span: LocationGather.streetBounds)
		mapView.setRegion(region, animated: true)
	}
}

extension MapSearchViewController: UISearchBarDelegate {
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		if bottomVC.isCollapsed {
			moveSheet()
		}
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if !bottomVC.isCollapsed {
			moveSheet()
		}
	}
}

extension MapSearchViewController: ContainSheet {
	
	@objc private func tapSheetHandle(_ sender: UITapGestureRecognizer) {
		if sender.state == .ended {
			moveSheet()
		}
	}
	
	@objc private func dragSheetHandle(_ sender: UIPanGestureRecognizer) {
		switch sender.state {
		case .began:
			startDragSheet()
		case .changed:
			var delta = sender.translation(in: bottomVC.sheetHandle).y / bottomVC.expandedHeight
			delta *= bottomVC.isCollapsed ? 1: -1
			updateSheetState(delta)
		case .ended:
			continueSheetMoving(toReverse: blurAnimator != nil && blurAnimator!.fractionComplete < 0.2)
		default:
			break
		}
	}

}
