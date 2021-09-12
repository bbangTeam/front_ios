//
//  ReCommentViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/09/12.
//

import UIKit

class ReCommentViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentButton: UIButton!
    
    @IBOutlet var reCommentTableView: UITableView!
    
    @IBOutlet var reCommentLineView: UIView!
    @IBOutlet var reCommentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2

        reCommentTableView.delegate = self
        reCommentTableView.dataSource = self
        
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func heartButtonAction(_ sender: UIButton) {
        heartButton.isSelected.toggle()
        
        if heartButton.isSelected {
            print("좋아요")
        } else {
            print("좋아요 취소")
        }
    }
    @IBAction func commentButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
    }
    
   

}

//MARK: - TableView

extension ReCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangstaCommentTableViewCell", for: indexPath) as! BbangstaCommentTableViewCell
        
//        let commentLists = commentLists[indexPath.row]
//        cell.commentLabel.text = commentLists.content
//        cell.userIdLabel.text = commentLists.nickname
//        cell.goodLabel.text = "좋아요 \(commentLists.likeCount)개"
//        cell.reCommentButton.setTitle("댓글 \(commentLists.reCommentCount)개", for: .normal)
        
//        if commentLists.like == true {
//            cell.heartButton.isSelected = true
//        } else {
//            cell.heartButton.isSelected = false
//
//        }
        
        cell.setupViews()
        
        tableView.rowHeight = UITableView.automaticDimension
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
