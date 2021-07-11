//
//  EditTodoPopupViewController.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/07.
//

import Foundation
import UIKit
import Alamofire
class EditTodoPopupViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bgBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    var editCompletionClosure: (() -> Void)?
    
    var todoData: Todo? {
        didSet {
            if let data = todoData {
                print(data)
                contentTextField.text = data.content
                deadlineLabel.text = data.deadline
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
    }
    fileprivate func config() {
        editBtn.tintColor = .white
        editBtn.layer.cornerRadius = 5
        editBtn.layer.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        contentView.layer.cornerRadius = 30
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        deadlineLabel.layer.borderWidth = 1
        deadlineLabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        deadlineLabel.layer.cornerRadius = 5
        deadlineLabel.text = format.string(from: Date())
        pickerView.minimumDate = Date()
    }
    
    @IBAction func onBgBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditBtnClicked(_ sender: UIButton) {
        var parameters: [String: String] = [:]
        if let data = todoData{
            parameters = [
                "id" : String(data.id),
                "content": contentTextField.text ?? "",
                "deadline": deadlineLabel.text ?? "",
                "isClear": String(data.isClear)
            ]
        }
        
        TodoAlamofireManager.shared.putTodo(parameters: parameters) { [weak self]  in
            guard let self = self else { return }
            if let editCompletionClouser = self.editCompletionClosure {
                editCompletionClouser()
            }
            self.dismiss(animated: true, completion: nil)
        }
        

    }
    @IBAction func deadlineDatePickerValueChanged(_ sender: Any) {
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        dateformatter.dateFormat = "yyyy-MM-dd"
        let date = dateformatter.string(from: pickerView.date)
        deadlineLabel.text = date
    }
}
