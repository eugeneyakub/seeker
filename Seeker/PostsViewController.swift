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
    var page = 0
    
    @IBOutlet var collectionView: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        refresh(true)

    }
    
    func json_pathToPosts() -> String{
        return (type == "LikedPosts") ? "liked_posts": "posts"
    }
    
    func getPosts(){
        execution_getPosts(byType: type, atPage: page).subscribeNext({[weak self]  (o) -> Void in
            if let actualSelf = self{
                let json = JSONValue(o)
                if let liked_posts = json[actualSelf.json_pathToPosts()].array{
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
                        let body            = post["body"].string
                        
                        let tp = TumblrPost(postUrl: post["post_url"].string, post_date: post["date"].string, photo: photo, type:type, blog_name: blog_name, body: body )
                        actualSelf.posts.append(tp)
                        
                    }
                    
                    println(actualSelf)
                    actualSelf.collectionView.reloadData()
                    actualSelf.refreshControl.endRefreshing() //FIXME: cause bad access on back button click
                    
                }
            }
            }, error: { (e) -> Void in
                println("getPosts FAILED: " + e.description)
            }) { () -> Void in
                println("getPosts completed")
                
        }
    }
    
    
    func refresh(sender:AnyObject){
        posts = []
        page  = 0
        getPosts()
    }
    
    func loadMore(){
        ++page
        getPosts()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        self.refreshControl.removeTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//    }
    //func scrollViewDidScroll(scrollView: UIScrollView!) {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {

        let scrollViewHeight    = collectionView.frame.size.height
        let scrollContentHeight = collectionView.contentSize.height
        let scrollOffset        = collectionView.contentOffset.y
        //println("\(scrollOffset) + \(scrollViewHeight) == \(scrollContentHeight)")
        //if scrollOffset + scrollViewHeight == scrollContentHeight {
        if scrollOffset + scrollViewHeight >= scrollContentHeight {
            loadMore()
        }
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        let post = posts[indexPath.item]
        if post.type == "photo"{
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_photoPost", forIndexPath: indexPath) as PostCollectionViewCell
            if post.photo != nil{
                cell.postPhoto.setImageWithURL(NSURL(string:post.photo!.url), placeholderImage: UIImage(named: "photo_placeholder"))
            }
            cell.blogName.text = post.blog_name
            return cell
        } else {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_textPost", forIndexPath: indexPath) as TextPostCollectionViewCell
            if post.body != nil{
                cell.bodyPost.text = post.body!
            }
            cell.blogName.text = post.blog_name
            return cell
        }
        
        
 
        //println(posts.count)
       // return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: 320, height: 200)
    }
}
