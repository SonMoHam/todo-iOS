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
        
        let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
        
        switch orientation {
        case .left:
            let isClearAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("isclear 액션")
                // 데이터 변경 처리
//                let parameters = [
//                    "content": content,
//                    "deadline": deadline
//                ]
                
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
            
            isClearAction.title = "완료"
            isClearAction.image = UIImage(systemName: "checkmark")
            isClearAction.backgroundColor = .systemGreen
            return [isClearAction]
        case .right:
            let isClearAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("isclear 액션")
            }
            return [isClearAction]
        }
        
    }
    
    // 셀 액션 옵션
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        return options
    }
}


