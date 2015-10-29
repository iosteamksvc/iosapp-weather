//
//  Network.swift
//  kzWeather
//
//  Created by HQVINH-PC on 10/29/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit

class Network {
    
    // Show network error
    class func showNetworkError(inView: UIViewController, inFunction: Void->Void) {
        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "TRY", style: UIAlertActionStyle.Default) { (action) in
            isConnectedToNetwork(inView, inFunction: inFunction)
        }
        alert.addAction(okButton)
        inView.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Check intenet connection
    class func isConnectedToNetwork(inView: UIViewController, inFunction: Void->Void) -> Bool {
        
        var status: Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        } catch {
            print(error)
        }
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        //-----
        if(status) {
            inFunction()
        } else {
            showNetworkError(inView, inFunction: inFunction)
        }
        //-----
        return status
    }

}
