//
//  PostCollectionViewCell.swift
//  Seeker
//
//  Created by Eugene on 29/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
 
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    

    @IBAction func reblogTap(sender: UIButton) {
        signal_reblogPost(gl_user_blog_name + ".tumblr.com", post.reblog_key, post.post_id, "rebloged" ).subscribeNext({ (o) -> Void in
            //println(o)
            }, error: { (e) -> Void in
                println("reblogTap FAILED: " + e.description)
            }) { () -> Void in
                println("reblog completed")
                self.post.liked = true
                self.refresh()
        }
    }
    
    @IBAction func likeTap(sender: UIButton) {
        if post.liked == false{
            signal_likePost(post.post_id, post.reblog_key).subscribeNext({ (o) -> Void in
                //println(o)
                }, error: { (e) -> Void in
                    println("likeTap FAILED: " + e.description)
                }) { () -> Void in
                    println("like completed")
                    self.post.liked = true
                    self.refresh()
            }
            
        } else {
            signal_unlikePost(post.post_id, post.reblog_key).subscribeNext({ (o) -> Void in
                //println(o)
                }, error: { (e) -> Void in
                    println("unlikePost FAILED: " + e.description)
                }) { () -> Void in
                    println("unlike completed")
                    self.post.liked = false
                    self.refresh()
            }
        }
      
        
    }
    
    func refresh()->(){
        likeButton.imageView.image = post.liked == true ? UIImage(named: "liked") : UIImage(named:"like")
    }
    
    let storyboard:UIStoryboard!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var blogName: UIButton!
    @IBOutlet var gotoBlogButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var postPhoto: UIImageView!
    var post:TumblrPost!

}
