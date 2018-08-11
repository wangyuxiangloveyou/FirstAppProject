//
//  SmokeModel.swift
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

@objc(SmokeModel)

class SmokeModel: NSObject {
    var resultMessage:String?
    public var events : [eventsModel]!
    public var prodcutName:String?
    var responseStatus:smokeStatusModel?
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["events" :NSStringFromClass(eventsModel.self)]
    }
//    override func mj_keyValuesDidFinishConvertingToObject() {
//           self.events = eventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [eventsModel]
//    }
}

class eventsModel: NSObject {
    var buildingNo:String?=""
    var createTime:String?
    var eventID:String?
    var residentNum:NSNumber?
    var houseNo:String?=""
    var status:NSNumber?
    var tag:[String]=[]
    var villageName:String?=""
    var people:[peopelmodel]?
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["people" :NSStringFromClass(peopelmodel.self)]
    }
//    override func mj_keyValuesDidFinishConvertingToObject() {
//    self.people = peopelmodel.mj_objectArray(withKeyValuesArray: self.people).copy() as? [peopelmodel]
//}
}

class smokeStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}

class peopelmodel: NSObject {
    var phone:NSNumber?
    var name:String?
    var relation:NSNumber?
}






