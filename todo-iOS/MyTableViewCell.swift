//
//  MyTableViewCell.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/05.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoDeadlineLabel: UILabel!
    @IBOutlet weak var todoContentLabel: UILabel!
    @IBOutlet weak var todoIsClearButton: UIButton!
    @IBOutlet weak var todoIsClearLabel: UILabel!
    // checkmark.square
    // xmark.square
    // square
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
