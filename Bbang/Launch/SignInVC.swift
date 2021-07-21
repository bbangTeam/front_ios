//
//  SignInVC.swift
//  Bbang
//
//  Created by bart Shin on 18/07/2021.
//

import UIKit

class SignInVC: UIViewController {
	
	private var server: ServerDataOperator!
	@IBOutlet weak var logoView: UIImageView!
	@IBOutlet weak var loginButtonStack: UIStackView!
	private var loginButtons: [UIImageView] {
		loginButtonStack.subviews as! [UIImageView]
	}
	var handleLogin: () -> Void = { }
	
	override func awakeFromNib() {
		super.awakeFromNib()
		configColorMode()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		if DesignConstant.shared.interface == .dark {
			logoView.image = UIImage(named: "launchlogo_dark")
		}else {
			logoView.image = UIImage(named: "launchlogo_light")
		}
		setButtons()
    }
	
	func disappear() {
		let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
			self.view.frame.origin.x = self.view.frame.maxX
		}
		animator.startAnimation()
	}
	
	private func setButtons() {
		for (index, buttonView) in loginButtons.enumerated() {
			let button = LoginButton(index: index)
			buttonView.image = button.image
			buttonView.tag = index
			buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapButton)))
		}
	}
	
	@objc private func tapButton(_ gesture: UITapGestureRecognizer) {
		guard let buttonView = gesture.view else { return }
		let button = LoginButton(index: buttonView.tag)
		print("login by \(button)")
		handleLogin()
	}
	
	
	fileprivate func configColorMode(){
		if traitCollection.userInterfaceStyle == .dark {
			DesignConstant.shared.interface = .dark
			view.backgroundColor = DesignConstant.getUIColor(.secondary(staturation: 900))
		}else if traitCollection.userInterfaceStyle == .light {
			DesignConstant.shared.interface = .light
			view.backgroundColor = .white
		}
	}
	
	enum LoginButton: String {
		case kakao
		case naver
		case google
		case apple
		
		init(index: Int) {
			let allButtons: [LoginButton] = [.kakao, .naver, .google, .apple]
			self = allButtons[index]
		}
		
		var image: UIImage {
			UIImage(named: "loginbutton_\(self.rawValue)")!
		}
	}
}
