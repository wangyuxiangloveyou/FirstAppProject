//
//  CompleteSmokeView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import MJRefresh

class CompleteSmokeView: UIView,RefreshProtocol{
    func addRefresh(header: (() -> ())?, footer: (() -> ())?) {
        tableView?.mj_footer.endRefreshing()
        tableView?.mj_header.endRefreshing()
    }
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var pageNum=0
    var tableView:UITableView?
    var dataArray:[AnyObject]=[]
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        loadData1()
    }
    
    func configUI()  {
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.addSubview(tableView!)
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.isScrollEnabled = true
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "CompleteSmokeCell",bundle: nil), forCellReuseIdentifier: "CompleteSmokeCellId")
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        // 现在的版本要用mj_header
        tableView?.mj_header = header
        header.setTitle("", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        tableView?.mj_footer = footer
        footer.setTitle("", for: .idle)
        footer.setTitle("释放加载", for: .pulling)
        footer.setTitle("正在加载...", for: .refreshing)
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        self.tableView?.mj_header.beginRefreshing()
        loadData1()
    }
    
    // 底部刷新
    var index = 0
    func footerRefresh(){
        print("上拉刷新")
        self.tableView?.mj_footer.endRefreshing()
        
        // 2次后模拟没有更多数据
        index = index + 1
        if index > 2 {
            self.tableView?.mj_footer.endRefreshing()
        }
    }
    func startRefreshData()
    {
        self.tableView?.mj_header.beginRefreshing()
        loadData1()
    }
    // 顶部刷新
    //    func headerRefresh(){
    //        print("下拉刷新")
    //        // 结束刷新
    //        self.tableView?.mj_header.beginRefreshing()
    //        loadData1()
    //    }
    //
    //    // 底部刷新
    //    var index = 1
    //    func footerRefresh(){
    //        index = index + 1
    //        self.tableView?.mj_footer.beginRefreshing()
    //        loadData1()
    //    }
    
    //    func startRefreshData1()
    //    {
    ////        self.tableView?.mj_header.beginRefreshing()
    ////        loadData1()
    //    }
    
    //获取烟感事件列表
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
            "villageIDs":villageArray,
            "status":2,
            "pageNum":1,
            "pageSize":20,
            ]
        print(parameters)
        
        Alamofire.request("http://47.75.190.168:5000/api/app/getSmokeDetectorEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print("获取烟感已处理事件列表")
            print(villageID)
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(json)")
                print(dic)
                print((json?.length)!)
                if (json?.length)! >= 60 {
                    let model:CompleteSmokeModel = CompleteSmokeModel.mj_object(withKeyValues: dic)
                    // self.dataArray.removeAll()
                    self.dataArray=model.events!
                }
                print(self.dataArray.count)
            }
            else
            {
                print("dic: \(response)")
            }
            
            self.tableView?.reloadData()
            // 结束刷新
            self.tableView?.mj_header.endRefreshing()
            
        }
    }
    
    //    //获取烟感事件列表
    //    func loadData1()
    //    {
    //        let parameters: Parameters = [
    //            "head":[
    //                "platform":"app",
    //                "timestamp":timeStamp,
    //                "token":token1,
    //            ],
    //            "villageIDs":villageArray,
    //            "status":2,
    //            "pageNum":1,
    //            "pageSize":15,
    //            ]
    //
    //        print(parameters)
    //        Alamofire.request("http://47.75.190.168:5000/api/app/getSmokeDetectorEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
    //            print(token1)
    //            print("获取烟感已处理事件列表")
    //            if let dic = response.result.value {
    //                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
    //                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    //
    //                print("json: \(dic)")
    //                print(json)
    //                if (json?.length)! >= 70{
    //                    let model1:CompleteSmokeModel = CompleteSmokeModel.mj_object(withKeyValues: dic)
    ////                    let c =  model1.events!.count
    ////                    print(c)
    ////                    if c>0{
    ////                        for i in 0..<c {
    ////                            self.dataArray.append(model1.events[i])
    ////                        }
    ////                    }else{
    ////                        self.tableView!.mj_footer.endRefreshingWithNoMoreData()
    ////                    }
    //                    self.dataArray=model1.events
    //                }
    //                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    //                print(self.dataArray.count)
    //            }
    //            else
    //            {
    //                print("dic: \(response)")
    //            }
    //            // 结束刷新
    //            self.tableView?.reloadData()
    ////            self.tableView?.mj_header.endRefreshing()
    ////            self.tableView?.mj_footer.endRefreshing()
    //
    //        }
    //    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension CompleteSmokeView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        pageNum=Int(screenHeight/125)
        let model:CompleteSmokeEventsModel=self.dataArray[indexPath.row] as! CompleteSmokeEventsModel
        if model.resultContent == ""{
            return 120
        }
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CompleteSmokeCell = tableView.dequeueReusableCell(withIdentifier: "CompleteSmokeCellId", for: indexPath as IndexPath) as! CompleteSmokeCell
        let model:CompleteSmokeEventsModel=self.dataArray[indexPath.row] as! CompleteSmokeEventsModel
        cell.FirstmageView.image=UIImage(named: "居民楼-黑.png")
        if model.villageName != nil && model.buildingNo != nil && model.houseNo != nil{
            let str = model.villageName!+"-"+"\(model.buildingNo!)"+"栋-"+"\(model.houseNo!)"
            cell.AdressLabel.text=str
        }
        
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        cell.TimeLongLabel.textAlignment = .center
        cell.Person.text="共"+"\(model.residentNum!)"+"人"
        if model.people!.count>0{
            for i in 0..<model.people!.count{
                if Int((model.people?[i].relation)!) == 1{
                    cell.NameLabel.text="业主:" + (model.people?[i].name)!
                }
            }
        }
        if model.createTime != ""{
            cell.TimeLabel.text=model.createTime
        }
        cell.AllLabel.text="具体内容"
        if model.resultContent != ""{
            
            cell.AllLabel.textColor=UIColor.lightGray
            cell.AllLabel.font=UIFont.systemFont(ofSize: 12)
            cell.AllLabel1.text=model.resultContent!
            cell.AllLabel1.numberOfLines=0
            cell.AllLabel1.font=UIFont.systemFont(ofSize: 12)
        }
        
        if (model.resultType.count) > 0  {
            for i in 0..<model.resultType.count{
                if model.resultType[i] == 1{
                    cell.ErrorLabel.textAlignment = .center
                    cell.ErrorLabel.text="误报"
                    cell.ErrorLabel.textColor=UIColor.gray
                    cell.ErrorLabel.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
                }
                if model.resultType[i] == 2{
                    cell.ErrorLabel.textAlignment = .center
                    //  cell.ErrorLabel.text="非误报"
                    cell.ErrorLabel.textColor=UIColor.white
                    //  cell.backgroundColor=UIColor.orange
                    let layer:CATextLayer=CATextLayer()
                    layer.frame=CGRect(x: 20, y: 8, width: 80, height:35)
                    layer.string="非误报"
                    layer.foregroundColor=UIColor.white.cgColor
                    layer.fontSize=UIFont.systemFont(ofSize: 14).pointSize
                    
                    let gradientLayer1: CAGradientLayer = CAGradientLayer()
                    let TColor = UIColor.init(red: 236/255, green: 86/255, blue: 86/255, alpha: 1)
                    let BColor = UIColor.init(red: 255/255, green: 152/255, blue: 74/255, alpha: 1)
                    let gradientColors1: [CGColor] = [TColor.cgColor, BColor.cgColor]
                    gradientLayer1.colors = gradientColors1
                    gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
                    gradientLayer1.endPoint = CGPoint(x: 1, y: 0)
                    gradientLayer1.frame = CGRect(x: 0, y: 0, width: 80, height:35)
                    cell.ErrorLabel.layer.addSublayer(gradientLayer1)
                    cell.ErrorLabel.layer.addSublayer(layer)
                }
                if model.resultType[i] == 3{
                    cell.TimeLongLabel.text="接单超时"
                    cell.TimeLongLabel.backgroundColor=UIColor.init(red: 146/255, green: 203/255, blue: 197/255, alpha: 1)
                }
            }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
}

