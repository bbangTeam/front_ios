//
//  WorldCupVC.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit
import Combine
import SpriteKit

class WorldCupVC: UIViewController {
	
	private let worldCupTitle = "식빵 이상형 월드컵"
	private var breads = [BubbleScene.BubbleData]()
	private var breadsCount = 8
	private var spriteView: SKView!
	private var bubbleScene: BubbleScene!
	private var navigationBar: UINavigationBar!
	private var blurView: UIVisualEffectView!
	private var stageObserver: AnyCancellable?
	private var winnerObserver: AnyCancellable?
	fileprivate var navigationArea: CGRect {
		CGRect(origin: CGPoint(x: view.bounds.origin.x,
																 y: view.bounds.height*0.15),
								 size: CGSize(width: view.bounds.width,
															height: view.bounds.height*0.1))
	}
	fileprivate var contentArea: CGRect {
		CGRect(origin: CGPoint(x: view.bounds.origin.x,
													 y: view.bounds.height*0.2),
					 size: CGSize(width: view.bounds.width,
												height: view.bounds.height*0.6))
	}
		
	// MARK:- User intents
	@objc fileprivate func tapCloseButton() {
		dismiss(animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadBreadsData()
		initBlurView()
		initBubbleView()
		initNavigationBar()
		observeBubbleScene()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	
	fileprivate func observeBubbleScene() {
		stageObserver = bubbleScene.$stage.sink(receiveValue: { [weak weakSelf = self] stage in
			let stageString: String
			if stage == 4 {
					stageString = "준결승"
			}else if stage == 2 {
				stageString = "결승"
			}else {
				stageString = "\(stage) 강"
			}
			weakSelf?.navigationBar.topItem?.title = "\(weakSelf?.worldCupTitle ?? "") \(stageString)"
		})
		winnerObserver = bubbleScene.$winnerId.sink(receiveValue: { [weak weakSelf = self] winnerId in
			guard let winner = weakSelf?.breads.first(where: {
							$0.id == winnerId
						}) else {
				return
			}
			weakSelf?.showWinnerView(for: winner)
		})
	}
	
	fileprivate func showWinnerView(for winner: BubbleScene.BubbleData) {
		navigationBar.topItem?.title = "\(winner.title)"
		let winnerView: WorldcupWinnerView = UIView.fromNib()
		winnerView.frame = contentArea
		winnerView.imageView.image = winner.image
		winnerView.title.text = winner.title
		view.addSubview(winnerView)
	}
	
	fileprivate func initBlurView() {
		blurView = UIVisualEffectView(frame: view.bounds)
		blurView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
		blurView.alpha = 0.6
		blurView.isUserInteractionEnabled = false
		view.addSubview(blurView)
	}
	
	fileprivate func initNavigationBar() {
		navigationBar = UINavigationBar(frame: navigationArea)
		let navigationItem = UINavigationItem(title: worldCupTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .close, target: self, action: #selector(tapCloseButton))
		navigationBar.pushItem(navigationItem, animated: false)
		view.addSubview(navigationBar)
	}
	
	fileprivate func initBubbleView() {
		spriteView = SKView( frame: contentArea)
		view.addSubview(spriteView)
		spriteView.isUserInteractionEnabled = true
		spriteView.isMultipleTouchEnabled = false
		spriteView.backgroundColor = .white
		spriteView.ignoresSiblingOrder = false
		bubbleScene = BubbleScene(data: breads, size: view.bounds.size)
		spriteView.presentScene(bubbleScene)
	}
	
	fileprivate func loadBreadsData() {
		for count in 1...breadsCount {
			let num = count%5 + 1
			let data = BubbleScene.BubbleData(
				image: UIImage(named: "breadBubble\(num)")!,
				title: "식빵 \(count)",
				description: "description description description",
				id: "\(count)")
			breads.append(data)
		}
	}
}
