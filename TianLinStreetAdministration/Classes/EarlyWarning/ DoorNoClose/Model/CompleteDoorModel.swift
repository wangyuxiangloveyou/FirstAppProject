
//
//  CompleteDoorModel.swift
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

@objc(CompleteDoorModel)

class CompleteDoorModel: NSObject {
    var resultMessage:String?
    public var events : [CompleteDoorEventsModel]?
    public var prodcutName:String?
    var responseStatus:CompleteDoorStatusModel?
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.events = CompleteDoorEventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [CompleteDoorEventsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["events" :NSStringFromClass(CompleteDoorEventsModel.self)]
    }
}

class CompleteDoorEventsModel: NSObject {
    var buildingNo:NSNumber?
    var createTime:String?
    var eventID:String?
    var residentNum:NSNumber?
    var houseNo:NSNumber?
    var status:NSNumber?
    var tag:[String]=[]
    var villageName:String?
}


class CompleteDoorStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}
