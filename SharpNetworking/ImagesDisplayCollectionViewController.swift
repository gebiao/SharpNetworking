//
//  ImagesDisplayCollectionViewController.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/28/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectViewCellIdentifier"
private let width = UIScreen.mainScreen().bounds.size.width
private let height = UIScreen.mainScreen().bounds.size.width * 3 / 4

class ImagesDisplayCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var link: CADisplayLink {
        return CADisplayLink.init(target: self, selector: "tick:")
    }
    private var count: Int32 = 0
    private var lastTime: NSTimeInterval = 0
    private let urlList = [
        "https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
        
        // animated gif: http://cinemagraphs.com/
        "http://i.imgur.com/uoBwCLj.gif",
        "http://i.imgur.com/8KHKhxI.gif",
        "http://i.imgur.com/WXJaqof.gif",
        
        // animated gif: https://dribbble.com/markpear
        "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
        "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
        "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
        "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
        "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
        "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
        
        // animaged gif: https://dribbble.com/jonadinges
        "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
        "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
        "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
        "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
        
        // jpg: https://dribbble.com/snootyfox
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
        "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
        
        // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
        "http://littlesvr.ca/apng/images/BladeRunner.png",
        "http://littlesvr.ca/apng/images/Contact.webp"]
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.itemSize = CGSizeMake(width, height)
        self.collectionView = UICollectionView.init(frame: CGRectMake(0, 64, width, UIScreen.mainScreen().bounds.size.height - 64), collectionViewLayout: viewLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CollectViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(collectionView)
        
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
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
        title = "\(fps) FPS"
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? CollectViewCell
        //        let url = "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(indexPath.row + 1).jpg"
        if cell == nil {
            cell = CollectViewCell()
        }
        
        cell!.imageUrlString = urlList[indexPath.row]
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewHeight = scrollView.frame.height + scrollView.contentInset.top
        for cell in self.collectionView.visibleCells() where (cell is CollectViewCell) {
            let y = cell.center.y - scrollView.contentOffset.y
            let p = y - viewHeight / 2
            let scale = cos(p / viewHeight * 0.8) * 0.95
            UIView.animateWithDuration(0.15, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut, .CurveEaseIn], animations: { () -> Void in
                (cell as! CollectViewCell).cellImageView.transform = CGAffineTransformMakeScale(scale, scale)
                }, completion: nil)
        }
    }
    
}


class CollectViewCell: UICollectionViewCell {
    
    var cellImageView: UIImageView
    var imageUrlString: String! {
        didSet {
            
        }
        willSet {
            cellImageView.gb_setImage(newValue, key: newValue, placehold: "placeHoldImage", progress: { (progress) -> Void in
                
                }) { (image, error) -> Void in
                    print(error)
            }
        }
    }
    
    override init(frame: CGRect) {
        self.cellImageView = UIImageView(frame: CGRectMake(10, 5, width - 20, height - 10))
        super.init(frame: frame)
        self.contentView.addSubview(self.cellImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






