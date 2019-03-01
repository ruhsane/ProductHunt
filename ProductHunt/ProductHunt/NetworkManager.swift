//
//  NetworkManager.swift
//  ProductHunt
//
//  Created by Ruhsane Sawut on 2/26/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import Foundation

class NetworkManager {
    let urlSession = URLSession.shared
    var baseURL = "https://api.producthunt.com/v1/"
    var token = "7c8a13877fd67c02c52a3018a728d158842a8b335f33bf316553011c65532ace"
    
    func getPosts(_ completion: @escaping (Result<[Post]>) -> Void ) {
        let postsRequest = makeRequest(for: .posts)
        let task = urlSession.dataTask(with: postsRequest) { (data, response, error) in
            // check for error
            if let error = error {
                return completion(Result.failure(error))
            }
            
            //check to see if there is any data that was retrieved
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            //attempt to decode the data
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let posts = result.posts
            
            //return the result with completion handler.
            DispatchQueue.main.async {
                completion(Result.success(posts))
            }
        }
        task.resume()
    }
    
    func getComments(_ postId: Int, completion: @escaping (Result<[Comment]>) -> Void) {
        let commentRequest = makeRequest(for: .comments(postId: postId))
        let task = urlSession.dataTask(with: commentRequest) { (data, respone, error) in
            if let error = error {
                return completion(Result.failure(error))
            }
            
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            guard let result = try? JSONDecoder().decode(CommentApiResponse.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            DispatchQueue.main.async {
                completion(Result.success(result.comments))
            }
        }
        task.resume()
    }
    
    enum EndPoints {
        case posts
        case comments(postId: Int)
        
        //get the path of the posts and comments.
        func getPath() -> String {
            switch self {
            case .posts:
                return "posts/all"
            case.comments:
                return "comments"
            }
        }
        
        // get the http method in a type-safe way.
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        //get headers.
        func getHeaders(token: String) -> [String:String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Host": "api.producthunt.com"
            ]
        }
        
        //get parameters
        func getParams() -> [String:String] {
            switch self {
            case .posts:
                return [
                    "sort_by": "votes_count",
                    "order": "desc",
                    "per_page": "20",
                    "seach[featured]": "true"
                ]
                
            case let .comments(postId):
                return [
                    "sort_by": "votes",
                    "order": "asc",
                    "per_page": "20",
                    "search[post_id]": "\(postId)"
                ]
            }
        }
        
        //convert the params array into a connected string
        func paramsToString() -> String {
            let parameterArray = getParams().map{ key, value in
                return "\(key)=\(value)"
            }
            return parameterArray.joined(separator: "&")
        }
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        let stringParams = endPoint.paramsToString()
        let path = endPoint.getPath()
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
        
        return request
    }
    
    
    
}
