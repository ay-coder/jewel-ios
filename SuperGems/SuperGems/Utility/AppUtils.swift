//
//  AppUtils.swift
//  Pairi
//
//  Created by Bhavik on 30/10/16.
//  Copyright © 2016 Bhavik. All rights reserved.
//

import Foundation
import UIKit

var config : SwiftLoader.Config = SwiftLoader.Config()


func App_showAlert(withMessage message:String, inView viewC : UIViewController) {
    let alert = UIAlertController(title: Application_Name, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(action)
    viewC.present(alert, animated: true, completion: nil)
}

func isValidEmailID(strEmail: String) -> Bool {
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: strEmail)
}

func showProgress(inView view: UIView?) {
    
    if progressView == nil {
        var frame : CGRect
        if (view != nil) {
            frame = (view?.bounds)!
        }else{
            frame = CGRect(x: 0, y: 0, width: MainScreen.width, height: MainScreen.height)
        }
        progressView = UIView(frame: frame)
        progressView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let activity = UIActivityIndicatorView()
        activity.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activity.startAnimating()
        progressView!.addSubview(activity)
        
        if (view != nil) {
            view?.addSubview(progressView!)
        }else{
            appDelegate.window?.addSubview(progressView!)
        }
    }
}
func hideProgress() {
    progressView?.removeFromSuperview()
    progressView = nil
}

func ShowProgresswithImage(inView view: UIView? , image : UIImage?)
{
    if progressView == nil
    {
        var frame : CGRect
        if (view != nil)
        {
            frame = (view?.bounds)!
        }
        else
        {
            frame = CGRect(x: 0, y: 0, width: MainScreen.width, height: MainScreen.height)
        }
        progressView = UIView(frame: frame)
        //progressView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let imgvw = UIImageView(image: image)
        imgvw.contentMode = .scaleToFill
        imgvw.frame = CGRect(x: 0, y: 0, width: MainScreen.width, height: MainScreen.height)
        progressView!.addSubview(imgvw)
        
        if (view != nil)
        {
            view?.addSubview(progressView!)
        }
        else
        {
            appDelegate.window?.addSubview(progressView!)
        }
    }

}
func hideProgresswithImage()
{
    progressView?.removeFromSuperview()
    progressView = nil
}

func resize(_ image: UIImage) -> UIImage
{
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    let maxHeight: Float = 300.0
    let maxWidth: Float = 400.0
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    let imageData: Data? = UIImageJPEGRepresentation(img!, 1.0)
    UIGraphicsEndImageContext()
    return UIImage(data: imageData!)!
}

func actionShowSwiftyLoader()
{
    config.size = 170
    config.backgroundColor = UIColor.white
    config.spinnerColor = UIColor.black
    config.titleTextColor = UIColor.black
    config.spinnerLineWidth = 2.0
    config.foregroundColor = UIColor.black
    config.foregroundAlpha = 0.5
    SwiftLoader.setConfig(config: config)
    SwiftLoader.show(title: "Loading...", animated: true)
}
func HideSwiftyLoader()
{
    SwiftLoader.hide()
}
