//
//  BbangstaWriteViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/05/30.
//

import UIKit

class BbangstaWriteViewController: UIViewController {

    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var storeTextField: UITextField!
    @IBOutlet var breadNameTextField: UITextField!
    
    @IBOutlet var breadReviewTextView: UITextView!
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var writeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        breadReviewTextView.layer.borderWidth = 1
        breadReviewTextView.layer.cornerRadius = 4
        breadReviewTextView.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.cornerRadius = 4
        cameraButton.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        cameraView.layer.cornerRadius = 10
        writeButton.layer.cornerRadius = 8
        
        let photoCollectionViewFlowLayout = UICollectionViewFlowLayout()
        photoCollectionView.collectionViewLayout = photoCollectionViewFlowLayout
        photoCollectionViewFlowLayout.scrollDirection = .horizontal
        
    }
    
    @IBAction func writeButtonAction(_ sender: UIButton) {
    }
    

}

//MARK: - CollectionView
extension BbangstaWriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritePhotoCollectionViewCell", for: indexPath)
        
        
        return cell
    }
    
    
}

//MARK: CollectionView FlowLayout
extension BbangstaWriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
