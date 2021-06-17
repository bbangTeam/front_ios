//
//  MapSearchViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController {

	var server: ServerDataOperator!
	var location: LocationGather!
	var mapSearchController: MapSearchController!
	private var bottomVC: BottomSheetVC!
	var sheetVC: Collapsable {
		bottomVC
	}
	@IBOutlet private weak var mapView: MKMapView!
	var sheetAnimator: UIViewPropertyAnimator?
	var sheetPauseFraction: CGFloat = 0
	private var searchController: UISearchController!
	private let searchButton = UIButton()
	private let cancelButton = UIButton()
	private let searchBarButtonSize: CGFloat = 40
	private var navigationBarHeight: CGFloat {
		view.bounds.width * (48.0/375.0)
	}
	private var minimumMapHeight: CGFloat {
		view.bounds.width * (280.0/375.0)
	}
	var durationForMoveSheet: TimeInterval = 0.5
	
	//MARK:- User intents
	
	@objc private func tapSearchButton() {
		searchController.searchBar.resignFirstResponder()
		searchBarSearchButtonClicked(searchController.searchBar)
	}
	
	@objc private func tapCancelButton() {
		searchController.searchBar.resignFirstResponder()
		searchBarCancelButtonClicked(searchController.searchBar)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapSearchController = MapSearchController(server: server)
		initMapView()
		initBottomSheet()
		initNavigationBar()
		bottomVC.sheetHandle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSheetHandle(_:))))
		bottomVC.sheetHandle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragSheetHandle(_:))))
		self.extendedLayoutIncludesOpaqueBars = true
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		mapView.frame.size.height = view.bounds.height - (bottomVC.isCollapsed ? bottomVC.collapsedHeight: bottomVC.expandedHeight)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		location.requestAuthorization()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		modifySearchBar()
	}
	
	fileprivate func initMapView() {
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
	
	fileprivate func initBottomSheet() {
		let sheetHeights: (expanded: CGFloat, collapsed: CGFloat) = (view.bounds.height - minimumMapHeight - navigationBarHeight, view.bounds.height * 0.15)
		let bottomVC = BottomSheetVC(heights: sheetHeights, mapSearchController: mapSearchController) { [weak self] isCollapsed in
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
	
	fileprivate func initNavigationBar() {
		let safeAreaHeight = view.getInsetHeight(for: .top)
		let navigationBar = UINavigationBar(
			frame: CGRect(
				origin: CGPoint(x: view.bounds.origin.x,
												y: view.bounds.origin.y + safeAreaHeight),
				size: CGSize(width: view.bounds.width,
										 height: navigationBarHeight)))
		navigationBar.backgroundColor = .white
		navigationBar.isTranslucent = false
		initSearchBar(in: navigationBar)
		view.addSubview(navigationBar)
	}
	
	fileprivate func initSearchBar(in navigationBar: UINavigationBar) {
		searchController = UISearchController(searchResultsController: nil)
		navigationBar.addSubview(searchController.searchBar)
		searchController.searchResultsUpdater = bottomVC
		searchController.showsSearchResultsController = false
		searchController.searchBar.autocapitalizationType = .none
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		searchController.searchBar.searchTextField.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.width.equalToSuperview().multipliedBy(279.0/375.0)
		}
		searchController.searchBar.showsCancelButton = false
		initSearchBarButton()
	}
	
	fileprivate func initSearchBarButton() {
		let searchImage = UIImage(systemName: "magnifyingglass")!
		searchButton.setImage(searchImage, for: .normal)
		searchButton.tintColor = .black
		searchButton.frame.size = CGSize(width: searchBarButtonSize,
																		 height: searchBarButtonSize)
		searchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
		searchController.searchBar.addSubview(searchButton)
		searchButton.snp.makeConstraints {
			$0.right.equalToSuperview().offset(-18)
			$0.centerY.equalToSuperview()
		}
		let cancelImage = UIImage(systemName: "arrow.left")!
		cancelButton.setImage(cancelImage, for: .normal)
		cancelButton.tintColor = .black
		cancelButton.frame.size = CGSize(width: searchBarButtonSize,
																		 height: searchBarButtonSize)
		cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
		searchController.searchBar.addSubview(cancelButton)
		cancelButton.snp.makeConstraints {
			$0.left.equalToSuperview().offset(20)
			$0.centerY.equalToSuperview()
		}
		cancelButton.isEnabled = false
	}
	
	fileprivate func modifySearchBar() {
		if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
			textfield.borderStyle = .none
			textfield.leftViewMode = .never
			textfield.backgroundColor = DesignConstant.getUIColor(palette: .secondary(staturation: 100))
			let font = DesignConstant.getUIFont(.init(family: .NotoSansCJKkr, style: .body(scale: 1)))
			if let placeholderLabel = textfield.value(forKey: "placeholderLabel") as? UILabel {
				textfield.addSubview(placeholderLabel)
				placeholderLabel.text = "검색어를 입력하세요"
				placeholderLabel.font = font
				placeholderLabel.textColor = DesignConstant.getUIColor(palette: .secondary(staturation: 400))
				placeholderLabel.snp.makeConstraints {
					$0.width.equalToSuperview().multipliedBy(0.7)
					$0.height.equalToSuperview()
					$0.left.equalToSuperview().offset(17.5)
				}
			}
			textfield.textColor = DesignConstant.getUIColor(palette: .secondary(staturation: 900))
			textfield.font = font
		}
	}
	var blurEffect: UIBlurEffect? = nil
	var blurView: UIVisualEffectView? = nil
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
		cancelButton.isEnabled = true
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if !bottomVC.isCollapsed {
			moveSheet()
		}
		cancelButton.isEnabled = false
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if bottomVC.isCollapsed {
			moveSheet()
		}
		cancelButton.isEnabled = false
		if let searchString = searchBar.text {
			mapSearchController.search(for: searchString)
		}
	}
}

extension MapSearchViewController: ContainSheet {
	
	func additionalAnimation(toCollapse: Bool) {
		mapView.frame.size.height = view.bounds.height - (toCollapse ? bottomVC.collapsedHeight: bottomVC.expandedHeight)
	}
	
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
			continueSheetMoving(toReverse: sheetAnimator != nil && sheetAnimator!.fractionComplete < 0.2)
		default:
			break
		}
	}
 
}
