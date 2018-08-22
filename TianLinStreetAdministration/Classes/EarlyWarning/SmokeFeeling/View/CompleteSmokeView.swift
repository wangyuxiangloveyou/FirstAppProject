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
        tableView1?.mj_footer.endRefreshing()
        tableView1?.mj_header.endRefreshing()
    }
    var shouldLoadMoreData = true
    var index = 1
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var pageNum=0
    var tableView1:UITableView?
    var dataArray:[AnyObject]=[]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView1=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
         self.tableView1?.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
         self.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        self.tableView1?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView1?.isScrollEnabled = true
         self.addSubview(tableView1!)
        loadData1()
        
    }
    
    func configUI()  {
        //创建表格试图
        
        tableView1?.dataSource=self
        tableView1?.delegate=self
       
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView1?.register(UINib(nibName: "CompleteSmokeCell",bundle: nil), forCellReuseIdentifier: "CompleteSmokeCellId")
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(CompleteSmokeView.headerRefresh))
        // 现在的版本要用mj_header
        tableView1?.mj_header = header
        header.setTitle("", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(CompleteSmokeView.footerRefresh))
        tableView1?.mj_footer = footer
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
        if shouldLoadMoreData {
            loadData1()
        } else {
            self.tableView1!.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    func startRefreshData1()
    {
        self.tableView1?.mj_header.beginRefreshing()
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
            "pageSize":20,
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
                let model1:CompleteSmokeModel = CompleteSmokeModel.mj_object(withKeyValues: dic)
                if model1.responseStatus?.resultCode == 0 && model1.events != nil {
                    let c =  model1.events!.count
                    self.shouldLoadMoreData = c >= 20
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
                        //self.tableView!.mj_footer.endRefreshingWithNoMoreData()
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
            self.tableView1?.reloadData()
            self.configUI()
            self.tableView1?.mj_header.endRefreshing()
            self.tableView1?.mj_footer.endRefreshing()
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
        let cell:CompleteSmokeCell = (tableView.dequeueReusableCell(withIdentifier: "CompleteSmokeCellId", for: indexPath as IndexPath) as? CompleteSmokeCell)!
        let model:CompleteSmokeEventsModel=self.dataArray[indexPath.row] as! CompleteSmokeEventsModel
        cell.refreshData(model: model)
        return cell
    }
}







