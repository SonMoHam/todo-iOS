//
//  MyTableViewCell.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/05.
//

import Foundation
import UIKit
import SwipeCellKit

class MyTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var todoDeadlineLabel: UILabel!
    @IBOutlet weak var todoContentLabel: UILabel!
    @IBOutlet weak var todoIsClearButton: UIButton!
    @IBOutlet weak var todoIsClearLabel: UILabel!
    
    var todoData: Todo? {
        didSet{
            if let data = todoData {
                print("\(data.id) \(data.isClear)")
                todoContentLabel.text = data.content
                todoDeadlineLabel.text = data.deadline
                if data.isClear {
                    configIsClearUI(buttonColor: .systemGreen, buttonImageName: "checkmark.square", labelText: "완료")
                } else {
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd"
                    let deadline = format.date(from: data.deadline)!
                    let today = format.date(from: format.string(from: Date()))!
                    switch deadline.compare(today) {
                    // deadline < Date()
                    case .orderedAscending:
                        configIsClearUI(buttonColor: .systemRed, buttonImageName: "xmark.square", labelText: "기한 초과")
                        
                    // deadline > Date()
                    case .orderedDescending:
                        configIsClearUI(buttonColor: .systemGray, buttonImageName: "square", labelText: "미완")
                        
                    // deadline == Date()
                    case .orderedSame:
                        configIsClearUI(buttonColor: .systemYellow, buttonImageName: "square", labelText: "오늘까지")
                    }
                }
            }
        }
    }
    
    fileprivate func configIsClearUI(buttonColor: UIColor, buttonImageName: String, labelText: String ) {
        self.todoIsClearButton.tintColor = buttonColor
        self.todoIsClearButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
        self.todoIsClearLabel.text = labelText
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
