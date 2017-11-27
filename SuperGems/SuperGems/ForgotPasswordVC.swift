//
//  ForgotPasswordVC.swift
//  SuperGems
//
//  Created by Yash on 19/11/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController
{
    @IBOutlet weak var txtEmail : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSIGNINAction(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnforgotPWDAction(_ sender: Any)
    {
        if (self.txtEmail.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email address", inView: self)
        }
        else
        {
        let url = kServerURL + kforgotpassword
        let parameters: [String: Any] = ["email": self.txtEmail.text!]
        
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
                                
                                let alertView = UIAlertController(title: Application_Name, message: "New Password send on Register Email Id", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                { (action) in
                                    _ =  self.navigationController?.popViewController(animated: true)
                                }
                                alertView.addAction(OKAction)
                                self.present(alertView, animated: true, completion: nil)
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

    }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
