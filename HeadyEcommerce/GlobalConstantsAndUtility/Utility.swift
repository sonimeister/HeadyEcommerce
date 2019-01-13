//
//  Utility.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 04/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import Foundation

class Utility: NSObject {
    
    static let sharedInstance: Utility = { return Utility() }()
    
    var loadingView:UIView!
    
    //Start loader
    func startLoading(onView : UIView){
        loadingView = UIView.init(frame: onView.bounds)
        loadingView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = loadingView.center
        DispatchQueue.main.async {
            self.loadingView.addSubview(activityIndicator)
            onView.addSubview(self.loadingView)
        }
    }
    
    // Stop loader
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
        }
    }
    
    
    func stringToDate(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
