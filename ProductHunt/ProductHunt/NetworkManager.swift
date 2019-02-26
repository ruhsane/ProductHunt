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
    
    func getPosts(completion: @escaping ([Post]) -> Void ) {
        // Construct the URL to get posts from API.
        let query = "posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20"
        let fullURL = URL(string: baseURL + query)!
        var request = URLRequest(url: fullURL)
        
        request.httpMethod = "GET"
        // Set up header with API Token.
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)",
            "Host": "api.producthunt.com"]
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            // Check for errors.
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else { return }
            
            // Check to see if there is any data that was retrieved.
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else { return }
            let posts = result.posts
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        task.resume()
        
    }
}
