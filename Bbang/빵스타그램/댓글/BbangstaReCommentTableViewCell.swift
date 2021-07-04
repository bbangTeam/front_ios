//
//  BbangstaReCommentTableViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/07/03.
//

import UIKit

class BbangstaReCommentTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var heartButton: UIButton!
    
    @IBOutlet var reCommentLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func heartButtonAction(_ sender: UIButton) {
    }
}
