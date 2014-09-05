//
//  PostCollectionViewCell.swift
//  Seeker
//
//  Created by Eugene on 29/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
 
    
    @IBAction func likeTap(sender: UIButton) {
        if liked == false{
            signal_likePost(post_id, reblog_key).subscribeNext({ (o) -> Void in
                //println(o)
                }, error: { (e) -> Void in
                    println("getInfo FAILED: " + e.description)
                }) { () -> Void in
                    println("like completed")
                    self.liked = true
                    self.refresh()
            }
            
        } else {
            signal_unlikePost(post_id, reblog_key).subscribeNext({ (o) -> Void in
                println(o)
                }, error: { (e) -> Void in
                    //println("getInfo FAILED: " + e.description)
                }) { () -> Void in
                    println("unlike completed")
                    self.liked = false
                    self.refresh()
            }
        }
      
        
    }
    
    func refresh()->(){
        likeButton.imageView.image = liked == true ? UIImage(named: "liked") : UIImage(named:"like")
    }
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var blogName: UILabel!
    @IBOutlet var postPhoto: UIImageView!
    var post_id:String!
    var reblog_key:String!
    var liked:Bool!
}
