//
//  BbangstaCommentViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/20.
//

import UIKit

class BbangstaCommentViewController: UIViewController {

    @IBOutlet var bbangstaCommentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangstaCommentTableView.delegate = self
        bbangstaCommentTableView.dataSource = self
      
    }
    
    @IBAction func backBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: .none)
    }
    
}
//MARK: - TableView

extension BbangstaCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangstaCommentTableViewCell", for: indexPath) as! BbangstaCommentTableViewCell
        
        cell.userProfileImageView.layer.cornerRadius = 15
        
        return cell
    }
    
    
}
