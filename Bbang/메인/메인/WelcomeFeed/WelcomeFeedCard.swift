//
//  WelcomFeedCard.swift
//  Bbang
//
//  Created by bart Shin on 27/05/2021.
//

import UIKit

class WelcomeFeedCard: SlideCardCell {
	@IBOutlet weak var cardImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionText: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		additionalWidth = 100
		additionalHeight = 200
		cardImage.layer.cornerRadius = 30
	}
}
