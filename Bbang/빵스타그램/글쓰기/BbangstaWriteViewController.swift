//
//  BbangstaWriteViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/05/30.
//

import UIKit

class BbangstaWriteViewController: UIViewController {
    
    lazy var dataManager = BbangstaDataManager()
    
    var textArray = ["빵", "소보루", "식빵", "이름이아주아주긴빵ddddddd"]
    var imageArray = [1,2,3,4,5,6,7,8,9,10]
    
    var imageList: [ImageLists] = [ImageLists(id: "", num: 0, imageUrl: "")]
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var storeTextField: UITextField!
    @IBOutlet var breadNameTextField: UITextField!
    
    @IBOutlet var breadTagCollectionView: UICollectionView!
    @IBOutlet var breadReviewTextView: UITextView!
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var imageCountLabel: UILabel!
    
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var writeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breadReviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 200, right: 5)
        breadReviewTextView.text = "가게와 빵에 대한 솔직한 리뷰를 남겨주세요. 허위 리뷰를 작성 시 이용에 제한이 있을 수 있습니다."
        breadReviewTextView.textColor = .lightGray
        
        textFieldSetupLayout()
        collectionSetupLayout()
       
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func writeButtonAction(_ sender: UIButton) {
       
        let input: BbangstaWriteRequest = BbangstaWriteRequest(id: "idddd", cityName: "서울", storeName: "빵가게", breadName: "크림빵", content: "크림빵 맛있어", imageList: imageList)
        
        dataManager.bbangstaWrite(input, delegate: self)
    }
    

}
//MARK: - TextField, TextView
extension BbangstaWriteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldSetupLayout() {
        locationTextField.attributedPlaceholder = NSAttributedString(string: "내 위치 자동입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        locationTextField.delegate = self
        storeTextField.delegate = self
        breadNameTextField.delegate = self
        breadReviewTextView.delegate = self
        
        breadReviewTextView.layer.borderWidth = 1
        breadReviewTextView.layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        breadReviewTextView.layer.cornerRadius = 8
        
        borderLayout(sender: locationTextField)
        borderLayout(sender: storeTextField)
        borderLayout(sender: breadNameTextField)
        
    }
    
    func borderLayout(sender: UITextField) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        sender.layer.cornerRadius = 8
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        breadReviewTextView.text = ""
        breadReviewTextView.textColor = .black
    }
    
}

//MARK: - CollectionView
extension BbangstaWriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionSetupLayout() {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
        case 1:
            return 4
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
            cell.breadNameLabel.text = textArray[indexPath.row]
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritePhotoCollectionViewCell", for: indexPath) as! WritePhotoCollectionViewCell
            
            cell.layer.cornerRadius = 8
            cell.contentView.frame.size.width = 70
            cell.deleteButton.layer.cornerRadius = cell.deleteButton.frame.size.height/2
            
            return cell
        default:
            return UICollectionViewCell()
        }
    
    }
    
    
}

//MARK: - CollectionView FlowLayout
extension BbangstaWriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch collectionView.tag {
        case 1:
            let height = breadTagCollectionView.frame.size.height
            let label = UILabel(frame: CGRect.zero)
            label.text = textArray[indexPath.item]
            label.sizeToFit()
            
            return CGSize(width: label.frame.width + 52, height: height)
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

//MARK: - API
extension BbangstaWriteViewController {
    func bbangstaWrite(_ result: BbangstaWriteResponse) {
        print(result)
    }

    func failedToRequest(message: String) {
        print(message)
    }
}

