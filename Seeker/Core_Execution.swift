//
//  Core_Execution.swift
//  Seeker
//
//  Created by Eugene on 29/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

var gl_user_blog_name:String!

import Foundation

func execution_getUserBlogName() -> RACSignal{
    return signal_getInfo().flattenMap { (o) -> RACStream! in
        println(o)
        let json = JSONValue(o)
        
        if let blogs = json["user"]["blogs"].array{
            if blogs.count > 0{
                gl_user_blog_name = blogs[0]["name"].string!
            }
        }
        return nil
    }
}

func execution_getPosts(byType type:String, atPage page:Int) -> RACSignal{
    
    let signal =  gl_user_blog_name == nil ? execution_getUserBlogName() : RACSignal.empty()
    return signal.then { () -> RACSignal! in
        if type == "LikedPosts"{
            return signal_likedPosts(page)
        } else if type == "PostsOfBlog"{
            return signal_getPostsOfBlog("pain-for-gainz", page)
        } else if type == "dashboard"{
            return signal_dashboard(page)
        }
        return RACSignal.empty()
    }
}


