//
//  SeoulTabViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/27.
//

import UIKit

class SeoulTabViewController: UIViewController {

    @IBOutlet var seoulTableView: UITableView!
    @IBOutlet var seoulView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        seoulTableView.delegate = self
        seoulTableView.dataSource = self
    
    }
    
}
//MARK: - TableView
extension SeoulTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 10
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
