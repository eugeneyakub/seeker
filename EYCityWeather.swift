//
//  EYCity.swift
//  Seeker
//
//  Created by Eugene on 25/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import Foundation

class EYCityWeather{
    init() {
        
    }
    init(byName name:String){
        cityName = name
    }
    var needRefresh = true
    var cityName:String!
    var coord:(lat:Double, lon:Double)!
    var temp:Double!
    var humidity:Double!
    
}
