//
//  SettingViewController.swift
//  Bbang
//
//  Created by bart Shin on 12/07/2021.
//

import SwiftUI

class SettingViewController: UIViewController {
	private var hostingVC: UIHostingController<SettingView>!

    override func viewDidLoad() {
        super.viewDidLoad()
		hostingVC = UIHostingController(rootView: SettingView())
		view.addSubview(hostingVC.view)
		hostingVC.view.snp.makeConstraints {
			if #available(iOS 11, *) {
				$0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
				$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
				$0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
				$0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
			} else {
				$0.edges.equalToSuperview()
			}
		}
    }
}
