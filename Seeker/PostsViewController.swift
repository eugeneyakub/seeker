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
    var blogName:String?

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
        execution_getPosts(byType: type, atPage: page, ofBlog: blogName).subscribeNext({[weak self]  (o) -> Void in
            if let actualSelf = self{
                let json = JSONValue(o)
                if let liked_posts = json[actualSelf.json_pathToPosts()].array{
                   // println(liked_posts)
                    
                    actualSelf.posts = map(liked_posts) {(post) -> TumblrPost in
                        var photos_arr:[Photo] = []
                        let type            = post["type"].string!
                        let blog_name       = post["blog_name"].string!
                        let reblog_key      = post["reblog_key"].string!
                        let post_id         = post["id"].integer!
                        let liked           = post["liked"].bool!
                        if let photos = post["photos"].array{
                            for ph in photos {
                                let width           = ph["original_size"]["width"].integer
                                let height          = ph["original_size"]["height"].integer
                                let url             = ph["original_size"]["url"].string
                                
                                var photo:Photo?
                                if width != nil && height != nil && url != nil{
                                    photo = Photo(width: width!, height: height!, url: url!)
                                    photos_arr.append(photo!)
                                }
                            }
                        }
                        let body            = post["body"].string
                        
                        let tp = TumblrPost(postUrl: post["post_url"].string, post_date: post["date"].string, photos: photos_arr, type:type, blog_name: blog_name, body: body, reblog_key: reblog_key, post_id:post_id, liked:liked )
                        return tp
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
    
    func handle_loadMore(){
        let scrollViewHeight    = collectionView.frame.size.height
        let scrollContentHeight = collectionView.contentSize.height
        let scrollOffset        = collectionView.contentOffset.y
        println("\(scrollOffset) + \(scrollViewHeight) >= \(scrollContentHeight)")
        //if scrollOffset + scrollViewHeight == scrollContentHeight {
        let offsetFromBottom:CGFloat = 140.0
        if scrollOffset + scrollViewHeight + offsetFromBottom >= scrollContentHeight {
            loadMore()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        println("decelerating")
        handle_loadMore()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if !decelerate{
            println("not decelerating")
            handle_loadMore()
        }
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        let post = posts[indexPath.item]
        if post.type.toRaw() == "photo"{
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_photoPost", forIndexPath: indexPath) as PostCollectionViewCell
            if post.photos.count != 0{
                for imageView in cell.containerView.subviews{
                    imageView.removeFromSuperview()
                    
                }
                println(post.photos.count)
               // cell.postPhoto.hidden = true
//                cell.postPhoto.setImageWithURL(NSURL(string:post.photos[0].url), placeholderImage: UIImage(named: "photo_placeholder"))
//                cell.postPhoto.frame = CGRect(x: 0, y: 40, width: 320, height: post.photos[0].height!)

                if post.photos.count > 0 {
                    var offset_y:CGFloat = 0.0
                    for i in 0 ... post.photos.count - 1{
                        let h = CGFloat(post.photos[i].height!) * (320.0 / CGFloat(post.photos[i].width!))
                        var imageView = UIImageView(frame: CGRectMake(0.0, offset_y, 320.0, h))
                        imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        imageView.setImageWithURL(NSURL(string:post.photos[i].url), placeholderImage:  UIImage(named: "photo_placeholder"))
                        cell.containerView.addSubview(imageView)
                        offset_y += h

                    }
                }
            }
            cell.post = post
            cell.avatar.setImageWithURL(NSURL(string:"http://api.tumblr.com/v2/blog/\(post.blog_name).tumblr.com/avatar/64"), placeholderImage:  UIImage(named: "photo_placeholder"))
            cell.blogName.setTitle(post.blog_name, forState: UIControlState.Normal)
            cell.blogName.setTitle(post.blog_name, forState: UIControlState.Highlighted)
            cell.blogName.addTarget(self, action: "gotoBlog:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.refresh()
            return cell
        } else {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_textPost", forIndexPath: indexPath) as TextPostCollectionViewCell
            if post.body != nil{
                cell.bodyPost.text = post.body!
            }
            cell.avatar.setImageWithURL(NSURL(string:"http://api.tumblr.com/v2/blog/\(post.blog_name).tumblr.com/avatar/64"), placeholderImage:  UIImage(named: "photo_placeholder"))
            cell.blogName.setTitle(post.blog_name, forState: UIControlState.Normal)
            cell.blogName.setTitle(post.blog_name, forState: UIControlState.Highlighted)
            cell.blogName.addTarget(self, action: "gotoBlog:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.reblog_key    = post.reblog_key
            cell.post_id       = post.post_id
           
            cell.liked         = post.liked
            //cell.refresh()
            return cell
        }
        
        
 
        //println(posts.count)
       // return cell
    }
    
    func gotoBlog(sender:UIButton)->(){
        let postsViewController = storyboard.instantiateViewControllerWithIdentifier("identifier_postsViewController") as PostsViewController
        
        postsViewController.blogName = sender.titleForState(UIControlState.Normal)
        postsViewController.type     = "PostsOfBlog"
        self.navigationController.pushViewController(postsViewController, animated: true)
    }
    
//    func mergeImages(images:[Photo]) -> Photo?{
//        if images.count == 0 {
//            return nil
//        }
//        
//        exampleImage:Photo =
//        
//        return nil
    
//        - (UIImage *)mergeImagesFromArray: (NSArray *)imageArray {
//            
//            if ([imageArray count] == 0) return nil;
//            
//            UIImage *exampleImage = [imageArray firstObject];
//            CGSize imageSize = exampleImage.size;
//            CGSize finalSize = CGSizeMake(imageSize.width, imageSize.height * [imageArray count]);
//            
//            UIGraphicsBeginImageContext(finalSize);
//            
//            for (UIImage *image in imageArray) {
//                [image drawInRect: CGRectMake(0, imageSize.height * [imageArray indexOfObject: image],
//                    imageSize.width, imageSize.height)];
//            }
//            
//            UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
//            
//            UIGraphicsEndImageContext();
//            
//            return finalImage;
//        }
//    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let post = posts[indexPath.item]
        if post.type.toRaw() == "photo"{
            let cl = post.photos.reduce(0, { (sum:CGFloat, p:Photo) -> CGFloat in
                return ceil(sum + CGFloat(p.height!) * (320.0 / CGFloat(p.width!)))
            })
            return CGSize(width: 320, height: cl + 100)
        }
        
        return CGSize(width: 320, height: 200)
    }
}
