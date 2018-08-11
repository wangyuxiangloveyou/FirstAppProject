//
//  UILabel+Common.swift
//  WangyuxiangLivevideo
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 zhb. All rights reserved.
//

import Foundation
import UIKit


extension UILabel{
    class func creatLabel(text:String?,textAlignmet:NSTextAlignment?,font:UIFont?)->UILabel{
        let label=UILabel()
        if let tmpText = text{
            label.text=tmpText
        }
        if let tmpAlignmet=textAlignmet{
            label.textAlignment=tmpAlignmet
        }
        if let tmpfont = font{
            label.font=tmpfont
        }
        return label
    }
}
