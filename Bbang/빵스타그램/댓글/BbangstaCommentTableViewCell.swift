//
//  BbangstaCommentTableViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/06/20.
//

import UIKit

class BbangstaCommentTableViewCell: UITableViewCell {

    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var heartButton: UIButton!
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    @IBOutlet var reCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func reCommentButtonAction(_ sender: UIButton) {

    }

}

//MARK: - API

func failedToRequest(message: String) {
    
}
