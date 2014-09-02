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
    
    init(postUrl post_url:String?, post_date:String?, photo:Photo?, type:String!, blog_name:String!, body:String?) {
        
        self.post_url   = (post_url != nil) ? post_url!: "empty_url"
        self.date       = (date != nil) ? NSDate(dateString: post_date!) : NSDate()
        self.photo      = photo
        self.type       = enum_PostType.fromRaw(type) != nil ? enum_PostType.fromRaw(type)! : enum_PostType.Unhandled
        self.blog_name  = blog_name
        self.body       = body
        if self.body    != nil{
            println(self.body!)
        }
    }
    
    var post_url:String!
    var date:NSDate!
    var photo:Photo?
    var body:String?
    var type:enum_PostType!
    var blog_name:String!
    
}
