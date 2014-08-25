//
//  SeekerViewController.swift
//  Seeker
//
//  Created by Eugene on 22/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit

class SeekerViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var buttonSeek: UIButton!
    @IBOutlet var textField_seek: UITextField!
    
    let wManager = EWeatherManager()
    var cityList: [EYCityWeather] = []
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        textField_seek.rac_textSignal().subscribeNext { (o:AnyObject!) -> Void in
            let s = o as String
            println(s)
        }
        cityList = ["Moscow", "Vladivostok", "Khabarovsk", "Yakutsk", "Magadan", "Chelyabinsk", "Ivanovo"].map{ (o:String) -> EYCityWeather in
                return EYCityWeather(byName: o)
        }


    }
    
    func refresh(sender:AnyObject){
        for cityInfo in cityList{
            cityInfo.needRefresh = true
        }
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadInfo(ofCity city:String) ->(RACSignal){
        return wManager.seekWeather(forCityList: [city])
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    var counter = 0
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("weatherCell", forIndexPath: indexPath) as seekerCell
        var cityInfo = cityList[indexPath.item]
        if cityInfo.needRefresh{
            
            println("\(++counter)")
            loadInfo(ofCity: cityList[indexPath.item].cityName)
            .subscribeNext { (o:AnyObject!) -> Void in
                cityInfo.needRefresh = false
                var d = o as NSDictionary!
                
                if d != nil{
                    
                    cell.labelCityName.text = d["name"] as String
                    
                    let lat = d.valueForKey("coord").valueForKey("lat") as Double
                    let lon = d.valueForKey("coord").valueForKey("lon") as Double
                    let temp = d.valueForKey("main").valueForKey("temp") as Double
                    cityInfo.cityName = cell.labelCityName.text
                    cityInfo.temp = temp
                    cityInfo.coord = (lat, lon)
                    cell.labelTemperature.text = "\(temp)"
                    cell.labelLatLon.text = "\(lat)  \(lon)"
                }
                    //cell.labelLatLon.text   = (d["coord"]["lat"] as String) + " " + (d["coord"]["lon"] as String)
                
                
            }
        } else {
            cell.labelCityName.text = cityInfo.cityName
            cell.labelLatLon.text   = "\(cityInfo.coord.0) \(cityInfo.coord.1)"
            cell.labelTemperature.text = "\(cityInfo.temp)"
        }
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}
