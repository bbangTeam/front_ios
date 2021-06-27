//
//  TwoViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/27.
//

import UIKit

class TwoViewController: UIViewController {
    
    @IBOutlet var twoTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twoTableView.delegate = self
        twoTableView.dataSource = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - TableView
extension TwoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 5
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
