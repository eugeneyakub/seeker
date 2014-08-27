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
        
        signal_authenticate().doError { (e) -> Void in
            println("authenticate FAILED: " + e.description)
        }.doCompleted { () -> Void in
            println("authenticate completed")
        }.then { () -> RACSignal! in
            return self.signal_getInfo()
        }.subscribeNext({ (o) -> Void in
            println(o)
        }, error: { (e) -> Void in
            println("getInfo FAILED: " + e.description)
        }) { () -> Void in
            println("getInfo completed")
        }
        
        
    }
    
    
    @IBAction func followers(sender: UIButton) {
        //signal_makeTextPost("some text here").subscribeNext({ (o) -> Void in
        signal_makePhotoPost("http://cs620425.vk.me/v620425229/11f03/PIBkjjsEvcA.jpg").subscribeNext({ (o) -> Void in
    println(o)
    }, error: { (e) -> Void in
    println("followers: " + e.description)
    }) { () -> Void in
    println("followers completed")
    }

//        signal_blogInfo("fitness-bodybuilding.tumblr.com").then{ () ->RACSignal! in
//                return self.signal_posts("fitness-bodybuilding.tumblr.com")
//            }.subscribeNext({ (o) -> Void in
//                println(o)
//            }, error: { (e) -> Void in
//                println("followers: " + e.description)
//            }) { () -> Void in
//                println("followers completed")
//        }
    }
    
    
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
   
    
    func signal_posts(blogName:String)->RACSignal{
        let signal = RACSignal.createSignal { (s) -> RACDisposable! in
            TMAPIClient.sharedInstance().posts(blogName, type: nil, parameters: nil) {(o:AnyObject!, e:NSError!) ->() in
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
}
