//
//  DetailViewController.swift
//  HNMobileTest
//
//  Created by Diego Sepúlveda on 5/29/19.
//  Copyright © 2019 reigndesign. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var hit: Hit!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)

        let nsurl = URL(string: hit.storyUrl!)
        self.title = nsurl?.host
        let request: NSMutableURLRequest = NSMutableURLRequest(url: nsurl!)
        request.timeoutInterval = 60
        self.webView.loadRequest(request as URLRequest)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        iToast.makeText("\(error)").setDuration(3000).setGravity(iToastGravityBottom).show(iToastTypeWarning)
    }

}

