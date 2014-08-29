//
//  TumblrPost.swift
//  Seeker
//
//  Created by Eugene on 29/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import Foundation


extension NSDate
    {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d)
    }
}

struct Photo{
    var width:Int?
    var height:Int?
    var url:String?
}

class TumblrPost{
    init(){
        
    }
    
    init(postUrl post_url:String?, post_date:String?, photo:Photo?, type:String!, blog_name:String!) {
        
        self.post_url   = (post_url != nil) ? post_url!: "empty_url"
        self.date       = (date != nil) ? NSDate(dateString: post_date!) : NSDate()
        self.photo      = photo
        self.type       = type
        self.blog_name  = blog_name
    }
    
    var post_url:String!
    var date:NSDate!
    var photo:Photo?
    var type:String!
    var blog_name:String!
    
}