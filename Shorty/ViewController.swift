//
//  ViewController.swift
//  Shorty
//
//  Created by John Malloy on 8/23/16.
//  Copyright © 2016 BigRedINC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDelegate,NSURLConnectionDataDelegate
    
{
    @IBOutlet var urlField: UITextField!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var shortenButton: UIBarButtonItem!
    @IBOutlet var shortLabel: UIBarButtonItem!
    @IBOutlet var clipboardButton: UIBarButtonItem!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func loadLocation( _: AnyObject)
    {
        var urlText = urlField.text
        
        if !urlText!.hasPrefix("http:") && !(urlText?.hasPrefix("https:"))!
        {
            if !(urlText?.hasPrefix("//"))!
            {
                urlText = "//" + urlText!
            }
            urlText = "http:" + urlText!
        }
        let url = NSURL(string: urlText!)
        webView.loadRequest(NSURLRequest(URL: url!))
        
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        shortenButton.enabled = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        shortenButton.enabled = true
        urlField.text = webView.request?.URL?.absoluteString
    }

    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        let message = "That page could not be loaded." + (error?.localizedDescription)!
        
        let alert = UIAlertController(title: "Could not load URL"
            , message: message
            , preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "That's sad",
                                     style: .Default,
                                     handler: nil)
        
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    let GoDaddyAccountKey = "0a9fd9fe6cf111e6b131fa163e105be8"
    var shortenURLConnection = NSURLConnection?()
    var shortURLData = NSMutableData?()
    
    @IBAction func shortenURL ( _: AnyObject)
    
    {
        if let toShorten = webView.request?.URL?.absoluteString
        {
            let encodedURL = toShorten.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            let urlString = "http://api.x.co/Squeeze.svc/text/\(GoDaddyAccountKey)?url=\(encodedURL)"
            
            shortURLData = NSMutableData()
            let request = NSURLRequest(URL:NSURL(string:urlString)!)
            shortenURLConnection = NSURLConnection(request: request, delegate: self)
            shortenButton.enabled = false
        }
    }
    
    
    func connection (connection: NSURLConnection,didFailWithError error:NSError)
        
    {
        shortLabel.title = "Failed"
        clipboardButton.enabled = false
        shortenButton.enabled = true
    }
    
    func connection (connection:NSURLConnection!, didRecieveData data:NSData!)
    {
        shortURLData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        if let data = shortURLData
        {
            let shortURLString = NSString(data: data, encoding: NSUTF8StringEncoding)
            shortLabel.title = shortURLString
            clipboardButton.enabled = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}










