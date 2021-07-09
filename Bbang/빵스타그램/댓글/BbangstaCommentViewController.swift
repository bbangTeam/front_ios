//
//  BbangstaCommentViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/20.
//

import UIKit

class BbangstaCommentViewController: UIViewController {
    
    var textArray = [
                        "댓글내용입니다. 이하 더미텍스트입니다. 댓글내용입니다. 이하 더미텍스트입니다.  제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다.❤❤❤",
                        "댓글내용입니다. 이하 더미텍스트입니다. 댓글내용입니다. 이하 더미텍스트입니다.  제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다.❤❤❤댓글내용입니다. 이하 더미텍스트입니다. 댓글내용입니다. 이하 더미텍스트입니다.  제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다.❤❤❤",
                        "아아아아아"
                                    ]

    @IBOutlet var bbangstaCommentTableView: UITableView!
    //@IBOutlet var bbangstaCommentTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangstaCommentTableView.delegate = self
        bbangstaCommentTableView.dataSource = self
        
        commentTextField.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        //bbangstaCommentTableViewHeight.constant = 1000
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.bbangstaCommentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.bbangstaCommentTableView.removeObserver(self, forKeyPath: "contentSize")
//    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize" {
//            if let newvalue = change?[.newKey]{
//                let newsize = newvalue as! CGSize
//                self.bbangstaCommentTableViewHeight.constant = newsize.height
//            }
//        }
//    }
    
    @IBAction func backBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: .none)
    }
    
}
//MARK: - TableView

extension BbangstaCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangstaCommentTableViewCell", for: indexPath) as! BbangstaCommentTableViewCell
        
        cell.commentLabel.text = textArray[indexPath.row]
        
        cell.userProfileImageView.layer.cornerRadius = cell.userProfileImageView.layer.frame.height/2
        
//        tableView.rowHeight = UITableView.automaticDimension
//        bbangstaCommentTableView.estimatedRowHeight = 500
        
        cell.setupViews()
       
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
