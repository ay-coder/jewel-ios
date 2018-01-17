//
//  ViewCartVC.swift
//  SuperGems
//
//  Created by Yash on 25/11/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ViewCartVC: UIViewController
{
    var arrCartData = NSMutableArray()
    @IBOutlet weak var lblCartTotal: UILabel!
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet var tblCart : UITableView!
    @IBOutlet weak var vwOrderPlaced : UIView!
    var bPresent = Bool()
    @IBOutlet weak var btnBack : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if bPresent == true
        {
            btnBack.setImage(UIImage(named: "close_icon"), for: .normal)
        }
        // Do any additional setup after loading the view.
        self.tblCart.estimatedRowHeight = 143;
        self.tblCart.rowHeight = UITableViewAutomaticDimension;
        self.getCartDetailsData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Get Category data
    func getCartDetailsData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetCartDetails
        showProgress(inView: self.view)
        
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
                            self.arrCartData = NSMutableArray()
                            self.tblCart.reloadData()
                        }
                        else
                        {
                            self.arrCartData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            
                            var fCartTotal = CGFloat()
                            for i in 0..<self.arrCartData.count
                            {
                                let dic = self.arrCartData[i] as! NSDictionary
                                fCartTotal = fCartTotal + (dic[kkeyproductPrice] as! CGFloat)
                            }
                            
                            self.lblCartTotal.text = "$\(fCartTotal)"
                            self.lblScreenTitle.text = "YOUR BASKET (\(self.arrCartData.count) ITEM)"
                            
                            /*if (CGFloat(self.arrCartData.count) * 143.0) < MainScreen.height
                            {
                                self.tblCartHeightCT.constant = CGFloat(self.arrCartData.count)
                            }
                            else
                            {
                                self.tblCartHeightCT.constant =  MainScreen.height - 149
                            }*/
                            self.tblCart.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.tblCart.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    func btnRemoveAction(sender:UIButton)
    {
        let intRow = sender.tag
        let iDeleteId : Int = (arrCartData.object(at: intRow) as! NSDictionary).value(forKey: kkeyproductId) as! Int
        
        let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to remove this product from your cart?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in
            
            let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
            let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
            let token = final .value(forKey: "userToken")
            let headers = ["Authorization":"Bearer \(token!)"]
            
            let url = kServerURL + kRemoveProductfromCart
            let parameters: [String: Any] = ["product_id": iDeleteId]
            
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
                                    App_showAlert(withMessage: "Product removed from Cart Successfully", inView: self)
                                    self.getCartDetailsData()
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
        alertView.addAction(OKAction)
        let CancelAction = UIAlertAction(title: "No", style: .default)
        {
            (action) in
        }
        alertView.addAction(CancelAction)
        self.present(alertView, animated: true, completion: nil)

    }
    
    func btnUpdateQuantity(sender:UIButton)
    {
        let intRow = sender.tag
        let iDeleteId : Int = (arrCartData.object(at: intRow) as! NSDictionary).value(forKey: kkeyproductId) as! Int

            ActionSheetStringPicker.show(withTitle: "Select Quantity", rows: ["1", "2", "3","4","5","6","7","8","9","10"], initialSelection: 0, doneBlock: {
                picker, value, index in
                
                
                print("value = \(value)")
                print("index = \(index)")
                print("picker = \(picker)")
                let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
                let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
                let token = final .value(forKey: "userToken")
                let headers = ["Authorization":"Bearer \(token!)"]
                
                let url = kServerURL + kAddtoCart
                let parameters: [String: Any] = ["product_id": iDeleteId, "qty":  "\(index!)"]
                
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
                                        self.arrCartData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                                        
                                        var fCartTotal = CGFloat()
                                        for i in 0..<self.arrCartData.count
                                        {
                                            let dic = self.arrCartData[i] as! NSDictionary
                                            fCartTotal = fCartTotal + (dic[kkeyproductPrice] as! CGFloat)
                                        }
                                        
                                        self.lblCartTotal.text = "$\(fCartTotal)"
                                        self.lblScreenTitle.text = "YOUR BASKET (\(self.arrCartData.count) ITEM)"
                                        
                                       /* if (CGFloat(self.arrCartData.count) * 143.0) < MainScreen.height
                                        {
                                            self.tblCartHeightCT.constant = CGFloat(self.arrCartData.count)
                                        }
                                        else
                                        {
                                            self.tblCartHeightCT.constant =  MainScreen.height - 149
                                        }*/
                                        self.tblCart.reloadData()
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
                
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func btnBackAction(_ sender: Any)
    {
//
        if bPresent == true
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnProceedtoCheckoutAction(_ sender: Any)
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kordersCreate
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .post, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.vwOrderPlaced.isHidden = false
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ViewCartVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrCartData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCartCell", for: indexPath) as! viewCartCell
        cell.selectionStyle = .none
        let dic = self.arrCartData[indexPath.row] as! NSDictionary
        
        let strurl = dic[kkeyproductImage] as! String
        let url  = URL.init(string: strurl)
        cell.imgProduct.sd_setImage(with: url, placeholderImage: nil)
        
        cell.lblProductName.text = dic[kkeyproductTitle] as? String
        cell.lblProductDescription.text = dic[kkeyproductDescription] as? String
        cell.lblPrice.text = "$\(dic[kkeyproductPrice] as! Int)"
        cell.lblQty.text = "Qty: \(dic[kkeycartQty] as! Int)"
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(self.btnRemoveAction(sender:)), for: .touchUpInside)
        
        cell.btnQty.tag = indexPath.row
        cell.btnQty.addTarget(self, action: #selector(self.btnUpdateQuantity(sender:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}

class viewCartCell: UITableViewCell
{
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQty: UILabel!

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnQty: UIButton!

}
