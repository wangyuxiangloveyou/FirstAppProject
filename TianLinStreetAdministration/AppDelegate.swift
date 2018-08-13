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



public var longitude:Double=0.0000
public var latitude:Double=0.0000
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate{

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

