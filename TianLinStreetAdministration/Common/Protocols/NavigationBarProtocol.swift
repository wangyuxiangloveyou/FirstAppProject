//
//  NavigationBarProtocol.swift
//  PublicSecurityRepairs
//
//  Created by wangyuxiang on 2017/3/8.
//  Copyright © 2017年 ShangHaiJinTian. All rights reserved.
//

import Foundation
import Foundation
import UIKit

enum BarButtonPosition {
    case left
    case right
}

protocol navigationprotocol:NSObjectProtocol {
    func addTitle(title:String)
    func addBarButton(title:String?,bgImageName:String?,postion:BarButtonPosition,select:Selector)
}

extension navigationprotocol where Self:UIViewController{
    func addTitle(title:String){
        let label=UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        label.font=UIFont.boldSystemFont(ofSize: 22)
        label.textColor=UIColor.black
        label.textAlignment = .center
        label.text = title
        navigationItem.titleView=label
        navigationController?.navigationBar.backgroundColor=UIColor.blue
//      navigationController?.navigationBar.setBackgroundImage(UIImage(named:"top-bg.png"), forBarMetrics: .Default)
    }
    
    func addBarButton(title:String?=nil,bgImageName:String?,postion:BarButtonPosition,select:Selector){
        let btn=UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 38))
        if title != nil{
            btn.setTitle(title, for: UIControlState())
        }
        if bgImageName != nil{
            let image:UIImage = UIImage(named:bgImageName!)!
            btn.setBackgroundImage(image , for: UIControlState())
            btn.frame = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        }
        btn.setTitleColor(UIColor.black, for: UIControlState())
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.addTarget(self, action: select, for: .touchUpInside)
        let tabBUttonItem=UIBarButtonItem(customView: btn)
        if postion == .left{
            if (navigationItem.leftBarButtonItems != nil){
                navigationItem.leftBarButtonItems=navigationItem.leftBarButtonItems!+[tabBUttonItem]
            }else{
                navigationItem.leftBarButtonItems=[tabBUttonItem]
            }
        }else{
            if navigationItem.rightBarButtonItems != nil{
                navigationItem.rightBarButtonItems=navigationItem.rightBarButtonItems!+[tabBUttonItem]
                
            }else{
                navigationItem.rightBarButtonItems=[tabBUttonItem]
            }
        }
    }
}
