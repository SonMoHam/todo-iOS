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
//    fileprivate let baseURL = "http://3.37.62.54:3000/"
    static let shared = TodoAlamofireManager()
    
//    func requestTest(completion:@escaping ([JSON]) -> Void ) {
//        AF.request(TodoRouter.getTodos).responseJSON { (response) in
//            if let value = response.value {
//                let json = JSON(value)
//
//                completion(json["data"].arrayValue)
//            }
//        }
//    }
    
    func getTodos(completion: @escaping ([JSON]) -> Void) {
        AF.request(TodoRouter.getTodos).responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                
                completion(json["data"].arrayValue)
            }
        }
    }
    
    func postTodo(parameters: [String: String], completion: @escaping () -> Void) {
        AF.request(TodoRouter.postTodo(parameters: parameters)).responseJSON { (response) in
            completion()
        }
//        AF.request("\(baseURL)todo", method: .post, parameters: parameters).responseJSON { (response) in
//            completion()
//        }
    }
    
    func putTodoIsClear(targetId: Int, completion: @escaping () -> Void) {
//        AF.request("\(baseURL)todoIsClear/\(targetId)", method: .put).responseJSON { (response) in
//            print(response)
//            completion()
//        }
        AF.request(TodoRouter.putTodoIsClear(targetId: targetId)).responseJSON { (response) in
            completion()
        }
    }
    
    func putTodo(parameters: [String: String], completion: @escaping () -> Void) {
        
        AF.request(TodoRouter.putTodo(parameters: parameters)).responseJSON { (response) in
            completion()
        }
//        AF.request("\(baseURL)todo", method: .put, parameters: parameters).responseJSON { (response) in
//            print(response)
//
//            completion()
//        }
            // 컴플리션 블럭 호출
            //            if let editCompletionClouser = self.editCompletionClosure {
            //                editCompletionClouser()
            //            }
            //            self.dismiss(animated: true, completion: nil)
        
    }
    
    func deleteTodo(targetId: Int) {
        AF.request(TodoRouter.deleteTodo(targetId: targetId)).responseJSON { (response) in
            print(response)
        }
//        AF.request("\(baseURL)todo/\(targetId)", method: .delete).responseJSON { (response) in
//            print(response)
//        }
    }
}
