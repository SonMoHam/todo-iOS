//
//  ViewController.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/04.
//

import UIKit
import SwiftyJSON
import SwipeCellKit

class ViewController: UIViewController{
    var todos: [JSON] = []
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TodoAlamofireManager.shared.getTodos { [weak self] result in
            guard let self = self else { return }
            print(result)
            self.todos = result
            self.configTableView()
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

// MARK: - extensions
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
        
        
        switch orientation {
        case .left:
            let isClearAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("isclear 액션")
                
                TodoAlamofireManager.shared.putTodoIsClear(targetId: dataItem.id) {
                    TodoAlamofireManager.shared.getTodos { [weak self] result in
                        guard let self = self else { return }
                        print(result)
                        self.todos = result
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
            
            isClearAction.title = dataItem.isClear ? "완료 해제" : "완료 처리"
            isClearAction.image = dataItem.isClear ? UIImage(systemName: "xmark") : UIImage(systemName: "checkmark")
            isClearAction.backgroundColor = dataItem.isClear ? .systemRed : .systemGreen
            return [isClearAction]
            
        case .right:
            let editAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("editAction")
                
                // popupView 띄우기
                let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
                let editTodoPopUpVC = storyboard.instantiateViewController(withIdentifier: "EditTodoPopUpVC") as! EditTodoPopupViewController
                
                // 보여지는 스타일
                editTodoPopUpVC.modalPresentationStyle = .overCurrentContext
                // 사라지는 스타일
                editTodoPopUpVC.modalTransitionStyle = .crossDissolve
                
                editTodoPopUpVC.editCompletionClosure = {
                    print("editCompletion 블럭 호출")
                    TodoAlamofireManager.shared.getTodos(completion: { [weak self] result in
                        guard let self = self else { return }
                        print(result)
                        self.todos = result
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    })
                }
    
                self.present(editTodoPopUpVC, animated: true) {
                    editTodoPopUpVC.todoData = dataItem
                }
            }
            editAction.title = "수정하기"
            editAction.image = UIImage(systemName: "pencil.and.ellipsis.rectangle")  // ellipsis.circle
            editAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            
            let deleteAction = SwipeAction(style: .destructive, title: nil) { (action, indexPath) in
                print("delete action")
                // delete method
                
                self.todos.remove(at: indexPath.row)
                TodoAlamofireManager.shared.deleteTodo(targetId: dataItem.id)
                
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


