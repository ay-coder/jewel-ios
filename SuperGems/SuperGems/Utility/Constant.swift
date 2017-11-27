//
//  Constant.swift
//  YoBored_New
//
//  Created by Bhavik on 18/07/16.
//  Copyright © 2016 Bhavik. All rights reserved.
//

import Foundation
import UIKit

let MainScreen = UIScreen.main.bounds.size

let appDelegate     = UIApplication.shared.delegate as! AppDelegate
let userDefaults    = UserDefaults.standard
let Application_Name  =  "Super Gems"
let Alert_NoInternet    = "You are not connected to internet.\nPlease check your internet connection."
let kPrivacyTermsVCViewID = "PrivacyTermsVC"
let Alert_NoDataFound    = "No Data Found."


let kForgotPasswordVCViewID = "ForgotPasswordVC"


let kkeydata = "data"
let kkeymessage = "message"
let kkeyuserid = "id"
let kkeyuser_name = "user_name"
let kkeyemail = "email"
let kkeybio = "bio"
let kkeydevice_id = "device_id"
let kkeyimage = "image"
let kkeystatus = "status"
let kkeyvisibility = "visibility"
let kkeyname = "name"
let kkeyaddress = "address"
let kkeyfirst_name = "first_name"
let kkeylast_name = "last_name"
let kkeyfollowing = "following"
let kkeylat = "lat"
let kkeylon = "lon"
let kkeyuser = "user"
let kkeyLoginData = "LoginData"
let kkeyAllCampusUser = "AllCampusUser"

let kkeyisMember = "isMember"
let kkeyisLeader = "isLeader"
let kkeyisPrivate = "isPrivate"
let kkeymemberStatus = "memberStatus"
let kkeyis_attachment = "is_attachment"
let kkeyattachment_link = "attachment_link"

let kkeyisUserLogin = "UserLogin"
let kkeyError = "error"
let kkeyCampusCode = "CampusCode"
let kkeyCampusID = "campusID"
let kkeyMessage = "message"

let kkeytext = "text"
let kkeytime = "time"
let kkeytitle = "title"
let kkeysubtitle = "subtitle"

let kNO = "NO"
let kYES = "YES"

let kFBAPPID = "128398547683260"


let kServerURL = "http://52.66.73.127/jewel/public/api/"

let kWhatsNewAPI = "products"
let kcategories = "categories"
let kAddtoCart = "products/add-to-cart"
let kGetCartDetails = "products/get-cart"
let kRemoveProductfromCart = "products/remove-product-from-cart"
let kProductsbyCategoryID = "products-by-category"
let kFeaturedData = "categories/featured"
let kordersCreate = "orders/create"

let kkeyproductTitle = "productTitle"
let kkeyproductImage = "productImage"
let kkeyproductPrice = "productPrice"
let kkeyproductDescription = "productDescription"
let kkeyproductId = "productId"
let kkeycategoryId = "categoryId"
let kkeycartQty = "cartQty"

let kkeycategoryImage = "categoryImage"
let kkeycategoryTitle = "categoryTitle"
let kkeyproductsCount = "productsCount"


let kSignUP = "register"
let kLogin = "login"
let kGuestLogin = "register-guest"

let kEditProfileAPI = "user-profile/update-profile"

let kPrivacy = "privacy-policy"
let kTermsConditions = "terms-conditions"

var progressView : UIView?

//var CurrentUser : ModelUser = ModelUser()
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: self)
    }
}
