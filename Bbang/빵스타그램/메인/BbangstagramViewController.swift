//
//  BbangstagramViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/05/26.
//

import UIKit

class BbangstagramViewController: UIViewController {

    @IBOutlet var bbangstaCollectionView: UICollectionView!
    @IBOutlet var bbangstaCollectionViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangstaCollectionView.delegate = self
        bbangstaCollectionView.dataSource = self
        
        bbangstaCollectionViewWidth.constant = view.frame.size.width
        

    }
    
}

//MARK: - CollectionView

extension BbangstagramViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BbangstaCollectionViewCell", for: indexPath) as! BbangstaCollectionViewCell
        
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.height/2
        cell.scrollViewHeight.constant = view.frame.size.width
        cell.numberView.layer.cornerRadius = 15
        
        
        return cell
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
