//
//  DashboradVC.swift
//  SuperGems
//
//  Created by Yash on 19/11/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class DashboradVC: UIViewController
{
    @IBOutlet weak var btnFeatured : UIButton!
    @IBOutlet weak var btnWhatsNew : UIButton!
    @IBOutlet weak var btnCategories : UIButton!

    @IBOutlet weak var imgFeatured : UIImageView!
    @IBOutlet weak var imgWhatsNew : UIImageView!
    @IBOutlet weak var imgCategories : UIImageView!

    var iSelectedTab = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        iSelectedTab = 1
        
        self.SetButtonSelected(iTag: iSelectedTab)
        // Do any additional setup after loading the view.
    }

    func SetButtonSelected(iTag: Int)
    {
        if iTag == 1
        {
            btnFeatured.isSelected = true
            btnWhatsNew.isSelected = false
            btnCategories.isSelected = false
            
            btnFeatured.titleLabel?.font = UIFont (name: "Raleway-SemiBold", size: 14)
            btnWhatsNew.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 14)
            btnCategories.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 14)

            
            imgFeatured.isHidden = false
            imgWhatsNew.isHidden = true
            imgCategories.isHidden = true

        }
        else if iTag == 2
        {
            btnWhatsNew.titleLabel?.font = UIFont (name: "Raleway-SemiBold", size: 14)
            btnFeatured.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 14)
            btnCategories.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 14)

            
            btnFeatured.isSelected = false
            btnWhatsNew.isSelected = true
            btnCategories.isSelected = false
            
            imgFeatured.isHidden = true
            imgWhatsNew.isHidden = false
            imgCategories.isHidden = true

        }
        else if iTag == 3
        {
            btnCategories.titleLabel?.font = UIFont (name: "Raleway-SemiBold", size: 14)
            btnFeatured.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 14)
            btnWhatsNew.titleLabel?.font = UIFont (name: "Raleway-Regular", size: 14)

            btnFeatured.isSelected = false
            btnWhatsNew.isSelected = false
            btnCategories.isSelected = true
            
            imgFeatured.isHidden = true
            imgWhatsNew.isHidden = true
            imgCategories.isHidden = false
        }
    }
    
    @IBAction func btnChangedTabAction(_ sender: UIButton)
    {
        iSelectedTab = sender.tag
        self.SetButtonSelected(iTag: iSelectedTab)

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
