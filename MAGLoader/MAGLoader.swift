//
//  MAGLoader.swift
//  MAGLoader
//
//  Created by MAG on 9/16/15.
//  Copyright (c) 2015 MAG. All rights reserved.
//

import Foundation
import Alamofire


protocol MAGLoaderDelegate: class {
    func magLoaderNumberOfRequests(loader: MAGLoader) -> Int
    func magLoaderRequestForIndex(loader: MAGLoader, index: Int) -> NSURLRequest
    func magLoaderItemDidLoad(loader: MAGLoader, index: Int, data: NSData?)
    func magLoaderItemLoadingFailed(loader: MAGLoader, index: Int, error: NSError?)
}


class MAGLoader {
    
    weak var delegate: MAGLoaderDelegate?
    
    private var loaderQueue: NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Loader Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    init() {
        stop()
        reloadItems()
    }
    
    func reloadItems() {
        
        if let loaderDelegate = delegate {
            for i in 0...loaderDelegate.magLoaderNumberOfRequests(self) - 1 {
                let request = loaderDelegate.magLoaderRequestForIndex(self, index: i)
                
                loaderQueue.addOperationWithBlock({ [weak self] () -> Void in
                    self?.loadRequest(request, index: i)
                })
            }
        }
    }
    
    func loadRequest(request: NSURLRequest, index: Int) {
        
        Alamofire.request(request).response { [weak self] (request, response, data, error) in
            
            println(request.URLString)
            
            if let loader = self {
                if error != nil || data == nil {
                    loader.delegate?.magLoaderItemLoadingFailed(loader, index: index, error: error)
                } else {
                    loader.delegate?.magLoaderItemDidLoad(loader, index: index, data: data)
                }
            }
        }
    }
    
    func stop() {
        loaderQueue.suspended = true
    }
    
    func resume() {
        loaderQueue.suspended = false
    }
    
}


