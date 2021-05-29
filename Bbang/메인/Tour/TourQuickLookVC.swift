//
//  TourQuickLookVC.swift
//  Bbang
//
//  Created by bart Shin on 28/05/2021.
//

import UIKit

class TourQuickLookVC: UIViewController {
	
	@IBOutlet weak var scrollview: UIScrollView!
	private var map = SimpleMapView()
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var cardImage: UIImageView!
	private var cardShadow: UIView?
	@IBOutlet weak var cardImageHeight: NSLayoutConstraint!
	@IBOutlet weak var cardImageWidth: NSLayoutConstraint!
	@IBOutlet weak var backButton: UIButton!
	
	@objc private func tapMap(sender: UIGestureRecognizer) {
		let location  = sender.location(in: map)
		if let foundMap = map.findMap(contain: location) {
			map.selectedArea = foundMap.map
			scrollview.zoom(to: foundMap.frame, animated: true)
		}
	}
	@IBAction func tapBackButton(_ sender: UIButton) {
		changeCardState(of: nil, toShow: false)
		zoomOut()
	}
	
	private func zoom(to area: MapPath.Area) {
		if let frame = map.getFrame(of: area) {
			map.selectedArea = area
			scrollview.zoom(to: frame, animated: true)
		}
	}
	
	private func zoomOut() {
		map.selectedArea = nil
		scrollview.setZoomScale(1.0, animated: true)
	}
	
	private func changeCardState(of area: MapPath.Area?, toShow: Bool) {
		cardView.isHidden = !toShow
		cardShadow?.isHidden = !toShow
		backButton.isHidden = !toShow
		scrollview.isUserInteractionEnabled = !toShow
		if area != nil {
			cardImage.image = UIImage(named: area!.rawValue)
		}
		UIView.animate(withDuration: 1,
									 delay: 0, options: [.curveEaseInOut]) { [weak self] in
			guard let strongSelf = self else {
				return
			}
			strongSelf.cardImageWidth.constant = strongSelf.view.bounds.width * 0.8
			strongSelf.cardImageHeight.constant = strongSelf.view.bounds.height * 0.7
			strongSelf.cardView.alpha = 1
			strongSelf.cardShadow?.alpha = 1
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		map.areas = MapPath.Area.allCases
		initScrollview()
		initCardView()
		map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMap(sender:))))
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// FIXME: Dummy location
		zoom(to: .busan)
	}
	
	private func initScrollview() {
		scrollview.delegate = self
		scrollview.addSubview(map)
		scrollview.maximumZoomScale = 2.0
		scrollview.contentSize = map.bounds.size
		scrollview.isMultipleTouchEnabled = false
	}
	
	private func initCardView() {
		cardView.alpha = 0
		cardView.isHidden = true
		cardView.layer.cornerRadius = 20
		cardView.layer.borderWidth = 2
		cardView.layer.borderColor = UIColor.gray.cgColor
		cardShadow = UIView.createShadowView(in: view, behind: cardImage, heightScale: 0.6)
		if cardShadow != nil {
			view.insertSubview(cardShadow!, belowSubview: cardView)
			cardShadow!.isHidden = true
			cardShadow!.alpha = 0
		}
		cardImageWidth.constant = view.bounds.width/2
		cardImageHeight.constant = view.bounds.height/2
	}
}

extension TourQuickLookVC: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		map
	}
	
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		if let area = map.selectedArea {
			changeCardState(of: area, toShow: true)
		}
	}
}

