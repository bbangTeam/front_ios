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

    
    
    @IBOutlet var recommentTableView: UITableView!
    @IBOutlet var recommentTableViewHeight: NSLayoutConstraint!
    
    func setupViews() {
        
        recommentTableView.delegate = self
        recommentTableView.dataSource = self
        
        recommentTableView.isHidden = true
        recommentTableViewHeight.constant = 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func commentButtonAction(_ sender: UIButton) {
        
        recommentTableView.isHidden = false
        recommentTableViewHeight.constant = 100

    }

}

extension BbangstaCommentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangstaReCommentTableViewCell", for: indexPath) as! BbangstaReCommentTableViewCell
        
        
        return cell
    }
    
}
