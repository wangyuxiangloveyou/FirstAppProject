//
//  CompleteSmokeModel.swift
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

@objc(CompleteSmokeModel)

class CompleteSmokeModel: NSObject {
    var resultMessage:String?
    public var events : [CompleteSmokeEventsModel]!
    public var prodcutName:String?
    var responseStatus:CompleteSmokeStatusModel?
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
         return ["events" :NSStringFromClass(CompleteSmokeEventsModel.self)]
    }
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.events = CompleteSmokeEventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [CompleteSmokeEventsModel]
//    }
}

class CompleteSmokeEventsModel: NSObject {
    var buildingNo:NSNumber?
    var createTime:String?
    var eventID:String?
    var residentNum:NSNumber?
    var houseNo:NSNumber?
    var status:NSNumber?
    var tag:[String]=[]
    var villageName:String?
    var people:[comPeopelmodel]?
    var resultType:[NSNumber]=[]
    var resultContent:String?
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.people = comPeopelmodel.mj_objectArray(withKeyValuesArray: self.people).copy() as? [comPeopelmodel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["people" :NSStringFromClass(comPeopelmodel.self)]
    }
}

class CompleteSmokeStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}

class comPeopelmodel: NSObject {
    var phone:NSNumber?
    var name:String?
    var relation:NSNumber?
}
