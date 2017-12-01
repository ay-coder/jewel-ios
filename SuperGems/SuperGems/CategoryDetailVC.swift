//
//  CategoryDetailVC.swift
//  SuperGems
//
//  Created by Yash on 26/11/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class CategoryDetailVC: UIViewController
{
    @IBOutlet weak var lblScreenTitle: UILabel!
    var arrWhatsNewData = NSMutableArray()
    var dicofSelectedCategory = NSDictionary()
    @IBOutlet weak var clWhatsNew : UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblScreenTitle.text = dicofSelectedCategory[kkeycategoryTitle] as? String
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.getProductDetialsData()
    }
    
    //MARK: Get Product Data
    func getProductDetialsData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kProductsbyCategoryID
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["category_id": dicofSelectedCategory[kkeycategoryId] as! Int]

        request(url, method: .get, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                            let dictFeaturedData = NSMutableDictionary(dictionary: dictemp.value(forKey: "data") as! NSDictionary)
                            self.arrWhatsNewData = NSMutableArray(array: dictFeaturedData["products"] as! NSArray)
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
    
    //MARK: Button Action
    @IBAction func btnBackAction(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnViewCartClicked(_ sender: UIButton)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objProductDetailVC = storyTab.instantiateViewController(withIdentifier: "ViewCartVC") as! ViewCartVC
        objProductDetailVC.bPresent = false
        self.navigationController?.pushViewController(objProductDetailVC, animated: true)
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
extension CategoryDetailVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var  iHeightofDescription = CGFloat()
        var  iHeightofTitle = CGFloat()
        var  iHeightofPrice = CGFloat()
        
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
        
        return CGSize(width: MainScreen.width/2, height: (200.0 + iHeightofTitle + iHeightofDescription + iHeightofPrice))
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
extension CategoryDetailVC : UICollectionViewDelegate
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
