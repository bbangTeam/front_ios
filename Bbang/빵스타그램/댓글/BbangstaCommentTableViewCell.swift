//
//  BbangstaCommentTableViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/06/20.
//

import UIKit

class BbangstaCommentTableViewCell: UITableViewCell {
    
    var textArray = [
                        "댓글내용입니다. 이하 더미텍스트입니다. 댓글내용입니다. 이하 더미텍스트입니다.  제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다.❤❤❤",
                        "댓글내용입니다. 이하 더미텍스트입니다. 댓글내용입니다. 이하 더미텍스트입니다.  제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다.❤❤❤댓글내용입니다. 이하 더미텍스트입니다. 댓글내용입니다. 이하 더미텍스트입니다.  제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다.❤❤❤",
                        "아아아아아"
                                    ]

    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var heartButton: UIButton!
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    @IBOutlet var reCommentButton: UIButton!
    
    @IBOutlet var reCommentTableView: UITableView!
    @IBOutlet var reCommentTableViewHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        reCommentTableView.delegate = self
        reCommentTableView.dataSource = self
        
        self.reCommentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newvalue = change?[.newKey]{
                let newsize = newvalue as! CGSize
                self.reCommentTableViewHeight.constant = newsize.height
            }
        }
    }
    
    
    @IBAction func reCommentButtonAction(_ sender: UIButton) {
       
    }
    
    @IBAction func commentButtonAction(_ sender: UIButton) {
        print("댓글달기")
        //키보드 위로 올라오기

    }

}

extension BbangstaCommentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangstaReCommentTableViewCell", for: indexPath) as! BbangstaReCommentTableViewCell
        

        cell.reCommentLabel.text = textArray[indexPath.row]
        
        cell.userImageView.layer.cornerRadius = cell.userImageView.layer.frame.height/2
        
        tableView.rowHeight = UITableView.automaticDimension
        reCommentTableView.estimatedRowHeight = 500
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
