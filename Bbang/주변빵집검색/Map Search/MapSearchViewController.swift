//
//  MapSearchViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit
import MapKit
import Combine
import SDWebImage

class MapSearchViewController: UIViewController {

	var server: ServerDataOperator!
	var location: LocationGather!
	var infoManager: BakeryInfoManager!
	private var focusedBakeryObserver: AnyCancellable?
	private var bottomVC: BottomSheetVC!
	var sheetVC: Collapsable {
		bottomVC
	}
	@IBOutlet private weak var mapView: MKMapView!
	private var userCoordinate: CLLocationCoordinate2D? {
		didSet {
			if userCoordinate != nil {
				showUserLocation()
				infoManager.respondToMovingMap(for: userCoordinate!)
			}
		}
	}
	private var lastUpdatedCoordinate: CLLocationCoordinate2D?
	
	private var displayedAnnotations: [MKAnnotation]? {
		willSet {
			if let existAnnotations = displayedAnnotations {
				mapView.removeAnnotations(existAnnotations)
			}
		}
		didSet {
			if let newAnnotattions = displayedAnnotations {
				mapView.addAnnotations(newAnnotattions)
			}
		}
	}
	
	private var bakeryImageView: UIImageView!
	var mainVCAnimator: UIViewPropertyAnimator?
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
	
	@IBAction func tapLocationButton(_ sender: UIButton) {
		showUserLocation()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initMapView()
		initBottomSheet()
		initNavigationBar()
		bottomVC.sheetHandle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSheetHandle(_:))))
		bottomVC.sheetHandle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragSheetHandle(_:))))
		self.extendedLayoutIncludesOpaqueBars = true
		initBakeryImageView()
		observeFocusedBakery()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		bottomVC.searchResultView.isUserInteractionEnabled = !bottomVC.isCollapsed
		mapView.frame.size.height = view.bounds.height - (bottomVC.isCollapsed ? bottomVC.collapsedHeight: bottomVC.expandedHeight)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		location.requestAuthorization()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let lastLocation = location.lastLocation {
			userCoordinate = lastLocation.coordinate
			loadAnnotations(near: lastLocation.coordinate)
		}
		modifySearchBar()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if searchController.isActive == true {
			searchController.isActive = false
		}
	}
	
	private func initMapView() {
		mapView.isZoomEnabled = true
		mapView.isScrollEnabled = true
		let seoul = MKCoordinateRegion(
			center: LocationGather.seoulLocation,
			span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5))
		mapView.setRegion(seoul, animated: false)
		mapView.showsUserLocation = true
		mapView.register(BakeryAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing: BakeryAnnotationView.self))
		mapView.delegate = self
	}
	
	private func initBottomSheet() {
		let sheetHeights: (expanded: CGFloat, collapsed: CGFloat) = (view.bounds.height - minimumMapHeight - navigationBarHeight, view.bounds.height * 0.15)
		let bottomVC = BottomSheetVC(heights: sheetHeights, infoManager: infoManager) { [weak self] isCollapsed in
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
	
	private func initNavigationBar() {
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
	
	private func initSearchBar(in navigationBar: UINavigationBar) {
		searchController = UISearchController(searchResultsController: nil)
		navigationBar.addSubview(searchController.searchBar)
		navigationBar.backgroundColor = Constant.searcbarBackgroundColor
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
	
	private func initSearchBarButton() {
		let searchImage = UIImage(systemName: "magnifyingglass")!
		searchButton.setImage(searchImage, for: .normal)
		searchButton.tintColor = Constant.searchbarButtonColor
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
		cancelButton.tintColor = Constant.searchbarButtonColor
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
	
	private func modifySearchBar() {
		searchController.searchBar.backgroundColor = Constant.searcbarBackgroundColor
		if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
			textfield.borderStyle = .none
			textfield.leftViewMode = .never
			textfield.backgroundColor = Constant.searchbarTextfieldBackgroundColor
			let font = Constant.searchbarFont
			if let placeholderLabel = textfield.value(forKey: "placeholderLabel") as? UILabel {
				textfield.addSubview(placeholderLabel)
				placeholderLabel.text = "검색어를 입력하세요"
				placeholderLabel.font = font
				placeholderLabel.textColor = Constant.searchbarPlaceholderColor
				placeholderLabel.snp.makeConstraints {
					$0.width.equalToSuperview().multipliedBy(0.7)
					$0.height.equalToSuperview()
					$0.left.equalToSuperview().offset(17.5)
				}
			}
			textfield.textColor = Constant.searchbarTextColor
			textfield.font = font
		}
	}
	
	private func initBakeryImageView() {
		bakeryImageView = UIImageView()
		bakeryImageView.isHidden = true
		view.insertSubview(bakeryImageView, belowSubview: bottomVC.view)
		bakeryImageView.snp.makeConstraints {
			$0.edges.equalTo(mapView.snp.edges)
		}
	}
	
	private func observeFocusedBakery() {
		focusedBakeryObserver = infoManager.$focusedBakery.sink { [weak self] in
			guard let strongSelf = self else {
				return
			}
			if let bakery = $0 {
				strongSelf.showBakeryImage(bakery: bakery)
			}else {
				strongSelf.hideBakeryImage()
			}
		}
	}
	
	private func showBakeryImage(bakery: BakeryInfoManager.Bakery) {
		bakeryImageView.sd_setImage(with: bakery.imageUrl) { [weak weakSelf = self] image, error, _, url in
			if image != nil {
				weakSelf?.bakeryImageView.isHidden = false
			}else {
				print("Fail to load bakery image from \(url?.absoluteString ?? "no url") \n error: \(error?.localizedDescription ?? "no error")")
			}
		}
	}
	
	var blurEffect: UIBlurEffect? = nil
	var blurView: UIVisualEffectView? = nil
	
	private struct Constant {
		static var searchbarButtonColor = DesignConstant.shared.interface == .dark ? DesignConstant.getUIColor(.surface): .black
		static let searchbarFont = DesignConstant.getUIFont(.init(family: .NotoSansCJKkr, style: .body(scale: 1)))
		static var searcbarBackgroundColor = DesignConstant.shared.interface == .dark ? DesignConstant.getUIColor(.secondary(staturation: 900)): .white
		static var searchbarTextColor = DesignConstant.getUIColor(light: .secondary(staturation: 900), dark: .surface)
		static var searchbarPlaceholderColor = DesignConstant.getUIColor(.secondary(staturation: 400))
		static var searchbarTextfieldBackgroundColor = DesignConstant.getUIColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 800))
	}
}


extension MapSearchViewController: MKMapViewDelegate {
	
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		guard hideOrShowAnnotations() else {
			if !bottomVC.isCollapsed {
				moveSheet()
			}
			return
		}
		if let lastCoordinate = lastUpdatedCoordinate {
			let lastCenter = CLLocation(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)
			let newCenter = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
			if lastCenter.distance(from: newCenter) > 500 {
				let isCollapsed = bottomVC.isCollapsed
				if !isCollapsed {
					infoManager.respondToMovingMap(for: mapView.centerCoordinate)
				}
				if lastCenter.distance(from: newCenter) > 2000 {
					loadAnnotations(near: newCenter.coordinate)
					if !isCollapsed {
						moveSheet()
					}
					lastUpdatedCoordinate = newCenter.coordinate
				}
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let reuseId = String(describing: BakeryAnnotationView.self)
		if annotation.isKind(of: MKUserLocation.self) {
			if #available(iOS 14.0, *), annotation is MKUserLocation {
				
				let reuseIdentifier = "userLocation"
				if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
					return existingView
				}
				let view = MKUserLocationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
				view.zPriority = .max
				view.isEnabled = false
				return view
			}else {
				return nil
			}
		}
		
		guard let bakeryAnnotation = (mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)) as? BakeryAnnotationView else {
			return nil
		}
		let image = UIImage(named: bakeryAnnotation.imageName)!
		bakeryAnnotation.image = image
		bakeryAnnotation.bounds.size = bakeryAnnotation.imageSize
		bakeryAnnotation.canShowCallout = true
		bakeryAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		return bakeryAnnotation
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if let bakeryAnnotaion = view.annotation as? BakeryAnnotation {
			infoManager.focusedBakery = bakeryAnnotaion.bakery
		}
		if bottomVC.isCollapsed{
			moveSheet()
		}
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if userCoordinate == nil {
			userCoordinate = userLocation.coordinate
		}
	}
	
	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		views.enumerated().forEach {
			$1.zPriority = .init(rawValue: Float($0))
		}
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		//		if let bakeryAnnotaion = view.annotation as? BakeryAnnotation {
		//			infoManager.focusedBakery = bakeryAnnotaion.bakery
		//		}
		//		if bottomVC.isCollapsed{
		//			moveSheet()
		//		}
	}
	
	/// Hide or show annotations base on zoom
	/// - Returns: True if show annotation false if hide
	private func hideOrShowAnnotations() -> Bool {
		let spanSize = (latitude: mapView.region.span.latitudeDelta, longitude: mapView.region.span.longitudeDelta)
		
		let isClose = spanSize.latitude < 0.1 || spanSize.longitude < 0.1
		if isClose,
		   mapView.annotations.count <= 1 { // User location annotation
			loadAnnotations(near: mapView.centerCoordinate)
		}
		else if !isClose,
				mapView.annotations.count > 1 {
			mapView.removeAnnotations(mapView.annotations)
		}
		return isClose
	}
	
	private func loadAnnotations(near coordinate: CLLocationCoordinate2D?) {
		guard let coordinate = coordinate ?? userCoordinate else {
			return
		}
		let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		var minDistance: Double?
		var coordinateKeyToShow: CLLocationCoordinate2D?
		infoManager.bakeriesNearLocation.keys.forEach {
			let requestBaseLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
			let distance = location.distance(from: requestBaseLocation)
			if minDistance == nil ||
				minDistance! > distance {
				minDistance = distance
				coordinateKeyToShow = requestBaseLocation.coordinate
			}
		}
		guard let key = coordinateKeyToShow else {
			return
		}
		displayedAnnotations = infoManager.bakeriesNearLocation[key]!.compactMap {
			BakeryAnnotation(bakery: $0)
		}
	}
	
	private func hideBakeryImage() {
		bakeryImageView.isHidden = true
		bakeryImageView.image = nil
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		infoManager.focusedBakery = nil
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
			if !bottomVC.isCollapsed,
			   infoManager.focusedBakery == nil {
				moveSheet()
			}
		}
	}
	
	private func showUserLocation(animated: Bool = true) {
		mapView.setRegion(
			MKCoordinateRegion(center: userCoordinate!,
							   span: LocationGather.streetBounds),
			animated: animated)
		lastUpdatedCoordinate = userCoordinate!
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
			infoManager.search(for: searchString)
		}
	}
}

extension MapSearchViewController: ContainSheet {
	
	func setAnimation(toCollapse: Bool) {
		mainVCAnimator = UIViewPropertyAnimator(
			duration: durationForMoveSheet,
			dampingRatio: 1)
		{ [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.mapView.frame.size.height = strongSelf.view.bounds.height - (toCollapse ? strongSelf.bottomVC.collapsedHeight: strongSelf.bottomVC.expandedHeight)
		}
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
			continueSheetMoving(
				toReverse: bottomVC.isCollapsed &&
					mainVCAnimator != nil && mainVCAnimator!.fractionComplete < 0.2)
		default:
			break
		}
	}
 
}
