//
//  TodoAlamofireManager.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/11.
//

import Foundation
import Alamofire
import SwiftyJSON

final class TodoAlamofireManager {
    fileprivate let baseURL = "http://3.37.62.54:3000/"
    static let shared = TodoAlamofireManager()
    
    func getTodos(completion: @escaping ([JSON]) -> Void) {
        AF.request("\(baseURL)todo").responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                
                
                // table view 새로고침
                // self.configTableView()
                completion(json["data"].arrayValue)
            }
        }
    }
    
    func postTodo(parameters: [String: String], completion: @escaping () -> Void) {
        AF.request("http://3.37.62.54:3000/todo", method: .post, parameters: parameters).responseJSON { (response) in
            completion()
        }
    }
    
    func putTodoIsClear(targetId: Int, completion: @escaping () -> Void) {
        AF.request("\(baseURL)todoIsClear/\(targetId)", method: .put).responseJSON { (response) in
            print(response)
            completion()
        }
    }
    
    func putTodo(parameters: [String: String], completion: @escaping () -> Void) {
        
        AF.request("\(baseURL)todo", method: .put, parameters: parameters).responseJSON { (response) in
            print(response)
            
            completion()
            // 컴플리션 블럭 호출
            //            if let editCompletionClouser = self.editCompletionClosure {
            //                editCompletionClouser()
            //            }
            //            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteTodo(targetId: Int) {
        AF.request("\(baseURL)todo/\(targetId)", method: .delete).responseJSON { (response) in
            print(response)
        }
    }
}
