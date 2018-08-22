
//
//  UntreatedDoorModel.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/27.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Toast_Swift
import MBProgressHUD
import MJExtension

@objc(UntreatedDoorModel)

class UntreatedDoorModel: NSObject {
    var resultMessage:String?
    public var events : [UntreatedDoorEventsModel]?
    public var prodcutName:String?
    var responseStatus:UntreatedDoorStatusModel?
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.events = UntreatedDoorEventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [UntreatedDoorEventsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["events" :NSStringFromClass(UntreatedDoorEventsModel.self)]
    }
}

class UntreatedDoorEventsModel: NSObject {
    var buildingNo:NSNumber?
    var createTime:String?
    var eventID:String?
    var residentNum:NSNumber?
    var houseNo:NSNumber?
    var status:NSNumber?
    var tag:[String]=[]
    var villageName:String?
    var options:[optionsModel]?
    var key:String?
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.options = optionsModel.mj_objectArray(withKeyValuesArray: self.options).copy() as? [optionsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["options" :NSStringFromClass(optionsModel.self)]
    }
}

class UntreatedDoorStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}
class optionsModel: NSObject {
    var code:String?
    var name:String?
}










