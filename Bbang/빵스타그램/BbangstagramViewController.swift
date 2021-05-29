//
//  BbangstagramViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/05/26.
//

import UIKit

class BbangstagramViewController: UIViewController {

    
    @IBOutlet var BbangstaCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BbangstaCollectionView.delegate = self
        BbangstaCollectionView.dataSource = self
        
 //       BbangstaCollectionView.register(BbangstaCollectionViewCell.self, forCellWithReuseIdentifier: "BbangstaCollectionViewCell")

    }
    
}

extension BbangstagramViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BbangstaCollectionViewCell", for: indexPath) as! BbangstaCollectionViewCell
        
        cell.backgroundColor = .blue

        return cell
    }
    
    
}

extension BbangstagramViewController: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    // 옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            
            return 1
        }
    
    // cell 사이즈
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = collectionView.frame.width
            let size = CGSize(width: width, height: width)
            
            return size
            
        }
    
    
}
