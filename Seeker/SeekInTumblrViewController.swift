//
//  SeekInTumblrViewController.swift
//  Seeker
//
//  Created by Eugene on 27/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit

class SeekInTumblrViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (OAuthToken, OAuthTokenSecret) = (NSUserDefaults.standardUserDefaults().objectForKey("OAuthToken") as String!,  NSUserDefaults.standardUserDefaults().objectForKey("OAuthTokenSecret") as String!)
        if OAuthToken != nil && OAuthTokenSecret != nil{
            TMAPIClient.sharedInstance().OAuthToken = OAuthToken
            TMAPIClient.sharedInstance().OAuthTokenSecret = OAuthTokenSecret
        } else {
            
            signal_authenticate().doError { (e) -> Void in
                println("authenticate FAILED: " + e.description)
                }.doCompleted { () -> Void in
                    println("authenticate completed")
                    NSUserDefaults.standardUserDefaults().setObject(TMAPIClient.sharedInstance().OAuthToken, forKey: "OAuthToken")
                    NSUserDefaults.standardUserDefaults().setObject(TMAPIClient.sharedInstance().OAuthTokenSecret, forKey: "OAuthTokenSecret")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }.subscribeNext({ (o) -> Void in
                    println(o)
                    }, error: { (e) -> Void in
                        println("getInfo FAILED: " + e.description)
                    }) { () -> Void in
                        println("getInfo completed")
            }

        }
        
//        }.then { () -> RACSignal! in
//            return signal_getInfo()
//        }.subscribeNext({ (o) -> Void in
//            println(o)
//        }, error: { (e) -> Void in
//            println("getInfo FAILED: " + e.description)
//        }) { () -> Void in
//            println("getInfo completed")
//        }
    
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let postsController = segue.destinationViewController as PostsViewController
        if segue.identifier == "segue_LikedPosts"{
            postsController.type = "LikedPosts"
        } else if segue.identifier == "segue_PostsOfBlog"{
            postsController.type = "PostsOfBlog"
        }
    }
    
    @IBAction func tap_blogsIFollow(sender: UIButton) {
        signal_blogsIAmFollowing().flattenMap { (o) -> RACStream! in
            let json = JSONValue(o)
            if let firstBlogName = json["blogs"][0]["name2"].string{
                return signal_getPostsOfBlog(firstBlogName + ".tumblr.com", 0)
            }
            return nil
        }.subscribeNext({ (o) -> Void in
            println(o)
            }, error: { (e) -> Void in
                println("i am following error: " + e.description)
            }) { () -> Void in
                println("i am following completed")
        }

    }
    @IBAction func tap_makePost(sender: UIButton) {
        //signal_makeTextPost("some text here").subscribeNext({ (o) -> Void in
        signal_makePhotoPost("http://cs620425.vk.me/v620425229/11f03/PIBkjjsEvcA.jpg").subscribeNext({ (o) -> Void in
            println(o)
            }, error: { (e) -> Void in
                println("followers: " + e.description)
            }) { () -> Void in
                println("followers completed")
        }
    }
    
//    @IBAction func tap_getPostsOfBlog(sender: UIButton) {
//        signal_blogInfo("fitness-bodybuilding.tumblr.com").then{ () ->RACSignal! in
//            return signal_getPostsOfBlog("fitness-bodybuilding.tumblr.com")
//            }.subscribeNext({ (o) -> Void in
//                println(o)
//                }, error: { (e) -> Void in
//                    println("followers: " + e.description)
//                }) { () -> Void in
//                    println("followers completed")
//        }
//    }
    
    @IBAction func followers(sender: UIButton) {



    }
    
    
}
