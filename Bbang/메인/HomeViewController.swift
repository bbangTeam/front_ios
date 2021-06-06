//
//  HomeViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit

class HomeViewController: UIViewController {
	
	private let worldCupPageCount = 5
	private var worldCupPages = [WorldCupPreview]()
	private var margin: CGFloat!
	private var worldCupPreviewSize: CGSize {
		CGSize(width: view.bounds.width*0.6, height: worldCupSelector.frame.height)
	}
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var welcomeFeed: UIView!
	@IBOutlet weak var tourQuickLook: UIView!
	@IBOutlet weak var BbangStarQuikLook: UIView!
	@IBOutlet weak var worldCupSelector: UIScrollView!
	
	// MARK:- User intents
	
	@objc private func tapWorldCupPreview(_ gesture: UITapGestureRecognizer) {
		guard let preview = gesture.view as? WorldCupPreview else {
			return
		}
		let worldCupVC = WorldCupVC(nibName: nil, bundle: nil)
		worldCupVC.view.frame = CGRect(
			origin: view.frame.origin,
			size: CGSize(width: view.bounds.width,
									 height: view.bounds.height*0.6))
		worldCupVC.providesPresentationContextTransitionStyle = true
		worldCupVC.definesPresentationContext = true
		worldCupVC.modalPresentationStyle = .overCurrentContext
		worldCupVC.view.backgroundColor = .clear
		present(worldCupVC, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initWorldCupView()
	}
	
	fileprivate func initWorldCupView() {
		worldCupSelector.contentSize = CGSize(
			width: view.bounds.width*CGFloat(worldCupPageCount),
			height: worldCupPreviewSize.height)
		margin = view.bounds.width*0.05
		for index in 0..<worldCupPageCount {
			let preview = createPreview(index: index)
			worldCupSelector.addSubview(preview)
			worldCupPages.append(preview)
		}
		worldCupSelector.delegate = self
	}
	
	fileprivate func createPreview(index: Int) -> WorldCupPreview {
		let origin = CGPoint(x: worldCupPages.last == nil ? margin*2: worldCupPages.last!.frame.maxX + margin,
												 y: worldCupSelector.bounds.origin.y)
		let preview: WorldCupPreview = .fromNib()
		preview.frame = CGRect(origin: origin, size: worldCupPreviewSize)
		preview.imageView.image = UIImage(named: "worldCupPreview\(index+1)")
		preview.title.text = "빵드컵 \(index+1)"
		preview.addGestureRecognizer(UITapGestureRecognizer(
																	target: self,
																	action: #selector(tapWorldCupPreview(_:))))
		return preview
	}
	
	enum Segue: String {
		case welcomeFeed
		case tourQuickLook
		case worldCup
		case bbangStarQuikLook
	}
}

extension HomeViewController: UIScrollViewDelegate {
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		guard abs(velocity.x) > 0.3 else {
			return
		}
		let estimatedX = targetContentOffset.pointee.x
		var destinationPage = worldCupPages.first!
		
		for page in worldCupPages {
			let gap = page.frame.origin.x - estimatedX
			if velocity.x*gap > 0,
				 abs(destinationPage.frame.origin.x - estimatedX) > abs(gap) {
				destinationPage = page
			}
		}
		targetContentOffset.pointee = CGPoint(
			x:  destinationPage.frame.origin.x - worldCupPreviewSize.width/2,
			y: destinationPage.frame.origin.y)
	}
}
