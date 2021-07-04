//
//  BreadTagCollectionViewCell.swift
//  Bbang
//
//  Created by 소영 on 2021/07/04.
//

import UIKit

class BreadTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var breadNameLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        print("삭제")
    }
}
