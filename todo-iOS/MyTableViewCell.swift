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
    // checkmark.square
    // xmark.square
    // square
    
    var todoData: Todo? {
        didSet{
            if let data = todoData {
                print("\(data.id) \(data.isClear)")
                todoContentLabel.text = data.content
                todoDeadlineLabel.text = data.deadline
                if data.isClear {
                    todoIsClearButton.tintColor = .systemGreen
                    todoIsClearButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    todoIsClearLabel.text = "완료"

                } else {
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd"
                    let deadline = format.date(from: data.deadline)!
                    let today = format.date(from: format.string(from: Date()))!
                    switch deadline.compare(today) {
                    // deadline < Date()
                    case .orderedAscending:
                        todoIsClearButton.tintColor = .systemRed
                        todoIsClearButton.setImage(UIImage(systemName: "xmark.square"), for: .normal)
                        todoIsClearLabel.text = "기한 초과"
                    // deadline > Date()
                    case .orderedDescending:
                        todoIsClearButton.tintColor = .systemGray
                        todoIsClearButton.setImage(UIImage(systemName: "square"), for: .normal)
                        todoIsClearLabel.text = "미완"
                    // deadline == Date()
                    case .orderedSame:
                        todoIsClearButton.tintColor = .systemYellow
                        todoIsClearButton.setImage(UIImage(systemName: "square"), for: .normal)
                        todoIsClearLabel.text = "오늘까지"
                    }


  
                }
                
            }
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
