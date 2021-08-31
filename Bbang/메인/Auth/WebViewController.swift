//
//  WebViewController.swift
//  Bbang
//
//  Created by bart Shin on 2021/08/02.
//

import Foundation
import WebKit
import AuthenticationServices

class WebViewController: UIViewController, WKUIDelegate {
	private(set) var webView: WKWebView!
	var allowedUrls = [String: URL]()
	var toolbar: UIView!
	var popWebView: () -> Void = {}
	var handleResponse: ([String: Any]) -> Void = {_ in}
	private var isLoggedIn = false
	
	func load(url: URL) {
		webView.load(URLRequest(url: url))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initWebView()
		initToolbar()
		
	}
	
	private func initWebView() {
		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: CGRect(origin: view.bounds.origin,
										  size: CGSize(width: view.bounds.width,
													   height: view.bounds.height * (1 - Constant.toolBarHeight))),
							configuration: webConfiguration)
		view.addSubview(webView)
		webView.uiDelegate = self
		webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
		webView.navigationDelegate = self
		webView.allowsBackForwardNavigationGestures = true
	}
	
	private func initToolbar() {
		toolbar = UIView(frame: CGRect(origin: CGPoint(x: view.bounds.origin.x,
													   y: view.bounds.height * (1 - Constant.toolBarHeight)),
									   size: CGSize(width: view.bounds.width,
													height: view.bounds.height * Constant.toolBarHeight)))
		view.addSubview(toolbar)
		initCancelButton()
		initRefreshButton()
	}
	
	private func initCancelButton() {
		let cancelButton = UIButton()
		toolbar.addSubview(cancelButton)
		cancelButton.snp.makeConstraints {
			$0.size.equalTo(Constant.toolbarButtonSize)
			$0.left.equalToSuperview().offset(Constant.toolbarItemMargin)
			$0.centerY.equalToSuperview()
		}
		cancelButton.setImage(UIImage(systemName: "xmark.circle")!, for: .normal)
		cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
	}
	
	private func initRefreshButton() {
		let refreshButton = UIButton()
		toolbar.addSubview(refreshButton)
		refreshButton.snp.makeConstraints {
			$0.size.equalTo(Constant.toolbarButtonSize)
			$0.right.equalToSuperview().offset(-Constant.toolbarItemMargin)
			$0.centerY.equalToSuperview()
		}
		refreshButton.setImage(UIImage(systemName: "arrow.clockwise")!, for: .normal)
		refreshButton.addTarget(self, action: #selector(tapRefreshButton), for: .touchUpInside)
	}
	
	@objc private func tapRefreshButton() {
		webView.reload()
	}
	
	@objc private func tapCancelButton() {
		popWebView()
	}
	
	private struct Constant {
		static let toolBarHeight: CGFloat = 0.1
		static let toolbarButtonSize = CGSize(width: 40, height: 40)
		static let toolbarItemMargin: CGFloat = 10
	}
}

extension WebViewController: WKNavigationDelegate {
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		if let url = navigationResponse.response.url ,
		   url.host == OAuthConfig.callbackBaseUrl.host,
		   url.pathComponents.dropLast() == OAuthConfig.callbackBaseUrl.pathComponents {
			isLoggedIn = true
			guard let httpUrlResponse = navigationResponse.response as? HTTPURLResponse,
				  let header = httpUrlResponse.allHeaderFields as? [String: Any] else {
				assertionFailure("Fail to get response")
				return
			}
			handleResponse(header)
		}
		decisionHandler(.allow)
	}
}
