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
    var shouldLoadMoreData = true
    var index = 1
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
        header.setRefreshingTarget(self, refreshingAction: #selector(CompleteSmokeView.headerRefresh))
        // 现在的版本要用mj_header
        tableView?.mj_header = header
        header.setTitle("", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(CompleteSmokeView.footerRefresh))
        tableView?.mj_footer = footer
        footer.setTitle("", for: .idle)
        footer.setTitle("释放加载", for: .pulling)
        footer.setTitle("正在加载...", for: .refreshing)
        footer.setTitle("没有更多数据", for: .noMoreData)
    }
    
    
    //顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
//        self.tableView?.mj_header.beginRefreshing()
        index=1
        loadData1()
    }
    
    // 底部刷新
    
    func footerRefresh()
    {
        index = index + 1
//        self.tableView?.mj_footer.beginRefreshing()
        if shouldLoadMoreData {
          loadData1()
        } else {
            self.tableView!.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    func startRefreshData1()
    {
        self.tableView?.mj_header.beginRefreshing()
        index = 1
        loadData1()
    }
    
    //获取烟感事件列表
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "villageIDs":villageArray,
            "status":2,
            "pageNum":index,
            "pageSize":15,
            ]
        
        print(parameters)
        Alamofire.request("http://47.75.190.168:5000/api/app/getSmokeDetectorEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print(token1)
            print("获取烟感已处理事件列表")
            if let dic = response.result.value
            {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                
                print("json: \(dic)")
//                print(json)
                let model1:CompleteSmokeModel = CompleteSmokeModel.mj_object(withKeyValues: dic)
                if model1.responseStatus?.resultCode == 0 && model1.events != nil {
                    let c =  model1.events!.count
                    print(c)
                    self.shouldLoadMoreData = c >= 15
                    if c>0
                    {
                        if self.index > 1
                        {
                            for i in 0..<c
                            {
                                self.dataArray.append(model1.events[i])
                            }
                        }
                        else if self.index == 1
                        {
                            self.dataArray = model1.events!
                        }
                    }
                    else
                    {
//                        self.tableView!.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                print(self.dataArray.count)
            }
            else
            {
                print("dic: \(response)")
            }
            
            // 结束刷新
            self.tableView?.reloadData()
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
        }
    }
    
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
        cell.refreshData(model: model)
        
        cell.selectionStyle = .none
        return cell
    }
}







//获取烟感事件列表
//    func loadData1()
//    {
//        let parameters: Parameters = [
//            "head":[
//                "platform":"app",
//                "timestamp":timeStamp,
//                "token":token1,
//                "longitude":longitude,
//                "latitude":latitude,
//            ],
//            "villageIDs":villageArray,
//            "status":2,
//            "pageNum":1,
//            "pageSize":20,
//            ]
//        print(parameters)
//
//        Alamofire.request("http://47.75.190.168:5000/api/app/getSmokeDetectorEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
//            print("获取烟感已处理事件列表")
//            print(villageID)
//            if let dic = response.result.value {
//                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
//                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
//                print("json: \(json)")
//                print(dic)
//                print((json?.length)!)
//                if (json?.length)! >= 60 {
//                    let model:CompleteSmokeModel = CompleteSmokeModel.mj_object(withKeyValues: dic)
//                    // self.dataArray.removeAll()
//                    self.dataArray=model.events!
//                }
//                print(self.dataArray.count)
//            }
//            else
//            {
//                print("dic: \(response)")
//            }
//
//            self.tableView?.reloadData()
//            // 结束刷新
//            self.tableView?.mj_header.endRefreshing()
//
//        }
//    }
