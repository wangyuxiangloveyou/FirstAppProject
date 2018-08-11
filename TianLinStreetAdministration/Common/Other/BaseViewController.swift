//
//  BaseViewController.swift
//  PublicSecurityRepairs
//
//  Created by wangyuxiang on 2017/3/7.
//  Copyright © 2017年 ShangHaiJinTian. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //导航上面添加按钮
    func addNavBtn(imageName:String,target:AnyObject?,action:Selector,isLeft:Bool){
        let btn=UIButton.creatBtn(nil, bgImageName: imageName, highlightImageName: nil, selectImageName: nil, target: target, action: action)
        btn.frame=CGRect(x: 0, y: 0, width: 24, height: 36)
        let barBtn=UIBarButtonItem(customView: btn)
        if isLeft{
            navigationItem.leftBarButtonItem=barBtn
            
        }else{
            navigationItem.rightBarButtonItem=barBtn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
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
