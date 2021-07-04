//
//  AddTodoViewController.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/04.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        let content = contentTextField.text ?? ""
        let deadline = deadlineTextField.text ?? ""
        
        if content.count == 0 {
            let alert = UIAlertController(title: "content", message: "todo 내용을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확안", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let parameters = [
            "content": content,
            "deadline": deadline
        ]
        
        AF.request("http://3.37.62.54:3000/todo", method: .post, parameters: parameters).responseJSON { (response) in
            print(response)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
