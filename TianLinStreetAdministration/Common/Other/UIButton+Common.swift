//
//  UIButton+Common.swift
//  PublicSecurityRepairs
//
//  Created by wangyuxiang on 2017/3/7.
//  Copyright © 2017年 ShangHaiJinTian. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    class func creatBtn(_ title:String?,bgImageName:String?,highlightImageName:String?,selectImageName:String?,target:AnyObject?,action:Selector?)->UIButton{
        let btn=UIButton(type: .custom)
        
        if let tmpTitle=title{
            btn.setTitle(tmpTitle, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
        }
        if let tmpBgImageName=bgImageName{
            btn.setBackgroundImage(UIImage(named: tmpBgImageName), for: .normal)
        }
        if let tmphighlightImageName=highlightImageName{
            btn.setBackgroundImage(UIImage(named: tmphighlightImageName), for: .highlighted)
        }
        if let tmpselectImageName=selectImageName{
            btn.setBackgroundImage(UIImage(named: tmpselectImageName), for: .selected)
        }
        if target != nil && action != nil{
            btn.addTarget(target, action: action!, for: .touchUpInside)
        }
        return btn
    }
}

