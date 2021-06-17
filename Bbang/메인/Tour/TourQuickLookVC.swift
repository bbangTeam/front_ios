//
//  TourQuickLookVC.swift
//  Bbang
//
//  Created by bart Shin on 28/05/2021.
//

import UIKit

class TourQuickLookVC: UIViewController, PushToOtherTap {
	
	
	private let storeIconImage = UIImage(named: "bread_icon")!
	private let storeIconSize = CGSize(width: 35, height: 35)
	private var map = CompleteMapView()
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var detailView: UIView!
	@IBOutlet weak var cityImageView: UIImageView!
	
	var stores = [Area: [StoreInfo]]() {
		didSet {
			if let currentArea = map.selectedArea,
				 stores[currentArea] != nil {
				DispatchQueue.main.async {
					self.drawStores()
				}
			}
		}
	}
	
	// MARK:- User intents
	@objc private func tapMap(sender: UIGestureRecognizer) {
		let location  = sender.location(in: map)
		if let found = map.findMap(contain: location) {
			zoom(to: found.map, with: found.frame)
		}
	}
	
	@IBAction func tapBackButton(_ sender: UIButton) {
		changeView(from: detailView, to: scrollview, completion: zoomOut)
	}
	
	func zoom(to area: Area, with givenFrame: CGRect? = nil) {
		let frame = givenFrame ?? map.getFrame(of: area)
		guard frame != nil else {
			assertionFailure("Fail to find frame to zoom of \(area)")
			return
		}
		map.selectedArea = area
		scrollview.zoom(to: frame!, animated: true)
		cityImageView.image = UIImage(named: "path_\(area.rawValue)")
		changeView(from: scrollview, to: detailView)
	}
	
	private func drawStores() {
		stores[map.selectedArea!]!.forEach{ info in
			guard let offset = map.selectedArea!.calcOffset(location: info.location, in: cityImageView.bounds.size) else {
				return
			}
			let center = CGPoint(x: cityImageView.frame.minX + offset.x,
													 y: cityImageView.frame.minY + offset.y)
			let icon = UIImageView()
			icon.image = storeIconImage
			icon.contentMode = .scaleAspectFit
			icon.frame.size = storeIconSize
			icon.center = center
			detailView.addSubview(icon)
		}
	}
	
	private func zoomOut() {
		map.selectedArea = nil
		scrollview.setZoomScale(1.0, animated: true)
		titleLabel.text = "빵지순례"
		subtitleLabel.text = "원하는 지역을 골라주세요"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		initLabels()
		initScrollview()
		map.areas = Area.allCases
		map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMap(sender:))))
	}
	
	fileprivate func initLabels() {
		titleLabel.font = DesignConstant.getUIFont(.init(family: .NotoSansCJKkr, style: .headline(scale: 2)))
		subtitleLabel.font = DesignConstant.getUIFont(.init(family: .NotoSansCJKkr, style: .subtitle(scale: 1)))
		titleLabel.textColor = DesignConstant.getUIColor(palette: .secondary(staturation: 900))
		subtitleLabel.textColor = DesignConstant.getUIColor(palette: .secondary(staturation: 900))
	}
	
	fileprivate func initScrollview() {
		scrollview.delegate = self
		scrollview.addSubview(map)
		scrollview.maximumZoomScale = 3.0
		scrollview.contentSize = map.bounds.size
		scrollview.isMultipleTouchEnabled = false
	}
}

extension TourQuickLookVC: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		map
	}
	
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		if let area = map.selectedArea {
			changeView(from: scrollview, to: detailView) { [weak weakSelf = self] in
				weakSelf?.titleLabel.text = area.koreanName
				weakSelf?.subtitleLabel.text = "빵덕후들의 성지"
			}
		}
	}
	
	fileprivate func changeView(from toHide: UIView, to toShow: UIView, completion: @escaping () -> Void = {}) {
		let duration: TimeInterval = 0.5
		let hideAnimator = UIViewPropertyAnimator(
			duration: duration,
			curve: .easeIn) {
			toHide.alpha = 0
		}
		let showAnimator = UIViewPropertyAnimator(
			duration: duration,
			curve: .easeOut) {
			toShow.alpha = 1
		}
		showAnimator.addCompletion { _ in
			completion()
		}
		hideAnimator.startAnimation()
		showAnimator.startAnimation(afterDelay: duration)
	}
}

