//
//  testViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/25.
//

import UIKit

class BbangtourViewController: UIViewController {
    
    let count = 10

    @IBOutlet var test: UIButton!
    @IBOutlet var bbangtourMapImageView: UIImageView!
    @IBOutlet var bbangtourTableView: UITableView!
    @IBOutlet var bbangtourTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangtourTableView.dataSource = self
        bbangtourTableView.delegate = self
        
        //bbangtourTableViewHeight.constant = CGFloat(Double(count) * 190)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bbangtourTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.bbangtourTableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newvalue = change?[.newKey]{
                let newsize = newvalue as! CGSize
                self.bbangtourTableViewHeight.constant = newsize.height
            }
        }
    }
    
    @IBAction func testButtonAciton(_ sender: UIButton) {
        
        bbangtourTableView.reloadData()

    }
    
}

//MARK: - TableView

extension BbangtourViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BbangtourTableViewCell", for: indexPath) as? BbangtourTableViewCell {
            
            cell.bbangtourImageView.layer.cornerRadius = 8
            
            cell.bbangtourBreadTimeLabel.layer.masksToBounds = true
            cell.bbangtourBreadTimeLabel.layer.cornerRadius = 2
            cell.bbangtourStoreTimeLabel.layer.masksToBounds = true
            cell.bbangtourStoreTimeLabel.layer.cornerRadius = 2
            
            return cell
    
        }
        return UITableViewCell()
    }
    
}
