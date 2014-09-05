//
//  Core_Execution.swift
//  Seeker
//
//  Created by Eugene on 29/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import Foundation

func execution_getPosts(byType type:String, atPage page:Int) -> RACSignal{
    if type == "LikedPosts"{
        return signal_likedPosts(page)
    } else if type == "PostsOfBlog"{
        return signal_getPostsOfBlog("pain-for-gainz", page)
    } else if type == "dashboard"{
        return signal_dashboard(page)
    }
    return RACSignal.empty()
}
