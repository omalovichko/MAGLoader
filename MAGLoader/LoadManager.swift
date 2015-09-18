//
//  LoadManager.swift
//  MAGLoader
//
//  Created by MAG on 9/16/15.
//  Copyright (c) 2015 MAG. All rights reserved.
//

import Foundation

protocol LoadManagerDelegate {
    func itemDidLoad(data: NSData?)
}

class LoadManager : MAGLoaderDelegate {
    
    static let sharedInstance = LoadManager()
    
    var loader = MAGLoader()
    var items = [NSURL?]()
    var delegate: LoadManagerDelegate?
    
    init() {
        loader.delegate = self
        
        let URL1 = NSURL(string: "http://qids.org/wp-content/uploads/2014/01/Fat-Cat-Facts-pets-pet-cat-Cats.jpg")
        let URL2 = NSURL(string: "http://i.ytimg.com/vi/USAtCfAoMio/hqdefault.jpg")
        items = [URL1, URL2]
        
        loader.reloadItems()
    }
    
    func loadItems() {
        loader.resume()
    }
    
    
    // MARK: MAGLoader Deleate
    
    func magLoaderNumberOfRequests(loader: MAGLoader) -> Int {
        return items.count
    }
    
    func magLoaderRequestForIndex(loader: MAGLoader, index: Int) -> NSURLRequest {
        if let URL = items[index] {
            let request = NSURLRequest(URL: URL)
            return request
        }
        return NSURLRequest()
    }
    
    func magLoaderItemDidLoad(loader: MAGLoader, index: Int, data: NSData?) {
        delegate?.itemDidLoad(data)
    }
    
    func magLoaderItemLoadingFailed(loader: MAGLoader, index: Int, error: NSError?) {
        println("Failed to load item at index: \(index)")
    }
    
}