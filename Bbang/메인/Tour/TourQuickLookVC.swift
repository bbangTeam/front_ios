//
//  TourQuickLookVC.swift
//  Bbang
//
//  Created by bart Shin on 28/05/2021.
//

import UIKit

class TourQuickLookVC: UIViewController, PushToOtherTap {
	
	private var map = SimpleMapView()
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var cardImage: UIImageView!
	@IBOutlet weak var cardImageHeight: NSLayoutConstraint!
	@IBOutlet weak var cardImageWidth: NSLayoutConstraint!
	@IBOutlet weak var backButton: UIButton!
	
	// MARK:- User intents
	@objc private func tapMap(sender: UIGestureRecognizer) {
		let location  = sender.location(in: map)
		if let found = map.findMap(contain: location) {
			zoom(to: found.map, with: found.frame)
		}
	}
	
	@objc private func tapCard() {
		// TODO: Pass area seleted
		guard let area = map.selectedArea ,
					let tourVC = tabBarController?.viewControllers?.first(where: {
						$0 is BbangtourViewController
					})
		else { return }
		if let superView = findSuperView(from: view)  {
			changeTapWithAnimation(from: superView, to: tourVC) { destination in
				
			}
		}else {
			changeTapWithAnimation(from: nil, to: tourVC) { destination in
			}
		}
	}
	
	@IBAction func tapBackButton(_ sender: UIButton) {
		changeCardState(of: nil, toShow: false)
		zoomOut()
	}
	
	private func zoom(to area: SimpleMapView.Area, with givenFrame: CGRect? = nil) {
		let frame = givenFrame ?? map.getFrame(of: area)
		guard frame != nil else {
			assertionFailure("Fail to find frame to zoom of \(area)")
			return
		}
		map.selectedArea = area
		scrollview.zoom(to: frame!, animated: true)
		map.alpha = 0.6
	}
	
	private func zoomOut() {
		map.selectedArea = nil
		scrollview.setZoomScale(1.0, animated: true)
		map.alpha = 1
	}
	
	private func changeCardState(of area: SimpleMapView.Area?, toShow: Bool) {
		cardView.isHidden = !toShow
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
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		map.areas = SimpleMapView.Area.allCases
		initScrollview()
		initCardView()
		map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMap(sender:))))
		cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard)))
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// TODO: Change Dummy location to user's
		zoom(to: .busan)
	}
	
	fileprivate func initScrollview() {
		scrollview.delegate = self
		scrollview.addSubview(map)
		scrollview.maximumZoomScale = 2.0
		scrollview.contentSize = map.bounds.size
		scrollview.isMultipleTouchEnabled = false
	}
	
	fileprivate func initCardView() {
		cardView.alpha = 0
		cardView.isHidden = true
		cardView.layer.cornerRadius = 20
		cardView.layer.borderWidth = 2
		cardView.layer.borderColor = UIColor.gray.cgColor
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

