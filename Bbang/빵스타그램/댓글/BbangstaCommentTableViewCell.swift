//
//  BbangstaCommentTableViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/06/20.
//

import UIKit

protocol recommentDelegate {
    func goToRecommentView()
}

class BbangstaCommentTableViewCell: UITableViewCell {
    
    var delegate: recommentDelegate!
    
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
    
    func setupViews() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.layer.frame.height/2
    }
    @IBAction func heartButtonAction(_ sender: UIButton) {
        heartButton.isSelected.toggle()
        
        if heartButton.isSelected {
            print("좋아요")
        } else {
            print("좋아요 취소")
        }
    }
    
    @IBAction func recommentButton(_ sender: UIButton) {
        delegate.goToRecommentView()
    }
    

}

//MARK: - API
func failedToRequest(message: String) {
    
}
