//
//  EarlyWarningController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/3.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

public var smokeRed:NSNumber = 0
public var doorRed:NSNumber = 0
public var carStopRed:NSNumber = 0
class EarlyWarningController: UIViewController,UITableViewDelegate,UITableViewDataSource,navigationprotocol {
    var array1:[AnyObject]=[]
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor=UIColor.white
        
        //创建一个用于显示背景图片的imageView
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "mmexport1525609772323.jpg")
        backgroundImage.contentMode = .scaleAspectFill //等比缩放填充（图片可能有部分显示不全）
        //将背景图片imageView插入到当前视图中
        view.insertSubview(backgroundImage, at: 0)
        
        // self.view.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        //view.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        //        navigationController?.navigationBar.backgroundColor = UIColor.init(red: 24/255, green: 55/255, blue: 191/255, alpha: 1)
        
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 31/255, green: 80/255, blue: 203/255, alpha: 1)
        
       // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.hidesBackButton = false
        
        let backItem:UIBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
       // UINavigationBar.appearance().tintColor = UIColor.white
        self.title=villageName
        loadData1()
        
    }
    
    //获取预警展示列表
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
                "longitude":longitude,
                "latitude":latitude,
            ],
            "villageIDs":villageArray
        ]
        print(parameters)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "加载中"
        hud.dimBackground = true
        //背景渐变效果
        hud.alpha = 0.8
        Alamofire.request("http://47.75.190.168:5000/api/app/getEventNameList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print("获取预警展示列表")
            hud.hide(animated: true)
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print(dic)
                // let model = EarlyWarningModel.mj_object(withKeyValues: json)
                //  创建一个loginmodel对象
                let model1:EarlyWarningModel = EarlyWarningModel.mj_object(withKeyValues: dic)
                var arrDataSource:[AnyObject]=[]
                self.array1=model1.events!
                smokeRed=model1.events![0].unsolveNum!
                doorRed=model1.events![1].unsolveNum!
                carStopRed=model1.events![2].unsolveNum!
            }
            else
            {
                print("dic: \(response)")
            }
            self.configUI()
            self.tableView?.reloadData()
        }
    }
    
    func configUI()  {
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y: 70, width:screenWidth , height: screenHeight), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        self.view.addSubview(tableView!)
        tableView?.backgroundColor=UIColor.clear
        self.tableView?.isScrollEnabled = false
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(UINib(nibName: "EarlyWarningTableViewCell",bundle: nil), forCellReuseIdentifier: "EarlyWarningTableViewCellId")
    }
    func rightClick()  {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EarlyWarningController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:EarlyWarningTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EarlyWarningTableViewCellId", for: indexPath as IndexPath) as! EarlyWarningTableViewCell
        
        let model:warningEventsModel=self.array1[indexPath.row] as! warningEventsModel
        if indexPath.row == 0{
            cell.warningImage.image=UIImage(named:"烟感.png")
            
        }
        if indexPath.row == 1{
            cell.warningImage.image=UIImage(named:"门未关.png")
        }
        if indexPath.row == 2{
            cell.warningImage.image=UIImage(named:"停车.png")
        }
        
        cell.nameLabel.text = model.name
        let formattor = NumberFormatter()
        formattor.numberStyle = .decimal
        cell.numberLabel.text = formattor.string(from: model.unsolveNum!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = SmokeFeelingController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1{
            let vc = DoorNoCloseController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
            let vc = CarStopController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 3 {
            let vc = InspectController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //    //去掉UITableView的粘滞性
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let h: CGFloat = 54
    //        if scrollView.contentOffset.y >= h {
    //            scrollView.contentInset = UIEdgeInsetsMake(-h, 0, 0, 0)
    //
    //        }else if scrollView.contentOffset.y > 0 {
    //            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
    //        }
    //    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}

