//
//  ImagesDisplayCollectionViewController.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/28/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectViewCellIdentifier"

class ImagesDisplayCollectionViewController: UICollectionViewController {
    
    private(set) var fpsLabel: UILabel!
    private var link: CADisplayLink {
        return CADisplayLink.init(target: self, selector: "tick:")
    }
    private var count: Int32 = 0
    private var lastTime: NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        fpsLabel = UILabel(frame: CGRectMake(10, 64, 60, 30))
        self.view.addSubview(fpsLabel)
        
    }
    
    //fps检测
    @objc private func tick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count++
        let delta = link.timestamp - lastTime
        if delta < 1 { return }
        lastTime = link.timestamp
        let fps = count / Int32(delta)
        count = 0
        fpsLabel.text = "\(fps) FPS"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cleanCache(sender: AnyObject) {
        SharpNetManager.manager.memoryChache.cleanCache()
        SharpNetManager.manager.memoryChache.cleandiskCache()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectViewCell
        let url = "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(indexPath.row + 1).jpg"
        cell.cellImageView.gb_setImage(url, key: url, placehold: "beautiful.jpg", completedHandle: nil)
        
        return cell
    }
}


class CollectViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
}





