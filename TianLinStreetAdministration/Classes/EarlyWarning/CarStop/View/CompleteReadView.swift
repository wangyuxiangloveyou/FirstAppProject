//
//  CompleteReadView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class CompleteReadView: UIView {
    var tableView:UITableView?
    var dataArray:[AnyObject]=[]
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        loadData1()
       // self.backgroundColor=UIColor.white
    }
    
    func configUI()  {
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y: navigationBarHeight-44, width:screenWidth , height: screenHeight+navigationBarHeight-160), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
         tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
    
        tableView?.register(UINib(nibName: "CompleteReadCell",bundle: nil), forCellReuseIdentifier: "CompleteReadCellId")
   
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
    //获取停车已读事件列表
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
            "pageSize":10,
            ]
        Alamofire.request("http://47.75.190.168:5000/api/app/getParkingEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print(token1)
            
            print("获取停车已读事件列表")
            print(villageArray)
            if let dic = response.result.value {
                
                let data : NSData! = try? JSONSerialization.data(withJSONObject: dic, options: []) as NSData!
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(json)")
               print(dic)
                
                     let model1:CompleteReadModel = CompleteReadModel.mj_object(withKeyValues: dic)
                if model1.responseStatus?.resultCode == 0 && model1.events != nil{
                    self.dataArray=model1.events!
                }
                
            
                
            }
            else
            {
                print("dic: \(response)")
            }
            self.tableView?.reloadData()
            self.tableView?.mj_header.endRefreshing()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



extension CompleteReadView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CompleteReadCell = tableView.dequeueReusableCell(withIdentifier: "CompleteReadCellId", for: indexPath as IndexPath) as! CompleteReadCell
        let model:CompleteReadEventsModel=self.dataArray[indexPath.row] as! CompleteReadEventsModel
      
             cell.timeLabel.textColor=UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
            cell.timeLabel.text=model.creatTime
            cell.carLabel.textColor=UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
            cell.carLabel.text=model.title
        
        if model.resultType == 3{
            cell.pictureLabel.textAlignment = .center
            cell.pictureLabel.text="反馈超时"
            cell.pictureLabel.backgroundColor=UIColor.init(red: 190/255, green: 223/255, blue: 219/255, alpha: 1)
        }
        
//        if indexPath.row == 1 {
//            cell.timeLabel.textColor=UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
//            cell.timeLabel.text="2018-02-10 10:45:44"
//            cell.carLabel.textColor=UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
//            cell.carLabel.text="小区车辆低于85%"
//        }
        cell.selectionStyle = .none
        return cell
        
    }
}

