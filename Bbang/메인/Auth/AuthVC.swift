//
//  AuthVC.swift
//  Bbang
//
//  Created by bart Shin on 18/07/2021.
//

import SwiftUI
import WebKit

class AuthVC: UIViewController, ObservableObject {
	
	var server: ServerDataOperator!
	var signUpNickname = String() 
	@Published private(set) var nicknameIsDuplciated = false
	@IBOutlet weak var logoView: UIImageView!
	@IBOutlet weak var loginButtonStack: UIStackView!
	private var loginButtons: [UIImageView] {
		loginButtonStack.subviews as! [UIImageView]
	}
	var handleLogin: () -> Void = { }
	private lazy var webVC = WebViewController()
	private var signUpHC: UIHostingController<SignUpView>!
	
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
		initButtons()
		initWebView()
		initSignUpView()
    }
	
	func disappear() {
		UIViewPropertyAnimator(duration: Constant.navigateDuration, dampingRatio: Constant.navigateDampingRatio) { [self] in
			view.frame.origin.x = view.frame.origin.x - view.bounds.width
		}.startAnimation()
	}
	
	private func initButtons() {
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
		let config: OAuthConfig
		switch button {
			case .google:
				config = OAuthConfig(provider: .google)
			case .naver:
				config = OAuthConfig(provider: .naver)
			case .kakao:
				config = OAuthConfig(provider: .kakao)
			case .apple:
				handleLogin()
				return
		}
		showWebView()
		webVC.load(url: config.provider.loginUrl)
	}
	
	private func initWebView() {
		webVC.loadViewIfNeeded()
		webVC.view.isHidden = true
		view.addSubview(webVC.view)
		webVC.view.bounds.size = view.bounds.size
		webVC.popWebView = popWebView
		webVC.handleResponse = handleLogin(response:)
	}
	
	private func showWebView() {
		webVC.view.isHidden = false
		webVC.view.frame.origin = CGPoint(x: view.bounds.maxX, y: view.bounds.origin.y)
		UIViewPropertyAnimator(duration: Constant.navigateDuration, dampingRatio: Constant.navigateDampingRatio) { [self] in
			webVC.view.frame.origin.x = view.frame.origin.x
		}.startAnimation()
	}
	
	private func popWebView() {
		let animator = UIViewPropertyAnimator(duration: Constant.navigateDuration, dampingRatio: Constant.navigateDampingRatio) { [self] in
			webVC.view.frame.origin.x = view.frame.maxX
		}
		animator.addCompletion { position in
			if position == .end {
				self.webVC.view.isHidden = true
			}
		}
		animator.startAnimation()
	}
	
	private func handleLogin(response: [String: Any]) {
		guard let responseCode = Int(response["code"] as? String ?? ""),
		var token = response["accessToken"] as? String else {
			assertionFailure()
			return
		}
		if responseCode == 1 {
			// TODO: JWT token
//			server.setAccessToken(token)
			pushSignUpView()
		}
	}
	
	private func initSignUpView() {
		let signUpView = SignUpView(authVC: self)
		signUpHC = UIHostingController(rootView: signUpView)
		view.addSubview(signUpHC.view)
		let origin = CGPoint(x: view.frame.maxX, y: view.frame.origin.y)
		signUpHC.view.frame = CGRect(origin: origin, size: view.bounds.size)
		signUpHC.view.isHidden = true
	}
	
	
	private func pushSignUpView() {
		signUpHC.view.isHidden = false
		let animator = UIViewPropertyAnimator(duration: Constant.navigateDuration, dampingRatio: Constant.navigateDampingRatio) { [self] in
			signUpHC.view.frame.origin = view.frame.origin
			webVC.view.frame.origin = CGPoint(x: view.frame.origin.x - view.bounds.width, y: view.frame.origin.y)
		}
		animator.addCompletion { position in
			self.webVC.view.isHidden = true
		}
		animator.startAnimation()
	}
	
	func checkNicknameIsDuplicated() -> Promise<Bool> {
		let promise = Promise<Bool>()
		server.checkNicknameDuplicated(signUpNickname)
		return promise
	}
	
	func requestSignUp() {
		
	}
	
	private func configColorMode(){
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
	
	private struct Constant {
		static let navigateDuration: TimeInterval = 0.5
		static let navigateDampingRatio: CGFloat = 1
	}
}
