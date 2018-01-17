//
//  ProductDetailVC.swift
//  SuperGems
//
//  Created by Yash on 25/11/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController
{
//    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnAddtoCart: UIButton!
    @IBOutlet weak var btnAlreadyAddedtoCart: UIButton!

    @IBOutlet weak var scrHeightCT : NSLayoutConstraint!
    var dicofProductDetail = NSDictionary()
    var iImageCount = Int()
    var arrImagesURL = NSMutableArray()
    @IBOutlet weak var clHeightCT : NSLayoutConstraint!
    @IBOutlet weak var clImages : UICollectionView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let strurl = dicofProductDetail[kkeyproductImage] as! String
//        let url  = URL.init(string: strurl)
//        imgProduct.sd_setImage(with: url, placeholderImage: nil)
        
        lblProductName.text = dicofProductDetail[kkeyproductTitle] as? String
        lblProductDescription.text = dicofProductDetail[kkeyproductDescription] as? String
        lblPrice.text = "$\(dicofProductDetail[kkeyproductPrice] as! Int)"
        
        if dicofProductDetail[kkeyisWishList] as! Int == 1
        {
            btnAddtoCart.isHidden = true
            btnAlreadyAddedtoCart.isHidden = false
        }
        else
        {
            btnAddtoCart.isHidden = false
            btnAlreadyAddedtoCart.isHidden = true
        }
        
        
        var strImg1 = dicofProductDetail[kkeyproductImage]  as! NSString
        if strImg1.length > 0
        {
            iImageCount = iImageCount + 1
            arrImagesURL.add(dicofProductDetail[kkeyproductImage]  as! NSString)
        }
        
        strImg1 = dicofProductDetail[kkeyproductImage1]  as! NSString
        if strImg1.length > 0
        {
            iImageCount = iImageCount + 1
            arrImagesURL.add(dicofProductDetail[kkeyproductImage1]  as! NSString)

        }

        strImg1 = dicofProductDetail[kkeyproductImage2]  as! NSString
        if strImg1.length > 0
        {
            iImageCount = iImageCount + 1
            arrImagesURL.add(dicofProductDetail[kkeyproductImage2]  as! NSString)

        }

        strImg1 = dicofProductDetail[kkeyproductImage3]  as! NSString
        if strImg1.length > 0
        {
            iImageCount = iImageCount + 1
            arrImagesURL.add(dicofProductDetail[kkeyproductImage3]  as! NSString)
        }
        
        clHeightCT.constant = CGFloat(268 * iImageCount)
        
        scrHeightCT.constant = clHeightCT.constant + 260
        clImages.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func btnAddtoCartAction(_ sender: Any)
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]

            let url = kServerURL + kAddtoCart
            let parameters: [String: Any] = ["product_id": dicofProductDetail[kkeyproductId] as! Int, "qty": 1]
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
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
                                    let alertView = UIAlertController(title: Application_Name, message: "Product Added to Cart", preferredStyle: .alert)
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
        //        _ = self.navigationController?.popViewController(animated: true)
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
extension ProductDetailVC : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: MainScreen.width-16, height: 268.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return iImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "ProudctImageCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! ProudctImageCell
        
        let strurl = arrImagesURL[indexPath.row] as! String
        let url  = URL.init(string: strurl)
        cell.imgProduct.sd_setImage(with: url, placeholderImage: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}
class ProudctImageCell: UICollectionViewCell
{
    @IBOutlet weak var imgProduct: UIImageView!
}
