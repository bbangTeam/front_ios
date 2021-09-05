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
