//
//  BbangstaCollectionViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/05/29.
//

import UIKit

class BbangstaCollectionViewCell: UICollectionViewCell {
    
    var images: [UIImage] = [#imageLiteral(resourceName: "message"), #imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "tagXmark")]
    var imageViews = [UIImageView]()
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var bbangstaScrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var numberView: UIView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var allNumberLabel: UILabel!
    
    func setupViews() {
        bbangstaScrollView.delegate = self
        addContentScrollView()
        setPageControl()
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
            imageView.frame = CGRect(x: xPosition, y: 0, width: bbangstaScrollView.bounds.width, height: bbangstaScrollView.bounds.height)
            imageView.image = images[i]
            bbangstaScrollView.addSubview(imageView)
            bbangstaScrollView.contentSize.width = bbangstaScrollView.frame.width * CGFloat(i + 1)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))

    }
    
    func setPageControl() {
        pageControl.numberOfPages = images.count
    }
    func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
        numberLabel.text = "\(currentPage + 1)"
    }
}
