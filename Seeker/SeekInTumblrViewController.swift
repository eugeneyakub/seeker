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
        
        signal_authenticate().then { () -> RACSignal! in
            return self.signal_getInfo()
        }.subscribeNext({ (o) -> Void in
            println(o)
        }, error: { (e) -> Void in
            println(e)
        }) { () -> Void in
            println("completed")
        }
    }
    
    
    func signal_authenticate() ->RACSignal{
        let signal = RACSignal.createSignal { (s) -> RACDisposable! in
            TMAPIClient.sharedInstance().authenticate("com.appgranula.Seeker", callback: { (e:NSError!) -> Void in
                if e{
                    println(e.description)
                    s.sendError(e)
                    return
                }
                println("login completed")
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
}
