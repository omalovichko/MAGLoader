//
//  ViewController.swift
//  MAGLoader
//
//  Created by MAG on 9/16/15.
//  Copyright (c) 2015 MAG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var images = [UIImage]()
    var loadManager = LoadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadImages(sender: UIButton) {
        loadManager.loadItems()
    }

    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
        cell.imageHolder?.image = images[indexPath.row]
        
        return cell
    }
    
    
    // MARK: LoadManager
    
    func itemDidLoad(data: NSData?) {
        if let imageData = data {
            if let image = UIImage(data: imageData) {
                images.append(image)
                tableView.reloadData()
            }
        }
    }
}

