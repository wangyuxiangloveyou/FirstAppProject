

//
//  UnDrugAddictsModel.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/19.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Toast_Swift
import MBProgressHUD
import MJExtension

@objc(UnDrugAddictsModel)

class UnDrugAddictsModel: NSObject {
    var resultMessage:String?
    public var groups : [UnDrugAddictsGroupsModel]?
    var responseStatus:UnDrugAddictsStatusModel?
    
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.groups = UnDrugAddictsGroupsModel.mj_objectArray(withKeyValuesArray: self.groups).copy() as? [UnDrugAddictsGroupsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["groups" :NSStringFromClass(UnDrugAddictsGroupsModel.self)]
    }
}

class UnDrugAddictsGroupsModel: NSObject {
    var models:[modelsModel]?
    var groupName:String?
    var unsolveNum:NSNumber?
    var prodcutName:String?
    
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.models = modelsModel.mj_objectArray(withKeyValuesArray: self.models).copy() as? [modelsModel]
//    }
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["models" :NSStringFromClass(modelsModel.self)]
    }
}

class UnDrugAddictsStatusModel: NSObject {
    var resultCode:NSNumber?
    var resultMessage:String?
}
class modelsModel: NSObject {
    var modelID:String?
    var modelName:String?
    var unsolveNum:String?
}
