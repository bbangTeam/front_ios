//
//  BbangstagramViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/05/26.
//

import UIKit

class BbangstagramViewController: UIViewController {
    
    lazy var dataManager = BbangstaDataManager()
    var bbangstaLists: [BreadstagramList] = []
    
    var fetchingMore = false
    var stop = false
    var page = 0
 
    @IBOutlet var bbangstaCollectionView: UICollectionView!
    @IBOutlet var bbangstaCollectionViewWidth: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangstaCollectionView.delegate = self
        bbangstaCollectionView.dataSource = self
        
        bbangstaCollectionViewWidth.constant = view.frame.size.width
        
        dataManager.bbangstaList(page: self.page, delegate: self)
    
    }
    @IBAction func goReviewButtonAction(_ sender: UIBarButtonItem) {
        
        let starReviewVC = self.storyboard?.instantiateViewController(identifier: "BbangstaStarReviewViewController")
        self.present(starReviewVC!, animated: false, completion: nil)
        
    }
    
    
}

//MARK: - CollectionView

extension BbangstagramViewController: UICollectionViewDelegate, UICollectionViewDataSource, commentDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bbangstaLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BbangstaCollectionViewCell", for: indexPath) as! BbangstaCollectionViewCell
        
        cell.setupViews()
        
        let bbangstaList = bbangstaLists[indexPath.row]
        
        cell.userIdLabel.text = bbangstaList.nickname
        cell.storeLabel.text = bbangstaList.breadStoreName
        //cell.breadNameLabel.text = bbangstaList.breadName
        cell.locationLabel.text = "#\(bbangstaList.cityName!)"
        cell.contentLabel.text = bbangstaList.content
        cell.likeNumberLabel.text = "***님 외 \(bbangstaList.likeCount!)명이 좋아합니다."
        cell.commentButton.setTitle("댓글 \(bbangstaList.commentCount!)개 모두 보기", for: .normal)
        
        if bbangstaList.commentCount == 0 {
            cell.commentStackView.isHidden = true
            cell.stackViewBottom.constant = 85
        }
        
        // 별점 갯수
        if bbangstaList.star == 0.0 {
            for i in 0...4 {
                cell.starLists[i].isHidden = true
            }
        } else if bbangstaList.star == 1.0 {
            for i in 1...4 {
                cell.starLists[i].isHidden = true
            }
        } else if bbangstaList.star == 2.0 {
            for i in 2...4 {
                cell.starLists[i].isHidden = true
            }
        } else if bbangstaList.star == 3.0 {
            for i in 3...4 {
                cell.starLists[i].isHidden = true
            }
        } else if bbangstaList.star == 4.0 {
                for i in 2...4 {
                    cell.starLists[i].isHidden = true
                }
        }
        
        // 좋아요
        if bbangstaList.like == true {
            cell.likeButton.isSelected = true
            print(bbangstaList.like)
        } else {
            cell.likeButton.isSelected = false
            cell.likeButton.isSelected = false
            print(bbangstaList.like)
        }
        
        cell.storeId = bbangstaList.storeId!
        cell.id = bbangstaList.id!
        
        cell.delegate = self
        
        return cell
    }
    
    func didSelectedCommentButton(data: String) {
        let commentVC = self.storyboard?.instantiateViewController(identifier: "BbangstaCommentViewController") as! BbangstaCommentViewController
        
        commentVC.id = data
        
        self.present(commentVC, animated: true, completion: nil)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY >= contentHeight - scrollView.frame.size.height {
            print("늘렸다")
            if !fetchingMore
            {
                beingBatchFetch()
            }
        }
    }

    func beingBatchFetch() {
        if stop == false {
            fetchingMore = true
            self.page += 1
            print("page: \(page)")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.dataManager.bbangstaList(page: self.page, delegate: self)
            })
        } else {
            print("마지막 페이지 입니다. / page: \(page)")
        }
    }

    
    
}
//MARK: - CollectionView FlowLayout

extension BbangstagramViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: - API
extension BbangstagramViewController {
    func bbangstaList(result: BbangstaListResponse) {
        bbangstaLists = result.breadstagramList!
        bbangstaCollectionView.reloadData()
    }
    
    func addBbangstaList(result: BbangstaListResponse) {
        bbangstaLists.append(contentsOf: result.breadstagramList!)
        self.fetchingMore = false
        self.bbangstaCollectionView.reloadData()
    }
   
    func failedToRequest(message: String) {
        print(message)
    }
}
