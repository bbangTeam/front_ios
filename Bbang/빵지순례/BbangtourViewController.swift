//
//  testViewController.swift
//  Bbang
//
//  Created by 소영 on 2021/06/25.
//

import UIKit

class BbangtourViewController: UIViewController {
    
    var pageViewController: PageViewController!
    
    @IBOutlet var bbangtourScrollView: UIScrollView!
    
    @IBOutlet var seoulButton: UIButton!
    @IBOutlet var twoButton: UIButton!
    @IBOutlet var threeButton: UIButton!
    
    @IBOutlet var seoulLineLabel: UILabel!
    @IBOutlet var twoLineLabel: UILabel!
    @IBOutlet var threeLineLabel: UILabel!
    
    @IBOutlet var bbangtourMapImageView: UIImageView!
    @IBOutlet var bbangtourView: UIView!
    @IBOutlet var bbangtourViewHeight: NSLayoutConstraint!
    

    var buttonLists: [UIButton] = []
    var lineLists: [UILabel] = []
    
    var currentIndex : Int = 0 {
        didSet {
            changeButtonColor()
            changeLineColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bbangtourScrollView.delegate = self
        
        setButtonList()
        setLineList()
   
    }

    //MARK: - Function
    
    func setButtonList() {
        buttonLists.append(seoulButton)
        buttonLists.append(twoButton)
        
        seoulButton.tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        twoButton.tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 0.2)
       
    }
    
    func setLineList() {
        
        lineLists.append(seoulLineLabel)
        lineLists.append(twoLineLabel)
        
        seoulLineLabel.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        twoLineLabel.backgroundColor = .clear
        
    }
    
    func changeButtonColor() {
        for (index, element) in buttonLists.enumerated() {
            if index == currentIndex {
                element.tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
            }
            else {
                element.tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 0.2)
            }
        }
    }
    
    func changeLineColor() {
        for (index, element) in lineLists.enumerated() {
            if index == currentIndex {
                element.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
            }
            else {
                element.backgroundColor = .clear
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "PageViewController" {
                guard let vc = segue.destination as? PageViewController else {return}
                pageViewController = vc
                
                pageViewController.completeHandler = { (result) in
                    self.currentIndex = result
                }
                
            }
        }
    
    @IBAction func seoulButtonAction(_ sender: UIButton) {
        pageViewController.setViewcontrollersFromIndex(index: 0)
        
    }
    @IBAction func twoButtonAction(_ sender: UIButton) {
        pageViewController.setViewcontrollersFromIndex(index: 1)

    }

}

//MARK: - ScrollView
extension BbangtourViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == bbangtourScrollView {
            if pageViewController.currentIndex == 0 { // 지역1
                adjustPageHeight(numberOfCell: 6)
            } else {
                adjustPageHeight(numberOfCell: 4)
            }
        }
    }
    
    func adjustPageHeight(numberOfCell: Int) {
        bbangtourViewHeight.constant = CGFloat(184 * numberOfCell)
    }
}
