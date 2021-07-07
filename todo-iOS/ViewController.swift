//
//  ViewController.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/04.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwipeCellKit

class Todo {
    let id: Int
    let content: String
    let deadline: String
    var isClear: Bool = false
    
    init(id: Int, content: String, deadline: String, isClear: Bool) {
        self.id = id
        self.content = content
        self.deadline = deadline
        self.isClear = isClear
    }
    
}

class ViewController: UIViewController{
    var todos: [JSON] = []
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        AF.request("http://3.37.62.54:3000/todo", method: .post, parameters: parameters).responseJSON { (response) in
        //            print(response)
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTodos()

    }
    
    fileprivate func getTodos() {
        AF.request("http://3.37.62.54:3000/todo").responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                self.todos = json["data"].arrayValue
                
                // table view 새로고침
                self.configTableView()
                
            }
        }
    }


    
    fileprivate func configTableView() {
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: "myTableViewCell")
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 120
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.reloadData()
        
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("datasource")
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
        cell.delegate = self
        
        if self.todos.count > 0 {
            let todo = todos[indexPath.row]
            cell.todoData = Todo(id: todo["id"].intValue,
                                 content: todo["content"].stringValue,
                                 deadline: (todo["deadline"].stringValue).components(separatedBy: "T")[0],
                                 isClear: todo["isClear"].boolValue)
        }
        return cell
    }
}

// MARK: - SwipeTableViewCellDelegate
extension ViewController: SwipeTableViewCellDelegate {
    
    // 셀 스와이프 액션
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let todo = todos[indexPath.row]
        let dataItem = Todo(id: todo["id"].intValue,
                            content: todo["content"].stringValue,
                            deadline: (todo["deadline"].stringValue).components(separatedBy: "T")[0],
                            isClear: todo["isClear"].boolValue)
        
        // let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
        
        switch orientation {
        case .left:
            let isClearAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("isclear 액션")

                AF.request("http://3.37.62.54:3000/todoIsClear/\(dataItem.id)", method: .put).responseJSON { (response) in
                    print(response)
                    self.getTodos()
                }

//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                    // 스와이프 액션 셀만 리로드
//                    tableView.reloadRows(at: [indexPath], with: .none)
//                }
                // put todo
            }
            
            isClearAction.title = dataItem.isClear ? "완료 해제" : "완료 처리"
            isClearAction.image = dataItem.isClear ? UIImage(systemName: "xmark") : UIImage(systemName: "checkmark")
            isClearAction.backgroundColor = dataItem.isClear ? .systemRed : .systemGreen
            return [isClearAction]
        case .right:

//            let closure: (UIAlertAction) -> Void = { (action: UIAlertAction) in
//                cell.hideSwipe(animated: true)
//                if let selectedTitle = action.title {
//                    print("selectedTItle: \(selectedTitle)")
//                    let alertController = UIAlertController(title: selectedTitle, message: "클릭됨", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "a닫기", style: .cancel, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
            let editAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("editAction")
                
//                let bottomAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//                bottomAlertController.addAction(UIAlertAction(title: "댓글", style: .default, handler: closure))
//                bottomAlertController.addAction(UIAlertAction(title: "닫기", style: .default, handler: closure))
//                self.present(bottomAlertController, animated: true, completion: nil)
            }
            editAction.title = "수정하기"
            editAction.image = UIImage(systemName: "pencil.and.ellipsis.rectangle")  // ellipsis.circle
            editAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            
            let deleteAction = SwipeAction(style: .destructive, title: nil) { (action, indexPath) in
                print("delete action")
                // delete method

                self.todos.remove(at: indexPath.row)
                AF.request("http://3.37.62.54:3000/todo/\(dataItem.id)", method: .delete).responseJSON { (response) in
                    print(response)
                }

            }
            deleteAction.title = "지우기"
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return [deleteAction, editAction]
        }
        
    }
    
    // 셀 액션 옵션
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = .drag
        return options
    }
}


