//
//  ViewController.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/6/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

let videoUrl = "http://video.dispatch.tc.qq.com/54371892/f0016kk9vtn.p202.1.mp4?sdtfrom=v1001&type=mp4&vkey=90E374AF07B43A0DDC3AB1CD8029A3B268163270243D2861263581348E0E45EF16CEDF56740EEA453452DC95A59BCDA7A005F3A76ABF832CF082E1F03F1621A93DCEA04385442D4FAEBCE4C13303867396A435F36174BDDE&platform=11&br=98&fmt=hd&sp=350&guid=2AD956E7F3764B1351993F3D1F7ECC6FF7CAECFD"
let imageUrl = "http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg"//"https://upload.wikimedia.org/wikipedia/commons/6/69/NASA-HS201427a-HubbleUltraDeepField2014-20140603.jpg"//"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg"


class ViewController: UIViewController {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    var progress: NSProgress = NSProgress(totalUnitCount: 0)
    var request: Request!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func startAction(sender: AnyObject) {
        let destination = Request.suggestDownloadFileDesination(.DocumentDirectory, domains: .UserDomainMask)
        if request == nil {
            self.request = download(.GET, URLString: imageUrl, destination: destination)
        }
        Manager.sharedInstance.delegate.downloadTaskDidWrited = { [unowned self](session, downloadTask, didWriteData, totalBytesWritten, totalBytesExpectedToWrite) in
            self.progress.totalUnitCount = totalBytesExpectedToWrite
            self.progress.completedUnitCount = totalBytesWritten
            dispatch_async(dispatch_get_main_queue()) { self.progressLabel.text = self.progress.localizedDescription }
        }
        
        Manager.sharedInstance.delegate.downloadDataCompleted = { [unowned self](session, downloadTask, dataFileUrl, data) in
            dispatch_async(dispatch_get_main_queue(), { [unowned self]() -> Void in
                let image = UIImage.init(data: data!)
                self.backImageView.image = image
                self.backImageView.setNeedsLayout()
                })
        }
        
        
        
    }
    
    @IBAction func suspendAction(sender: AnyObject) {
        request.suspend()
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        request.cancel()
    }
    
    @IBAction func goOnAction(sender: AnyObject) {
        request.resume()
    }
}

