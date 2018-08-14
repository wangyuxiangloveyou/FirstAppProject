//
//  NewModel.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/30.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Toast_Swift
import MBProgressHUD
import MJExtension


import UIKit

class NewModel: NSObject {
        var alarmTime:String?
        var alarmID:String?
        var buildingNo:String?
        var houseNo:NSNumber?
        var state:NSNumber?
        var peopleName:String?
        var tag:[Any]?
        var bool1:Bool!
        var trafficRecords:[trafficRecordsModel1]?
        var visitorRecords:[visitorRecordsModel1]?
    override func setValue(_ value: Any?, forKey key: String) {
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

class trafficRecordsModel1: NSObject {
    var modelID:String?
    var modelName:String?
    var unsolveNum:String?
}

class visitorRecordsModel1: NSObject {
    var modelID:String?
    var modelName:String?
    var unsolveNum:String?
}



