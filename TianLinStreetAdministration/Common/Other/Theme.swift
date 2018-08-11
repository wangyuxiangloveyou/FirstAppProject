//
//  Theme.swift
//  PublicSecurityRepairs
//
//  Created by wangyuxiang on 2017/3/7.
//  Copyright © 2017年 ShangHaiJinTian. All rights reserved.
//

import Foundation
import UIKit


let screenHeight=UIScreen.main.bounds.height
let screenWidth=UIScreen.main.bounds.width
let isIphoneX = screenHeight == 812 ? true : false
let navigationBarHeight : CGFloat = isIphoneX ? 68 : 44

//获取当前时间
let now = NSDate()
let timeInterval:TimeInterval = now.timeIntervalSince1970
let timeStamp = Int(timeInterval)

public typealias labelJumpClosure = ((UIView) -> Void)
//开放测试url
//催办维修单

let messagesUrl="http://192.168.0.27:13305/yunwei/v1/messages?all=false"
extension CATextLayer {
    class func createTextLayer()->CATextLayer {
        let badgeLayer=CATextLayer()
        badgeLayer.backgroundColor=UIColor.red.cgColor
        badgeLayer.foregroundColor=UIColor.white.cgColor
        badgeLayer.alignmentMode = kCAAlignmentCenter
        badgeLayer.frame=CGRect(x: 0, y: 0, width: 24, height: 24)
        badgeLayer.position=CGPoint(x: 0, y: 0)
        badgeLayer.isWrapped=true
        badgeLayer.cornerRadius=12
        badgeLayer.fontSize=13
        //badgeLayer.string="3"
        badgeLayer.anchorPoint=CGPoint.zero
        badgeLayer.contentsScale=UIScreen.main.scale
        return badgeLayer
    }
}

extension CAGradientLayer {
    class func createCAGradientLayer()->CAGradientLayer {
        //渐变颜色
        let gradientLayer1: CAGradientLayer = CAGradientLayer()
        let TColor1 = UIColor.init(red: 22/255, green: 207/255, blue: 243/255, alpha: 1)
        let BColor1 = UIColor.init(red: 0/255, green: 120/255, blue: 166/255, alpha: 1)
        let gradientColors1: [CGColor] = [TColor1.cgColor, BColor1.cgColor]
        gradientLayer1.colors = gradientColors1
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 0)
        //设置frame和插入view的layer
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: screenWidth/3-screenWidth/15, height: screenHeight/25)
        return gradientLayer1
    }
}


