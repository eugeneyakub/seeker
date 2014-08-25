////
//  EWeatherManager.swift
//  Seeker
//
//  Created by Eugene on 22/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit


class EWeatherManager: NSObject {
    let apiKey =  "faa4072018f337f121cb8413722f3ba1"
    
    override init() {
        super.init()
    }
    
    func seekWeather(forCityList cityList:[String]) -> RACSignal{
        let _signal = RACSignal.createSignal({ (s:RACSubscriber!) -> RACDisposable! in
            let manager = AFHTTPRequestOperationManager()
            let urlString = "http://api.openweathermap.org/data/2.5/weather"
            
            let k = Int(arc4random_uniform(UInt32(cityList.count)))
            var params = ["q":cityList[k], "APPID":self.apiKey]
   
            
            manager.GET( urlString,
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            
                    s.sendNext(responseObject)
                    s.sendCompleted()
                },
                failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
          
                    s.sendError(error)
                })
            return nil
        })
        
        return _signal
    }
    
    
    
    
    
    func rac_seek(){
        let wManager = EWeatherManager()
        let cityList = ["Harare", "Moscow", "Kiev", "Paris"]
        var _signal = wManager.seekWeather(forCityList: cityList)
        
        for i in 0...2{
            println(i)
            _signal = _signal.then({ () -> RACSignal! in
                
                return wManager.seekWeather(forCityList: cityList)
            })
            //            _signal = _signal.flattenMap({ (o) -> RACStream! in
            //                println("\(o as NSDictionary)")
            //                return wManager.seekWeather(forCityList: cityList)
            //            })
        }
        
        _signal.subscribeNext { (o) -> Void in
            let s = o as NSDictionary
            println(s)
        }
        
    }
    
    //------------------------
    
    func seekWeatherPromise(forCityList cityList:[String]) -> Future<NSDictionary> {
        let promise = Promise<NSDictionary>()
        
        Queue.global.async {
            let wManager = EWeatherManager()
            // do a complicated task
            let manager = AFHTTPRequestOperationManager()
            let urlString = "http://api.openweathermap.org/data/2.5/weather"
            
            let k = Int(arc4random_uniform(UInt32(cityList.count)))
            var params = ["q":cityList[k], "APPID":wManager.apiKey]
            
            
            manager.GET( urlString,
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                    //   println("\(responseObject.description)")
                    promise.success(responseObject as NSDictionary)
                },
                failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                    //  println("\(error.description)")
                    promise.error(error)
            })
            
            
        }
        
        return promise.future
    }
    
    func promise_seek(){
        var  k = 1
        self.seekWeatherPromise(forCityList: ["Moscow"]).andThen{ (r: TaskResult<NSDictionary>) -> () in
            switch r{
            case .Success(let val):
                println(val.value)
            case .Failure(_):
                break
            }
            k *= 10
            println("k \(k)")
            }.onSuccess{ (o:AnyObject!) -> () in
                println(o)
        }
        println("k \(k)")
    }
    
    
    
    func fibonacci(start: Int) -> Int {
        if start == 0 {
            return start
        }
        if start == 1 {
            return start
        }
        return (fibonacci(start - 1) + fibonacci(start - 2))
    }
    
    func fibonacci_promise(){
        
                future(fibonacci(40)).onSuccess { value in
                    println(value)
                }
        
//                future(fibonacci(20)).map( { number, error in
//                    if number > 5 {
//                        return "large"
//                    }
//                    return "small"
//                    }).map { sizeString, _ in
//                        return sizeString == "large"
//                    }.onSuccess { numberIsLarge in
//                        // numberIsLarge is true
//                        println(numberIsLarge)
//                }
    }
    
}
