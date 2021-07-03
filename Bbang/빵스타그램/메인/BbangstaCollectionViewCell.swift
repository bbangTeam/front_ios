//
//  BbangstaCollectionViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/05/29.
//

import UIKit

class BbangstaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var bbangstaScrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet var numberView: UIView!
    @IBOutlet var numberLabel: UILabel!
    
 
    @IBAction func bbangstaCommentButtonAction(_ sender: UIButton) {
       
    }
    @IBAction func bbangstaMenuButtonAction(_ sender: UIButton) {
        
    }
    
    
    
}
