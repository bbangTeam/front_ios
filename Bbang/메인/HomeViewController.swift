//
//  HomeViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit
import Combine
import SDWebImage

class HomeViewController: UIViewController {
	
	var location: LocationGather!
	var server: ServerDataOperator! {
		didSet {
			observeServerResponse()
			_ = server.reqeustWorldCupData()
		}
	}
	private var tourQuickLookVC: TourQuickLookVC?
	
	private var serverResponseObserver: AnyCancellable?
	private var cityObserver: AnyCancellable?
	private var tourObserver: AnyCancellable?
	private var worldCupPreviews = [(content: WorldCupContent, preview: WorldCupPreview)]()
	private var worldCupImageObservers = [WorldCupContent: AnyCancellable]()
	
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var welcomeFeed: UIView!
	@IBOutlet weak var tourQuickLook: UIView!
	@IBOutlet weak var BbangStarQuikLook: UIView!
	@IBOutlet weak var worldCupSelector: UIScrollView!
	
	private var previewMargin: CGFloat!
	private var worldCupPreviewSize: CGSize {
		CGSize(width: view.bounds.width*0.6, height: worldCupSelector.frame.height)
	}
	
	// MARK:- User intents
	
	@objc private func tapWorldCupPreview(_ gesture: UITapGestureRecognizer) {
		guard let preview = gesture.view as? WorldCupPreview,
					let content = worldCupPreviews.first(where: {
						$0.preview == preview
					})?.content else {
			return
		}
		let worldCupVC = WorldCupVC(with: content)
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
		scrollview.contentInsetAdjustmentBehavior = .never
		observeCity()
		location.requestAuthorization()
	}
	
	fileprivate func observeCity() {
		cityObserver = location.$cityname.sink { [weak weakSelf = self] in
			if let cityName = $0,
				 let city = Area.allCases.first(where: {
					$0.koreanName.contains(cityName) || cityName.contains($0.koreanName)
				 }) {
				weakSelf?.tourQuickLookVC?.zoom(to: city)
				weakSelf?.server.requestFamous(
					nearby: city,
					lengthDemand: 40,
					needDetail: false)
					.observe(using: { result in
						print(result)
					})
			}
		}
	}
	
	fileprivate func observeServerResponse() {
		serverResponseObserver = server.$responses.sink{ [self] responses in
			if responses[.worldCup] != nil {
				extractWorlcupDate(in: responses[.worldCup]!)
			}
			if responses[.famous] != nil {
				extractFamousData(in: responses[.famous]!)
			}
		}
	}
	
	fileprivate func extractWorlcupDate(in responses: Set<ServerDataOperator.Response> ) {
		responses.forEach {
			server.removeResponse($0, in: .worldCup)
			if let data = $0.data ,
				 let content = WorldCupContent(from: data) {
				waitWorldCupImages(for: content)
				content.fetchImages()
			}
		}
	}
	
	fileprivate func extractFamousData(in responses: Set<ServerDataOperator.Response>) {
		responses.forEach {
			server.removeResponse($0, in: .famous)
			if let data = $0.data,
				 
				 let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				 let tag = $0.requestTag,
				 let area = Area(rawValue: tag),
				 let storeList = json["storeList"] as? [[String: Any]]{
				let stores = storeList.compactMap {
					StoreInfo(from: $0)
				}
				tourQuickLookVC?.stores[area] = stores
			}
		}
	}
	
	fileprivate func waitWorldCupImages(for content: WorldCupContent) {
		worldCupImageObservers[content] = content.$fetcedImageCount.sink {
			[weak weakSelf = self] in
			if $0 >= 16 {
				weakSelf?.worldCupImageObservers[content] = nil
				weakSelf?.createPreview(with: content)
			}
		}
	}
	
	fileprivate func initWorldCupView() {
		previewMargin = view.bounds.width*0.05
		worldCupSelector.delegate = self
	}
	
	fileprivate func createPreview(with content: WorldCupContent) {
		let origin = CGPoint(x: worldCupPreviews.last == nil ? previewMargin*2: worldCupPreviews.last!.1.frame.maxX + previewMargin,
												 y: worldCupSelector.bounds.origin.y)
		let preview: WorldCupPreview = .fromNib()
		preview.frame = CGRect(origin: origin, size: worldCupPreviewSize)
		preview.imageView.image = content.images.first?.value
		preview.title.text = "빵드컵"
		preview.addGestureRecognizer(UITapGestureRecognizer(
																	target: self,
																	action: #selector(tapWorldCupPreview(_:))))
		worldCupPreviews.append((content, preview))
		worldCupSelector.contentSize = CGSize(
			width: view.bounds.width*CGFloat(worldCupPreviews.count),
			height: worldCupPreviewSize.height)
		worldCupSelector.addSubview(preview)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is TourQuickLookVC {
			self.tourQuickLookVC = (segue.destination as! TourQuickLookVC)
		}
	}
}

extension HomeViewController: UIScrollViewDelegate {
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		guard abs(velocity.x) > 0.3 else {
			return
		}
		let estimatedX = targetContentOffset.pointee.x
		var destinationPage = worldCupPreviews.first!.preview
		
		for page in worldCupPreviews {
			let gap = page.preview.frame.origin.x - estimatedX
			if velocity.x*gap > 0,
				 abs(destinationPage.frame.origin.x - estimatedX) > abs(gap) {
				destinationPage = page.preview
			}
		}
		targetContentOffset.pointee = CGPoint(
			x:  destinationPage.frame.origin.x - worldCupPreviewSize.width/2,
			y: destinationPage.frame.origin.y)
	}
}


class WorldCupContent {

	private let id = UUID()
	private(set) var fragments: [Fragment]
	@Published private(set) var fetcedImageCount = 0
	private(set) var images = [Fragment: UIImage]() {
		didSet {
			fetcedImageCount = images.values.count
		}
	}
	
	func fetchImages() {
		fragments.forEach { fragment in
			guard let url = URL(string: fragment.imageUrl) else {
				return
			}
			SDWebImageDownloader.shared.downloadImage(with: url) {  [weak self] image, data, error, _ in
				guard let strongSelf = self else {
					return
				}
				if image != nil {
					strongSelf.images[fragment] = image!
				}
				else {
					print("Fail to download worldcup image for \(fragment.name) \(error?.localizedDescription ?? "")")
				}
			}
		}
	}
	
	init?(from data: Data) {
		guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				let breadList = json["breadList"] as? [[String:Any]] else {
			return nil
		}
		self.fragments = breadList.compactMap {
			.init(from: $0)
		}
	}
	
	struct Fragment: Codable, Hashable {
		let id: String
		let imageUrl: String
		let name: String
		
		init?(from dictionary: [String: Any]) {
			if let id = dictionary["id"] as? String,
				 let imageUrl = dictionary["imageUrl"] as? String,
				 let name = dictionary["name"] as? String {
				self.id = id
				self.name = name
				self.imageUrl = imageUrl
			}
			else {
				return nil
			}
		}
	}
}

extension WorldCupContent: Equatable, Hashable {
	
	static func == (lhs: WorldCupContent, rhs: WorldCupContent) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
