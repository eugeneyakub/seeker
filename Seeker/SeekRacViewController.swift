//
//  SeekRacViewController.swift
//  Seeker
//
//  Created by Eugene on 26/08/14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

import UIKit



class SeekRacViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var signal:RACSignal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.signal_searchBarTextChanged().subscribeNext { (o) -> Void in
            println(o)
        }
    }
    
    
    func signal_searchBarTextChanged() -> RACSignal{
        signal = searchBar.rac_signalForSelector(Selector("searchBar:textDidChange:"), fromProtocol: UISearchBarDelegate.self).map { (o) -> AnyObject! in
   
            let t = o as RACTuple
            return t.second
        }
        println(signal)
        return signal
    }

    

}
