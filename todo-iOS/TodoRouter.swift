//
//  TodoRouter.swift
//  todo-iOS
//
//  Created by 손대홍 on 2021/07/11.
//

import Foundation
import Alamofire

enum TodoRouter: URLRequestConvertible {
    
    case getTodos
    case postTodo(parameters: [String: String])
    case putTodoIsClear(targetId: Int)
    case putTodo(parameters: [String: String])
    case deleteTodo(targetId: Int)
    
    var baseURL: URL {
        return URL(string: "http://3.37.62.54:3000/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTodos:
            return .get
        case .postTodo:
            return .post
        case .putTodoIsClear, .putTodo:
            return .put
        case .deleteTodo:
            return .delete
        }
        
    }
    
    var endPoint: String {
        switch self {
        case .getTodos, .postTodo, .putTodo:
            return "todo"
        case let .deleteTodo(targetId):
            return "todo/\(targetId)"
        case let .putTodoIsClear(targetId):
            return "todoIsClear/\(targetId)"
        }
    }
    
    var params: [String: String]? {
        switch self {
        case let .postTodo(parameters), let .putTodo(parameters):
            return parameters
        default:
            return nil
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        print("\(self) - \(#function) url: \(url)")
        request.method = method
        
        switch self {
        case .getTodos, .putTodoIsClear, .deleteTodo:
            return request
            
        case .postTodo, .putTodo:
            request = try URLEncodedFormParameterEncoder().encode(params, into: request)
            return request
        }
    }
}
