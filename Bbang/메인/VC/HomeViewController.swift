//
//  HomeViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import SwiftUI
import Combine

class HomeViewController: UIViewController {
	
	var location: LocationGather!
	var bakeryInfo: BakeryInfoManager!
	var server: ServerDataOperator! {
		didSet {
			observeServerResponse()
			_ = server.requestWorldCupData()
		}
	}
	private var isLoggedIn = false
	private var bakeryListHC: UIHostingController<HomeBakeryList>!
	private var tourQuickLookVC: TourVC?
	private var BSPreviewVC: BSPreviewVC?
	
	private var serverResponseObserver: AnyCancellable?
	private var cityObserver: AnyCancellable?
	private var worldCupPreviews = [(content: WorldCupContent, preview: UIView)]()
	private var worldCupImageObservers = [WorldCupContent: AnyCancellable]()
	
	@IBOutlet weak var homeVerticalScrollview: UIScrollView!
	@IBOutlet weak var welcomeFeed: UIView!
	@IBOutlet weak var bakeryListContainerView: UIView!
	@IBOutlet weak var tourView: UIView!
	@IBOutlet weak var BbangStarView: UIView!
	@IBOutlet weak var worldCupScrollView: UIScrollView!
	@IBOutlet weak var listCollapseButton: UIButton!
	@IBOutlet weak var bakeryListViewHeight: NSLayoutConstraint!
	@IBOutlet weak var collapseButtonView: UIView!
	private var isBakeryListCollapsed = true
	private var bakeryListCollapsedHeight: CGFloat!
	
	// MARK:- User intents
	
	@objc private func tapWorldCupPreview(_ gesture: UITapGestureRecognizer) {
		guard let preview = gesture.view,
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
		worldCupVC.server = server
		present(worldCupVC, animated: true)
	}
	
	@IBAction private func tapListCollapseButton(_ sender: UIButton) {
		isBakeryListCollapsed.toggle()
		sender.setTitle(isBakeryListCollapsed ? "더보기": "접기", for: .normal)
		UIView.animate(withDuration: 0.8,
					   delay: 0,
					   usingSpringWithDamping: 0.7,
					   initialSpringVelocity: 1,
					   options: [.curveEaseInOut]) { [self] in
			bakeryListViewHeight.constant = isBakeryListCollapsed ? bakeryListCollapsedHeight: bakeryListHC.view.bounds.height + Constant.collapseButtonHeight
			if isBakeryListCollapsed {
				homeVerticalScrollview.contentOffset =
					CGPoint(x: bakeryListContainerView.frame.origin.x,
							y: bakeryListContainerView.frame.origin.y + bakeryListCollapsedHeight)
			}
			homeVerticalScrollview.layoutIfNeeded()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configColorMode()
		checkLogin()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !isLoggedIn {
			tabBarController?.tabBar.isHidden = true
			let signInVC: SignInVC = UIStoryboard(storyboard: .Main).instantiateViewController()
			signInVC.handleLogin = { [self] in
				loadContent()
				isLoggedIn = true
				signInVC.disappear()
				tabBarController?.tabBar.isHidden = false
			}
			addChild(signInVC)
			view.addSubview(signInVC.view)
		}
	}
	
	fileprivate func checkLogin() {
		// TODO: Login
	}
	
	fileprivate func loadContent() {
		initBakeryListView()
		homeVerticalScrollview.contentInsetAdjustmentBehavior = .never
		observeCity()
		location.requestAuthorization()
		server.requestFeed(at: 1, by: 10)
			.observe { result in
				print("Request news feed \(result)")
			}
	}
	
	fileprivate func configColorMode(){
		if traitCollection.userInterfaceStyle == .dark {
			view.backgroundColor = DesignConstant.getUIColor(.secondary(staturation: 900))
		}else if traitCollection.userInterfaceStyle == .light {
			view.backgroundColor = .white
		}
	}
	
	fileprivate func initBakeryListView() {
		bakeryListCollapsedHeight = HomeBakeryList.Constant.topBarHeight + (UIScreen.main.bounds.width - HomeBakeryList.Constant.horizontalMargin * 2) * BakeryFeedView.Constant.aspectRatio * 2 + Constant.collapseButtonHeight - 50
		bakeryListViewHeight.constant = bakeryListCollapsedHeight
		bakeryListHC = UIHostingController(rootView: HomeBakeryList(bakeries: BakeryInfoManager.dummys))
		bakeryListHC.view.frame = .init(
			origin: bakeryListContainerView.bounds.origin,
			size: .init(width: bakeryListContainerView.bounds.width,
						height: bakeryListHC.view.intrinsicContentSize.height))
		bakeryListContainerView.insertSubview(bakeryListHC.view, belowSubview:
												collapseButtonView)
		bakeryListHC.view.sizeToFit()
		initCollapseButton()
	}
	
	fileprivate func initCollapseButton() {
		listCollapseButton.frame.size = Constant.collapseButtonSize
		listCollapseButton.snp.makeConstraints {
			$0.size.equalTo(Constant.collapseButtonSize)
		}
		listCollapseButton.titleLabel?.font = Constant.collapseButtonFont
		listCollapseButton.setTitleColor(Constant.collapseButtonColor, for: .normal)
		listCollapseButton.layer.borderWidth = 1
		listCollapseButton.layer.borderColor = Constant.collapseButtonColor.cgColor
		listCollapseButton.layer.cornerRadius = 4
	}
	
	fileprivate func observeCity() {
		cityObserver = location.$cityname.sink { [weak weakSelf = self] in
			if let cityName = $0,
				 let city = Area.allCases.first(where: {
					$0.koreanName.contains(cityName) || cityName.contains($0.koreanName)
				 }) {
				_ = weakSelf?.server.requestFamous(
					nearby: city,
					lengthDemand: 40,
					needDetail: false)
					.observe { _ in
						DispatchQueue.main.async {
							weakSelf?.tourQuickLookVC?.zoom(to: city)
						}
					}
			}
		}
	}
	
	fileprivate func observeServerResponse() {
		serverResponseObserver = server.objectWillChange.sink{ [self] in
			if server.responses[.worldCup] != nil,
			   !server.responses[.worldCup]!.isEmpty{
				extractWorlcupDate()
			}
			if server.responses[.famous] != nil,
			   !server.responses[.famous]!.isEmpty{
				extractFamousData()
			}
			if server.responses[.bbangStarNewsFeed] != nil,
			   !server.responses[.bbangStarNewsFeed]!.isEmpty{
				extractNewsFeed()
			}
		}
		
	}
	
	fileprivate func extractWorlcupDate() {
		server.responses[.worldCup]!.forEach {
			server.removeResponse($0, in: .worldCup)
			if let data = $0.data ,
				 let content = WorldCupContent(from: data) {
				waitWorldCupImages(for: content)
				content.fetchImages()
			}
		}
	}
	
	fileprivate func extractNewsFeed() {
		server.responses[.bbangStarNewsFeed]!.forEach { server.removeResponse($0, in: .bbangStarNewsFeed)
			if let data = $0.data ,
			   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ,
			   let list = json["breadstagramList"] as? [[String: Any]] {
				let newFeeds = list.compactMap { BSFeed(from: $0) }
				#if DEBUG
				if newFeeds.isEmpty {
					DispatchQueue.main.async {
						self.BSPreviewVC?.feeds = .init(repeating: .dummy, count: 10)
					}
					print("BS feed is emtpy using dummy data")
					return
				}
				#endif
				DispatchQueue.main.async {
					self.BSPreviewVC?.feeds = newFeeds
				}
			}else {
				print("Fail to get data for \($0)")
				#if DEBUG
					DispatchQueue.main.async {
						self.BSPreviewVC?.feeds = .init(repeating: .dummy, count: 10)
					}
					print("Using dummy data")
				#endif
			}
		}
	}
	
	fileprivate func extractFamousData() {
		guard tourQuickLookVC != nil else {
			return
		}
		server.responses[.famous]!.forEach {
			server.removeResponse($0, in: .famous)
			if let data = $0.data,
				 let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				 let tag = $0.requestTag,
				 let area = Area(koreanName: tag),
				 let bakeryList = json["storeList"] as? [[String: Any]]{
				let bakeries = bakeryList.compactMap {
					BakeryInfoManager.Bakery(from: $0)
				}
				tourQuickLookVC?.setBakeryData(bakeries, for: area)
			}
		}
	}
	
	fileprivate func waitWorldCupImages(for content: WorldCupContent) {
		worldCupImageObservers[content] = content.$fetcedImageCount.sink {
			[weak weakSelf = self] in
			if $0 >= 16 {
				weakSelf?.worldCupImageObservers[content] = nil
				weakSelf?.createPreview(with: content)
				weakSelf?.createPreview(with: content)
			}
		}
	}
	
	fileprivate func createPreview(with content: WorldCupContent) {
		let origin = CGPoint(x: worldCupPreviews.last == nil ? Constant.previewMargin : worldCupPreviews.last!.1.frame.maxX + Constant.previewMargin * 2 ,
							 y: worldCupScrollView.bounds.origin.y)
		let size = CGSize(width: worldCupScrollView.bounds.width - Constant.previewMargin * 2,
						  height: worldCupScrollView.bounds.height)
		let preview = UIImageView(frame: CGRect(origin: origin, size: size))
		preview.isUserInteractionEnabled = true
		preview.contentMode = .scaleAspectFill
		let bannerImage = UIImage(named: "worldcup_banner")!
		preview.image = bannerImage
		preview.addGestureRecognizer(
			UITapGestureRecognizer(
				target: self,
				action: #selector(tapWorldCupPreview(_:))))
		worldCupPreviews.append((content, preview))
		worldCupScrollView.contentSize = CGSize(
			width: view.bounds.width*CGFloat(worldCupPreviews.count),
			height: worldCupScrollView.bounds.height)
		worldCupScrollView.addSubview(preview)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tourVC = segue.destination as? TourVC {
			self.tourQuickLookVC = tourVC
			tourVC.server = server
		}
		else if let BSPreviewVC = segue.destination as? BSPreviewVC {
			BSPreviewVC.server = server
			self.BSPreviewVC = BSPreviewVC
		}
	}
	
	struct Constant {
		static let collapseButtonHeight: CGFloat = 50
		static var previewMargin: CGFloat = 0
		static let collapseButtonSize = CGSize(width: 264, height: 34)
		static let collapseButtonFont = DesignConstant.getUIFont(.init(family: .NotoSansCJKkr, style: .body(scale: 1)))
		static let collapseButtonColor = DesignConstant.getUIColor(.secondary(staturation: 400))
	}
}
