//
//  BbangstaCommentViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/20.
//

import UIKit

class BbangstaCommentViewController: UIViewController {
    
    lazy var dataManager = BbangstaDataManager()
    var commentLists: [CommentList] = []
    
    var id = "6121e6c7f127835d6c6dfe08"
    var content = ""
    var page = 0
    
    @IBOutlet var bbangstaCommentTableView: UITableView!
    
    @IBOutlet var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangstaCommentTableView.delegate = self
        bbangstaCommentTableView.dataSource = self
        
        commentTextField.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        dataManager.bbangstaCommentList(id: id, page: page, delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .CommentReloadData, object: nil)
        
        print(id)
    }
    
    override func viewWillLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .CommentReloadData, object: nil)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .CommentReloadData, object: nil)
    }
    
    @objc func reloadData(_ notification: Notification) {
        dataManager.bbangstaCommentList(id: id, page: page, delegate: self)
    }
    
    
    @IBAction func backBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func commentButtonAction(_ sender: UIButton) {
        let input: BbangstaCommentWriteRequest = BbangstaCommentWriteRequest(id: id, type: "breadstagram", content: commentTextField.text!)
        dataManager.bbangstaCommentWrite(input, delegate: self)
        commentTextField.text = ""
        
        NotificationCenter.default.post(name: .CommentReloadData, object: nil)
    }

    
}

//MARK: - TableView

extension BbangstaCommentViewController: UITableViewDelegate, UITableViewDataSource, recommentDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangstaCommentTableViewCell", for: indexPath) as! BbangstaCommentTableViewCell
        
        let commentLists = commentLists[indexPath.row]
        cell.commentLabel.text = commentLists.content
        cell.userIdLabel.text = commentLists.nickname
        cell.goodLabel.text = "좋아요 \(commentLists.likeCount)개"
        cell.reCommentButton.setTitle("댓글 \(commentLists.reCommentCount)개", for: .normal)

        if commentLists.like == true {
            cell.heartButton.isSelected = true
        } else {
            cell.heartButton.isSelected = false

        }
        
        cell.setupViews()
        cell.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
       
        return cell
    }
    
    func goToRecommentView() {
        let reCommentVC = self.storyboard?.instantiateViewController(identifier: "ReCommentViewController")
        
        present(reCommentVC!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - API
extension BbangstaCommentViewController {
    func bbangstaCommentList(result: BbangstaCommentResponse) {
        commentLists = result.commentList!
        bbangstaCommentTableView.reloadData()
        print(commentLists)
    }
    
    func bbangstaCommentWrite(_ result: BbangstaCommentWriteResponse) {
       print("댓글 입력 성공")
    }
    
    func failedToRequest(message: String) {
      print(message)
    }
}
//MARK: - Notification
extension Notification.Name {
    static let CommentReloadData = Notification.Name("CommentReloadData")
}
