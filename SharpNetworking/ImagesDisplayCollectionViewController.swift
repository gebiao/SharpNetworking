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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cleanCache(sender: AnyObject) {
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
        
        print("\(cell.dynamicType)")
        let url = "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(indexPath.row + 1).jpg"
        cell.cellImageView.gb_setImage(url, key: url, completedHandle: nil)
        
        return cell
    }
}


class CollectViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
}





