//
//  BbangstaCollectionViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/05/29.
//

import UIKit

protocol commentDelegate: AnyObject {
    func didSelectedCommentButton(data: String)
}

class BbangstaCollectionViewCell: UICollectionViewCell {
    
    lazy var dataManager = BbangstaDataManager()
    
    var images: [UIImage] = [#imageLiteral(resourceName: "message"), #imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "tagXmark")]
    var imageViews = [UIImageView]()
    
    var id = ""
    var storeId = "60b8c723fa467c1b60f71adc"
    var count = 0
    
    var delegate: commentDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var breadNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var likeNumberLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var commentButton: UIButton!
    
    @IBOutlet var bbangstaScrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var numberView: UIView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var allNumberLabel: UILabel!
    
    @IBOutlet var menuAlertView: UIView!
    
    func setupViews() {
        bbangstaScrollView.delegate = self
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        scrollViewHeight.constant = self.contentView.frame.size.width
        numberView.layer.cornerRadius = 15
        
        menuAlertView.layer.cornerRadius = 4
        menuAlertView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        menuAlertView.layer.shadowOpacity = 1
        menuAlertView.layer.shadowOffset = CGSize(width: 0, height: 2)
        menuAlertView.layer.masksToBounds = true
        menuAlertView.isHidden = true
        
        addContentScrollView()
        setPageControl()
        
    }
    
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        likeButton.isSelected.toggle()
        
        if likeButton.isSelected {
            dataManager.bbangstaLike(true, storeId: storeId, delegate: self)
            print(storeId)
        } else {
            dataManager.bbangstaLike(false, storeId: storeId, delegate: self)
            print(storeId)
        }
    }
    
    @IBAction func bbangstaCommentButtonAction(_ sender: UIButton) {
        delegate?.didSelectedCommentButton(data: id)
    }
    @IBAction func bbangstaMenuButtonAction(_ sender: UIButton) {
        menuButton.isSelected.toggle()
        
        if menuButton.isSelected {
            menuAlertView.isHidden = false
        } else {
            menuAlertView.isHidden = true
        }
        
    }
    
}

//MARK: - 이미지 페이징
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

//MARK: - API
extension BbangstaCollectionViewCell {
    func bbangstaImageList(result: BbangstaListResponse) {
    }
    func bbangstaLike(_ reuslt: BbangstaListResponse) {
        print(reuslt.result)
    }
    func bbangstaCommentNumber(result: BbangstaCommentNumberResponse) {
        count = result.count!
    }
   
    func failedToRequest(message: String) {
        print(message)
    }
}
