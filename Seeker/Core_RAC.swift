//
//  Core_RAC.swift
//  Seeker
//
//  Created by Eugene on 28/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import Foundation


func signal_authenticate() ->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().authenticate("com.appgranula.Seeker", callback: { (e:NSError!) -> Void in
            if e{
                s.sendError(e)
                return
            }
            s.sendCompleted()
        })
        return nil
    }
    
    return signal
}

func signal_getInfo()->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().userInfo{(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        return nil
    }
    
    return signal
}


func signal_likedPosts(page:Int)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().likes(["limit":20, "offset":(page*20)]) {(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}



func signal_makePhotoPost(sourceLink:String)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().post("ovladetel.tumblr.com", type: "photo", parameters: ["source" : sourceLink]) {(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

func signal_makeTextPost(someText:String)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().post("ovladetel.tumblr.com", type: "text", parameters: ["body" : someText]) {(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

func signal_blogInfo(blogName:String)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().blogInfo(blogName) {(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

func signal_dashboard(page:Int) -> RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().dashboard(["limit":20, "offset":(page*20)]){(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
            
        }
        return nil
    }
    return signal
}


func signal_getPostsOfBlog(blogName:String, page:Int)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().posts(blogName, type: nil, parameters: ["limit":20, "offset":(page*20)]) {(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

func signal_blogsIAmFollowing() -> RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().following(nil){(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}


func signal_followers(blogName:String)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().followers(blogName, parameters: nil) {(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

func signal_likePost(post_id:String, reblog_key:String)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().like(post_id, reblogKey: reblog_key){(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

func signal_unlikePost(post_id:String, reblog_key:String)->RACSignal{
    let signal = RACSignal.createSignal { (s) -> RACDisposable! in
        TMAPIClient.sharedInstance().unlike(post_id, reblogKey: reblog_key){(o:AnyObject!, e:NSError!) ->() in
            if e{
                s.sendError(e)
                return
            }
            s.sendNext(o)
            s.sendCompleted()
        }
        
        return nil
    }
    return signal
}

