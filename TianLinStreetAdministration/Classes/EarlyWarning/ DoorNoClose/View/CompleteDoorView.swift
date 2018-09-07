//
//  CompleteDoorView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//


import UIKit
import Alamofire
import MBProgressHUD
import MJRefresh

class CompleteDoorView: UIView {
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
        loadData1()
        
        self.backgroundColor=UIColor.white
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
        self.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        tableView?.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.isScrollEnabled = true
        self.addSubview(tableView!)
      
    }
    
    func configUI()  {
        //创建表格试图
        //tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
       // self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "CompleteDoorCell",bundle: nil), forCellReuseIdentifier: "CompleteDoorCellId")
        
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
    //获取门禁已完成事件列表
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
            "pageSize":20,
            ]
       
        Alamofire.request("http://47.75.190.168:5000/api/app/getAccessEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            //hud.hide(animated: true)
            print("获取门禁已完成事件列表")
            print(villageArray)
            if let dic = response.result.value {
                let data : NSData! = try? JSONSerialization.data(withJSONObject: dic, options: []) as NSData!
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(dic)")
                print(json)
                let model1:CompleteDoorModel = CompleteDoorModel.mj_object(withKeyValues: dic)
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
                }            }
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



extension CompleteDoorView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CompleteDoorCell = tableView.dequeueReusableCell(withIdentifier: "CompleteDoorCellId", for: indexPath as IndexPath) as! CompleteDoorCell
         let model:CompleteDoorEventsModel=self.dataArray[indexPath.row] as! CompleteDoorEventsModel
        cell.FristImageView.image=UIImage(named: "居民楼-黑.png")
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
         let str = model.villageName!+"-"+"\(model.buildingNo!)"+"栋"
        let moneyTitle = NSMutableAttributedString.init(string:str)
        moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
        moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:20), range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
        cell.AdressLabel.attributedText = moneyTitle
       
        cell.RightLabel.text="人为"
        cell.RightLabel.textAlignment = .center
        cell.RightLabel.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
       
        cell.TimeLabel.text=model.createTime
        
        cell.OneLabel.text="特殊情况"
        cell.OneLabel.textAlignment = .center
        cell.OneLabel.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        cell.TwoLabel.text="处置超时"
         cell.TwoLabel.textAlignment = .center
        cell.TwoLabel.backgroundColor=UIColor.init(red: 190/255, green: 223/255, blue: 219/255, alpha: 1)
      cell.selectionStyle = .none
        return cell
        
    }
}

