//
//  WelcomeFeedCard.swift
//  Bbang
//
//  Created by bart Shin on 07/06/2021.
//

import UIKit

class WelcomeFeedCard: UIView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var backgroundView: UIImageView!
	
	override func awakeFromNib() {
		titleLabel.textColor = .black
		subtitleLabel.textColor = .black
		titleLabel.font = DesignConstant.getUIFont(
			.init(family: .NotoSansCJKkr, style: .headline(scale: 2)))
		subtitleLabel.font = DesignConstant.getUIFont(
			.init(family: .NotoSansCJKkr, style: .headline(scale: 5)))
		subtitleLabel.snp.makeConstraints {
			$0.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.5)
		}
		subtitleLabel.numberOfLines = 2
	}
}
