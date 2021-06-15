//
//  BbangtourViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/05/26.
//

import UIKit

class BbangtourViewController: UIViewController {
    
    
    @IBOutlet var bbangtourTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bbangtourTableView.delegate = self
        bbangtourTableView.dataSource = self
        
    }
    

}

//MARK: - TableView

extension BbangtourViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BbangtourTableViewCell", for: indexPath) as! BbangtourTableViewCell
        
        cell.bbangtourImageView.layer.cornerRadius = 8
        
        cell.bbangtourBreadTimeLabel.layer.masksToBounds = true
        cell.bbangtourBreadTimeLabel.layer.cornerRadius = 2
        cell.bbangtourStoreTimeLabel.layer.masksToBounds = true
        cell.bbangtourStoreTimeLabel.layer.cornerRadius = 2
        
        
        return cell
        
    }
    
}
