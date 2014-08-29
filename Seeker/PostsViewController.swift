//
//  PostsViewController.swift
//  Seeker
//
//  Created by Eugene on 29/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit


class PostsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var type = "LikedPosts"
    var posts:[TumblrPost] = []
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        execution_getPosts(byType: type).subscribeNext({ (o) -> Void in
            let json = JSONValue(o)
            if let liked_posts = json["liked_posts"].array{
                println(liked_posts)
                for post in liked_posts{
                    let width           = post["photos"][0]["original_size"]["width"].integer
                    let height          = post["photos"][0]["original_size"]["height"].integer
                    let url             = post["photos"][0]["original_size"]["url"].string
                    let type            = post["type"].string!
                    let blog_name       = post["blog_name"].string!
                    var photo:Photo?
                    if width != nil && height != nil && url != nil{
                        photo = Photo(width: width!, height: height!, url: url!)
                    }
                    
                    let tp = TumblrPost(postUrl: post["post_url"].string, post_date: post["date"].string, photo: photo, type:type, blog_name: blog_name )
                    self.posts.append(tp)
                    
                }
                
                self.collectionView.reloadData()
            }
            }, error: { (e) -> Void in
                println("getPosts FAILED: " + e.description)
            }) { () -> Void in
                println("getPosts completed")
                
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("postCell", forIndexPath: indexPath) as PostCollectionViewCell
        let post = posts[indexPath.item]
        cell.blogName.text = post.blog_name
        if post.photo != nil{
            cell.postPhoto.setImageWithURL(NSURL(string:post.photo!.url), placeholderImage: UIImage(named: "photo_placeholder"))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: 320, height: 200)
    }
}
