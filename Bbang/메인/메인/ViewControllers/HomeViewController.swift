//
//  HomeViewController.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var welcomeFeed: UIView!
	@IBOutlet weak var tourQuickLook: UIView!
	@IBOutlet weak var worldCup: UIView!
	@IBOutlet weak var BbangStarQuikLook: UIView!
	
	
	enum Segue: String {
		case welcomeFeed
		case tourQuickLook
		case worldCup
		case bbangStarQuikLook
	}
}
