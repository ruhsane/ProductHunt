//
//  PostTableViewCell.swift
//  ProductHunt
//
//  Created by Ruhsane Sawut on 2/26/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            nameLabel.text = post.name
            taglineLabel.text = post.tagline
            commentCountLabel.text = "Comments: \(post.commentsCount)"
            voteCountLabel.text = "Votes: \(post.votesCount)"
            updatePreviewImage()
        }
    }
    
    func updatePreviewImage() {
        screenshotImageView.image = UIImage(named: "placeholder")
    }
        
}
