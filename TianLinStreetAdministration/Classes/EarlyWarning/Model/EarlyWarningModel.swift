//
//  EarlyWarningModel.swift
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

@objc(EarlyWarningModel)

class EarlyWarningModel: NSObject {
    var resultMessage:String?
    public var events : [warningEventsModel]?
    public var prodcutName:String?
    var responseStatus:warningModel?
    var villageIDs:[String] = []

    override func mj_keyValuesDidFinishConvertingToObject() {
        self.events = warningEventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [warningEventsModel]
    }
}

class warningEventsModel: NSObject {
    var code:String?
    var name:String?
    var unsolveNum:NSNumber?
    var solveNum:NSNumber?
}

class warningModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}


