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

enum enum_PostType:String{
    case Text = "text"
    case Quote = "quote"
    case Link = "link"
    case Answer = "answer"
    case Video = "video"
    case Audio = "audio"
    case Photo = "photo"
    case Chat  = "chat"
    case Unhandled = "unhandled"
}

struct Photo{
    var width:Int?
    var height:Int?
    var url:String?
}

//text, quote, link, answer, video, audio, photo, chat
class TumblrPost{
    init(){
        
    }
    
    init(postUrl post_url:String?, post_date:String?, photos:[Photo], type:String!, blog_name:String!, body:String?, reblog_key:String, post_id:Int, liked:Bool) {
        
        self.post_url   = (post_url != nil) ? post_url!: "empty_url"
        self.date       = (date != nil) ? NSDate(dateString: post_date!) : NSDate()
        self.photos     = photos
        self.type       = enum_PostType.fromRaw(type) != nil ? enum_PostType.fromRaw(type)! : enum_PostType.Unhandled
        self.blog_name  = blog_name
        self.body       = body
        self.reblog_key = reblog_key
        self.post_id    = String(post_id)
        self.liked      = liked
    }
    
    var reblog_key:String!
    var post_url:String!
    var date:NSDate!
    var photos:[Photo]!
    var body:String?
    var type:enum_PostType!
    var blog_name:String!
    var source:String?
    var post_id:String!
    var liked:Bool!
    
}
