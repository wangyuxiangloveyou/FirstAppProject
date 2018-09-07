//
//  CompleteReadModel.swift
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


@objc(CompleteReadModel)

class CompleteReadModel: NSObject {
    var resultMessage:String?
    public var events : [CompleteReadEventsModel]?
    public var prodcutName:String?
    var responseStatus:CompleteReadStatusModel?
    
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.events = CompleteReadEventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [CompleteReadEventsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["events" :NSStringFromClass(CompleteReadEventsModel.self)]
    }
}

class CompleteReadEventsModel: NSObject {
    var creatTime:String?
    var eventID:String?
    var ratio:String?
    var houseNo:NSNumber?
    var status:NSNumber?
    var tag:[String]=[]
    var villageName:String?
    var describe:String?
    var title:String?
    var resultType:NSNumber?
}

class CompleteReadStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}
