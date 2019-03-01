//
//  FeedViewController.swift
//  ProductHunt
//
//  Created by Ruhsane Sawut on 2/26/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [Post] = []{
        didSet {
            feedTableView.reloadData()
        }
    }
    
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        updateFeed()
    }
    
    func updateFeed() {
        networkManager.getPosts { (result) in
            switch result {
            case let .success(posts):
                self.posts = posts
            case let .failure(error):
                print(error)
            }
        }
    }
    
}


// MARK: UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    /// Determines how many cells will be shown on the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    /// Creates and configures each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.post = post
        
        return cell
    }
}


// MARK: UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    // Code to handle cell events goes here...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let commentsView = storyboard.instantiateViewController(withIdentifier: "commentsView") as? CommentsViewController else {
            return
        }
        commentsView.postID = post.id
        navigationController?.pushViewController(commentsView, animated: true)
    }
}
