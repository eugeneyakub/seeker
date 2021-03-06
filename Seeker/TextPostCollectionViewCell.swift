//
//  TextPostCollectionViewCell.swift
//  Seeker
//
//  Created by Eugene on 02/09/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit

class TextPostCollectionViewCell: UICollectionViewCell {
    @IBAction func reblogTap(sender: UIButton) {
    }
    @IBAction func likeTap(sender: UIButton) {
        signal_likePost(post_id, reblog_key)
    }

    @IBOutlet var likeButton: UIButton!
    @IBOutlet var avatar: UIImageView!

    @IBOutlet var blogName: UIButton!
    @IBOutlet var bodyPost: UITextView!
    var post_id:String!
    var reblog_key:String!
    var liked:Bool!
}
