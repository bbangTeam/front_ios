//
//  BubbleScene.swift
//  Bbang
//
//  Created by bart Shin on 04/06/2021.
//

import SpriteKit

class BubbleScene: SKScene {
	
	private var gravity: GravityDirection
	private var field: SKFieldNode
	private var bubbles: Set<BubbleNode>
	private var winnerBubbles: Set<BubbleNode>
	private var startButton: SKLabelNode
	private var leftTitle: SKLabelNode
	private var rightTitle: SKLabelNode
	@Published private(set) var stage: Int
	@Published private(set) var winnerId: String?
	private(set) var currentRaisedBubbles: [BubbleNode] {
		didSet {
			if currentRaisedBubbles.count == 2 {
				dimmBubbles()
			}
		}
	}
	fileprivate static let bubbleRadius: CGFloat = 30
	
	// MARK:- User intents
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		let location = touch.location(in: self)
		if !startButton.isHidden,
			startButton.contains(location) {
			raiseRandomBubbles()
		}else {
			if let touchedBubble = currentRaisedBubbles.first(where: {
				$0.contains(location)
			}) {
				touchRaisedBubble(touchedBubble)
			}
		}
	}
	
	fileprivate func touchRaisedBubble(_ touchedBubble: BubbleNode) {
		guard let notTouchedBubble = currentRaisedBubbles.first(where: {
			$0 != touchedBubble
		}) else {
			return
		}
		leftTitle.isHidden = true
		rightTitle.isHidden = true
		drop(notTouchedBubble) { [weak self] in
			guard let strongSelf = self else {
				return
			}
			strongSelf.choose(touchedBubble) {
				strongSelf.currentRaisedBubbles = []
				if strongSelf.bubbles.isEmpty {
					if strongSelf.winnerBubbles.count > 1 {
						strongSelf.goToNextState()
					}else if let winner = strongSelf.winnerBubbles.first {
						strongSelf.winnerId = winner.id
						strongSelf.endScene()
					}
				}else {
					strongSelf.raiseRandomBubbles()
				}
			}
		}
	}
	
	fileprivate func goToNextState() {
		winnerBubbles.forEach {
			$0.setScale(1)
			$0.alpha = 1
			$0.zPosition = 0
			$0.physicsBody = SKPhysicsBody(circleOfRadius: $0.physicsRadius)
			addBubble($0)
		}
		bubbles = winnerBubbles
		winnerBubbles = []
		startButton.isHidden = false
		startButton.text = "Continue"
		stage = bubbles.count
	}
	
	fileprivate func drop(_ bubble: BubbleNode, completion: @escaping () -> Void) {
		let destination = CGPoint(x: frame.midX,
															y: frame.minY)
		let dropAction = SKAction.move(to: destination, duration: bubble.timeToTransition/2)
		let fadeOutAction = SKAction.fadeAlpha(to: 0, duration: bubble.timeToTransition/2)
		bubble.run(SKAction.group([dropAction, fadeOutAction])) {
			completion()
		}
	}
	
	fileprivate func choose(_ bubble: BubbleNode, completion: @escaping () -> Void) {
		guard currentRaisedBubbles.contains(bubble) else {
			assertionFailure("Try to chosse bubble not raised \(bubble)")
			return
		}
		winnerBubbles.insert(bubble)
		let centralAction = SKAction.moveTo(x: frame.midX, duration: bubble.timeToTransition/2)
		let heaven = CGPoint(x: frame.midX,
															y: frame.maxY + 100)
		let ascendAction = SKAction.move(to: heaven, duration: bubble.timeToTransition)
		let shrinkAction = SKAction.scale(to: 1, duration: bubble.timeToTransition)
		let goToHeavenAction = SKAction.group([ascendAction, shrinkAction])
		bubble.run(SKAction.sequence([
			centralAction,
			SKAction.wait(forDuration: bubble.timeToTransition/2),
			goToHeavenAction
		])) {
			bubble.alpha = 0
			completion()
		}
	}
	
	fileprivate func raiseRandomBubbles() {
		let first = bubbles.randomElement()!
		var second: BubbleNode
		repeat {
			second = bubbles.randomElement()!
		}while first == second
		raiseUpBubbles(of: [first, second])
		startButton.isHidden = true
		leftTitle.text = first.title
		rightTitle.text = second.title
	}
	
	private func raiseUpBubbles(of bubblesToRaise: [BubbleNode]) {
		bubblesToRaise.forEach { bubble in
			bubble.alpha = 1
			bubble.run(SKAction.scale(to: bubble.bigScale, duration: bubble.timeToTransition)) { [weak self] in
				guard let strongSelf = self else {
					return
				}
				bubble.physicsBody = nil
				bubble.zPosition = 2
				let destinationX = strongSelf.frame.width*(bubble == bubblesToRaise.first ? 0.25: 0.75)
				let moveAction = SKAction.move(
					to: CGPoint(x: destinationX,
											y: strongSelf.frame.height/2),
					duration: bubble.timeToTransition)
				let expandAction = SKAction.scale(to: bubble.giantScale, duration: bubble.timeToTransition)
				bubble.run(SKAction.group([moveAction, expandAction])) {
					strongSelf.bubbles.remove(bubble)
					strongSelf.currentRaisedBubbles.append(bubble)
					strongSelf.leftTitle.isHidden = false
					strongSelf.rightTitle.isHidden = false
				}
			}
		}
	}
	
	fileprivate func dimmBubbles() {
		bubbles.forEach { bubble in
			bubble.run(SKAction.fadeAlpha(to: 0.2, duration: bubble.timeToTransition))
		}
	}
	
	override func didMove(to view: SKView) {
		super.didMove(to: view)
		scaleMode = .aspectFill
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		backgroundColor = .white
		initField()
		initLabels()
		bubbles.forEach {
			addBubble($0)
			addChild($0)
		}
	}
	
	fileprivate func initField() {
		field.region = SKRegion(radius: 10000)
		field.minimumRadius = 10000
		field.strength = 6000
		field.position = CGPoint(x: size.width / 2,
														 y: size.height / 2)
		addChild(field)
	}
	
	fileprivate func initLabels() {
		startButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
		leftTitle.position = CGPoint(x: frame.width * 0.25, y: frame.midY - 200)
		rightTitle.position = CGPoint(x: frame.width * 0.75, y: frame.midY - 200)
		[startButton, leftTitle, rightTitle].forEach {
			$0.zPosition = 3
			$0.fontSize = 30
			$0.fontColor = .black
			addChild($0)
		}
		leftTitle.isHidden = true
		rightTitle.isHidden = true
		startButton.text = "Start"
		startButton.fontColor = .blue
	}
	
	private func addBubble(_ bubble: BubbleNode) {
		let isLeft = Bool.random()
		let xPosition = frame.size.width*(isLeft ? CGFloat.random(in: 0.7...1.0): CGFloat.random(in: 0...0.3))
		let yPosition = CGFloat.random(in: 0.1...1)*frame.size.height
		bubble.position = CGPoint(x: xPosition, y: yPosition)
	}
	
	override func update(_ currentTime: TimeInterval) {
		bubbles.forEach { bubble in
			let distanceFromCenter = field.position.distance(from: bubble.position)
			bubble.physicsBody?.linearDamping = 2
			
			if distanceFromCenter <= 100 {
				bubble.physicsBody?.linearDamping += ((100 - distanceFromCenter) / 5)
			}
		}
	}
	
	fileprivate func endScene() {
		removeFromParent()
		view?.isHidden = true
	}

	init(data: [BubbleData], size: CGSize) {
		gravity = .central
		bubbles = Set(data.compactMap {
			BubbleNode.create(title: $0.title, caption: $0.description, image: $0.image, radius: BubbleScene.bubbleRadius, id: $0.id)
		})
		currentRaisedBubbles = []
		winnerBubbles = []
		field =  SKFieldNode.radialGravityField()
		startButton = SKLabelNode(text: nil)
		leftTitle = SKLabelNode(text: nil)
		rightTitle = SKLabelNode(text: nil)
		stage = data.count
		winnerId = nil
		super.init(size: size)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum GravityDirection {
		case central
		case below
	}
	
	struct BubbleData {
		let image: UIImage
		let title: String
		let description: String
		let id: String
	}
	
	enum NodeName: String {
		case startButton
	}
}
