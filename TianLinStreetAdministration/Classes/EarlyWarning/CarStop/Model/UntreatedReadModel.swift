
//
//  UntreatedReadModel.swift
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

@objc(UntreatedReadModel)

class UntreatedReadModel: NSObject {
    
    var resultMessage:String?
    public var events : [UntreatedReadEventsModel]?
    public var prodcutName:String?
    var responseStatus:UntreatedReadStatusModel?
    
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.events = UntreatedReadEventsModel.mj_objectArray(withKeyValuesArray: self.events).copy() as? [UntreatedReadEventsModel]
//    }
        override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
            return ["events" :NSStringFromClass(UntreatedReadEventsModel.self)]
        }
}

class UntreatedReadEventsModel: NSObject {
    var creatTime:String?
    var eventID:String?
    var ratio:String?
    var houseNo:NSNumber?
    var status:NSNumber?
    var tag:[String]=[]
    var villageName:String?
    var describe:String?
    var title:String?
}

class UntreatedReadStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}
