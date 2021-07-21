//
//  WelcomeFeedVC.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit

class WelcomeFeedVC: UIViewController {
	
	let cardInfos: [CardInfo] = CardInfo.dummyCards
	private var cards = [WelcomeFeedCard]()
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var pageControl: ResizedPageControl!
	private var swipeTimer: Timer?
	
	//MARK:- User intents
	@objc fileprivate func tapPageController(_ sender: ResizedPageControl) {
		let page = cards[sender.currentPage]
		scrollview.scrollRectToVisible(page.frame, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollview.contentInsetAdjustmentBehavior = .never
		createCards()
		scrollview.delegate = self
		initPageController()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		startAutoSwipe()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		swipeTimer?.invalidate()
	}
	
	fileprivate func createCards() {
		cardInfos.forEach {
			let card: WelcomeFeedCard = UIView.fromNib()
			card.titleLabel.text = $0.title
			card.subtitleLabel.text = $0.description
			card.backgroundView.image = UIImage(named: $0.imageName)
			cards.append(card)
			scrollview.addSubview(card)
		}
	}
	
	fileprivate func initPageController() {
		pageControl.numberOfPages = cards.count
		pageControl.currentPage = 0
		pageControl.pageIndicatorTintColor = DesignConstant.getUIColor(.onSecondary(for: .medium))
		pageControl.currentPageIndicatorTintColor = DesignConstant.getUIColor(.primary(saturation: 600))
		pageControl.addTarget(self, action: #selector(tapPageController(_:)), for: .valueChanged)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		scrollview.contentSize = CGSize(
			width: CGFloat(cards.count) * view.bounds.width,
			height: view.bounds.height)
		let cardSize = CGSize(width: view.bounds.width, height: view.bounds.height)
		cards.enumerated().forEach { (index, card) in
			let origin = CGPoint(x: view.bounds.origin.x + CGFloat(index)*view.bounds.width,
								 y: view.bounds.origin.y)
			card.frame = CGRect(
				origin: origin, size: cardSize)
		}
	}
	
	struct CardInfo {
		var title: String
		var description: String
		var imageName: String
		
		static var dummyCards: [CardInfo] { [
			CardInfo(title: "모나카 앙버터", description: "고소한 모나카에 버터와 단팥을 한가득 담아 색다르게 즐기는 앙버터", imageName: "cardimage1"),
			CardInfo(title: "인절미 모나카 앙버터", description: "모나카에 한가득 담은 버터와 단팥, 콩가루와 찹쌀떡으로 더욱 고소한 앙버터", imageName: "cardimage2"),
			CardInfo(title: "이탈리아노 티라미수 케익", description: "Italiano Tiramisu Cake", imageName: "cardimage3"),
			CardInfo(title: "Card 4", description: "create your own egg & cheese sandwich – $4.50 add bacon, sausage or ham – $6.25 substitute egg whites – add $0.50. 1. BREAD (pick 1) • bagel (toasted)", imageName: "cardimage4"),
			CardInfo(title: "Card 5", description: "create your own egg & cheese sandwich – $4.50 add bacon, sausage or ham – $6.25 substitute egg whites – add $0.50. 1. BREAD (pick 1) • bagel (toasted)", imageName: "cardimage5")
		]}
	}
}

extension WelcomeFeedVC: UIScrollViewDelegate {
	
	private func getCurrentCardIndex() -> Int? {
		let offset = scrollview.contentOffset.x
		if let index = cards.firstIndex(where: {
			abs($0.frame.origin.x - offset) < 10
		}) {
			return index
		}
		return nil
	}
	
	private func startAutoSwipe() {
		swipeTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
			guard let strongSelf = self else { return }
			if let currentIndex = strongSelf.getCurrentCardIndex() {
				let nextIndex = (currentIndex + 1) % strongSelf.cards.count
				let nextCardFrame = strongSelf.cards[nextIndex].frame
				if nextIndex == 0 {
					strongSelf.flashScrollView()
				}
				strongSelf.scrollview.scrollRectToVisible(nextCardFrame, animated: nextIndex != 0)
				strongSelf.pageControl.currentPage = nextIndex
			}
		}
		swipeTimer?.tolerance = 0.3
	}
	
	private func flashScrollView() {
		UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations:{
			self.scrollview.alpha = 0.8
		})  { completed in
			if completed {
				UIView.animate(withDuration: 0.5) {
					self.scrollview.alpha = 1
				}
			}
		}
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		swipeTimer?.fireDate = Date() + 3
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if let index = getCurrentCardIndex() {
			pageControl.currentPage = index
		}
	}
}
