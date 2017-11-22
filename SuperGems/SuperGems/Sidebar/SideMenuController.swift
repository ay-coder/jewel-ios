//
//  SideMenuController.swift
//  SJSwiftNavigationController
//
//  Created by Mac on 12/19/16.
//  Copyright © 2016 Sumit Jagdev. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var menuTableView : UITableView!
   
    var menuItems : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuTableView.estimatedRowHeight = 200.0
        self.menuTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTableView.allowsSelection = true
        menuTableView.isUserInteractionEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 9
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Sidebar2
            cell.selectionStyle = .none

            switch indexPath.row
            {
                case 0:
                    cell.lblTitle.text = "View Cart"
                    break
                case 1:
                    cell.lblTitle.text = "Logout"
                    break
                default:
                    break
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SJSwiftSideMenuController.hideLeftMenu()
        switch indexPath.row
        {
            case 0:
                break
            case 1:
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rootVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
                SJSwiftSideMenuController.pushViewController(rootVC, animated: true)
                break
            default:
                break
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

class Sidebar2 : UITableViewCell
{
    @IBOutlet weak var lblTitle : UILabel!
}
