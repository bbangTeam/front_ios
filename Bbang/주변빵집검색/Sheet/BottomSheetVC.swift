//
//  BottomSheetVC.swift
//  Bbang
//
//  Created by bart Shin on 29/05/2021.
//

import SwiftUI
import MapKit

class BottomSheetVC: UIViewController {
	
	let searchResultView: UIView
	static let nibName = "BottomSheet"
	let expandedHeight: CGFloat
	let collapsedHeight: CGFloat
	var handleHeight: CGFloat = 20
	private let handleConnerRadius: CGFloat = 20
	
	unowned var mapView: MKMapView!
	@IBOutlet weak var sheetHandle: UIView!
	@IBOutlet weak var handleBar: UIView!
	var frameAnimator: UIViewPropertyAnimator?
	private var mapItems = [MKMapItem]()
	private let tableViewSelectHandler: (Bool) -> Void
	private func getAddress(of item: MKMapItem) -> String {
		"\(item.placemark.locality ?? "") \(item.placemark.thoroughfare ?? "")"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.clipsToBounds = true
		initHandle()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		searchResultView.snp.makeConstraints {
			$0.top.equalTo(sheetHandle.snp.bottom)
			$0.left.bottom.right.equalToSuperview()
		}
	}
	
	fileprivate func initHandle() {
		sheetHandle.snp.makeConstraints {
			$0.height.equalTo(handleHeight)
		}
		handleBar.backgroundColor = DesignConstant.getUIColor(light: .secondary(staturation: 100), dark: .secondary(staturation: 400))
		handleBar.layer.cornerRadius = 10
	}
	
	init(heights: (expanded: CGFloat, collapsed: CGFloat),
			 mapSearchController: BakeryInfoManager,
			 tableViewSelectHandler: @escaping (Bool) -> Void) {
		self.expandedHeight = heights.expanded
		self.collapsedHeight = heights.collapsed
		self.tableViewSelectHandler = tableViewSelectHandler
		let hostingVC = UIHostingController(rootView: MapBakeryList()
																					.environmentObject(mapSearchController))
		hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
		searchResultView = hostingVC.view
		super.init(nibName: Self.nibName, bundle: nil)
		addChild(hostingVC)
		view.addSubview(hostingVC.view)
		hostingVC.didMove(toParent: self)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum State {
		case expanded
		case collapsed
	}
}

extension BottomSheetVC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		mapItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)+"Cell"),
					mapItems.count >= indexPath.row else {
			assertionFailure("Fail to dequeue cell for \(self) or Fail to get map item")
			return UITableViewCell()
		}
		var content = cell.defaultContentConfiguration()
		let mapitem = mapItems[indexPath.row]
		content.text = mapitem.name
		content.secondaryText = getAddress(of: mapitem)
		cell.contentConfiguration = content
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard mapItems.count >= indexPath.row else {
			assertionFailure("Select cell without map item")
			return
		}
		let mapitem = mapItems[indexPath.row]
		let location = mapitem.placemark.coordinate
		mapView.addAnnotation(StoreAnnotation(coordinate: location, title: mapitem.name, subtitle: getAddress(of: mapitem)))
		mapView.setRegion(MKCoordinateRegion(center: location,
																				 span: LocationGather.streetBounds), animated: true)
		tableViewSelectHandler(isCollapsed)
	}
}

extension BottomSheetVC: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchBarText = searchController.searchBar.text else { return }
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = searchBarText
		request.region = mapView.region
		let search = MKLocalSearch(request: request)
		search.start { [weak weakSelf = self] response, _ in
			guard let response = response else {
				return
			}
			weakSelf?.mapItems = response.mapItems.filter {
				$0.placemark.countryCode == "KR"
			}
		}
	}
}

extension BottomSheetVC: Collapsable {
	
	var isCollapsed: Bool {
		guard view.superview != nil  else {
			return false
		}
		let currentHeight = view.superview!.bounds.height - view.frame.origin.y
		return abs(collapsedHeight - currentHeight) < abs(expandedHeight - currentHeight)
	}
	
	func changeState(toCollapse: Bool, duration: TimeInterval, dampingRatio: CGFloat) {
		guard let superView = view.superview else {
			return
		}
		let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) { [weak self] in
			guard let strongSelf = self else {
				return
			}
			strongSelf.view.frame.origin.y = superView.bounds.height - (toCollapse ? strongSelf.collapsedHeight: strongSelf.expandedHeight)
			strongSelf.view.layer.cornerRadius = toCollapse ? strongSelf.handleConnerRadius: 0
		}
		animator.addCompletion { [weak weakSelf = self] _ in
			weakSelf?.frameAnimator = nil
		}
		frameAnimator = animator
		animator.startAnimation()
	}
}
