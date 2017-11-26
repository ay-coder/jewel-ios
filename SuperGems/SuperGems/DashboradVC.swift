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
    var dictFeaturedData = NSMutableDictionary()
    var arrproducts = NSMutableArray()

    @IBOutlet weak var clWhatsNew : UICollectionView!
    
    @IBOutlet weak var vwFeatured : UIView!
    @IBOutlet weak var vwWhatsNew : UIView!
    @IBOutlet weak var vwCategories : UIView!
    
    //FeaturedView Configuration
    @IBOutlet weak var imgNewFeatured : UIImageView!
    @IBOutlet weak var lblNewFeaturedTitle : UILabel!
    @IBOutlet weak var lblNewFeaturedSubTitle : UILabel!
    @IBOutlet weak var tblFeatured : UITableView!

    //Category View
    @IBOutlet weak var clCategory : UICollectionView!
    var arrCategorySectionSelection = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        iSelectedTab = 1
        self.navigationController?.navigationBar.isHidden = true
        self.SetButtonSelected(iTag: iSelectedTab)
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

        self.tblFeatured.estimatedRowHeight = 143;
        self.tblFeatured.rowHeight = UITableViewAutomaticDimension;
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
            
            vwFeatured.isHidden = false
            vwWhatsNew.isHidden = true
            vwCategories.isHidden = true
            self.getFeaturedData()
            

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
            
            vwFeatured.isHidden = true
            vwWhatsNew.isHidden = false
            vwCategories.isHidden = true

            self.getWhatsNewData()

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
            
            
            vwFeatured.isHidden = true
            vwWhatsNew.isHidden = true
            vwCategories.isHidden = false
            self.getCategoryData()
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
                            
                            if self.iSelectedTab == 1
                            {
                                self.tblFeatured.reloadData()
                            }
                            else
                            {
                                self.arrCategorySectionSelection = NSMutableArray()
                                for i in 0..<self.arrCategoryData.count
                                {
                                    self.arrCategorySectionSelection.add(kNO)
                                }
                                self.clCategory.reloadData()
                            }
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrCategoryData = NSMutableArray()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    //MARK: Get featured data
    func getFeaturedData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kFeaturedData
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
                            self.dictFeaturedData = NSMutableDictionary(dictionary: dictemp.value(forKey: "data") as! NSDictionary)
                            
                            let dic = self.dictFeaturedData["featured"] as! NSDictionary
                            
                            let strurl = dic["image"] as! String
                            let url  = URL.init(string: strurl)
                            self.imgNewFeatured.sd_setImage(with: url, placeholderImage: nil)
                            
                            self.lblNewFeaturedTitle.text = dic[kkeytitle] as? String
                            self.lblNewFeaturedSubTitle.text = dic[kkeysubtitle] as? String
                            
                            self.getCategoryData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.dictFeaturedData = NSMutableDictionary()
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

    func btnRemoveAction(sender:UIButton)
    {
        let intRow = sender.tag
        
        if arrCategorySectionSelection[intRow] as! String == kNO
        {
            arrCategorySectionSelection.replaceObject(at: intRow, with: kYES)
        }
        else
        {
            arrCategorySectionSelection.replaceObject(at: intRow, with: kNO)
        }
        self.clCategory.reloadData()
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
extension DashboradVC : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var  iHeightofDescription = CGFloat()
        var  iHeightofTitle = CGFloat()
        var  iHeightofPrice = CGFloat()
        
        if  collectionView == self.clCategory
        {
            
            let dic = self.arrproducts[indexPath.row] as! NSDictionary
            let fontAttributes = [NSFontAttributeName: UIFont (name: "Raleway-Regular", size: 17)]
            var size = (dic[kkeyproductTitle] as! NSString).size(attributes: fontAttributes)
            
            iHeightofTitle = size.height
            
            if let temp = dic[kkeyproductDescription]
            {
                size = (dic[kkeyproductDescription] as! NSString).size(attributes: fontAttributes)
                iHeightofDescription = size.height
            }
            
            size = ("$\(dic[kkeyproductPrice] as! Int)".size(attributes: fontAttributes))
            iHeightofPrice = size.height
        }
        else
        {
            let dic = self.arrWhatsNewData[indexPath.row] as! NSDictionary
            let fontAttributes = [NSFontAttributeName: UIFont (name: "Raleway-Regular", size: 17)]
            var size = (dic[kkeyproductTitle] as! NSString).size(attributes: fontAttributes)
            
            iHeightofTitle = size.height
            
            if let temp = dic[kkeyproductDescription]
            {
                size = (dic[kkeyproductDescription] as! NSString).size(attributes: fontAttributes)
                iHeightofDescription = size.height
            }
            
            size = ("$\(dic[kkeyproductPrice] as! Int)".size(attributes: fontAttributes))
            iHeightofPrice = size.height
        }

        return CGSize(width: MainScreen.width/2, height: (200.0 + iHeightofTitle + iHeightofDescription + iHeightofPrice))
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if  collectionView == self.clCategory
        {
            return self.arrCategoryData.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if  collectionView == self.clWhatsNew
        {
            return self.arrWhatsNewData.count
        }
        else
        {
            if arrCategorySectionSelection[section] as! String == kYES
            {
                let dictFeaturedData = NSMutableDictionary(dictionary: self.arrCategoryData[section]  as! NSDictionary)
                self.arrproducts = NSMutableArray(array: dictFeaturedData["products"] as! NSArray)
                return self.arrproducts.count
            }
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
        else
        {
            let dic = self.arrproducts[indexPath.row] as! NSDictionary
            let strurl = dic[kkeyproductImage] as! String
            let url  = URL.init(string: strurl)
            cell.imgProduct.sd_setImage(with: url, placeholderImage: nil)
            
            cell.lblProductName.text = dic[kkeyproductTitle] as? String
            cell.lblProductDescription.text = dic[kkeyproductDescription] as? String
            cell.lblPrice.text = "$\(dic[kkeyproductPrice] as! Int)"

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        switch kind
        {
            case UICollectionElementKindSectionHeader:
                let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CategoryCollectionReusableView", for: indexPath) as! CategoryCollectionReusableView
            
                let dic = self.arrCategoryData[indexPath.row] as! NSDictionary
            
                let strurl = dic[kkeycategoryImage] as! String
                let url  = URL.init(string: strurl)
                reusableview.imgCategory.sd_setImage(with: url, placeholderImage: nil)
            
                reusableview.lblCategoryName.text = dic[kkeycategoryTitle] as? String
                reusableview.lblTotalProductCount.text = "\(dic[kkeyproductsCount] as! Int) items —"
                
                reusableview.btnTapped.tag = indexPath.section
                reusableview.btnTapped.addTarget(self, action: #selector(self.btnRemoveAction(sender:)), for: .touchUpInside)

                return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if collectionView == self.clWhatsNew
        {
            return CGSize.zero
        }
        else
        {
            return CGSize(width: MainScreen.width, height: 108)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if  collectionView == self.clWhatsNew
        {
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objProductDetailVC = storyTab.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
             objProductDetailVC.dicofProductDetail = self.arrWhatsNewData[indexPath.row] as! NSDictionary
            self.navigationController?.pushViewController(objProductDetailVC, animated: true)
        }
        else
        {
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objProductDetailVC = storyTab.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            objProductDetailVC.dicofProductDetail = self.arrproducts[indexPath.row] as! NSDictionary
            self.navigationController?.pushViewController(objProductDetailVC, animated: true)

        }
    }
}
extension DashboradVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrCategoryData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCell
        cell.selectionStyle = .none
        let dic = self.arrCategoryData[indexPath.row] as! NSDictionary
        
        let strurl = dic[kkeycategoryImage] as! String
        let url  = URL.init(string: strurl)
        cell.imgCategory.sd_setImage(with: url, placeholderImage: nil)
        
        cell.lblCategoryName.text = dic[kkeycategoryTitle] as? String
        cell.lblTotalProductCount.text = "\(dic[kkeyproductsCount] as! Int) items —"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objCategoryDetailVC = storyTab.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
        objCategoryDetailVC.dicofSelectedCategory = self.arrCategoryData[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(objCategoryDetailVC, animated: true)
    }
}

class WhatsNewCell: UICollectionViewCell
{
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

}
class FeaturedCell: UITableViewCell
{
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblTotalProductCount: UILabel!
}
class CategoryCollectionReusableView: UICollectionReusableView
{
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblTotalProductCount: UILabel!
    @IBOutlet weak var btnTapped: UIButton!

}
