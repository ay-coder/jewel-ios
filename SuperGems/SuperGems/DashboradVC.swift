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
    
    var arrWhatsNewData = NSMutableArray()
    var arrCategoryData = NSMutableArray()

    @IBOutlet weak var clWhatsNew : UICollectionView!
    
    @IBOutlet weak var vwFeatured : UIImageView!
    @IBOutlet weak var vwWhatsNew : UIImageView!
    @IBOutlet weak var vwCategories : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        iSelectedTab = 1
        self.navigationController?.navigationBar.isHidden = true
        self.SetButtonSelected(iTag: iSelectedTab)
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

        self.getWhatsNewData()
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
    
    //MARK: Get Product Data
    func getWhatsNewData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kWhatsNewAPI
        showProgress(inView: self.view)
        //        ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_discoverloading"))
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                        if (dictemp.value(forKey: "error") != nil)
                        {
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrWhatsNewData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                        }
                        self.clWhatsNew.reloadData()
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                self.clWhatsNew.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    //MARK: Get Category data
    func getCategoryData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kcategories
        showProgress(inView: self.view)
        //        ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_discoverloading"))
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                        if (dictemp.value(forKey: "error") != nil)
                        {
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrCategoryData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
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

    
    //MARK: Button Action
    @IBAction func btnChangedTabAction(_ sender: UIButton)
    {
        iSelectedTab = sender.tag
        self.SetButtonSelected(iTag: iSelectedTab)
    }
    @IBAction func btnViewCartClicked(_ sender: UIButton)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objProductDetailVC = storyTab.instantiateViewController(withIdentifier: "ViewCartVC") as! ViewCartVC
        self.navigationController?.pushViewController(objProductDetailVC, animated: true)
    }

    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton)
    {
        SJSwiftSideMenuController.showLeftMenu()
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
extension DashboradVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        /*  if collectionView != self.clvwLeading
         {
         if UIScreen.main.bounds.size.height<=568
         {
         return CGSize(width: 140, height: 140)
         }
         return CGSize(width: 170, height: 220)
         }*/
        return CGSize(width: MainScreen.width/2, height: 500)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if  collectionView == self.clWhatsNew
        {
            return self.arrWhatsNewData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "WhatsNewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! WhatsNewCell
        
        if  collectionView == self.clWhatsNew
        {
            let dic = self.arrWhatsNewData[indexPath.row] as! NSDictionary
            let strurl = dic[kkeyproductImage] as! String
            let url  = URL.init(string: strurl)
            cell.imgProduct.sd_setImage(with: url, placeholderImage: nil)
            
            cell.lblProductName.text = dic[kkeyproductTitle] as? String
            cell.lblProductDescription.text = dic[kkeyproductDescription] as? String
            cell.lblPrice.text = "$\(dic[kkeyproductPrice] as! Int)"
        }
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension DashboradVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if  collectionView == self.clWhatsNew
        {
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objProductDetailVC = storyTab.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
             objProductDetailVC.dicofProductDetail = self.arrWhatsNewData[indexPath.row] as! NSDictionary
            self.navigationController?.pushViewController(objProductDetailVC, animated: true)
        }
    }
}
class WhatsNewCell: UICollectionViewCell
{
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

}
