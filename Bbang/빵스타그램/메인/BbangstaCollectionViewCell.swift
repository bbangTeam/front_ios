//
//  BbangstaCollectionViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/05/29.
//

import UIKit

class BbangstaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bbangstaTagCollectionView: UICollectionView!
    @IBOutlet var bbangstaTagCollectionViewHeight: NSLayoutConstraint!
    
    
    
    
    @IBAction func bbangstaCommentButton(_ sender: UIButton) {
       
    }
    
    func setupViews() {
        bbangstaTagCollectionView.delegate = self
        bbangstaTagCollectionView.dataSource = self
        
        let bbangstaTagflowLayout = UICollectionViewFlowLayout()
        bbangstaTagflowLayout.scrollDirection = .horizontal
        self.bbangstaTagCollectionView.collectionViewLayout = bbangstaTagflowLayout
        
        //bbangstaTagCollectionViewHeight.constant = 10 * 5
    }
}


//MARK: - CollectionView

extension BbangstaCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BbangstaTagCollectionViewCell", for: indexPath) as! BbangstaTagCollectionViewCell
            
        cell.layer.cornerRadius = 10
        
        return cell
    }
}

//MARK: - CollectionViewFlowLayout

extension BbangstaCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           let size = CGSize(width: 76, height: 20)
        
           return size
       }
    
   
    
}
