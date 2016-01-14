//
//  DetailViewController.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/14/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bodyContent: UITextView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var progressTitle: UILabel!
    
    var request: Request!
    var requestIdentifier: String!
    var URL: String!
    var resumeData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bodyContent.editable = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func StartAction(sender: AnyObject) {
        switch requestIdentifier {
        case "Data GET":
            request = getDataRequest(.GET, URLString: URL, parameters: nil, encoding: .URL, heard: nil, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                            self.bodyContent.text = "\(json)"
                        } catch {
                            
                        }
                    })
                    
                }) { (task, error) -> Void in
                    print("error : \(error)")
            }
        case "Data POST":
            request = getDataRequest(.POST, URLString: URL, parameters: nil, encoding: .URL, heard: nil, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                            self.bodyContent.text = "\(json)"
                        } catch {
                            
                        }
                    })
                    
                }) { (task, error) -> Void in
                    print("error : \(error)")
            }
        case "Data PUT":
            request = getDataRequest(.PUT, URLString: URL, parameters: nil, encoding: .URL, heard: nil, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                            self.bodyContent.text = "\(json)"
                        } catch {
                            
                        }
                    })
                    
                }) { (task, error) -> Void in
                    print("error : \(error)")
            }
        case "Data DELETE":
            request = getDataRequest(.DELETE, URLString: URL, parameters: nil, encoding: .URL, heard: nil, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                            self.bodyContent.text = "\(json)"
                        } catch {
                            
                        }
                    })
                    
                }) { (task, error) -> Void in
                    print("error : \(error)")
            }
        case "Download Data":
            let destination = Request.suggestDownloadFileDesination(.DocumentDirectory, domains: .UserDomainMask)
            request = download(.GET, URLString: URL, destination: destination, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self]() -> Void in
                        let image = UIImage.init(data: data)
                        self.backGroundImageView.image = image
                        self.backGroundImageView.setNeedsLayout()
                        })
                }, failure: { (task, error) -> Void in
                    print("error : \(error)")
            })
            
        case "Download Resume Data":
            let destination = Request.suggestDownloadFileDesination(.DocumentDirectory, domains: .UserDomainMask)
            guard let resumeData = resumeData else { return }
            request = download(resumeData, destination: destination, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self]() -> Void in
                        let image = UIImage.init(data: data)
                        self.backGroundImageView.image = image
                        self.backGroundImageView.setNeedsLayout()
                        })
                }, failure: { (task, error) -> Void in
                    print("error : \(error)")
            })
            
        case "Upload Data":
            
            let fileUrl = NSBundle.mainBundle().pathForResource("unicorn", ofType: "png")
            let data = NSData.init(contentsOfURL: NSURL.init(fileURLWithPath: fileUrl!))
            guard let data_0 = data else { return }
            
            request = upload(.POST, URLString: URL, data: data_0, progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: { (task, data) -> Void in
                    print("upload success")
                }) { (task, error) -> Void in
                    print("error : \(error)")
            }
        case "Upload File":
            let fileUrl = NSBundle.mainBundle().pathForResource("unicorn", ofType: "png")
            request = upload(.POST, URLString: URL, fileURL: NSURL.init(fileURLWithPath: fileUrl!), progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue()) { self.progressTitle.text = progress.localizedDescription }
                }, success: nil, failure: { (task, error) -> Void in
                    print("error : \(error)")
            })
            //        case "Upload Stream": break
        default: break
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
        if let downloadDele = request.delegate as? Request.DownloadTaskDelegate {
            resumeData = downloadDele.resumeData
        }
    }
}
