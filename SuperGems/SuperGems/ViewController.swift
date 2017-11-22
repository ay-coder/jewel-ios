//
//  ViewController.swift
//  SuperGems
//
//  Created by Yash on 19/11/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var vwLogin : UIView!

    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var btnSignup : UIButton!
    @IBOutlet weak var btnRememberMe : UIButton!

    
    @IBOutlet weak var vwSignup : UIView!
    @IBOutlet weak var txtSigunpUserName : UITextField!
    @IBOutlet weak var txtSigunpPassword : UITextField!
    @IBOutlet weak var txtSigunpConfirmPassword : UITextField!

    override func viewDidLoad()
    {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        SJSwiftSideMenuController.hideLeftMenu()
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .NONE)
        SJSwiftSideMenuController.enableDimBackground = true
        
        vwSignup.isHidden = true
        vwLogin.isHidden = false
        btnLogin.isSelected = true
        btnSignup.isSelected = false
        btnSignup.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 17)
        btnLogin.titleLabel?.font = UIFont (name: "Raleway-SemiBold", size: 17)
    }
    
    @IBAction func btnvwSelectedAction(_ sender: UIButton)
    {
        if(sender.tag == 1)
        {
            vwSignup.isHidden = true
            vwLogin.isHidden = false
            btnLogin.isSelected = true
            btnSignup.isSelected = false
            btnSignup.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 17)
            btnLogin.titleLabel?.font = UIFont (name: "Raleway-SemiBold", size: 17)

        }
        else
        {
            btnLogin.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 17)
            btnSignup.titleLabel?.font = UIFont (name: "Raleway-SemiBold", size: 17)

            vwSignup.isHidden = false
            btnLogin.isSelected = false
            vwLogin.isHidden = true
            btnSignup.isSelected = true
        }
    }
    
    @IBAction func btnRememberMeAction(_ sender: UIButton)
    {
        if(sender.isSelected == true)
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
    @IBAction func btnSIGNINAction(_ sender: Any)
    {
        
    }
    
    @IBAction func btnLoginasGuestAction(_ sender: Any)
    {
        
    }
    @IBAction func btnforgotPWDAction(_ sender: Any)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "ForgotPasswordVC")
        self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
@IBDesignable extension UIView
{
    
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
@IBDesignable extension UITextField
{
    
    @IBInspectable var placeholderColor: UIColor?
        {
        set {
            guard let uiColor = newValue else { return }
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder!, attributes: [NSForegroundColorAttributeName: uiColor])
        }
        get {
            guard let color = self.placeholderColor else { return nil }
            return color
        }
    }
}



