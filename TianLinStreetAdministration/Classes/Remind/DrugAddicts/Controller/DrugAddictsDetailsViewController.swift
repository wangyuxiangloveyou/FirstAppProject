//
//  DrugAddictsDetailsViewController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/12.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire



class DrugAddictsDetailsViewController: UIViewController {
    var tableView:UITableView?
    var dataSource:[[AnyObject]]=[]
    var dataSource1:[AnyObject]=[]
    var smallDataSource:[AnyObject]=[]
   var number3=1
    var idName=""
    var clourse:IngreJumpClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        self.title="吸毒人员监控"
        loadData2()
        //c()
    }
    
    
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "alarmID":self.idName,
            "resultType":1,
            ]
        print(parameters)
        
        Alamofire.request("http://47.75.190.168:5000/api/app/alarmProcessReport", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print("报警上传")
            //print(villageID)
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(json)")
                print(dic)
                 let Model : LonginModel = LonginModel.mj_object(withKeyValues: json)
                if Model.responseStatus?.resultCode == 0{
                    self.loadData2()
                }
            }
            else
            {
                print("dic: \(response)")
            }
            
        }
    }
    
    func loadData2()
    {
        var state=0
        if name2==1{
            state=1
        }else{
           state=0
        }
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "modelID": name1,
            "state": state,
            "villageIDs": villageArray,
            "pageNum": 1,
            "pageSize": 100
        ]
        
        print("获取报警信息")
        print(parameters)
        print(1111111111111111)
        
        Alamofire.request("http://47.75.190.168:5000/api/app/getAlarmList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("~~~~~~~~~~~~~~~~~~~~~~")
                print(json)
                print(dic)
                
                if (json?.length)! >= 60{
                    let model1:DetailsModel = DetailsModel.mj_object(withKeyValues: dic)
                     self.dataSource1.removeAll()
                    var dic1=NewModel()
                   dic1.alarmTime=model1.alarms![0].alarmTime
                    dic1.alarmID=model1.alarms![0].alarmID
                   dic1.state=1
                   self.dataSource1.append(dic1)
                    for i in 0..<model1.alarms!.count-1{
                        //初始化日期格式器
                        //if i<model1.alarms!.count-1{
                            let sub1 = model1.alarms![i].alarmTime!.prefix(10)
                            let sub2 = model1.alarms![i+1].alarmTime!.prefix(10)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            let oneDate = formatter.date(from: String(sub1))
                            let twoDate = formatter.date(from: String(sub2))
                            if  oneDate! != twoDate!  {
                                let dic5=NewModel()
                                dic5.alarmTime=model1.alarms![i].alarmTime
                                dic5.alarmID=model1.alarms![i].alarmID
                                dic5.state=0
                                self.dataSource1.append(dic5)
                                
                                let dic4=NewModel()
                                dic4.alarmTime=model1.alarms![i+1].alarmTime
                                 dic4.alarmID=model1.alarms![i+1].alarmID
                                dic4.state=1
                                self.dataSource1.append(dic4)
                            }
                            if  oneDate! == twoDate!  {
                                let dic2=NewModel()
                                dic2.alarmTime=model1.alarms![i].alarmTime
                                dic2.alarmID=model1.alarms![i].alarmID
                                dic2.state=0
                                self.dataSource1.append(dic2)
                            }
                            if  i==model1.alarms!.count-2  {
                                let dic3=NewModel()
                                dic3.alarmTime=model1.alarms![i+1].alarmTime
                                dic3.alarmID=model1.alarms![i+1].alarmID
                                dic3.state=0
                                self.dataSource1.append(dic3)
                            }
                    }
                }
            }
            else
            {
                print("dic: \(response)")
            }
            
            self.configUI()
            print(self.dataSource1)
            self.tableView?.reloadData()
        }
    }
    
    
    
    func c()  {
//        [1.3.3.1.2.2];
        var data:[Int] = []
        var array1=[4,4,4,4,4,4,3,3,2,2]
        [1,3,3,1,2,2]
         data.append(1)
        for i in 0..<array1.count-1{
            if array1[i] != array1[i+1]{
                 data.append(array1[i])
                data.append(1)
            }
            if array1[i] == array1[i+1]{
                data.append(array1[i])
            }
            if  i==array1.count-2 {
              data.append(array1[i+1])
            }
        }

       print(data)
    }
    func configUI(){
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y:40, width:screenWidth , height: screenHeight-40), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        view.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //        tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //        tableView?.allowsSelection = true
        //设置分割线颜色
        // self.tableView?.separatorColor = UIColor.white
        //  self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView?.register(UINib(nibName: "DrugAddictsDetailsCell",bundle: nil), forCellReuseIdentifier: "DrugAddictsDetailsCellId")
               tableView?.register(UINib(nibName: "TitleTableViewCell",bundle: nil), forCellReuseIdentifier: "TitleTableViewCellId")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DrugAddictsDetailsViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource1.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let model:NewModel=dataSource1[indexPath.section] as! NewModel
        if model.state == 1{
         return 35
        }
        if model.state == 0{
            return 85
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let model:NewModel=dataSource1[indexPath.section] as! NewModel
        print(model.state)
        if model.state==1{
            let cell:TitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCellId", for: indexPath as IndexPath) as! TitleTableViewCell
                  cell.numberLabel.text=model.peopleName
            cell.timeLabel.text=model.alarmTime
            cell.selectionStyle = .none
            return cell
        }
        if model.state==0{
             let cell:DrugAddictsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "DrugAddictsDetailsCellId", for: indexPath as IndexPath) as! DrugAddictsDetailsCell
            cell.nameLabel.font=UIFont.systemFont(ofSize: 12)
            cell.nameLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
            let str = "田林十二村-4栋-202"
            let moneyTitle = NSMutableAttributedString.init(string:str)
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:6, length: 1))
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:9, length: 3))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:6, length: 1))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:9, length: 3))
            cell.nameLabel.attributedText = moneyTitle
            cell.timeLabel.text=model.alarmTime
//           cell.suspiciousLabel.text="可疑"
//           cell.suspiciousLabel.isHidden=true
           return cell
        }
    
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
         let model:NewModel=dataSource1[indexPath.section] as! NewModel
        if model.state==1{
            return false
        }else{
            return true
        }
        return true
    }
    
    //返回每一个行对应的事件按钮
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            //创建“更多”事件按钮
            let more = UITableViewRowAction(style: .normal, title: "标记\n可疑") {
                action, index in
                
                 let model:NewModel=self.dataSource1[indexPath.section] as! NewModel
                self.idName=model.alarmID!
                print(self.idName)
                self.loadData1()
                
                print(11111111111)
            }
            
            more.backgroundColor = UIColor.orange
            more.accessibilityFrame=CGRect(x: 0, y: 5, width: 260, height: 75)
            // let view:UITableViewCellDeleteConfirmationView=UITab
           
            //返回所有的事件按钮
            return [more]
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let HeaderView=DetailHeaderView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 30))
//        HeaderView.backgroundColor=UIColor.white
//        return HeaderView
//    }

//    //设置header的高度
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
}




























//                    for i in 0..<model1.alarms!.count{
//                        //初始化日期格式器
//                        if i<model1.alarms!.count-1{
//                        let sub1 = model1.alarms![i].alarmTime!.prefix(10)
//                        let sub2 = model1.alarms![i+1].alarmTime!.prefix(10)
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy-MM-dd"
//                            let oneDate = formatter.date(from: String(sub1))
//                            let twoDate = formatter.date(from: String(sub2))
//
//                        if  oneDate! == twoDate!  {
//                            self.smallDataSource.append(model1.alarms![i].alarmTime as AnyObject)
//                            self.smallDataSource.append(model1.alarms![i+1].alarmTime as AnyObject)
//                        }
//                            if #available(iOS 11.0, *) {
//                                if  oneDate! > twoDate!  {
//                                    self.dataSource.append((self.smallDataSource as AnyObject) as! [AnyObject])
//                                    self.smallDataSource.removeAll()
//                                }
//                                if  i==model1.alarms!.count-2{
//                                    self.dataSource.append((self.smallDataSource as AnyObject) as! [AnyObject])
//                                    //self.smallDataSource.removeAll()
//                                }
//                            } else {
//                                // Fallback on earlier versions
//                            }
//                        }
//                    }
