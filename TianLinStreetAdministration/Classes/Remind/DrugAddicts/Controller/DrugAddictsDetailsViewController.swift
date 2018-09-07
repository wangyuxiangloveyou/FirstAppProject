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
import MJRefresh
import MBProgressHUD

class DrugAddictsDetailsViewController: UIViewController {
    var shouldLoadMoreData = true
    var state=0
    var index = 1
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var pageNum=0
    var tableView:UITableView?
    var dataSource:[[AnyObject]]=[]
    var dataSource1:[AnyObject]=[]
    var smallDataSource:[AnyObject]=[]
    var number3=1
    var idName=""
    var clourse:IngreJumpClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
         view.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        self.title="吸毒人员监控"
        startRefreshData1()
    }
    
    
    func loadData1()
    {
        var resultType=0
        if state == 0 {
            resultType == 1
        }
        if state == 1{
             resultType == 2
        }
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "alarmID":self.idName,
            "resultType":resultType,
            ]
        print(parameters)
        Alamofire.request("http://47.75.190.168:5000/api/app/alarmProcessReport", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print("报警上传")
             //hud.hide(animated: true)
            //print(villageID)
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(json)")
                print(dic)
                let Model : LonginModel = LonginModel.mj_object(withKeyValues: json)
                if Model.responseStatus?.resultCode == 0{
                    
                }
            }
            else
            {
                print("dic: \(response)")
            }
            self.startRefreshData1()
        }
        
    }
    
    func loadData2()
    {
        
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
                "longitude":longitude,
                "latitude":latitude,
            ],
            "modelID": name1,
            "state": state,
            "villageIDs": villageArray,
            "pageNum": index,
            "pageSize": 20
        ]
        
       // print("获取报警信息")
       // print(parameters)
       // print(1111111111111111)
        
        Alamofire.request("http://47.75.190.168:5000/api/app/getAlarmList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("~~~~~~~~~~~~~~~~~~~~~~")
                print(json)
                print(dic)
                 let model1:DetailsModel = DetailsModel.mj_object(withKeyValues: dic)
               if model1.responseStatus?.resultCode == 0 && model1.alarms != nil
                
                {
                    self.dataSource1.removeAll()
                    let dic1 : alarmsDetailsModel = model1.alarms![0].copy() as! alarmsDetailsModel
                    dic1.state=1
                    self.dataSource1.append(dic1)
                    if model1.alarms!.count == 1{
                        let dic2:alarmsDetailsModel=model1.alarms![0].copy() as! alarmsDetailsModel
                        dic2.state=0
                        self.dataSource1.append(dic2)
                    }
                    for i in 0..<model1.alarms!.count-1
                    {
                        //初始化日期格式器
                        //if i<model1.alarms!.count-1{
                        let sub1 = model1.alarms![i].alarmTime!.prefix(10)
                        let sub2 = model1.alarms![i+1].alarmTime!.prefix(10)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let oneDate = formatter.date(from: String(sub1))
                        let twoDate = formatter.date(from: String(sub2))
                        if  oneDate! != twoDate!  {
                            let dic5:alarmsDetailsModel=model1.alarms![i].copy() as! alarmsDetailsModel
                            dic5.state=0
                            self.dataSource1.append(dic5)
                            let dic4:alarmsDetailsModel=model1.alarms![i+1].copy() as! alarmsDetailsModel
                            dic4.state=1
                            self.dataSource1.append(dic4)
                        }
                        
                        if  oneDate! == twoDate!  {
                            let dic2:alarmsDetailsModel=model1.alarms![i].copy() as! alarmsDetailsModel
                            dic2.state=0
                            self.dataSource1.append(dic2)
                        }
                        
                        if  i==model1.alarms!.count-2  {
                            let dic3:alarmsDetailsModel=model1.alarms![i+1].copy() as! alarmsDetailsModel
                            dic3.state=0
                            self.dataSource1.append(dic3)
                        }
                    }
            
                    let c =  self.dataSource1.count
                    self.shouldLoadMoreData = c >= 20
                    if c>0
                    {
                        if self.index > 1
                        {
                            for i in 0..<c
                            {
                                self.dataSource1.append(self.dataSource1[i])
                            }
                        }
                        else if self.index == 1
                        {
                            //self.dataSource1 = model1.alarms!
                        }
                    }
                    else
                    {
                        //self.tableView!.mj_footer.endRefreshingWithNoMoreData()
                    }
                
                }
            }
            else
            {
                print("dic: \(response)")
            }
            
            // 结束刷新
            self.tableView?.reloadData()
            self.configUI()
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
        }
    }
    
    
    
    func c()  {
        // [1.3.3.1.2.2];
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
    //顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        // self.tableView?.mj_header.beginRefreshing()
        index=1
        loadData2()
    }
    
    // 底部刷新
    
    func footerRefresh()
    {
        index = index + 1
        if shouldLoadMoreData {
            loadData2()
        } else {
            self.tableView!.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    func startRefreshData1()
    {
        self.tableView?.mj_header.beginRefreshing()
        index = 1
        loadData2()
    }
    func configUI(){
        //创建表格试图
        
        tableView=UITableView(frame: CGRect(x: 0, y:69, width:screenWidth , height: screenHeight-69), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
         tableView?.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
       // tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
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
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        tableView?.mj_header = header
        header.setTitle("", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView?.mj_footer = footer
        footer.setTitle("", for: .idle)
        footer.setTitle("释放加载", for: .pulling)
        footer.setTitle("正在加载...", for: .refreshing)
        footer.setTitle("没有更多数据", for: .noMoreData)
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
        let model:alarmsDetailsModel=dataSource1[indexPath.section] as! alarmsDetailsModel
        if model.state == 1{
            return 35
        }
        if model.state == 0{
            return 85
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let model:alarmsDetailsModel=dataSource1[indexPath.section] as! alarmsDetailsModel
        print(model.state)
        
        if model.state==1{
            let cell:TitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCellId", for: indexPath as IndexPath) as! TitleTableViewCell
            cell.numberLabel.text=comDrugAddictName
            cell.timeLabel.text=model.alarmTime
            cell.selectionStyle = .none
            return cell
        }
        if model.state==0{
            let cell:DrugAddictsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "DrugAddictsDetailsCellId", for: indexPath as IndexPath) as! DrugAddictsDetailsCell
            cell.refreshData(model:model)
            cell.nameLabel.font=UIFont.systemFont(ofSize: 12)
            cell.nameLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
//            let str = villageName
//            let moneyTitle = NSMutableAttributedString.init(string:str)
//            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:6, length: 1))
//            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:9, length: 3))
//            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:6, length: 1))
//            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:9, length: 3))
            cell.nameLabel.text = villageName
            if state == 1{
           cell.suspiciousLabel.text="可疑"
            cell.suspiciousLabel.backgroundColor=UIColor.orange
            cell.suspiciousLabel.textAlignment = .center
            }
            cell.peopleLabel.text=model.peopleName
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        let model:alarmsDetailsModel=dataSource1[indexPath.section] as! alarmsDetailsModel
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
            var name1=""
            if state == 0{
                name1="标记\n可疑"
            }
            if state == 1{
                name1="取消\n可疑"
            }
            let more = UITableViewRowAction(style: .normal, title: name1) {
                action, index in
                let model:alarmsDetailsModel=self.dataSource1[indexPath.section] as! alarmsDetailsModel
                self.idName=model.alarmID!
                print(self.idName)
                self.loadData1()
            }
            more.backgroundColor=UIColor.init(red: 24/255, green: 127/255, blue: 230/255, alpha: 1)
//            //more.accessibilityFrame=CGRect(x: 0, y: 5, width: 260, height: 75)
//            //渐变颜色
//            let TColor = UIColor.init(red: 37/255, green: 77/255, blue: 222/255, alpha: 1)
//            let BColor = UIColor.init(red: 0/255, green: 255/255, blue: 255/255, alpha: 1)
//            let gradientColors: [CGColor] = [TColor.cgColor, BColor.cgColor]
//            let gradientLayer: CAGradientLayer = CAGradientLayer()
//            gradientLayer.colors = gradientColors
//            //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
//            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//            //设置frame和插入view的layer
//            gradientLayer.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/12)
//            //let label1=UILabe
//            self.view.layer.insertSublayer(gradientLayer, at: 0)
//           // more.layer.insertSublayer(gradientLayer, at: 0)
            return [more]
    }
    
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
