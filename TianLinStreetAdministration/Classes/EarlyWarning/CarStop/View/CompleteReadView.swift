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
    var shouldLoadMoreData = true
    var index = 1
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var pageNum=0
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
         //tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        //创建一个用于显示背景图片的imageView
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "mmexport1525609772323.jpg")
        backgroundImage.contentMode = .scaleAspectFill //等比缩放填充（图片可能有部分显示不全）
        //将背景图片imageView插入到当前视图中
        tableView?.insertSubview(backgroundImage, at: 0)
        
        self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
    
        tableView?.register(UINib(nibName: "CompleteReadCell",bundle: nil), forCellReuseIdentifier: "CompleteReadCellId")
   
        
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
    
    
    //顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        // self.tableView?.mj_header.beginRefreshing()
        index=1
        loadData1()
    }
    
    // 底部刷新
    
    func footerRefresh()
    {
        index = index + 1
        // self.tableView?.mj_footer.beginRefreshing()
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
            "pageNum":index,
            "pageSize":15,
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
                if model1.responseStatus?.resultCode == 0 && model1.events != nil {
                    let c =  model1.events!.count
                    self.shouldLoadMoreData = c >= 20
                    if c>0
                    {
                        if self.index > 1
                        {
                            for i in 0..<c
                            {
                                self.dataArray.append(model1.events![i])
                            }
                        }
                        else if self.index == 1
                        {
                            self.dataArray = model1.events!
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

