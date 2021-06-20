//
//  BbangtourReviewViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/19.
//

import UIKit

class BbangtourReviewViewController: UIViewController {
    
    
    @IBOutlet var bbangNameTextField: UITextField!
    
    @IBOutlet var bbangReviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangReviewTextView.delegate = self
        
        bbangReviewTextView.layer.borderWidth = 1
        bbangReviewTextView.layer.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
        bbangReviewTextView.layer.cornerRadius = 4
        bbangReviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 200, right: 5)
        bbangReviewTextView.text = "가게와 빵에 대한 솔직한 리뷰를 남겨주세요. 허위 리뷰를 작성 시 이용에 제한이 있을 수 있습니다."
        bbangReviewTextView.textColor = UIColor.lightGray
        
    }
    
    
    @IBAction func backBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: .none)
    }
    
}

//MARK: - TextView
extension BbangtourReviewViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "가게와 빵에 대한 솔직한 리뷰를 남겨주세요. 허위 리뷰를 작성 시 이용에 제한이 있을 수 있습니다."
            textView.textColor = UIColor.lightGray
        }
    }
}
