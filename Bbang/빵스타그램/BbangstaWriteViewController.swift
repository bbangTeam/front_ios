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
    
    @IBOutlet var breadTagCollectionView: UICollectionView!
    @IBOutlet var breadReviewTextView: UITextView!
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var writeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breadTagCollectionView.delegate = self
        breadTagCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        breadTagCollectionView.tag = 1
        photoCollectionView.tag = 2
        
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
        
        let breadTagCollectionViewFlowLayout = UICollectionViewFlowLayout()
        breadTagCollectionView.collectionViewLayout = breadTagCollectionViewFlowLayout
        breadTagCollectionViewFlowLayout.scrollDirection = .horizontal
        
        
    }
    
    @IBAction func writeButtonAction(_ sender: UIButton) {
        print("\(photoCollectionView.frame.size.height)dddd")
    }
    

}

//MARK: - CollectionView
extension BbangstaWriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
        case 1:
            return 5
        case 2:
            return 10
        default:
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreadTagCollectionViewCell", for: indexPath) as! BreadTagCollectionViewCell
            
            cell.layer.cornerRadius = 20
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritePhotoCollectionViewCell", for: indexPath) as! WritePhotoCollectionViewCell
            
            cell.layer.cornerRadius = 8
            cell.contentView.frame.size.width = 70
            
            return cell
        default:
            return UICollectionViewCell()
        }
    
    }
    
    
}

//MARK: CollectionView FlowLayout
extension BbangstaWriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch collectionView.tag {
        case 1:
            let height = breadTagCollectionView.frame.size.height
            return CGSize(width: 91, height: height)
        case 2:
            let height = photoCollectionView.frame.size.height
            return CGSize(width: height, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
