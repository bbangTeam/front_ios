//
//  BbangstaStarReviewViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/09/05.
//

import UIKit

class BbangstaStarReviewViewController: UIViewController {

    @IBOutlet var okButton: UIButton!
    @IBOutlet var goReviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    func setupLayout() {
        okButton.layer.cornerRadius = 8
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.black.cgColor
        
        goReviewButton.layer.cornerRadius = 8
        
    }
    
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func goReviewButtonAction(_ sender: UIButton) {
        let reviewVC = self.storyboard?.instantiateViewController(identifier: "BbangstaWriteViewController")
        self.present(reviewVC!, animated: false, completion: nil)
    }
    

}
