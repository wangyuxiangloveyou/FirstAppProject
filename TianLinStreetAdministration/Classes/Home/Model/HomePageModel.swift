
//
//  HomePageModel.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/26.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Toast_Swift
import MBProgressHUD
import MJExtension

@objc(HomePageModel)

class HomePageModel: NSObject {
    var resultMessage:String?
    public var functions : [functionModel]?
    public var prodcutName:String?
    var responseStatus:HomeStatusModel?
    var villages:[villageModel]?
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["functions" :NSStringFromClass(functionModel.self),"villages" :NSStringFromClass(villageModel.self)]
    }
}

class villageModel: NSObject {
    var villageID:String?
    var villageName:String?
    
}

class functionModel: NSObject {
    var unsolveNum:NSNumber?
    var name:String?
     var code:String?
    
}

class HomeStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
    var responseStatus:String?
}
