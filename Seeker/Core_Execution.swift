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
    }
    return RACSignal.empty()
}