//
//  bookWebViewController.swift Viewing the book
//  bliss
//
//  Created by Hanslen Chen on 16/1/30.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class bookWebViewController: UIViewController, UIWebViewDelegate, UINavigationControllerDelegate {

    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var loadingGif: UIImageView!
    var url:NSURL! = NSURL(string: "")
    let gif = UIImage.gifWithName("loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.loadRequest(NSURLRequest(URL: url))
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Add webView animation
    func webViewDidStartLoad(webView: UIWebView) {
        loadingGif.image = gif
        webView.hidden = true
        
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.hidden = true
        loadingGif.hidden = true
        loadingLabel.hidden = true
        webView.hidden = false
    }
    
//    Check error for network
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let networkFailed = UIAlertController(title: "Error", message: "Please check your network:-(", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkFailed.addAction(cancel)
        networkFailed.addAction(ok)
        self.presentViewController(networkFailed, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
