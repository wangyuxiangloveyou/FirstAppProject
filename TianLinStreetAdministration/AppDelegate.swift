//
//  AppDelegate.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/1.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import PushKit
import Alamofire
import Toast_Swift



public var longitude:Double=0.0000
public var latitude:Double=0.0000
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,JPUSHRegisterDelegate{
    
    
    var registrationID:String=""
    var window: UIWindow?
    let locationManager:CLLocationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        if #available(iOS 11.0, *) {
            let nav = UINavigationController.init(rootViewController: LoginInterfaceViewController())
            window?.rootViewController = nav
        } else {
            // Fallback on earlier versions
        }
        window?.makeKeyAndVisible()
        //控制整个功能是否启用。
        IQKeyboardManager.sharedManager().enable = true
        //控制点击背景是否收起键盘
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        UIApplication.shared.cancelAllLocalNotifications()
        
        
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //最佳定位
        //更新距离
        locationManager.distanceFilter = 100
        //发出授权请求
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            //允许使用定位服务的话，开始定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
        //推送
        // 通知注册实体类
        let entity = JPUSHRegisterEntity();
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self as! JPUSHRegisterDelegate);
        // 注册极光推送
        print("十倍")
        JPUSHService.setup(withOption: launchOptions, appKey: "703065f0aca11ea9b15c2c12", channel:"Publish channel" , apsForProduction: false);
        //        JPUSHService.setup(withOption: launchOptions, appKey: "703065f0aca11ea9b15c2c12", channel: JPushChannel, apsForProduction: isProduction)
        // 获取推送消息
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>;
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!  // 持续更新
        // 获取经纬度
        //        latitude.text = "纬度:\(currLocation.coordinate.latitude)"
        //        longitude.text = "纬度:\(currLocation.coordinate.longitude)"
        //获得海拔
        print("纬度:\(currLocation.coordinate.latitude)")
        print("经·度:\(currLocation.coordinate.longitude)")
        latitude=currLocation.coordinate.latitude
        longitude=currLocation.coordinate.longitude
        
    }
    
    
    
    // MARK: -JPUSHRegisterDelegate
    // iOS 10.x 需要
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo;
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler();
        // 应用打开的时候收到推送消息
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        let device = NSData(data: deviceToken)
        let deviceId = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        
        registrationID=deviceId
        print(deviceId)
        loadPost()
    }
    func loadPost(){
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":"app",
                "longitude":longitude,
                "latitude":latitude,
            ],
            "registrationID": registrationID
            
        ]
        Alamofire.request("http://47.75.190.168:5000/api/app/pushRegistrationID", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            let json = response.result.value
            print("json: \(json)")
            let loginModel : LonginModel = LonginModel.mj_object(withKeyValues: json)
            if loginModel.responseStatus?.resultCode == 0{
            }else{
            }
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(UIBackgroundFetchResult.newData);
    }
    // 接收到推送实现的方法
    @objc func receivePush(_ userInfo : Dictionary<String,Any>) {
        // 角标变0
        UIApplication.shared.applicationIconBadgeNumber = 0;
        // 剩下的根据需要自定义
        //        self.tabBarVC?.selectedIndex = 0;
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

