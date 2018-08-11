//
//  HairpinViewController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/7.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class HairpinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
         view.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
         self.title="移动发卡"
        let backItem:UIBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 31/255, green: 80/255, blue: 203/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
