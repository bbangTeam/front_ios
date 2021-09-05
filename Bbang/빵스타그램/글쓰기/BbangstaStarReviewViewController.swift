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
    
    @IBAction func sliderAction(_ sender: StarSlider) {
        let roundValue = round(sender.value)
        
        for index in 0 ... 5 {
            
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= Int(roundValue) {
                    starImage.image = UIImage(named: "star_fill")
                } else {
                    starImage.image = UIImage(named: "star")
                }
            }
        }
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
