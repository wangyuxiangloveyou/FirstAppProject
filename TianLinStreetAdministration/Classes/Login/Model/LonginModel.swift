    //
    //  LonginModel.swift
    //  Grass
    //
    //  Created by wangyuxiang on 2017/3/9.
    //  Copyright © 2017年 ShangHaiJinTian. All rights reserved.
    //
    
    import UIKit
    import Alamofire
    import SnapKit
    import Toast_Swift
    import MBProgressHUD
    import MJExtension
    
    @objc(LonginModel)
    
    class LonginModel: NSObject {
        var resultMessage:String?
        public var responseStatus : StatusModel1?
        public var token:String?
//        override func mj_keyValuesDidFinishConvertingToObject() {
//            self.responseStatus=StatusModel1.mj_object(withKeyValues: self.responseStatus)
//        }
    }
    class StatusModel1: NSObject {
        var resultCode:NSNumber?
        var resultMessage:String?
        var responseStatus:String?
    }
