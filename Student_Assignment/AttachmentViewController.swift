//
//  AttchmnetViewController.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/12/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController, UIWebViewDelegate {

    var attachmentUrl : String!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ATTACHMENT"
        let url : NSURL! = NSURL(string: attachmentUrl)
        webView.loadRequest(NSURLRequest(URL: url))
        webView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Webview Delegate
    func webViewDidStartLoad(webView: UIWebView) {
        AppDelegate.SharedDelegate().ShowLoadingView()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        AppDelegate.SharedDelegate().HideLoadingView()
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
