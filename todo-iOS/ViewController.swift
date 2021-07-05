//
//  ViewController.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/04.
//

import UIKit
import Alamofire
import SwiftyJSON

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
        
        AF.request("http://3.37.62.54:3000/todo").responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                self.todos = json["data"].arrayValue
                
                // table view 새로고침
                self.configTableView()
                self.myTableView.reloadData()
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
        
        
    }
    

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! MyTableViewCell
        let todo = todos[indexPath.row]
        cell.todoContentLabel.text = todo["content"].stringValue
        cell.todoDeadlineLabel.text = (todo["deadline"].stringValue).components(separatedBy: "T")[0]
        cell.todoIsClearLabel.text = todo["isClear"].stringValue
        let isClear = todo["isClear"].boolValue
        return cell
    }
    
}
