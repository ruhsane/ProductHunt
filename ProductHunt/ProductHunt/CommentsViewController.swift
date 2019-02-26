//
//  CommentsViewController.swift
//  ProductHunt
//
//  Created by Ruhsane Sawut on 2/26/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit
import Foundation

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!
    
    var comments: [String]! {
        didSet {
//            commentsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        cell.commentTextView.text = comment
        
        return cell
    }
}
