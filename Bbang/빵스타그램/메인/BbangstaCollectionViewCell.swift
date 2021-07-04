//
//  BbangstaCollectionViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/05/29.
//

import UIKit

class BbangstaCollectionViewCell: UICollectionViewCell {
    
    var images: [UIImage] = [#imageLiteral(resourceName: "message"), #imageLiteral(resourceName: "heart")]
    var imageViews = [UIImageView]()
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var bbangstaScrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet var numberView: UIView!
    @IBOutlet var numberLabel: UILabel!
    
    func setupViews() {
        bbangstaScrollView.delegate = self
        addContentScrollView()
    }
    
 
    @IBAction func bbangstaCommentButtonAction(_ sender: UIButton) {
       
    }
    @IBAction func bbangstaMenuButtonAction(_ sender: UIButton) {
        
    }
    
}

extension BbangstaCollectionViewCell: UIScrollViewDelegate {
    
    func addContentScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let xPosition = self.contentView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.width)
            bbangstaScrollView.contentSize.width = bbangstaScrollView.frame.width * CGFloat(i + 1)
           
            bbangstaScrollView.addSubview(imageView)
        }
    }
}
