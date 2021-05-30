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
        
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: width, height: 500)

        BbangstaCollectionView.collectionViewLayout = flowLayout

    }
    
}

extension BbangstagramViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BbangstaCollectionViewCell", for: indexPath) as! BbangstaCollectionViewCell
        
        cell.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)

        return cell
    }
    
    
}

extension BbangstagramViewController: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
    
}
