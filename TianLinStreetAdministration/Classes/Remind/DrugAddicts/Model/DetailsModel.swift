//
//  DetailsModel.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/26.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Toast_Swift
import MBProgressHUD
import MJExtension


//protocol Copyable {
//    func copy() -> Self
//}

@objc(DetailsModel)


class DetailsModel: NSObject {
    var alarms:[alarmsDetailsModel]?
    var responseStatus:DetailsStatusModel?
  

//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.alarms = alarmsDetailsModel.mj_objectArray(withKeyValuesArray: self.alarms).copy() as? [alarmsDetailsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["alarms" :NSStringFromClass(alarmsDetailsModel.self)]
    }
}

class alarmsDetailsModel: NSObject,NSCopying{
    
    func copy(with zone: NSZone? = nil) -> Any {
        let alarmsDetailsModel1=alarmsDetailsModel()
        alarmsDetailsModel1.state=self.state
        alarmsDetailsModel1.alarmID=self.alarmID
        alarmsDetailsModel1.alarmTime=self.alarmTime
        alarmsDetailsModel1.buildingNo=self.buildingNo
        alarmsDetailsModel1.houseNo=self.houseNo
        alarmsDetailsModel1.peopleName=self.peopleName
        alarmsDetailsModel1.tag=self.tag
        alarmsDetailsModel1.trafficRecords=self.trafficRecords
        alarmsDetailsModel1.visitorRecords=self.visitorRecords
         return alarmsDetailsModel1
    }
    
//    func copyWithZone(zone: NSZone) -> AnyObject {
//        let alarmsDetailsModel = alarmsDetailsModel()
//        alarmsDetailsModel.name = self.name
//        return theCopyObj
//    }
    //必须使用required关键字修饰
    required override init() {
        
    }
    var alarmTime:String?
    var alarmID:String?
    var buildingNo:String?
    var houseNo:NSNumber?
    var state:NSNumber?
    var peopleName:String?
    var tag:[Any]?
    var bool1:NSNumber!
    var trafficRecords:[trafficRecordsModel]?
    var visitorRecords:[visitorRecordsModel]?
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.trafficRecords = trafficRecordsModel.mj_objectArray(withKeyValuesArray: self.trafficRecords).copy() as? [trafficRecordsModel]
         self.visitorRecords = visitorRecordsModel.mj_objectArray(withKeyValuesArray: self.visitorRecords).copy() as? [visitorRecordsModel]
    }
}

class DetailsStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}
class trafficRecordsModel: NSObject {
    var modelID:String?
    var modelName:String?
    var unsolveNum:String?
}
class visitorRecordsModel: NSObject {
    var modelID:String?
    var modelName:String?
    var unsolveNum:String?
}

//class a: alarmsDetailsModel {
//    override init() {
//        self.bool1=bool1
//    }
//}
