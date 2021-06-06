//
//  BubbleNode.swift
//  Bbang
//
//  Created by bart Shin on 04/06/2021.
//

import SpriteKit

class BubbleNode: SKShapeNode {
	
	private(set) var id: String!
	private(set) var title: String?
	private(set) var caption: String?
	let bigScale: CGFloat = 1.5
	let giantScale: CGFloat = 3
	let giganticScale: CGFloat = 4
	let timeToTransition: TimeInterval = 1
	private(set) var radius: CGFloat!
	var physicsRadius: CGFloat {
		radius + 1.5
	}
	
	var state: State = .normal {
		didSet {
			strokeColor = state.color
		}
	}
	
	class func create(title: String?, caption: String?, image: UIImage, radius: CGFloat, id: String) -> BubbleNode {
		let bubble = BubbleNode(circleOfRadius: radius)
		
		bubble.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
		bubble.physicsBody!.restitution = 0.9
		bubble.physicsBody!.friction = 0
		bubble.strokeColor = bubble.state.color
		bubble.fillTexture = SKTexture(image: image)
		bubble.fillColor = .white
		bubble.radius = radius
		bubble.title = title
		bubble.caption = caption
		bubble.id = id
		bubble.isUserInteractionEnabled = false
		return bubble
	}
	
	enum State {
		case normal
		case won
		case lost
		
		var color: UIColor {
			switch self {
			case .normal:
				return .black
			case .won:
				return .blue
			case .lost:
				return .red
			}
		}
	}
}

