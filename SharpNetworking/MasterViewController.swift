//
//  MasterViewController.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/14/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SharpNetworking"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let anyVC = segue.destinationViewController
        switch segue.destinationViewController {
        case is ImagesDisplayCollectionViewController:
            print("calss is ImagesDisplayCollectionViewController")
        case is DetailViewController:
            let detailViewController = anyVC as! DetailViewController
            detailViewController.requestIdentifier = segue.identifier!
            
            switch segue.identifier! {
            case "Data GET":
                detailViewController.URL = "https://httpbin.org/get"
            case "Data POST":
                detailViewController.URL = "https://httpbin.org/post"
            case "Data PUT":
                detailViewController.URL = "https://httpbin.org/put"
            case "Data DELETE":
                detailViewController.URL = "https://httpbin.org/delete"
            case "Download Data":
                detailViewController.URL = "https://upload.wikimedia.org/wikipedia/commons/6/69/NASA-HS201427a-HubbleUltraDeepField2014-20140603.jpg"
            case "Download Resume Data":
                detailViewController.URL = "https://upload.wikimedia.org/wikipedia/commons/6/69/NASA-HS201427a-HubbleUltraDeepField2014-20140603.jpg"
            case "Upload Data":
                detailViewController.URL = "https://httpbin.org/"
            case "Upload File":
                detailViewController.URL = "https://httpbin.org/"
            case "Upload Stream":
                detailViewController.URL = "https://httpbin.org/"
            default: break
            }
        default: break
        }
    }
    
    
}
