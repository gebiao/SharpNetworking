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
    @IBOutlet weak var downloadProgress: UILabel!
    @IBOutlet weak var uploadProgress: UILabel!
    @IBOutlet weak var getDataProgress: UILabel!
    var resumeData: NSData?
    var downloadRequest: Request!
    var dataRequest: Request!
    var uploadRequest: Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func startAction(sender: AnyObject) {
        let destination = Request.suggestDownloadFileDesination(.DocumentDirectory, domains: .UserDomainMask)
        if downloadRequest == nil {
            downloadProgress.text = ""
            self.downloadRequest = download(.GET, URLString: imageUrl, destination: destination, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.downloadProgress.text = progress.localizedDescription }
                }, succee: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self]() -> Void in
                        let image = UIImage.init(data: data)
                        self.backImageView.image = image
                        self.backImageView.setNeedsLayout()
                        })
                }, failure: { (task, error) -> Void in
                    print("error : \(error)")
            })
        }
    }
    
    //Download Test
    @IBAction func suspendAction(sender: AnyObject) {
        downloadRequest.suspend()
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        downloadRequest.cancel()
        if let delegate = downloadRequest.delegate as? Request.DownloadTaskDelegate {
            self.resumeData = delegate.resumeData
        }
    }
    
    @IBAction func goOnAction(sender: AnyObject) {
        if let resumeData = resumeData {
            let destination = Request.suggestDownloadFileDesination(.DocumentDirectory, domains: .UserDomainMask)
            download(resumeData, destination: destination, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.downloadProgress.text = progress.localizedDescription }
                }, succee: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self]() -> Void in
                        let image = UIImage.init(data: data)
                        self.backImageView.image = image
                        self.backImageView.setNeedsLayout()
                        })
                }, failure: { (task, error) -> Void in
                    print("error : \(error)")
            })
        } else {
            downloadRequest.resume()
        }
    }
    
    //Upload Test
    @IBAction func startUploadAction(sender: AnyObject) {
        
        
    }
    
    @IBAction func suspendUploadAction(sender: AnyObject) {
    }
    
    @IBAction func cancelUploadAction(sender: AnyObject) {
    }
    
    //GetData Test
    @IBAction func startGetDataAction(sender: AnyObject) {
        let parametes = ["province" : "北京", "city" : "北京", "district" : "朝阳区"]
        let getUrl = "http://tqapi.mobile.360.cn/yingjian/weather/city"
        //        let getUrl = "https://httpbin.org/get"
        //        let posturl = "https://httpbin.org/post"
        //        let putUrl = "https://httpbin.org/put"
        //        let deleteUrl = "https://httpbin.org/delete"
        
        if let _ = dataRequest { return }
        getDataProgress.text = ""
        dataRequest = getDataRequest(.GET, URLString: getUrl, parameters: parametes, encoding: .URL, heard: nil, progress: { (progress) -> Void in
            dispatch_async(dispatch_get_main_queue()) { self.getDataProgress.text = progress.localizedDescription }
            }, succee: { (task, data) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                        print("json = \(json)")
                    } catch {
                        
                    }
                })
                
            }) { (task, error) -> Void in
                print("error : \(error)")
        }
    }
    
    @IBAction func suspendGetDataAction(sender: AnyObject) {
        dataRequest.suspend()
    }
    
    @IBAction func cancelGetDataAction(sender: AnyObject) {
        dataRequest.cancel()
    }
    
    
    
    
    
    
}

