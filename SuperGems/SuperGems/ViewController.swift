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
    @IBOutlet weak var txtSigunpName : UITextField!

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
        if (self.txtUserName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else
        {
            self.view .endEditing(true)
            self.callLoginAPI()
        }
//        let storyTab = UIStoryboard(name: "Main", bundle: nil)
//        let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "DashboradVC")
//        self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)
    }
    func callLoginAPI()
    {
        
        let url = kServerURL + kLogin
        let parameters: [String: Any] = ["email": self.txtUserName.text!, "password": self.txtPassword.text!]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if let err  =  dictemp.value(forKey: kkeyError)
                            {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }
                            else
                            {
                                appDelegate.arrLoginData = dictemp
                                let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                
                                if(self.btnRememberMe.isSelected)
                                {
                                    UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                }
                                else
                                {
                                    UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
                                }
                                UserDefaults.standard.synchronize()
                                
                                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "DashboradVC")
                                self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeyError]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
        
    }

    @IBAction func btnLoginasGuestAction(_ sender: Any)
    {
        
    }
    
    //MARK: Signup Action
    @IBAction func btnSIGNUPAction(_ sender: Any)
    {
        if (self.txtSigunpName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter name", inView: self)
        }
       else if (self.txtSigunpUserName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email address", inView: self)
        }
        else if (self.txtSigunpPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else if (self.txtSigunpConfirmPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter confirm password", inView: self)
        }
        else if (self.txtSigunpPassword.text! != self.txtSigunpConfirmPassword.text!)
        {
            App_showAlert(withMessage: "Password and confirm password must be same", inView: self)
        }
        else
        {
            self.view .endEditing(true)
            self.callSignUPAPI()
        }
    }
    func callSignUPAPI()
    {
        let url = kServerURL + kSignUP
        let parameters: [String: Any] = ["email": self.txtSigunpUserName.text!, "password": self.txtSigunpPassword.text!, "username":self.txtSigunpUserName.text!,"name":self.txtSigunpName.text!]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if let err = dictemp.value(forKey: kkeyError)
                            {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }
                            else
                            {
                                if let errorcode = dictemp.value(forKey: "code")
                                {
                                    if errorcode as! NSNumber == 200
                                    {
                                        let data = NSKeyedArchiver.archivedData(withRootObject: dictemp)
                                        UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                        UserDefaults.standard.synchronize()
                                        
                                        if(self.btnRememberMe.isSelected)
                                        {
                                            UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                        }
                                        else
                                        {
                                            UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
                                        }
                                        UserDefaults.standard.synchronize()
                                        
                                        let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                        let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "DashboradVC")
                                        self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)

                                    }
                                    else
                                    {
                                        App_showAlert(withMessage: dictemp[kkeyMessage]! as! String, inView: self)
                                    }
                                }
                                else
                                {
                                    App_showAlert(withMessage: dictemp[kkeyMessage]! as! String, inView: self)
                                }
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeyError]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
        
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



